#!/usr/bin/env bash
set -Eeuo pipefail

VERSION="v1.0.0"
STACK_NAME="jdu-intro-cybersecurity-2026"
INSTANCE_TYPE="t3.micro"
INSTANCE_PROFILE_NAME="LabInstanceProfile"
REGION="${AWS_REGION:-${AWS_DEFAULT_REGION:-}}"
BASE_URL="https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/${VERSION}"

usage() {
  printf '%s\n' "Usage: bash install.sh [--region REGION] [--stack-name NAME] [--instance-type t2.micro|t3.micro] [--instance-profile NAME]"
}

while (($#)); do
  case "$1" in
    --region) REGION="${2:?Missing region}"; shift 2 ;;
    --stack-name) STACK_NAME="${2:?Missing stack name}"; shift 2 ;;
    --instance-type) INSTANCE_TYPE="${2:?Missing instance type}"; shift 2 ;;
    --instance-profile) INSTANCE_PROFILE_NAME="${2:?Missing instance profile}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'ERROR Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
done

for command_name in aws curl sha256sum; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'ERROR Required command is missing: %s\n' "$command_name" >&2
    exit 2
  fi
done

if [[ -z "$REGION" ]]; then
  REGION="$(aws configure get region 2>/dev/null || true)"
fi
if [[ -z "$REGION" ]]; then
  printf '%s\n' 'ERROR AWS region is not configured. Use --region.' >&2
  exit 2
fi

case "$INSTANCE_TYPE" in
  t2.micro|t3.micro) ;;
  *) printf 'ERROR Unsupported instance type: %s\n' "$INSTANCE_TYPE" >&2; exit 2 ;;
esac

export AWS_PAGER=""
work_dir="$(mktemp -d)"
trap 'rm -rf -- "$work_dir"' EXIT

template_path="$work_dir/lab-environment.json"
checker_path="$work_dir/check-aws-environment.sh"
checksums_path="$work_dir/SHA256SUMS"

printf '%s\n' 'Downloading the fixed-version lab files...'
curl -fsSL --retry 3 "$BASE_URL/cloudformation/lab-environment.json" -o "$template_path"
curl -fsSL --retry 3 "$BASE_URL/scripts/check-aws-environment.sh" -o "$checker_path"
curl -fsSL --retry 3 "$BASE_URL/SHA256SUMS" -o "$checksums_path"
chmod 0755 "$checker_path"

verify_download() {
  local published_path="$1" local_path="$2" expected
  expected="$(awk -v path="$published_path" '$2 == path {print $1}' "$checksums_path")"
  if [[ ! "$expected" =~ ^[0-9a-f]{64}$ ]]; then
    printf 'ERROR Missing checksum for %s\n' "$published_path" >&2
    exit 2
  fi
  printf '%s  %s\n' "$expected" "$local_path" | sha256sum --check --status
}

verify_download cloudformation/lab-environment.json "$template_path"
verify_download scripts/check-aws-environment.sh "$checker_path"
printf '%s\n' 'PASS Download checksums match.'

printf '%s\n' 'Checking AWS login and CloudFormation template...'
aws sts get-caller-identity --region "$REGION" --output json >/dev/null
aws cloudformation validate-template --region "$REGION" --template-body "file://$template_path" >/dev/null

printf 'Deploying stack %s in %s...\n' "$STACK_NAME" "$REGION"
aws cloudformation deploy \
  --region "$REGION" \
  --stack-name "$STACK_NAME" \
  --template-file "$template_path" \
  --parameter-overrides \
    "InstanceType=$INSTANCE_TYPE" \
    "InstanceProfileName=$INSTANCE_PROFILE_NAME" \
    "LabVersion=$VERSION" \
  --no-fail-on-empty-changeset

printf '%s\n' 'Running the AWS environment acceptance check...'
"$checker_path" --region "$REGION" --stack-name "$STACK_NAME" --wait

instance_id="$(aws cloudformation describe-stacks --region "$REGION" --stack-name "$STACK_NAME" --query "Stacks[0].Outputs[?OutputKey=='InstanceId'].OutputValue | [0]" --output text)"
printf '\n%s\n' 'PASS The AWS lab environment is ready.'
printf 'Instance ID: %s\n' "$instance_id"
printf '%s\n' 'Open EC2 > Instances, select this instance, choose Connect, then choose Session Manager.'
printf '%s\n' 'No SSH key and no inbound TCP 22 rule are required.'
