# Introduction CyberSecurity Lab 2026 v1.4.2

Status: Draft / local acceptance tests passed / Learner Lab verification pending

2026年度のIntroduction CyberSecurity用AWS Academy Learner Lab配布物です。

## 初回構築

CloudShellで実行します。

```bash
curl -fsSLO https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.4.2/install.sh
bash install.sh --region us-east-1
```

`install.sh`は、CloudFormationのdeploy、CloudShell専用SSH鍵、Session Manager tunnel、Ubuntu初期設定、M1～M7の初期reset、教員progress serverへの登録を自動実行します。Progress endpointとregistration keyはこのversionに設定済みであり、学生は入力しません。Security Groupのinbound ruleは0件です。TCP 22をInternetへ公開しません。

Ubuntuへ接続します。

```bash
ssh jdu-ubuntu
```

## 学生用command

Missionの状態を確認します。

```bash
jdu-check M1
```

教員の進捗サーバーが設定されている場合、確認結果は自動送信されます。採点結果は変わりません。送信失敗も別に表示されます。

```bash
jdu-check M1
jdu-progress id
```

通信を一時的に行わず、local判定だけを実行する場合に限り、`--no-submit`を付けます。

```bash
jdu-check M1 --no-submit
```

最初からやり直す場合だけresetします。

```bash
jdu-reset M1
```

初回構築直後に学生がresetする必要はありません。M1～M7は、学生が何もしていない状態では0件PASSになるよう設計しています。

M6はCloudShellとUbuntuの両方で`jdu-check M6`を実行します。CloudShellのM6だけをやり直す場合も`jdu-reset M6`を使います。

課題本文は[MISSION_GUIDE.md](MISSION_GUIDE.md)を参照してください。

## 主なfile

| File | Purpose |
|---|---|
| `install.sh` | CloudShell、CloudFormation、SSH tunnelの初回構築 |
| `cloudformation/lab-environment.json` | Ubuntu実習環境のCloudFormation template |
| `scripts/setup-instance.sh` | Ubuntu初期設定と全Mission自動reset |
| `scripts/check-aws-environment.sh` | AWS全体構成のread-only受入checker |
| `scripts/jdu-fixture` | Ubuntu側のMission reset本体 |
| `scripts/jdu-labcheck` | Ubuntu側の学生課題checker本体 |
| `scripts/jdu-progress` | 匿名server IDとMission結果のHTTPS送信 |
| `scripts/jdu-cloud-reset` | CloudShell側M6 reset本体 |
| `scripts/jdu-cloudcheck` | CloudShell側M6 checker本体 |
| `MISSION_GUIDE.md` | 学生向け課題本文 |
| `tests/run-tests.sh` | Local acceptance test |
| `SHA256SUMS` | 配布物のchecksum |
| `teacher/install-teacher.sh` | 教員用HTTPS progress serverの構築 |
| `teacher/cloudformation/progress-server.json` | 教員用API Gateway、Lambda、DynamoDB |
| `teacher/scripts/jdu-dashboard` | 30分有効の閲覧URLを発行 |

## 教員用progress server

学生環境より先に、教員のCloudShellで構築します。詳細は[teacher/README.md](teacher/README.md)を参照してください。Installerが、学生へ渡す一行commandを表示します。

```bash
curl -fsSL \
  https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.4.2/teacher/install-teacher.sh \
  -o /tmp/jdu-install-teacher.sh
bash /tmp/jdu-install-teacher.sh --region us-east-1
```

Dashboard URLは教員CloudShellの`jdu-dashboard`で発行します。URLは30分で失効します。

## v1.4.2変更点

- 現行の教員progress endpointと公開registration keyを学生用installerの既定値にしました。
- 学生は`--progress-endpoint`と`--registration-key`を入力する必要がなくなりました。
- 教員用installerが表示する学生commandも、URLとkeyを含まない短い形式に変更しました。
- Endpointを変更する場合に備え、CLI optionとenvironment variableによる上書きは維持します。

## v1.4.1から継続する設計

- `jdu-check Mx`の実行後、進捗サーバーが設定されていれば自動でHTTPS送信します。
- `--submit`は付けなくてよくなりました。旧commandとの互換性のため指定しても動作します。
- 通信を一時停止するための`--no-submit`を追加しました。
- 進捗サーバーが設定されていない環境では、従来どおりlocal判定だけを表示します。

## v1.4.0から継続する設計

- 教員用と学生用のCloudFormationを分離しました。
- API GatewayのHTTPS endpointで進捗を受け取ります。
- 学生名を使わず、random server ID単位でM0～M7の最新結果を表示します。
- 教員のadmin keyはCloudShellだけに保存します。
- Browser用dashboard URLは短時間sessionにしました。
- Local判定後に同じ結果をHTTPSで送れるようにしました。

## v1.3.0から継続する設計

- 初期状態やreset直後に自動でPASSになる確認項目を、M1～M7の学生得点から削除しました。
- 各判定を学生向け課題と一対一に対応させました。
- M1～M7をCloudFormation構築時に自動resetします。
- 学生用commandを`jdu-check Mx`と`jdu-reset Mx`へ短縮しました。
- M5を独立した`jdu-web.service`へ変更し、M4完了がM5の事前PASSにならないようにしました。
- M6では構築済みのSSH鍵やtunnelを得点化せず、学生が作るfile、remote command、upload、downloadだけを判定します。
- M1～M7の問題文を、目的、初期状態、課題、判定、確認候補の同じ粒度で整理しました。

## 制約

- AWS Academy Learner Labの実アカウントで、Session Manager SSH documentと必要権限を最終確認する必要があります。
- Learner Lab実機でM1～M7のreference solution受入試験が必要です。
- 公開済みversionは変更しません。修正時は新しいversion directoryを作成します。
