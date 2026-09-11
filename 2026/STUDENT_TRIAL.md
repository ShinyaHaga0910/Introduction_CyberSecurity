# Student trial guide

対象version: `v1.1.0` draft
対象範囲: AWS環境構築、Session Manager接続、Mission 0、Mission 1

このguideは、教員が学生と同じ操作を試すためのものである。M2からM7はまだ実装されていない。

## 1. Learner Labを開始する

1. AWS Academy Learner Labで`Start Lab`を押す。
2. AWS表示がgreenになるまで待つ。
3. AWS Consoleを開く。
4. `CloudShell`を開く。

## 2. Ubuntu環境を作る

CloudShellで次を実行する。

```bash
curl -fsSLO https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.1.0/install.sh
bash install.sh --region us-east-1
```

最後に次が表示されれば、AWS全体checkerは合格である。

```text
Required checks: 22 PASS, 0 FAIL, 0 ERROR
PASS The AWS lab environment is ready.
```

`LabInstanceProfile`に関するerrorが出た場合は、その画面を保存する。Learner Lab固有の権限制限を確認する必要がある。

## 3. CloudShellからSSHで接続する

CloudShellで次を実行する。

```bash
ssh jdu-ubuntu
```

`ssm-user`のpromptになれば成功である。SSH keyはCloudShell内にだけ保存される。接続はSession Managerのtunnelを通る。Security GroupのTCP 22 inbound ruleは追加しない。

SSHで接続できない場合の予備経路として、AWS ConsoleのEC2画面から`Connect`、`Session Manager`、`Connect`を選択できる。

## 4. 配置状態を確認する

Ubuntu sessionで次を実行する。

```bash
cat /etc/jdu-lab/version
command -v jdu-fixture
command -v jdu-labcheck
```

`v1.1.0`と二つのcommand pathが表示されることを確認する。

課題directoryのownerと書込み権限も確認する。

```bash
ls -ld "$HOME" "$HOME/jdu-lab" "$HOME/jdu-lab/m0"
test -w "$HOME/jdu-lab/m0" && echo PASS_WRITABLE || echo FAIL_NOT_WRITABLE
```

`ssm-user`がownerで、`PASS_WRITABLE`と表示されることを確認する。課題fileの作成に`sudo`は使わない。

## 5. Mission 0を学生として試す

課題を初期状態にする。

```bash
jdu-fixture reset M0
jdu-labcheck mission M0
```

この時点では`M0-OBS-01`が`NOT_READY`でなければならない。

### 要件

`~/jdu-lab/m0/observation.env`を作る。次のfieldへ、現在のUbuntuから観察した値を保存する。

```text
OS_ID=
OS_VERSION_ID=
KERNEL_RELEASE=
PID1_COMM=
USER_NAME=
HOST_NAME=
```

値を推測しない。Ubuntu上のcommandで確認する。必要なら次のmanualを参照する。

```bash
man uname
man hostname
man id
```

完成後に再実行する。

```bash
jdu-labcheck mission M0
```

全required checkが`PASS`になり、終了code 0になることを確認する。

## 6. Mission 1を学生として試す

```bash
jdu-fixture reset M1
jdu-labcheck mission M1
```

最初は`case01`がないため、`NOT_READY`にならなければならない。

### 要件

`~/jdu-lab/m1/inbox`の資料を確認する。次の完成状態を作る。

```text
~/jdu-lab/m1/case01/
├── config/
│   └── app.conf
├── logs/
│   └── incident.log
└── notes/
    └── errors.txt
```

- `app.conf`と`incident.log`の内容を変更しない。
- `errors.txt`には、`incident.log`の`ERROR`行だけを行番号付きで保存する。
- 元の`inbox`は削除しない。

必要なら次のmanualを参照する。

```bash
man mkdir
man cp
man grep
```

完成後に再実行する。

```bash
jdu-labcheck mission M1
```

全required checkが`PASS`になることを確認する。

## 7. 試行結果として残すもの

次の情報だけを教員記録へ残す。

- Region。
- CloudFormation stack status。
- AWS checkerのPASS、FAIL、ERROR件数。
- CloudShellから`ssh jdu-ubuntu`で接続できたか。
- M0のreset直後と完成後の結果。
- M1のreset直後と完成後の結果。
- errorがある場合は、秘密情報を除いたerror message。

AWS credential、session token、private情報は保存しない。

## 8. 終了時

Learner Labの終了方法は大学の運用指示に従う。CloudFormation stackの削除試験は、削除対象を確認したうえで別途行う。
