#!/usr/bin/env bash
set -Eeuo pipefail

VERSION="${1:-v1.1.0}"
case "$VERSION" in
  v1.1.0) ;;
  *) printf 'ERROR Unsupported lab version: %s\n' "$VERSION" >&2; exit 2 ;;
esac

BASE_URL="https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/${VERSION}"
install -d -m 0755 /opt/jdu-lab/bin /opt/jdu-lab/fixtures/m1/source/config /opt/jdu-lab/fixtures/m1/source/logs /opt/jdu-lab/fixtures/m1/source/notes
install -d -m 0755 /var/lib/jdu-lab/progress /etc/jdu-lab

curl -fsSL --retry 5 --retry-delay 5 "$BASE_URL/SHA256SUMS" -o /tmp/jdu-SHA256SUMS
curl -fsSL --retry 5 --retry-delay 5 "$BASE_URL/scripts/jdu-labcheck" -o /opt/jdu-lab/bin/jdu-labcheck
curl -fsSL --retry 5 --retry-delay 5 "$BASE_URL/scripts/jdu-fixture" -o /opt/jdu-lab/bin/jdu-fixture
curl -fsSL --retry 5 --retry-delay 5 "$BASE_URL/scripts/jdu-prepare-student-home" -o /opt/jdu-lab/bin/jdu-prepare-student-home

verify_download() {
  local published_path="$1" local_path="$2" expected
  expected="$(awk -v path="$published_path" '$2 == path {print $1}' /tmp/jdu-SHA256SUMS)"
  [[ "$expected" =~ ^[0-9a-f]{64}$ ]] || return 1
  printf '%s  %s\n' "$expected" "$local_path" | sha256sum --check --status
}
verify_download scripts/jdu-labcheck /opt/jdu-lab/bin/jdu-labcheck
verify_download scripts/jdu-fixture /opt/jdu-lab/bin/jdu-fixture
verify_download scripts/jdu-prepare-student-home /opt/jdu-lab/bin/jdu-prepare-student-home
rm -f -- /tmp/jdu-SHA256SUMS

chmod 0755 /opt/jdu-lab/bin/jdu-labcheck /opt/jdu-lab/bin/jdu-fixture /opt/jdu-lab/bin/jdu-prepare-student-home
ln -sfn /opt/jdu-lab/bin/jdu-labcheck /usr/local/bin/jdu-labcheck
ln -sfn /opt/jdu-lab/bin/jdu-fixture /usr/local/bin/jdu-fixture
ln -sfn /opt/jdu-lab/bin/jdu-prepare-student-home /usr/local/sbin/jdu-prepare-student-home

if ! command -v sshd >/dev/null 2>&1; then
  apt-get update -qq
  DEBIAN_FRONTEND=noninteractive apt-get install -y -qq openssh-server
fi
systemctl enable --now ssh.service

if ! getent passwd ssm-user >/dev/null; then
  useradd --create-home --shell /bin/bash ssm-user
fi
usermod -aG sudo ssm-user
install -d -m 0750 /etc/sudoers.d
printf '%s\n' 'ssm-user ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ssm-user
chmod 0440 /etc/sudoers.d/ssm-user

cat > /etc/systemd/system/jdu-student-home.service <<'UNIT'
[Unit]
Description=Prepare the JDU workspace for the Session Manager student user
ConditionPathExists=/home/ssm-user

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/jdu-prepare-student-home ssm-user
UNIT

cat > /etc/systemd/system/jdu-student-home.path <<'UNIT'
[Unit]
Description=Watch for the Session Manager student home

[Path]
PathExists=/home/ssm-user
Unit=jdu-student-home.service

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable --now jdu-student-home.path
if getent passwd ssm-user >/dev/null; then
  /usr/local/sbin/jdu-prepare-student-home ssm-user
fi

printf '%s\n' 'mode=training' 'course=Introduction_CyberSecurity' > /opt/jdu-lab/fixtures/m1/source/config/app.conf
printf '%s\n' \
  '2026-09-01T08:00:00Z INFO service started' \
  '2026-09-01T08:03:00Z WARN retry requested' \
  '2026-09-01T08:05:00Z ERROR permission denied for report.txt' \
  '2026-09-01T08:06:00Z INFO request completed' \
  '2026-09-01T08:08:00Z ERROR configuration key is missing' \
  '2026-09-01T08:10:00Z INFO service stopped' > /opt/jdu-lab/fixtures/m1/source/logs/incident.log
printf '%s\n' 'Preserve the source files. Build the required case01 tree in your home directory.' > /opt/jdu-lab/fixtures/m1/source/notes/instructions.txt
sha256sum /opt/jdu-lab/fixtures/m1/source/config/app.conf /opt/jdu-lab/fixtures/m1/source/logs/incident.log /opt/jdu-lab/fixtures/m1/source/notes/instructions.txt > /opt/jdu-lab/fixtures/m1/SHA256SUMS
chmod -R a-w /opt/jdu-lab/fixtures

printf '%s\n' "$VERSION" > /etc/jdu-lab/version
printf '%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > /etc/jdu-lab/installed-at-utc
chmod 0644 /etc/jdu-lab/version /etc/jdu-lab/installed-at-utc

if command -v snap >/dev/null 2>&1 && snap list amazon-ssm-agent >/dev/null 2>&1; then
  snap start amazon-ssm-agent >/dev/null 2>&1 || true
elif systemctl list-unit-files amazon-ssm-agent.service >/dev/null 2>&1; then
  systemctl enable --now amazon-ssm-agent.service >/dev/null 2>&1 || true
fi

printf '%s\n' 'JDU_SETUP_COMPLETE'
