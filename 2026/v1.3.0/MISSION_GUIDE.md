# Ubuntu and OS Foundations — Mission Guide

対象: Mission 0～7
環境: Ubuntu Server 24.04 LTS
進め方: 授業回ではなく、学生ごとの進度でMissionを進める。

## 共通操作

初回構築時に、すべてのMissionは自動で未完成の状態になる。最初にresetする必要はない。

現在のMissionを確認する。

```bash
jdu-check M1
```

最初からやり直す場合だけ、そのMissionをresetする。

```bash
jdu-reset M1
```

reset直後は、すべての課題が`FAIL`になる。これは正常である。LabCheckは状態を修正しない。

## M0 Environment and OS

Ubuntu、Linux kernel、PID 1、現在のuser、hostnameを実機から確認する。`~/jdu-lab/m0/observation.env`へ6項目を記録する。

```text
OS_ID=
OS_VERSION_ID=
KERNEL_RELEASE=
PID1_COMM=
USER_NAME=
HOST_NAME=
```

値は実機のcommand出力から取得する。推測しない。

```bash
jdu-check M0
```

## M1 Shell, path, file, and text

### 目的

相対pathと絶対pathを区別する。Directoryとfileを作る。Fileをコピーする。Logから必要な行を取り出す。

### 初期状態

`~/jdu-lab/m1/inbox`に素材がある。`case01`は未完成であり、`staging`に不要な`.tmp` fileがある。

### 課題

1. 次のdirectory treeを作る。

```text
~/jdu-lab/m1/case01/
├── config/
├── logs/
└── notes/
```

2. `inbox/config/app.conf`を`case01/config/app.conf`へコピーする。
3. `inbox/logs/incident.log`を`case01/logs/incident.log`へコピーする。
4. コピーした2 fileの内容を変更しない。
5. `case01`の中から`.tmp` fileをすべて除く。
6. `case01`以下を現在の学生userが所有する状態にする。
7. `incident.log`から`ERROR`を含む完全な行だけを取り出し、`notes/errors.txt`へ保存する。行番号を付けない。
8. `incident.log`の最後の5行を順序を変えず、`notes/recent.txt`へ保存する。

### 判定

6課題を判定する。Directory、source file、`.tmp`、owner、`errors.txt`、`recent.txt`がそれぞれ課題に対応する。

```bash
jdu-check M1
```

確認候補: `pwd`, `ls`, `tree`, `mkdir`, `cp`, `rm`, `find`, `grep`, `tail`, `stat`

## M2 User, group, permission, and sudo

### 目的

User、primary group、supplementary groupを区別する。共有directoryへgroup accessとsetgidを設定する。

### 初期状態

`jduops`、`jduviewer`、`ops`は存在する。両userは`ops`に所属していない。`/srv/jdu-share`と`README.txt`のowner、group、modeは未完成である。

### 課題

1. `jduops`だけをsupplementary group `ops`へ追加する。
2. `jduviewer`を`ops`へ追加しない。
3. `/srv/jdu-share`を`root:ops`にする。
4. `/srv/jdu-share`をmode `2775`にする。setgidを使う。world-writableにしない。
5. `/srv/jdu-share/README.txt`を`root:ops`、mode `664`にする。
6. `jduops`が共有directoryにfileを作れることを確認する。新しいfileのgroupが`ops`になることも確認する。
7. `jduviewer`が`README.txt`を読めることを確認する。
8. `jduviewer`が共有directoryにfileを作れないことを確認する。

### 判定

6課題を判定する。Group membership、directory owner/group、directory mode、sample file、group継承、viewer accessが対応する。

```bash
jdu-check M2
```

確認候補: `id`, `groups`, `getent passwd`, `getent group`, `stat`, `namei`, `chown`, `chmod`, `usermod`, `sudo -u`

禁止: `chmod 777`

## M3 Process and package

### 目的

Serviceとprocessを対応させる。PIDを指定してsignalを送る。Ubuntu packageを調査し、installする。

### 初期状態

`jdu-m3-process1.service`、`jdu-m3-process2.service`、`jdu-m3-process3.service`が動いている。`cmatrix`は未installである。

### 課題A: process2だけを停止する

1. `jdu-m3-process2.service`のMain PIDを調べる。
2. `ps`で同じPIDのprocessを確認する。
3. そのPIDだけへ`TERM`を送る。
4. `process2`が停止し、`process1`と`process3`が動いていることを確認する。

広い条件の`pkill`、`killall`、signal `KILL`は使わない。

### 課題B: cmatrixをinstallする

1. Package情報を確認する。
2. `apt`で`cmatrix`をinstallする。
3. Commandを実行する。終了は`Ctrl+C`とする。
4. Packageのversionと、`/usr/bin/cmatrix`を提供するpackageを確認する。

### 判定

2課題を判定する。課題A全体で1件、課題B全体で1件である。提出fileはない。

```bash
jdu-check M3
```

確認候補: `systemctl status`, `systemctl show`, `ps`, `kill`, `apt show`, `apt install`, `dpkg-query`, `command -v`, `dpkg -S`

## M4 systemd service

### 目的

Unit file、service、processの関係を確認する。Activeとenabledを区別する。

### 初期状態

教師が用意した`jdu-status.service`はloaded、inactive、disabledである。Unit fileは完成済みである。

### 課題

1. `systemctl cat jdu-status.service`で`User`、`WorkingDirectory`、`ExecStart`を読む。
2. Unit fileを変更せず、serviceをstartする。
3. Boot時にstartするようenableする。
4. Activeとenabledを別々に確認する。
5. Main PIDを調べ、実際のprocessと対応させる。
6. Processのuser、command line、working directoryがunitの指定と一致することを確認する。

### 判定

3課題を判定する。Active、enabled、変更されていないunitと実processの対応がそれぞれ課題になる。提出fileはない。

```bash
jdu-check M4
```

確認候補: `systemctl cat`, `systemctl start`, `systemctl enable`, `systemctl is-active`, `systemctl is-enabled`, `systemctl show`, `ps`, `/proc/PID/cmdline`, `/proc/PID/cwd`

## M5 Port, socket, and log

### 目的

Service、process、socket、IP address、port、HTTP、journalを一つの実行状態として関連付ける。

### 初期状態

教師が用意した`jdu-web.service`はloaded、inactive、disabledである。Unit fileとcontent fileは完成済みである。TCP 8081にはlistenerがない。

### 課題

1. Unit fileの`User`、`ExecStart`、address、port、content pathを読む。
2. Unit fileを変更せず、`jdu-web.service`をstartする。
3. `127.0.0.1:8081`のlistenerを確認する。
4. Socketのowning PIDとserviceのMain PIDを比較する。
5. `0.0.0.0:8081`や`[::]:8081`でlistenしていないことを確認する。
6. `http://127.0.0.1:8081/`へrequestを送り、HTTP responseを確認する。
7. Service user `jduweb`がcontent fileを読めることを確認する。
8. `http://127.0.0.1:8081/m5-check`へrequestを送る。
9. 現在のservice起動に対応するjournalで`REQUEST path=/m5-check`を確認する。
10. TCP 18081にlistenerがなく、HTTP requestが失敗することを確認する。

### 判定

4課題を判定する。ListenerとPID、HTTPとfile access、学生が送ったrequestのlog、open portとclosed portの比較が対応する。LabCheckが送る`/` requestは、学生の`/m5-check`を代行しない。

```bash
jdu-check M5
```

確認候補: `systemctl cat`, `systemctl start`, `systemctl show`, `sudo ss -lntp`, `curl`, `sudo -u`, `sudo journalctl`

## M6 SSH and remote operation

### 目的

CloudShellをlocal、Ubuntuをremoteとして区別する。SSH remote commandと`scp`のupload、downloadを使う。

### 初期状態

SSH鍵、alias `jdu-ubuntu`、Session Manager tunnelは構築済みである。これらは課題点に含めない。CloudShellとUbuntuのMission fileは存在しない。

### 課題

1. CloudShellで`id -un`、`hostname`、`pwd`を確認する。
2. `ssh jdu-ubuntu`またはSSH remote commandで、Ubuntu側の同じ3項目を確認する。
3. CloudShellの`~/jdu-lab/m6/local-source.txt`へ、次の一行だけを書く。

```text
JDU SSH transfer test
```

4. `scp`で、Ubuntuの`~/jdu-lab/m6/upload.txt`へuploadする。
5. SSH remote commandを使い、Ubuntuに`~/jdu-lab/m6/remote-result.txt`を作る。値を手入力しない。

```text
REMOTE_USER=<Ubuntuで取得したuser>
REMOTE_HOST=<Ubuntuで取得したhostname>
REMOTE_PATH=<Ubuntuで取得したhome directory>
```

6. `scp`で、Ubuntuの`remote-result.txt`をCloudShellの`~/jdu-lab/m6/downloaded-result.txt`へdownloadする。
7. Upload元と先、download元と先を`sha256sum`で比較する。

### 判定

Ubuntu側は2課題を判定する。

```bash
jdu-check M6
```

CloudShell側は4課題を判定する。

```bash
jdu-check M6
```

両方で全件`PASS`にする。秘密鍵を表示、提出、移動しない。SSH service、SSH設定、`authorized_keys`を変更しない。

確認候補: `ssh`, `scp`, `sha256sum`, `id`, `hostname`, `pwd`, `printf`

## M7 Integrated Ubuntu check

### 目的

M2、M4、M5の知識を、新しいserviceへ自力で適用する。新しいcommandは追加しない。

### 初期状態

- 教師配布の`jdu-final.service`はloaded、inactive、disabledである。
- `/srv/jdu-final`と`index.txt`は存在しない。
- `jduwriter`と`jduviewer`は`finalops`に所属していない。

### 課題

1. `systemctl cat jdu-final.service`で`User`、`WorkingDirectory`、`ExecStart`を読む。
2. `/srv/jdu-final`を`root:finalops`、mode `2775`で作る。
3. `/srv/jdu-final/index.txt`を作る。内容は`/etc/jdu-lab/final-marker`と同じ一行にする。
4. `index.txt`を`root:finalops`、mode `664`にする。
5. `jduwriter`を`finalops`へ追加する。`jduviewer`は追加しない。
6. Writerがcontentを更新でき、viewerが更新できないことを確認する。
7. Unit fileを変更せず、serviceをstartしてenableする。
8. Serviceが`jdufinal`で動き、`127.0.0.1:8090`だけでlistenすることを確認する。
9. HTTP responseがstatus 200で、指定markerを返すことを確認する。
10. `http://127.0.0.1:8090/m7-check`へrequestを送る。
11. 現在のservice起動に対応するjournalで`REQUEST path=/m7-check`を確認する。

### 判定

6課題を判定する。File構成、writer/viewer、service、socket、HTTP、journalが対応する。Unit file、SSH設定、LabCheckを変更しない。

```bash
jdu-check M7
```

確認候補: `id`, `getent`, `stat`, `chown`, `chmod`, `systemctl`, `ps`, `sudo ss -lntp`, `curl`, `sudo journalctl`

## 安全上の禁止事項

- `chmod 777`を使わない。
- `/etc/ssh/sshd_config`を変更しない。
- `ssh.service`を停止しない。
- `killall`または広い条件の`pkill`を使わない。
- 秘密鍵を表示、提出、Gitへ追加しない。
- 外部hostへscanまたはlogin試行をしない。
