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

`jdu-labcheck mission M2`は、`jduops`の書込み成功、`jduviewer`の読取り成功、`jduviewer`の書込み拒否を独立して確認する。M2では別のprobe commandを実行しない。

観察候補: `id`, `getent`, `stat`, `namei`。

## M3 Process and package

三つのserviceが動いている。

### 問題A: process2だけを停止する

- `jdu-m3-process1.service`
- `jdu-m3-process2.service`
- `jdu-m3-process3.service`

`systemctl status`で`jdu-m3-process2.service`を調べる。`Main PID`を確認する。`ps`で同じPIDのprocessを確認する。そのPIDへ`TERM`を送る。

完成要件:

- `process2`だけが停止している。
- `process1`と`process3`は動いている。
- 広い条件の`pkill`や`killall`は使わない。
- `KILL`（signal 9）は使わない。

「停止」はprocessを終了することである。fileを削除することではない。

観察候補: `systemctl list-units`, `systemctl status`, `systemctl show`, `ps`, `kill`, `man 7 signal`。

### 問題B: cmatrixをinstallする

Ubuntuのpackage情報で`cmatrix`の説明を確認する。`apt`を使ってinstallする。`cmatrix`を実行し、動作を確認する。終了は`Ctrl+C`とする。

完成要件:

- `cmatrix` packageがinstallされている。
- `/usr/bin/cmatrix`を実行できる。
- `/usr/bin/cmatrix`が`cmatrix` packageによって配置されている。

観察候補: `apt show`, `apt update`, `apt install`, `dpkg-query`, `command -v`, `dpkg -S`。

M3では提出fileを作らない。LabCheckは現在のprocessとpackageの状態を直接確認する。

## M4 systemd service

`jdu-status.service`は初期状態で停止している。Base unitを直接変更しない。

要件:

- Unitの`User`、`ExecStart`、`WorkingDirectory`を確認する。
- Serviceをstartする。
- Boot時にstartする設定にする。
- Active stateとenabled stateを確認する。
- Main PIDと実際のprocessを対応させる。
- Processの実行user、command、working directoryを確認する。

M4では提出fileを作らない。LabCheckはserviceとprocessの現在状態を直接確認する。

観察候補: `systemctl cat`, `systemctl status`, `systemctl show`, `systemctl is-active`, `systemctl is-enabled`, `ps`, `/proc/PID/cmdline`, `/proc/PID/cwd`。

## M5 Port, socket, and log

このMissionでは`jdu-status.service`を変更しない。Service、process、socket、HTTP response、journalを同じ対象として確認する。

要件:

- TCP 8080のprotocol、address、port、owning PIDを調べる。
- `jdu-status.service`のMain PIDとsocketのowning PIDを比較する。
- Local HTTP requestが成功することを確認する。
- `/m5-check`へrequestを送る。
- 現在起動中のserviceのjournalで`REQUEST path=/m5-check`を確認する。
- TCP 18080にlistenerがないことを確認する。
- TCP 18080へのrequestが失敗することを確認する。

提出fileはない。LabCheckはsocket、HTTP response、journal、closed portを現在状態から直接確認する。LabCheck自身は`/`へ確認requestを送るため、学生が送る`/m5-check`の代わりにはならない。

観察候補: `sudo ss -lntp`, `curl`, `systemctl show`, `sudo journalctl`。

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
