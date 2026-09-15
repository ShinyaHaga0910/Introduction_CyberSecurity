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
  "$root_dir/scripts/jdu-probe" \
  "$root_dir/scripts/jdu-cloudcheck" \
  "$root_dir/tests/mock-bin/aws"; do
  bash -n "$script"
done
python3 - "$root_dir/scripts/jdu-worker" "$root_dir/scripts/jdu-http-service" <<'PY'
import ast
import sys

for path in sys.argv[1:]:
    with open(path, encoding="utf-8") as source:
        ast.parse(source.read(), filename=path)
PY
printf '%s\n' 'PASS shell and Python syntax'

(
  cd "$root_dir"
  sha256sum --check SHA256SUMS >/dev/null
)
printf '%s\n' 'PASS published checksums'

list_output="$(bash "$root_dir/scripts/jdu-labcheck" list)"
[[ "$(grep -c '^M[0-7] ' <<<"$list_output")" -eq 8 ]]
probe_output="$(bash "$root_dir/scripts/jdu-probe" list)"
grep -Fxq M2-WRITE-DENY <<<"$probe_output"
grep -Fxq M5-CLOSED-PORT <<<"$probe_output"
grep -Fxq M6-UNREGISTERED-KEY <<<"$probe_output"
printf '%s\n' 'PASS eight-Mission and negative-probe interfaces'

m0_test_home="$(mktemp -d)"
mkdir -p "$m0_test_home/jdu-lab/m0"
. /etc/os-release
printf '%s\n' \
  "OS_ID=$ID" \
  "OS_VERSION_ID=$VERSION_ID" \
  "KERNEL_RELEASE=$(uname -r)" \
  "PID1_COMM=$(cat /proc/1/comm)" \
  "USER_NAME=$(id -un)" \
  "HOST_NAME=$(hostname)" > "$m0_test_home/jdu-lab/m0/observation.env"
set +e
m0_complete_output="$(HOME="$m0_test_home" bash "$root_dir/scripts/jdu-labcheck" mission M0 2>&1)"
set -e
[[ "$(grep -Ec '^(PASS|NOT_READY|FAIL)[[:space:]]+M0-OBS-' <<<"$m0_complete_output")" -eq 6 ]]
grep -Fxq 'RESULT    6 / 6 questions cleared' <<<"$m0_complete_output"
grep -Fxq 'PASS      6' <<<"$m0_complete_output"
grep -Fxq 'FAIL      0' <<<"$m0_complete_output"
! grep -Eq 'M0-ENV-|Environment|READY|WARN|ERROR|NOT_READY' <<<"$m0_complete_output"

rm -f -- "$m0_test_home/jdu-lab/m0/observation.env"
set +e
m0_initial_output="$(HOME="$m0_test_home" bash "$root_dir/scripts/jdu-labcheck" mission M0 2>&1)"
set -e
[[ "$(grep -Ec '^FAIL[[:space:]]+M0-OBS-' <<<"$m0_initial_output")" -eq 6 ]]
grep -Fxq 'RESULT    0 / 6 questions cleared' <<<"$m0_initial_output"
grep -Fxq 'PASS      0' <<<"$m0_initial_output"
grep -Fxq 'FAIL      6' <<<"$m0_initial_output"
! grep -Eq 'M0-ENV-|Environment|READY|WARN|ERROR|NOT_READY' <<<"$m0_initial_output"
rm -rf -- "$m0_test_home"
printf '%s\n' 'PASS M0 reports only six PASS/FAIL student questions and a clear score'

runtime_directory="$(mktemp -d)"
worker_pid=''
http_pid=''
cleanup_runtime_test() {
  [[ -z "$worker_pid" ]] || kill -TERM "$worker_pid" >/dev/null 2>&1 || true
  [[ -z "$http_pid" ]] || kill -TERM "$http_pid" >/dev/null 2>&1 || true
  rm -rf -- "$runtime_directory"
}
trap cleanup_runtime_test EXIT

python3 "$root_dir/scripts/jdu-worker" test-token >"$runtime_directory/worker.log" 2>&1 &
worker_pid=$!
sleep 1
ps -p "$worker_pid" -o args= | grep -Fq 'jdu-worker test-token'
kill -TERM "$worker_pid"
wait "$worker_pid"
worker_pid=''
grep -Fq 'worker stopped: test-token' "$runtime_directory/worker.log"

printf '%s\n' 'JDU-HTTP-FUNCTIONAL' > "$runtime_directory/content.txt"
python3 "$root_dir/scripts/jdu-http-service" --address 127.0.0.1 --port 18081 --content "$runtime_directory/content.txt" >"$runtime_directory/http.log" 2>&1 &
http_pid=$!
for _attempt in {1..20}; do
  if curl -fsS --max-time 1 http://127.0.0.1:18081/ > "$runtime_directory/response.txt" 2>/dev/null; then break; fi
  sleep 0.2
done
grep -Fxq 'JDU-HTTP-FUNCTIONAL' "$runtime_directory/response.txt"
grep -Fq 'REQUEST path=/' "$runtime_directory/http.log"
kill -TERM "$http_pid"
wait "$http_pid" 2>/dev/null || true
http_pid=''
printf '%s\n' 'PASS process worker and loopback HTTP service functional tests'

python3 - "$root_dir/cloudformation/lab-environment.json" "$root_dir/scripts/setup-instance.sh" <<'PY'
import hashlib
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
assert parameters["LabVersion"]["AllowedValues"] == ["v1.2.3"]
assert "StudentSshPublicKeyBase64" in parameters
user_data = instance["UserData"]["Fn::Base64"]["Fn::Sub"]
assert "StudentSshPublicKeyBase64" in user_data
assert "/etc/jdu-lab/student-ssh-key.pub" in user_data
with open(sys.argv[2], "rb") as source:
    setup_hash = hashlib.sha256(source.read()).hexdigest()
assert setup_hash in user_data
assert template["Outputs"]["ConnectionMethod"]["Value"] == "SSH over AWS Systems Manager Session Manager"
assert template["Outputs"]["StudentSshUser"]["Value"] == "ssm-user"
print("PASS CloudFormation structure")
PY

python3 - \
  "$root_dir/install.sh" \
  "$root_dir/scripts/setup-instance.sh" \
  "$root_dir/scripts/jdu-fixture" \
  "$root_dir/scripts/jdu-labcheck" \
  "$root_dir/scripts/jdu-prepare-student-home" <<'PY'
import re
import sys

paths = sys.argv[1:]
texts = []
for path in paths:
    with open(path, encoding="utf-8") as source:
        texts.append(source.read())
installer, setup, fixture, checker, home = texts

assert "ssh-keygen -q -t ed25519" in installer
assert "StudentSshPublicKeyBase64=$student_public_key_base64" in installer
assert "aws ssm start-session" in installer
assert "scripts/jdu-cloudcheck" in installer
assert "ssh -o BatchMode=yes" in installer
assert "authorized_keys" in home
assert all(f'"$workspace/m{i}"' in home for i in range(8))

for mission in range(8):
    assert f"reset_m{mission}()" in fixture
    assert f"check_m{mission}()" in checker

zero_action_contract = {
    "M0": "observation.env is intentionally absent",
    "M1": "case01 is intentionally absent",
    "M2": "permissions are intentionally unfinished",
    "M3": "evidence are intentionally unfinished",
    "M4": "inactive, and disabled",
    "M5": "observation and closed-port probe records are intentionally absent",
    "M6": "remote evidence is intentionally absent",
    "M7": "intentionally unfinished",
}
for text in zero_action_contract.values():
    assert text in fixture

required_ids = {
    "M0": ["M0-OBS-01", "M0-OBS-02", "M0-OBS-03", "M0-OBS-04", "M0-OBS-05", "M0-OBS-06"],
    "M2": ["M2-ID-01", "M2-PERM-03", "M2-PERM-04", "M2-PERM-06"],
    "M3": ["M3-PROC-01", "M3-PROC-02", "M3-APT-01", "M3-APT-03"],
    "M4": ["M4-UNIT-02", "M4-SVC-01", "M4-SVC-02", "M4-EVID-01"],
    "M5": ["M5-SOCK-01", "M5-HTTP-01", "M5-LOG-01", "M5-NEG-01"],
    "M6": ["M6-SSH-01", "M6-SSH-04", "M6-SSH-05", "M6-NEG-02"],
    "M7": ["M7-SVC-01", "M7-SOCK-01", "M7-HTTP-01", "M7-PERM-03", "M7-INT-03"],
}
for ids in required_ids.values():
    for check_id in ids:
        assert check_id in checker

assert "chmod 777" not in fixture
assert 'local mission_id="$1"\n  local directory="$workspace/${mission_id,,}"' in fixture
assert 'local mission_id="$1" directory="$workspace/${mission_id,,}"' not in fixture
assert "SecurityGroupIngress\": []" not in installer
assert "jdu-final.service.template" in setup
assert "checker-baseline.sha256" in setup
assert "ssh-baseline.sha256" in setup
assert "Mission M0 (6 questions)" in checker
assert "RESULT    %d / %d questions cleared" in checker
assert "M0-ENV-" not in checker
print("PASS Mission reset, completion, negative-test, and integrity contracts")
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
