# Introduction CyberSecurity Lab 2026 v1.0.0

Status: First distribution candidate / local acceptance tests passed / Learner Lab verification pending

2026年度のAWS Academy Learner Lab用Ubuntu実習環境です。教材とLabをともに`v1.0.0`へ統一しています。

## 学生の初回構築

Learner Labを開始し、CloudShellで実行します。

```bash
curl -fsSLO https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.0.0/install.sh
bash install.sh --region us-east-1
```

`install.sh`は、CloudFormationの構築、CloudShell専用SSH鍵、Session Manager tunnel、Ubuntu初期設定、P1～P6とM1～M7の初期化、教員進捗サーバーへの登録を実行します。進捗送信先と登録キーは設定済みで、学生による入力は不要です。Security Groupのinbound ruleは0件で、TCP 22をインターネットへ公開しません。

Ubuntuへ接続します。

```bash
ssh jdu-ubuntu
```

## 演習と確認

問題文と手順付き解答を載せた[練習P1～P6](GUIDED_PRACTICE.md)と、[自力課題M0～M7](MISSION_GUIDE.md)があります。M0と統合課題M7には対応するPを設けていません。

```text
M0 → P1 → M1 → P2 → M2 → P3前半 → 第9章 → P3後半 → M3
   → P4 → M4 → P5 → M5 → P6 → M6 → M7
```

Ubuntu側では、`ssm-user`で実行します。

```bash
jdu-check P1
jdu-check M1
jdu-reset M1   # 最初からやり直すときだけ
```

確認結果は、設定済みの教員進捗サーバーへ自動送信されます。通信を止めてローカル判定だけ行う場合は`--no-submit`を指定します。初回構築直後に学生が`jdu-reset`する必要はありません。P1～P6とM1～M7の初期状態は0件PASSを意図しています。

P6とM6はUbuntuとCloudShellで別々に`jdu-check`を実行します。DashboardはUbuntu側2件、CloudShell側4件を分けて表示し、双方が全件PASSになったときに完了です。

### 既存のUbuntu環境を使い続ける場合

今回のP1判定修正は、新しくCloudFormationから作る環境には自動で入ります。すでに作成したUbuntu環境では、`ssm-user`として接続し、判定スクリプトだけを更新できます。演習成果物のresetは不要です。

```bash
curl -fsSL https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.0.0/scripts/jdu-labcheck -o /tmp/jdu-labcheck-v1.0.0
printf '%s  %s\n' '266ea663d86fd7480d5a8853e72d94717fa16e879afd54b82ec6ffdcf71719b4' '/tmp/jdu-labcheck-v1.0.0' | sha256sum --check
sudo install -o root -g root -m 0755 /tmp/jdu-labcheck-v1.0.0 /opt/jdu-lab/bin/jdu-labcheck
jdu-check P1
```

更新するまでは、既存環境のP1所有者判定が古い条件で動きます。

## 主なファイル

| ファイル | 役割 |
|---|---|
| `install.sh` | CloudShell・CloudFormation・SSH tunnelの初回構築 |
| `cloudformation/lab-environment.json` | 学生用UbuntuのCloudFormation template |
| `scripts/setup-instance.sh` | Ubuntu初期設定と演習の初期化 |
| `scripts/check-aws-environment.sh` | AWS構成のread-only検査 |
| `scripts/jdu-fixture` | Ubuntu側の初期化 |
| `scripts/jdu-labcheck` | Ubuntu側の課題判定 |
| `scripts/jdu-cloudcheck` | CloudShell側P6/M6の判定 |
| `scripts/jdu-progress` | 匿名server IDと結果のHTTPS送信 |
| `GUIDED_PRACTICE.md` | P1～P6の問題文と手順付き解答 |
| `MISSION_GUIDE.md` | M0～M7の課題文 |
| `tests/run-tests.sh` | ローカル受入試験 |
| `SHA256SUMS` | 配布物のチェックサム |

## 教員用進捗サーバー

学生環境より先に教員のCloudShellで構築します。詳細は[teacher/README.md](teacher/README.md)を参照してください。

```bash
curl -fsSL https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.0.0/teacher/install-teacher.sh -o /tmp/jdu-install-teacher.sh
bash /tmp/jdu-install-teacher.sh --region us-east-1
```

教員のCloudShellで`jdu-dashboard`を実行すると、30分有効の閲覧URLが表示されます。

## 検証範囲と版管理

ローカル自動試験は実施しています。AWS Academy Learner Lab実機での新規構築と全演習の通し受入試験は未完了です。

制作途中の旧版ディレクトリは現行のGitツリーから削除しました。以後の制作途中の変更はこのディレクトリとGitコミット履歴で管理します。旧版の`main`上のURLは使えません。既存のUbuntu環境は自動更新されないため、新しい配布物を試す際は環境を再構築してください。
