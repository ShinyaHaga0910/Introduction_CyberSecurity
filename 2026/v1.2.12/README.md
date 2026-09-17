# Introduction CyberSecurity Lab 2026 v1.2.12

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
| `scripts/jdu-cloudcheck` | CloudShell側のM6 SSH、key、scp、未登録key拒否を確認するscript |
| `MISSION_GUIDE.md` | 8 Missionの学生向け要件 |
| `scripts/jdu-prepare-student-home` | `ssm-user`作成後にhome配下の課題directoryとownerを初期化 |
| `tests/run-tests.sh` | templateとAWS checkerのlocal test |
| `SHA256SUMS` | 配布物のchecksum |

### CloudShell

```bash
curl -fsSLO https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.2.12/install.sh
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
- M6の未登録key試験は、CloudShellから実際のSession Manager tunnelを通して行う。
- Learner Lab実機でM0～M7のreference solution受入試験が必要である。

## Planned URL

```text
https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.2.12/install.sh
```

公開済みversionは変更しません。修正が必要な場合は、同じ年度の下に新しいversion directoryを作成します。

## v1.2.12 correction

- M7のunit authoringを廃止し、完成済みの教師配布unitをloaded、inactive、disabledで配置する。
- 学生はunitを読み、content、group、permissionを構成してserviceを起動する。
- M7の`evidence.env`と結果転記を廃止し、service、process、socket、HTTP、journal、permissionの実状態を直接確認する。
- 学生自身が送った`/m7-check` requestを、現在のservice invocationのjournalから確認する。
- M7をM2・M4・M5の知識を新しい対象へ適用する統合課題として区別する。

## Included corrections through v1.2.11

- M6の`remote-success.env`とUbuntu内の`jdu-probe`を廃止した。
- SSH remote commandでremote identityを作成し、`scp`のuploadとdownloadを必須にした。
- Ubuntu側はSSH server、TCP 22、key登録、転送file、remote command結果を直接確認する。
- CloudShell側はprivate/public key pair、Session Manager ProxyCommand、host key、認証、転送hash、未登録key拒否を直接確認する。

## Included corrections through v1.2.10

- M5の`observation.env`、UTC時刻、marker転記、closed-port probe記録を削除した。
- M5はsocket、HTTP、journal、service user、closed portの現在状態を直接確認する。
- 学生が`/m5-check`へ送ったrequestを、現在のsystemd invocationのjournalから確認する。
- LabCheck自身のhealth requestは`/`を使い、学生の操作を代行しない。

## Included corrections through v1.2.9

- v1.2.1のMission reset修正を含む。
- M0の学生向け結果から環境確認を削除した。
- 学生課題を`M0-OBS-01`～`M0-OBS-06`として個別判定する。
- 全Missionの学生向け結果を`PASS`と`FAIL`だけに統一する。
- 最後に「全確認項目中、何項目をクリアしたか」を表示する。
- M1の`errors.txt`は、ERROR行を元の内容のまま保存する仕様へ変更する。
- 元fileの行番号は不要とする。
- コピーとcommandのどちらでも、完成内容が正しければ合格とする。
- M2の`M2-WRITE-DENY` probeと記録要件を削除する。
- M2のLabCheck自身が、許可された書込みとviewerの書込み拒否を副作用なしで確認する。
- M3のworker名を`process1`、`process2`、`process3`へ簡素化する。
- `process2`だけの停止と、`process1`、`process3`の継続を現在状態から直接確認する。
- M3の`process.env`、`package.env`、metadata要件を削除する。
- M3の追加packageを`tree`から`cmatrix`へ変更する。M3 resetは`tree`を削除しない。
- M4の`evidence.env`と転記判定を削除する。
- M4はactive、enabled、Main PID、実process、実行user、command、working directoryを現在状態から直接確認する。
