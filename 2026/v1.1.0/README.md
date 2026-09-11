# Introduction CyberSecurity Lab 2026 v1.1.0

Status: Draft / local acceptance tests passed / Learner Lab verification pending

このdirectoryは、2026年度のIntroduction CyberSecurity用AWS Academy Learner Lab配布物を格納します。

## Files

| File | Purpose |
|---|---|
| `install.sh` | CloudShellでSSH鍵を生成し、CloudFormationをdeployしてSSH接続を確認するscript |
| `cloudformation/lab-environment.json` | Ubuntu実習環境を作成するCloudFormation template |
| `scripts/setup-instance.sh` | Ubuntu初期設定script |
| `scripts/check-aws-environment.sh` | AWS全体構成のread-only受入checker |
| `scripts/jdu-fixture` | 課題を未完成の初期状態へ戻すscript |
| `scripts/jdu-labcheck` | 学生の課題状態を確認するscript。v1.0.0ではM0とM1のみ実装 |
| `scripts/jdu-prepare-student-home` | `ssm-user`作成後にhome配下の課題directoryとownerを初期化 |
| `tests/run-tests.sh` | templateとAWS checkerのlocal test |
| `SHA256SUMS` | 配布物のchecksum |

### CloudShell

```bash
curl -fsSLO https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.1.0/install.sh
bash install.sh --region us-east-1
```

既定のEC2 instance profileは`LabInstanceProfile`である。Learner Lab側の名前が異なる場合は、教員が確認した名前を`--instance-profile`で指定する。

### Ubuntuへの接続

`install.sh`はCloudShell専用のEd25519 SSH鍵を`~/.ssh/jdu-intro-cybersecurity-2026`へ作成する。秘密鍵はCloudShellから持ち出さない。公開鍵だけがCloudFormationを通じてUbuntuへ登録される。

```bash
ssh jdu-ubuntu
```

SSHはSession Managerのtunnelを利用する。Security Groupのinbound ruleは0件のままであり、TCP 22をInternetへ公開しない。

初期設定が`ssm-user`、公開鍵、`/home/ssm-user/jdu-lab`を作成する。課題directoryは`ssm-user`所有で、学生は`sudo`なしで書き込める。AWS ConsoleのSession Manager接続も予備経路として利用できる。

### 課題の開始と確認

```bash
jdu-fixture reset M0
jdu-labcheck mission M0
```

reset直後は`NOT_READY`になる。指定された観察結果を作成し、live状態と一致すると`PASS`になる。

## Current limits

- AWS Academy Learner LabでSession Manager SSH documentと必要な権限が許可されるかは実機確認が必要である。
- AWS全体checkerはlocal mock testに合格しているが、実アカウントでは未実行である。
- 学生課題checkerはM0とM1だけ実装済みである。M2からM7は次versionで実装する。

## Planned URL

```text
https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.1.0/install.sh
```

公開済みversionは変更しません。修正が必要な場合は、同じ年度の下に`v1.0.1`などの新しいdirectoryを作成します。
