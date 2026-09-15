# Ubuntu and OS Foundations — Mission Guide

対象: Mission 0～7（合計8課題）
環境: Ubuntu Server 24.04 LTS
進め方: 授業回ではなく、学生ごとの進度でMissionを進める。

## 共通操作

Missionを始める前に、そのMissionだけを初期状態へ戻す。

```bash
jdu-fixture reset M2
jdu-labcheck mission M2
```

初回checkは不合格になる。これは正常である。必要な状態を作り、同じcheckを再実行する。

LabCheckは状態を修正しない。`FAIL`では、表示された観察対象を自分で確認する。

## M0 Environment and OS

Ubuntu、Linux kernel、PID 1、現在のuser、hostnameを実機から確認する。

提出先:

```text
~/jdu-lab/m0/observation.env
```

必須問題は6問である。各問題は1項目として個別に判定される。

| 問題 | 確認対象 | 記録field |
|---|---|---|
| 1 | OSの識別子 | `OS_ID` |
| 2 | OSのversion | `OS_VERSION_ID` |
| 3 | 実行中のkernel release | `KERNEL_RELEASE` |
| 4 | PID 1のcommand name | `PID1_COMM` |
| 5 | 現在のuser | `USER_NAME` |
| 6 | hostname | `HOST_NAME` |

提出形式:

```text
OS_ID=
OS_VERSION_ID=
KERNEL_RELEASE=
PID1_COMM=
USER_NAME=
HOST_NAME=
```

LabCheckは`M0-OBS-01`～`M0-OBS-06`の6問だけを`PASS`または`FAIL`で表示する。最後に、6問中何問をクリアしたか表示する。

## M1 Shell, path, file, and text

`~/jdu-lab/m1/inbox`を調べる。次のtreeを作る。

```text
~/jdu-lab/m1/case01/
├── config/app.conf
├── logs/incident.log
└── notes/
    ├── errors.txt
    └── recent.txt
```

`app.conf`と`incident.log`の内容を変更しない。

`errors.txt`の要件:

- 入力は`case01/logs/incident.log`とする。
- `ERROR`を含む行だけを抽出する。
- 日時、`ERROR`、messageを含む元の行全体を、そのまま保存する。
- 元fileの行番号は付けない。
- コピーしても、検索結果を標準出力から保存してもよい。LabCheckは完成した内容を判定する。

`recent.txt`には、`case01/logs/incident.log`の最後の5行を、順序と内容を変えずに保存する。

観察候補: `man grep`、`grep --help`。一致する行だけを表示する方法と、標準出力をfileへ保存する方法を確認する。

## M2 User, group, permission, and sudo

要件:

- `jduops`だけを`ops` groupへ追加する。
- `jduviewer`を`ops` groupへ追加しない。
- `/srv/jdu-share`を`root:ops`にする。
- Directoryへsetgidを設定する。
- Ownerとgroupは更新できる。
- Otherは読むこととdirectoryを通過することだけができる。
- World-writableにしない。

正試験と負試験を実行する。

```bash
jdu-probe run M2-WRITE-DENY
jdu-labcheck mission M2
```

観察候補: `id`, `getent`, `stat`, `namei`。

## M3 Process and package

三つのworkerが動いている。`/run/jdu-lab/m3/metadata.env`は対象userとtokenを示す。PIDを暗記せず、userとfull commandから対象を選ぶ。

要件:

- 対象workerへ`TERM`を送る。
- 二つのdecoy workerを残す。
- 変更前のPID、user、full command、signalを記録する。
- `tree` packageのcandidateと説明を確認してからinstallする。
- Installed versionとcommand pathを記録する。

提出先:

```text
~/jdu-lab/m3/process.env
~/jdu-lab/m3/package.env
```

`process.env`:

```text
TARGET_PID=
TARGET_USER=
TARGET_COMMAND=
SIGNAL=TERM
```

`package.env`:

```text
PACKAGE=tree
VERSION=
COMMAND=/usr/bin/tree
```

観察候補: `ps`, `pgrep`, `/proc/PID/status`, `apt-cache`, `dpkg-query`, `dpkg -S`。

## M4 systemd service

`jdu-status.service`は初期状態で停止している。Base unitを直接変更しない。

要件:

- Unitの`User`、`ExecStart`、`WorkingDirectory`を確認する。
- Serviceをstartする。
- Boot時にstartする設定にする。
- Active state、enabled state、MainPID、実行userを記録する。

提出先:

```text
~/jdu-lab/m4/evidence.env
```

```text
ACTIVE_STATE=
UNIT_FILE_STATE=
MAIN_PID=
SERVICE_USER=
```

観察候補: `systemctl cat`, `systemctl show`, `systemctl is-active`, `systemctl is-enabled`, `ps`。

## M5 Port, socket, and log

このMissionでは`jdu-status.service`を変更しない。Service、process、socket、HTTP response、journalを同じ対象として確認する。

要件:

- TCP 8080のprotocol、address、port、owning PIDを調べる。
- Local HTTP requestのstatusとmarkerを確認する。
- Requestに対応するjournal messageを確認する。
- TCP 18080にlistenerがないことを確認する。
- TCP 18080へのrequestが失敗することを記録する。

```bash
jdu-probe run M5-CLOSED-PORT
```

提出先:

```text
~/jdu-lab/m5/observation.env
```

```text
PROTOCOL=tcp
LOCAL_ADDRESS=127.0.0.1
SERVICE_PORT=8080
MAIN_PID=
HTTP_STATUS=200
HTTP_MARKER=
REQUESTED_AT_UTC=
JOURNAL_MESSAGE=
```

`REQUESTED_AT_UTC`は直近30分以内のUTC時刻とする。

観察候補: `ss`, `curl`, `systemctl show`, `journalctl`。

## M6 SSH and remote operation

CloudShellをlocalとする。Ubuntuをremoteとする。秘密鍵の内容を表示、提出、移動しない。

UbuntuでMissionをresetする。

```bash
jdu-fixture reset M6
```

CloudShellから新しいSSH commandを実行し、remote側へ次を作る。

```text
~/jdu-lab/m6/remote-success.env
```

必須field:

```text
REMOTE_USER=
REMOTE_HOST=
PUBLIC_KEY_FINGERPRINT=
```

値は接続先の実機と、CloudShellにある公開鍵から観察する。秘密鍵から転記しない。

Ubuntuで未登録keyの負試験を実行する。

```bash
jdu-probe run M6-UNREGISTERED-KEY
jdu-labcheck mission M6
```

CloudShell側も確認する。

```bash
~/.local/bin/jdu-cloudcheck mission M6
```

## M7 Integrated Ubuntu check

新しいcommandは追加しない。M1～M6で使った確認方法を組み合わせる。

Read-only template:

```text
/opt/jdu-lab/fixtures/m7/jdu-final.service.template
```

完成要件:

- `jdu-final.service`を作る。
- Serviceは`jdufinal`で動かす。
- Working directoryは`/srv/jdu-final`とする。
- `127.0.0.1:8090`だけでlistenする。
- Content fileは`/srv/jdu-final/index.txt`とする。
- Contentは`/etc/jdu-lab/final-marker`と同じ一行を返す。
- Serviceをactive、enabledにする。
- `/srv/jdu-final`は`root:finalops`、mode `2775`とする。
- `index.txt`は`root:finalops`、mode `664`とする。
- `jduwriter`を`finalops`へ追加する。
- `jduviewer`を`finalops`へ追加しない。
- Template、SSH設定、LabCheckを変更しない。

提出先:

```text
~/jdu-lab/m7/evidence.env
```

```text
ACTIVE_STATE=
UNIT_FILE_STATE=
MAIN_PID=
SERVICE_USER=
PROTOCOL=tcp
LOCAL_ADDRESS=127.0.0.1
SERVICE_PORT=8090
HTTP_STATUS=200
HTTP_MARKER=
REQUESTED_AT_UTC=
CONTENT_OWNER=root
CONTENT_GROUP=finalops
CONTENT_MODE=664
VIEWER_EXIT_CODE=
```

最後に実行する。

```bash
jdu-labcheck final
```

全必須checkが`PASS`になればUbuntu・OS基礎の8課題は完了である。

## 安全上の禁止事項

- `chmod 777`を使わない。
- `/etc/ssh/sshd_config`を変更しない。
- `ssh.service`を停止しない。
- `killall`または広い条件の`pkill`を使わない。
- 秘密鍵を表示、提出、Gitへ追加しない。
- External hostへscanまたはlogin試行をしない。
