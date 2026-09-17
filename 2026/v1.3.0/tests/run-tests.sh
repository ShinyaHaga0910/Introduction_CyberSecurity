#!/usr/bin/env bash
set -Eeuo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
checker="$root_dir/scripts/check-aws-environment.sh"
mock_bin="$root_dir/tests/mock-bin"

for script in \
  "$root_dir/install.sh" \
  "$root_dir/scripts/check-aws-environment.sh" \
  "$root_dir/scripts/setup-instance.sh" \
  "$root_dir/scripts/jdu-fixture" \
  "$root_dir/scripts/jdu-labcheck" \
  "$root_dir/scripts/jdu-prepare-student-home" \
  "$root_dir/scripts/jdu-cloudcheck" \
  "$root_dir/scripts/jdu-cloud-reset" \
  "$root_dir/tests/mock-bin/aws" \
  "$root_dir/tests/mock-bin/systemctl" \
  "$root_dir/tests/mock-bin/dpkg-query" \
  "$root_dir/tests/mock-m6/ssh"; do
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
grep -Fq 'jdu-check' "$root_dir/scripts/jdu-labcheck"
grep -Fq '/usr/local/bin/jdu-check' "$root_dir/scripts/setup-instance.sh"
grep -Fq '/usr/local/bin/jdu-reset' "$root_dir/scripts/setup-instance.sh"
printf '%s\n' 'PASS short student command interface'

declare -A expected_counts=(
  [M1]=6 [M2]=6 [M3]=2 [M4]=3 [M5]=4 [M6]=2 [M7]=6
)

for mission in M1 M2 M4 M5 M6 M7; do
  test_home="$(mktemp -d)"
  set +e
  output="$(HOME="$test_home" bash "$root_dir/scripts/jdu-labcheck" "$mission" 2>&1)"
  status=$?
  set -e
  [[ "$status" -eq 1 ]]
  grep -Fxq "RESULT    0 / ${expected_counts[$mission]} checks cleared" <<<"$output"
  grep -Fxq 'PASS      0' <<<"$output"
  grep -Fxq "FAIL      ${expected_counts[$mission]}" <<<"$output"
  ! grep -Eq '^PASS[[:space:]]+M[1-7]-' <<<"$output"
  rm -rf -- "$test_home"
done
printf '%s\n' 'PASS M1, M2, and M4-M7 have zero initial PASS items'

m3_test_home="$(mktemp -d)"
mkdir -p "$m3_test_home/jdu-lab/m3"
chmod 0755 "$root_dir/tests/mock-bin/systemctl" "$root_dir/tests/mock-bin/dpkg-query"
set +e
m3_initial="$(PATH="$root_dir/tests/mock-bin:$PATH" HOME="$m3_test_home" bash "$root_dir/scripts/jdu-labcheck" M3 2>&1)"
m3_stopped="$(MOCK_PROCESS2_STOPPED=1 PATH="$root_dir/tests/mock-bin:$PATH" HOME="$m3_test_home" bash "$root_dir/scripts/jdu-labcheck" M3 2>&1)"
m3_wrong="$(MOCK_PROCESS1_STOPPED=1 PATH="$root_dir/tests/mock-bin:$PATH" HOME="$m3_test_home" bash "$root_dir/scripts/jdu-labcheck" M3 2>&1)"
set -e
grep -Fxq 'RESULT    0 / 2 checks cleared' <<<"$m3_initial"
grep -Eq '^PASS[[:space:]]+M3-PROC-01[[:space:]]+Only process2 is stopped$' <<<"$m3_stopped"
grep -Fxq 'RESULT    1 / 2 checks cleared' <<<"$m3_stopped"
grep -Fxq 'RESULT    0 / 2 checks cleared' <<<"$m3_wrong"
rm -rf -- "$m3_test_home"
printf '%s\n' 'PASS M3 starts at zero and requires the exact process outcome'

m6_cloud_home="$(mktemp -d)"
m6_cloud_workspace="$m6_cloud_home/jdu-lab/m6"
m6_remote_directory="$m6_cloud_home/remote-m6"
mkdir -p "$m6_cloud_workspace" "$m6_remote_directory"
chmod 0755 "$root_dir/tests/mock-m6/ssh"
set +e
m6_initial="$(M6_REMOTE_DIR="$m6_remote_directory" JDU_M6_WORKSPACE="$m6_cloud_workspace" PATH="$root_dir/tests/mock-m6:$PATH" HOME="$m6_cloud_home" bash "$root_dir/scripts/jdu-cloudcheck" M6 2>&1)"
set -e
grep -Fxq 'RESULT    0 / 4 checks cleared' <<<"$m6_initial"
printf '%s\n' 'JDU SSH transfer test' > "$m6_cloud_workspace/local-source.txt"
cp "$m6_cloud_workspace/local-source.txt" "$m6_remote_directory/upload.txt"
printf '%s\n' 'REMOTE_USER=ssm-user' 'REMOTE_HOST=mock-host' 'REMOTE_PATH=/home/ssm-user' > "$m6_remote_directory/remote-result.txt"
cp "$m6_remote_directory/remote-result.txt" "$m6_cloud_workspace/downloaded-result.txt"
m6_complete="$(M6_REMOTE_DIR="$m6_remote_directory" JDU_M6_WORKSPACE="$m6_cloud_workspace" PATH="$root_dir/tests/mock-m6:$PATH" HOME="$m6_cloud_home" bash "$root_dir/scripts/jdu-cloudcheck" M6)"
grep -Fxq 'RESULT    4 / 4 checks cleared' <<<"$m6_complete"
grep -Fxq 'PASS      4' <<<"$m6_complete"
HOME="$m6_cloud_home" bash "$root_dir/scripts/jdu-cloud-reset" M6 >/dev/null
[[ ! -e "$m6_cloud_workspace/local-source.txt" && ! -e "$m6_cloud_workspace/downloaded-result.txt" ]]
rm -rf -- "$m6_cloud_home"
printf '%s\n' 'PASS M6 CloudShell tasks start at zero, complete, and reset safely'

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
curl -fsS --max-time 1 http://127.0.0.1:18081/m5-check >/dev/null
grep -Fq 'REQUEST path=/m5-check' "$runtime_directory/http.log"
kill -TERM "$http_pid"
wait "$http_pid" 2>/dev/null || true
http_pid=''
printf '%s\n' 'PASS process worker and HTTP service functional tests'

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
parameters = template["Parameters"]
assert parameters["LabVersion"]["AllowedValues"] == ["v1.3.0"]
user_data = instance["UserData"]["Fn::Base64"]["Fn::Sub"]
with open(sys.argv[2], "rb") as source:
    setup_hash = hashlib.sha256(source.read()).hexdigest()
assert setup_hash in user_data
assert template["Outputs"]["ConnectionMethod"]["Value"] == "SSH over AWS Systems Manager Session Manager"
print("PASS CloudFormation structure")
PY

python3 - \
  "$root_dir/install.sh" \
  "$root_dir/scripts/setup-instance.sh" \
  "$root_dir/scripts/jdu-fixture" \
  "$root_dir/scripts/jdu-labcheck" \
  "$root_dir/scripts/jdu-cloudcheck" \
  "$root_dir/MISSION_GUIDE.md" <<'PY'
import re
import sys
texts = []
for path in sys.argv[1:]:
    with open(path, encoding="utf-8") as source:
        texts.append(source.read())
installer, setup, fixture, checker, cloudchecker, guide = texts
assert 'VERSION="v1.3.0"' in installer
assert 'install -m 0755 "$cloudcheck_path" "$HOME/.local/bin/jdu-check"' in installer
assert 'install -m 0755 "$cloudreset_path" "$HOME/.local/bin/jdu-reset"' in installer
assert '"$HOME/.local/bin/jdu-reset" M6' in installer
assert '/opt/jdu-lab/bin/jdu-fixture reset all' in setup
assert '/usr/local/bin/jdu-check' in setup
assert '/usr/local/bin/jdu-reset' in setup
for mission in range(1, 8):
    assert f"reset_m{mission}()" in fixture
    assert f"check_m{mission}()" in checker
    assert f"## M{mission} " in guide
expected_ids = {
    "M1": {"M1-FS-01", "M1-FS-02", "M1-FS-03", "M1-FS-04", "M1-TXT-01", "M1-TXT-02"},
    "M2": {"M2-ID-01", "M2-PERM-01", "M2-PERM-02", "M2-PERM-03", "M2-PERM-04", "M2-PERM-05"},
    "M3": {"M3-PROC-01", "M3-APT-01"},
    "M4": {"M4-SVC-01", "M4-SVC-02", "M4-SVC-03"},
    "M5": {"M5-SOCK-01", "M5-HTTP-01", "M5-LOG-01", "M5-NEG-01"},
    "M6": {"M6-XFER-01", "M6-REMOTE-01"},
    "M7": {"M7-FILE-01", "M7-PERM-01", "M7-SVC-01", "M7-SOCK-01", "M7-HTTP-01", "M7-LOG-01"},
}
for mission, ids in expected_ids.items():
    found = set(re.findall(rf"{mission}-[A-Z]+-[0-9]+", checker))
    assert found == ids, (mission, found, ids)
assert set(re.findall(r"M6-[A-Z]+-[0-9]+", cloudchecker)) == {
    "M6-LOCAL-01", "M6-XFER-01", "M6-REMOTE-01", "M6-XFER-02"
}
assert "jdu-web.service" in checker and "jdu-web.service" in fixture and "jdu-web.service" in setup
assert "jdu-status.service" not in checker[checker.index("check_m5()") : checker.index("check_m6()")]
assert "chmod 777" not in fixture
assert "初回構築時に、すべてのMissionは自動で未完成の状態になる" in guide
print("PASS Mission task-to-check and automatic-reset contracts")
PY

chmod 0755 "$mock_bin/aws" "$checker"
pass_output="$(PATH="$mock_bin:$PATH" "$checker" --region us-east-1 --stack-name test-stack)"
grep -q '^Required checks: 22 PASS, 0 FAIL, 0 ERROR$' <<<"$pass_output"
set +e
fail_output="$(MOCK_BAD_SG=1 PATH="$mock_bin:$PATH" "$checker" --region us-east-1 --stack-name test-stack 2>&1)"
fail_status=$?
set -e
[[ "$fail_status" -eq 1 ]]
grep -q '^FAIL  Security group has no inbound rules' <<<"$fail_output"
printf '%s\n' 'PASS AWS acceptance checker positive and negative tests'

printf '%s\n' 'ALL TESTS PASSED'
