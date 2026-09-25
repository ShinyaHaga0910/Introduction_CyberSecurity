# Ubuntu and OS Foundations — 完全手順付き演習

対象: Guided Practice P1～P6

環境: Ubuntu Server 24.04 LTS

位置付け: 各Pを練習した後、同じ技能を使うMission Mを自力で解く。

## 0. 共通ルール

P1～P6は練習用である。M1～M6とは別のdirectory、user、group、service、portを使う。M7は統合課題であるため、対応する手順付き演習を設けない。

Ubuntuで次を実行する。表示が`ssm-user`であることを確認する。

```bash
id -un
```

別のuser名が表示された場合は、`exit`を1回実行する。もう一度確認する。

```bash
exit
id -un
```

各手順では、最初に作業directoryへ移動する。移動後に`pwd`で現在地を確認する。

採点は次の形で実行する。

```bash
jdu-check P1
```

最初からやり直す場合だけresetする。

```bash
jdu-reset P1
```

## P1 Shell、path、file、text

### 学ぶこと

- Home directoryと作業directoryを区別する。
- Directoryを作る。
- Fileをコピーする。
- Logから必要な行を保存する。

### 手順1: Home directoryへ移動する

```bash
cd ~
pwd
```

表示が`/home/ssm-user`であることを確認する。

### 手順2: P1 directoryへ移動する

```bash
cd ~/jdu-lab/p1
pwd
tree
```

`inbox`と、未完成の`practice01`を確認する。

### 手順3: 必要なdirectoryを作る

```bash
cd ~/jdu-lab/p1
mkdir -p practice01/config
mkdir -p practice01/logs
mkdir -p practice01/notes
tree practice01
```

### 手順4: Config fileをコピーする

コピー先のdirectoryへ移動する。

```bash
cd ~/jdu-lab/p1/practice01/config
pwd
cp ../../inbox/config/training.conf .
ls -l
```

`.`は現在のdirectoryを表す。

### 手順5: Log fileをコピーする

```bash
cd ~/jdu-lab/p1/practice01/logs
pwd
cp ../../inbox/logs/practice.log .
ls -l
```

### 手順6: 一時fileを探して削除する

`practice01`へ移動する。

```bash
cd ~/jdu-lab/p1/practice01
pwd
find . -type f -name '*.tmp' -print
find . -type f -name '*.tmp' -delete
find . -type f -name '*.tmp' -print
```

最後のcommandで何も表示されないことを確認する。

### 手順7: WARN行を保存する

出力先の`notes`へ移動する。

```bash
cd ~/jdu-lab/p1/practice01/notes
pwd
grep 'WARN' ../logs/practice.log > warnings.txt
cat warnings.txt
```

### 手順8: 最後の4行を保存する

```bash
cd ~/jdu-lab/p1/practice01/notes
tail -n 4 ../logs/practice.log > recent.txt
cat recent.txt
```

### 手順9: 全体を確認する

```bash
cd ~/jdu-lab/p1
tree practice01
stat -c '%U:%G %a %n' practice01 practice01/config/training.conf practice01/logs/practice.log practice01/notes/warnings.txt practice01/notes/recent.txt
jdu-check P1
```

全6件がPASSになったら、M1へ進む。

## P2 User、group、permission、setgid

### 学ぶこと

- Primary groupとsupplementary groupを確認する。
- 共有directoryへgroup permissionを設定する。
- setgidで新しいfileのgroupを継承する。

### 手順1: 管理userを確認する

```bash
cd ~
id -un
id
```

### 手順2: 初期groupを確認する

```bash
getent group practiceops
id jdupracticewriter
id jdupracticeviewer
```

初期状態では`jdupracticeviewer`が`practiceops`に入り、`jdupracticewriter`が入っていない。

### 手順3: Group membershipを修正する

```bash
cd ~
sudo usermod -aG practiceops jdupracticewriter
sudo gpasswd -d jdupracticeviewer practiceops
getent group practiceops
id jdupracticewriter
id jdupracticeviewer
```

### 手順4: 共有directoryを設定する

```bash
cd /srv
pwd
sudo chown root:practiceops jdu-practice-share
sudo chmod 2775 jdu-practice-share
stat -c '%U:%G %a %n' jdu-practice-share
```

### 手順5: GUIDE.txtを設定する

対象directoryへ移動する。

```bash
cd /srv/jdu-practice-share
pwd
sudo chown root:practiceops GUIDE.txt
sudo chmod 664 GUIDE.txt
stat -c '%U:%G %a %n' GUIDE.txt
```

### 手順6: Writerへ切り替えてfileを作る

```bash
cd ~
sudo su - jdupracticewriter
id -un
id
cd /srv/jdu-practice-share
pwd
printf '%s\n' 'guided writer file' > writer-created.txt
ls -l writer-created.txt
exit
id -un
```

最後に`ssm-user`と表示されることを確認する。

### 手順7: Viewerのreadとwriteを確認する

```bash
cd ~
sudo su - jdupracticeviewer
id -un
id
cd /srv/jdu-practice-share
pwd
cat GUIDE.txt
touch viewer-created.txt
exit
id -un
```

`cat`は成功する。`touch`は`Permission denied`になる。これは想定した失敗である。

### 手順8: 採点する

```bash
cd ~
id -un
jdu-check P2
```

全6件がPASSになったら、M2へ進む。

## P3 Processとpackage

第8章を読んだら手順1～4でプロセスを確認・停止する。続いて第9章を読み、手順5～6でパッケージを導入する。両方を終えてから`jdu-check P3`を実行する。

### 学ぶこと

- systemd serviceとprocessのPIDを対応させる。
- PIDを指定してTERM signalを送る。
- `apt`でpackageをinstallする。

### 手順1: 3 serviceを確認する

```bash
cd ~
systemctl list-units --type=service 'jdu-p3-*'
systemctl status jdu-p3-process1.service --no-pager
systemctl status jdu-p3-process2.service --no-pager
systemctl status jdu-p3-process3.service --no-pager
```

### 手順2: Process2のMain PIDを表示する

```bash
systemctl show --property MainPID --value jdu-p3-process2.service
```

### 手順3: PIDをshell変数へ保存する

```bash
P3_PID=$(systemctl show --property MainPID --value jdu-p3-process2.service)
printf '%s\n' "$P3_PID"
ps -fp "$P3_PID"
```

### 手順4: Process2だけへTERMを送る

```bash
sudo kill -TERM "$P3_PID"
systemctl is-active jdu-p3-process1.service
systemctl is-active jdu-p3-process2.service
systemctl is-active jdu-p3-process3.service
```

順に`active`、`inactive`、`active`になる。

### 手順5: figletを調査してinstallする

```bash
cd ~
apt show figlet
sudo apt update
sudo apt install -y figlet
command -v figlet
figlet JDU
```

### 手順6: Packageとcommandの対応を確認する

```bash
dpkg-query -W -f='${Status} ${Version}\n' figlet
dpkg -S /usr/bin/figlet
jdu-check P3
```

全2件がPASSになったら、M3へ進む。

## P4 systemd service

### 学ぶこと

- Unit fileを読む。
- Activeとenabledを別々に設定する。
- Main PIDと実processを対応させる。

### 手順1: Unit fileを読む

```bash
cd ~
systemctl cat jdu-practice-status.service
```

`User`、`WorkingDirectory`、`ExecStart`を確認する。

### 手順2: 初期状態を確認する

```bash
systemctl is-active jdu-practice-status.service
systemctl is-enabled jdu-practice-status.service
```

### 手順3: Serviceをstartする

```bash
sudo systemctl start jdu-practice-status.service
systemctl is-active jdu-practice-status.service
```

### 手順4: Boot時にstartするよう設定する

```bash
sudo systemctl enable jdu-practice-status.service
systemctl is-enabled jdu-practice-status.service
```

### 手順5: Main PIDとprocessを確認する

```bash
P4_PID=$(systemctl show --property MainPID --value jdu-practice-status.service)
printf '%s\n' "$P4_PID"
ps -fp "$P4_PID"
sudo cat "/proc/$P4_PID/cmdline" | tr '\0' ' '
printf '\n'
sudo readlink -f "/proc/$P4_PID/cwd"
```

### 手順6: 採点する

```bash
cd ~
jdu-check P4
```

全3件がPASSになったら、M4へ進む。

## P5 Port、socket、HTTP、journal

### 学ぶこと

- Service、process、listening socketを対応させる。
- IP addressとportを読む。
- HTTP requestがjournalへ記録されることを確認する。

### 手順1: Unit fileを読む

```bash
cd ~
systemctl cat jdu-practice-web.service
```

`127.0.0.1`、`8181`、`jdupracticeweb`、content fileのpathを確認する。

### 手順2: Serviceをstartする

```bash
sudo systemctl start jdu-practice-web.service
systemctl is-active jdu-practice-web.service
```

### 手順3: Listening socketを確認する

```bash
sudo ss -lntp | grep ':8181'
```

`127.0.0.1:8181`を確認する。同じ出力で`0.0.0.0:8181`や`[::]:8181`の待受がないことも確認する。前者はこのホスト内からの接続だけを受け付ける。後者は全アドレスでの待受を表す。

### 手順4: Socket PIDとMain PIDを比較する

```bash
systemctl show --property MainPID --value jdu-practice-web.service
sudo ss -lntp | grep ':8181'
```

2つのPIDが同じであることを確認する。

### 手順5: HTTP responseを確認する

```bash
curl -i http://127.0.0.1:8181/
```

### 手順6: Service userのread権限を確認する

Content directoryへ移動する。

```bash
cd /srv/jdu-practice-web
pwd
stat -c '%U:%G %a %n' index.txt
namei -l /srv/jdu-practice-web/index.txt
id jdupracticeweb
sudo -u jdupracticeweb -- test -r index.txt
echo $?
```

最後の値`0`はread可能を表す。

### 手順7: 学生用requestを送る

```bash
curl -i http://127.0.0.1:8181/p5-check
sudo journalctl -u jdu-practice-web.service --no-pager -n 20
```

`REQUEST path=/p5-check`を確認する。

### 手順8: Closed portと比較する

```bash
curl --max-time 2 http://127.0.0.1:18181/
sudo ss -lnt | grep ':18181'
```

どちらも成功しない。TCP 18181は待ち受けられていない。

### 手順9: 採点する

```bash
cd ~
jdu-check P5
```

全4件がPASSになったら、M5へ進む。

## P6 SSH、remote command、scp

### 学ぶこと

- CloudShellとUbuntuを区別する。
- `scp`でuploadとdownloadを行う。
- SSH remote commandを実行する。

### 手順1: UbuntuからCloudShellへ戻る

Ubuntuのpromptで実行する。

```bash
exit
```

CloudShellで現在地を確認する。

```bash
cd ~
pwd
id -un
hostname
```

### 手順2: CloudShell側の作業directoryを作る

```bash
mkdir -p ~/jdu-lab/p6
cd ~/jdu-lab/p6
pwd
```

### 手順3: Upload元fileを作る

```bash
printf '%s\n' 'JDU SSH guided transfer' > practice-source.txt
cat practice-source.txt
sha256sum practice-source.txt
```

### 手順4: Ubuntu側のdirectoryを作る

CloudShellで実行する。

```bash
ssh jdu-ubuntu 'mkdir -p ~/jdu-lab/p6'
```

### 手順5: Ubuntuへuploadする

CloudShellのP6 directoryにいる状態で実行する。

```bash
cd ~/jdu-lab/p6
scp practice-source.txt jdu-ubuntu:~/jdu-lab/p6/practice-upload.txt
ssh jdu-ubuntu 'sha256sum ~/jdu-lab/p6/practice-upload.txt'
sha256sum practice-source.txt
```

2つのSHA-256が同じであることを確認する。

### 手順6: SSH remote commandで結果fileを作る

CloudShellで、次の1 commandをそのまま実行する。

```bash
ssh jdu-ubuntu 'cd ~/jdu-lab/p6 && printf "REMOTE_USER=%s\nREMOTE_HOST=%s\nREMOTE_PATH=%s\n" "$(id -un)" "$(hostname)" "$HOME" > practice-remote-result.txt'
```

内容をremoteで確認する。

```bash
ssh jdu-ubuntu 'cat ~/jdu-lab/p6/practice-remote-result.txt'
```

### 手順7: Ubuntu側を採点する

Ubuntuへ接続する。

```bash
ssh jdu-ubuntu
cd ~/jdu-lab/p6
pwd
ls -l
jdu-check P6
exit
```

Ubuntu側2件がPASSになる。

### 手順8: Result fileをdownloadする

CloudShellで実行する。

```bash
cd ~/jdu-lab/p6
scp jdu-ubuntu:~/jdu-lab/p6/practice-remote-result.txt practice-downloaded-result.txt
cat practice-downloaded-result.txt
sha256sum practice-downloaded-result.txt
ssh jdu-ubuntu 'sha256sum ~/jdu-lab/p6/practice-remote-result.txt'
```

2つのSHA-256が同じであることを確認する。

### 手順9: CloudShell側を採点する

```bash
cd ~/jdu-lab/p6
jdu-check P6
```

CloudShell側4件がPASSになったら、M6へ進む。

## 学習順序

教科書の章は授業回数と一対一ではない。理解した範囲から演習へ進み、必要なら章へ戻る。

- 第1～3章と第4章の編集の基本を読む。その後、M0で実機のOSを観察する。
- 第4・5章を読んでP1、M1へ進む。
- 第6・7章を読んでP2、M2へ進む。
- 第8章を読んでP3手順1～4を行う。第9章を読んでP3手順5～6を行い、最後にM3へ進む。
- 第10章を読んでP4、M4へ進む。第11章を読んでP5、M5へ進む。
- 第12章を読んでP6、M6へ進む。既習の操作を組み合わせてM7へ進む。

演習全体では次の順序を推奨する。

```text
P1 → M1 → P2 → M2 → P3 → M3 → P4 → M4
   → P5 → M5 → P6 → M6 → M7（統合課題）
```

Pはcommandを見ながら進める。M1～M6ではPのcommandを見ずに、必要なcommandを自分で選ぶ。M7では、M2、M4、M5で学んだ内容を統合する。
