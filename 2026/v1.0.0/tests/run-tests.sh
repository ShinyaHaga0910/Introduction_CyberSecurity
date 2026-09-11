#!/usr/bin/env bash
set -Eeuo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mock_bin="$root_dir/tests/mock-bin"
checker="$root_dir/scripts/check-aws-environment.sh"

for script in \
  "$root_dir/install.sh" \
  "$root_dir/scripts/check-aws-environment.sh" \
  "$root_dir/scripts/setup-instance.sh" \
  "$root_dir/scripts/jdu-fixture" \
  "$root_dir/scripts/jdu-labcheck" \
  "$root_dir/scripts/jdu-prepare-student-home" \
  "$root_dir/tests/mock-bin/aws"; do
  bash -n "$script"
done
printf '%s\n' 'PASS shell syntax'

(
  cd "$root_dir"
  sha256sum --check SHA256SUMS >/dev/null
)
printf '%s\n' 'PASS published checksums'

fixture_home="$(mktemp -d)"
trap 'rm -rf -- "$fixture_home"' EXIT
HOME="$fixture_home" bash "$root_dir/scripts/jdu-fixture" reset M0 >/dev/null
[[ -d "$fixture_home/jdu-lab/m0" && -w "$fixture_home/jdu-lab/m0" ]]
[[ "$(stat -c '%U' "$fixture_home/jdu-lab/m0")" == "$(id -un)" ]]
printf '%s\n' 'PASS M0 workspace is writable and owned by the current student user'

python3 - "$root_dir/cloudformation/lab-environment.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    template = json.load(source)

resources = template["Resources"]
required = {
    "LabVpc", "InternetGateway", "GatewayAttachment", "PublicSubnet",
    "PublicRouteTable", "DefaultRoute", "PublicSubnetRouteTableAssociation",
    "LabSecurityGroup", "UbuntuLabInstance",
}
assert required <= resources.keys()
sg = resources["LabSecurityGroup"]["Properties"]
assert sg["SecurityGroupIngress"] == []
instance = resources["UbuntuLabInstance"]["Properties"]
assert "KeyName" not in instance
assert instance["MetadataOptions"]["HttpTokens"] == "required"
assert instance["IamInstanceProfile"] == {"Ref": "InstanceProfileName"}
assert instance["NetworkInterfaces"][0]["AssociatePublicIpAddress"] is True
assert template["Outputs"]["ConnectionMethod"]["Value"] == "AWS Systems Manager Session Manager"
print("PASS CloudFormation structure")
PY

chmod 0755 "$mock_bin/aws" "$checker"
pass_output="$(PATH="$mock_bin:$PATH" "$checker" --region us-east-1 --stack-name test-stack)"
grep -q '^Required checks: 18 PASS, 0 FAIL, 0 ERROR$' <<<"$pass_output"
printf '%s\n' 'PASS AWS checker accepts the intended environment'

set +e
fail_output="$(MOCK_BAD_SG=1 PATH="$mock_bin:$PATH" "$checker" --region us-east-1 --stack-name test-stack 2>&1)"
fail_status=$?
set -e
[[ "$fail_status" -eq 1 ]]
grep -q '^FAIL  Security group has no inbound rules' <<<"$fail_output"
printf '%s\n' 'PASS AWS checker rejects an unintended inbound rule'

printf '%s\n' 'ALL TESTS PASSED'
