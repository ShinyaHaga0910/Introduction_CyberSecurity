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
parameters = template["Parameters"]
assert parameters["LabVersion"]["AllowedValues"] == ["v1.1.0"]
assert "StudentSshPublicKeyBase64" in parameters
user_data = instance["UserData"]["Fn::Base64"]["Fn::Sub"]
assert "StudentSshPublicKeyBase64" in user_data
assert "/etc/jdu-lab/student-ssh-key.pub" in user_data
assert template["Outputs"]["ConnectionMethod"]["Value"] == "SSH over AWS Systems Manager Session Manager"
assert template["Outputs"]["StudentSshUser"]["Value"] == "ssm-user"
print("PASS CloudFormation structure")
PY

python3 - "$root_dir/install.sh" "$root_dir/scripts/jdu-prepare-student-home" <<'PY'
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    installer = source.read()
with open(sys.argv[2], encoding="utf-8") as source:
    home_preparer = source.read()

assert "ssh-keygen -q -t ed25519" in installer
assert "StudentSshPublicKeyBase64=$student_public_key_base64" in installer
assert "ProxyCommand sh -c" in installer
assert "aws ssm start-session" in installer
assert "ssh -o BatchMode=yes" in installer
assert "authorized_keys" in home_preparer
assert "/etc/jdu-lab/student-ssh-key.pub" in home_preparer
print("PASS CloudShell key and SSH wiring")
PY

chmod 0755 "$mock_bin/aws" "$checker"
pass_output="$(PATH="$mock_bin:$PATH" "$checker" --region us-east-1 --stack-name test-stack)"
grep -q '^Required checks: 22 PASS, 0 FAIL, 0 ERROR$' <<<"$pass_output"
printf '%s\n' 'PASS AWS checker accepts the intended environment'

set +e
fail_output="$(MOCK_BAD_SG=1 PATH="$mock_bin:$PATH" "$checker" --region us-east-1 --stack-name test-stack 2>&1)"
fail_status=$?
set -e
[[ "$fail_status" -eq 1 ]]
grep -q '^FAIL  Security group has no inbound rules' <<<"$fail_output"
printf '%s\n' 'PASS AWS checker rejects an unintended inbound rule'

printf '%s\n' 'ALL TESTS PASSED'
