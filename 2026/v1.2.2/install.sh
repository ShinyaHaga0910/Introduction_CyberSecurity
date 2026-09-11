#!/usr/bin/env bash
set -Eeuo pipefail

VERSION="v1.2.2"
STACK_NAME="jdu-intro-cybersecurity-2026-v122"
INSTANCE_TYPE="t3.micro"
INSTANCE_PROFILE_NAME="LabInstanceProfile"
REGION="${AWS_REGION:-${AWS_DEFAULT_REGION:-}}"
BASE_URL="https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/${VERSION}"
SSH_KEY_PATH="${JDU_SSH_KEY_PATH:-$HOME/.ssh/jdu-intro-cybersecurity-2026}"

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

for command_name in aws curl sha256sum ssh ssh-keygen base64 sort; do
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

ensure_session_manager_plugin() {
  local minimum_version='1.2.764.0' current_version=''
  if command -v session-manager-plugin >/dev/null 2>&1; then
    current_version="$(session-manager-plugin --version 2>/dev/null | tr -d '[:space:]')"
    if [[ "$current_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && \
       [[ "$(printf '%s\n' "$minimum_version" "$current_version" | sort -V | head -n 1)" == "$minimum_version" ]]; then
      return 0
    fi
    printf 'Updating the AWS Session Manager plugin from %s...\n' "${current_version:-unknown version}"
  fi

  local architecture package_url
  architecture="$(uname -m)"
  case "$architecture" in
    x86_64) package_url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" ;;
    aarch64|arm64) package_url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_arm64/session-manager-plugin.rpm" ;;
    *) printf 'ERROR Unsupported CloudShell architecture: %s\n' "$architecture" >&2; exit 2 ;;
  esac

  if ! command -v dnf >/dev/null 2>&1 || ! command -v sudo >/dev/null 2>&1; then
    printf '%s\n' 'ERROR Session Manager plugin is missing and automatic CloudShell installation is unavailable.' >&2
    exit 2
  fi
  printf '%s\n' 'Installing the AWS Session Manager plugin in CloudShell...'
  sudo dnf install -y "$package_url" >/dev/null
  command -v session-manager-plugin >/dev/null 2>&1 || {
    printf '%s\n' 'ERROR Session Manager plugin installation failed.' >&2
    exit 2
  }
  current_version="$(session-manager-plugin --version 2>/dev/null | tr -d '[:space:]')"
  if [[ ! "$current_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] || \
     [[ "$(printf '%s\n' "$minimum_version" "$current_version" | sort -V | head -n 1)" != "$minimum_version" ]]; then
    printf 'ERROR Session Manager plugin is too old: %s\n' "${current_version:-unknown version}" >&2
    exit 2
  fi
}

prepare_ssh_key() {
  install -d -m 0700 "$HOME/.ssh"
  if [[ -e "$SSH_KEY_PATH.pub" && ! -e "$SSH_KEY_PATH" ]]; then
    printf 'ERROR Public key exists but its private key is missing: %s\n' "$SSH_KEY_PATH" >&2
    exit 2
  fi
  if [[ ! -e "$SSH_KEY_PATH" ]]; then
    printf 'Creating the CloudShell-only SSH key: %s\n' "$SSH_KEY_PATH"
    ssh-keygen -q -t ed25519 -N '' -C 'jdu-intro-cybersecurity-2026-cloudshell' -f "$SSH_KEY_PATH"
  fi
  if [[ ! -e "$SSH_KEY_PATH.pub" ]]; then
    ssh-keygen -y -f "$SSH_KEY_PATH" > "$SSH_KEY_PATH.pub"
  fi
  chmod 0600 "$SSH_KEY_PATH"
  chmod 0644 "$SSH_KEY_PATH.pub"
  if [[ "$(wc -l < "$SSH_KEY_PATH.pub")" -ne 1 ]] || ! grep -Eq '^ssh-ed25519 [A-Za-z0-9+/=]+( .*)?$' "$SSH_KEY_PATH.pub"; then
    printf 'ERROR The SSH public key is not a valid single-line Ed25519 key: %s\n' "$SSH_KEY_PATH.pub" >&2
    exit 2
  fi
}

write_ssh_config() {
  local instance_id="$1" include_line='Include ~/.ssh/config.d/*' config_file config_fragment temporary_file
  config_file="$HOME/.ssh/config"
  config_fragment="$HOME/.ssh/config.d/jdu-intro-cybersecurity-2026.conf"
  install -d -m 0700 "$HOME/.ssh/config.d"
  cat > "$config_fragment" <<EOF
Host jdu-ubuntu
    HostName $instance_id
    User ssm-user
    IdentityFile $SSH_KEY_PATH
    IdentitiesOnly yes
    ProxyCommand sh -c "aws ssm start-session --region $REGION --target %h --document-name AWS-StartSSHSession --parameters portNumber=%p"
    StrictHostKeyChecking accept-new
EOF
  chmod 0600 "$config_fragment"

  if [[ ! -f "$config_file" ]] || ! grep -Fqx "$include_line" "$config_file"; then
    temporary_file="$(mktemp "$HOME/.ssh/config.XXXXXX")"
    printf '%s\n\n' "$include_line" > "$temporary_file"
    if [[ -f "$config_file" ]]; then
      cat "$config_file" >> "$temporary_file"
    fi
    mv -f -- "$temporary_file" "$config_file"
  fi
  chmod 0600 "$config_file"
}

ensure_session_manager_plugin
prepare_ssh_key
student_public_key_base64="$(base64 < "$SSH_KEY_PATH.pub" | tr -d '\r\n')"

template_path="$work_dir/lab-environment.json"
checker_path="$work_dir/check-aws-environment.sh"
cloudcheck_path="$work_dir/jdu-cloudcheck"
checksums_path="$work_dir/SHA256SUMS"

printf '%s\n' 'Downloading the fixed-version lab files...'
curl -fsSL --retry 3 "$BASE_URL/cloudformation/lab-environment.json" -o "$template_path"
curl -fsSL --retry 3 "$BASE_URL/scripts/check-aws-environment.sh" -o "$checker_path"
curl -fsSL --retry 3 "$BASE_URL/scripts/jdu-cloudcheck" -o "$cloudcheck_path"
curl -fsSL --retry 3 "$BASE_URL/SHA256SUMS" -o "$checksums_path"
chmod 0755 "$checker_path"
chmod 0755 "$cloudcheck_path"

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
verify_download scripts/jdu-cloudcheck "$cloudcheck_path"
printf '%s\n' 'PASS Download checksums match.'

install -d -m 0755 "$HOME/.local/bin"
install -m 0755 "$cloudcheck_path" "$HOME/.local/bin/jdu-cloudcheck"

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
    "StudentSshPublicKeyBase64=$student_public_key_base64" \
  --no-fail-on-empty-changeset

printf '%s\n' 'Running the AWS environment acceptance check...'
"$checker_path" --region "$REGION" --stack-name "$STACK_NAME" --wait

instance_id="$(aws cloudformation describe-stacks --region "$REGION" --stack-name "$STACK_NAME" --query "Stacks[0].Outputs[?OutputKey=='InstanceId'].OutputValue | [0]" --output text)"
write_ssh_config "$instance_id"

printf '%s\n' 'Checking SSH through the Session Manager tunnel...'
ssh_ready=false
for attempt in {1..20}; do
  if remote_user="$(ssh -o BatchMode=yes -o ConnectTimeout=15 jdu-ubuntu 'id -un' 2>/dev/null)" && [[ "$remote_user" == 'ssm-user' ]]; then
    ssh_ready=true
    break
  fi
  if ((attempt < 20)); then sleep 6; fi
done
if ! $ssh_ready; then
  printf '%s\n' 'ERROR The instance is online in Systems Manager, but the SSH acceptance check failed.' >&2
  printf '%s\n' 'Run: ssh -vv jdu-ubuntu' >&2
  exit 1
fi

printf '\n%s\n' 'PASS The AWS lab environment is ready.'
printf 'Instance ID: %s\n' "$instance_id"
printf 'Private key: %s (keep this file in CloudShell)\n' "$SSH_KEY_PATH"
printf '%s\n' 'Connect to Ubuntu with: ssh jdu-ubuntu'
printf '%s\n' 'Check the CloudShell side of Mission 6 with: ~/.local/bin/jdu-cloudcheck M6'
printf '%s\n' 'The Security Group still has no inbound TCP 22 rule.'
