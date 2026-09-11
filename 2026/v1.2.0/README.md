# Introduction CyberSecurity Lab 2026 v1.2.0

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
| `scripts/jdu-labcheck` | M0～M7の学生課題状態を確認するread-only checker |
| `scripts/jdu-probe` | M2、M5、M6の安全な負試験を実行・記録するscript |
| `scripts/jdu-cloudcheck` | CloudShell側のM6 SSH状態を確認するscript |
| `MISSION_GUIDE.md` | 8 Missionの学生向け要件と提出field |
| `scripts/jdu-prepare-student-home` | `ssm-user`作成後にhome配下の課題directoryとownerを初期化 |
| `tests/run-tests.sh` | templateとAWS checkerのlocal test |
| `SHA256SUMS` | 配布物のchecksum |

### CloudShell

```bash
curl -fsSLO https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.2.0/install.sh
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
jdu-fixture reset M2
jdu-labcheck mission M2
```

M0～M7が実装済みである。Mission番号は授業回ではない。各Missionのreset直後は全体不合格になり、要件を完成すると全required checkが`PASS`になる。

## Current limits

- AWS Academy Learner LabでSession Manager SSH documentと必要な権限が許可されるかは実機確認が必要である。
- AWS全体checkerはlocal mock testに合格しているが、実アカウントでは未実行である。
- M2、M5、M6の負試験は、対応する正試験が成立した後だけ合格になる。
- Learner Lab実機でM0～M7のreference solution受入試験が必要である。

## Planned URL

```text
https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.2.0/install.sh
```

公開済みversionは変更しません。修正が必要な場合は、同じ年度の下に`v1.0.1`などの新しいdirectoryを作成します。
