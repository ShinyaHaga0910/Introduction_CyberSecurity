# Introduction CyberSecurity Lab 2026 v1.3.0

Status: Draft / local acceptance tests passed / Learner Lab verification pending

2026年度のIntroduction CyberSecurity用AWS Academy Learner Lab配布物です。

## 初回構築

CloudShellで実行します。

```bash
curl -fsSLO https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.3.0/install.sh
bash install.sh --region us-east-1
```

`install.sh`は、CloudFormationのdeploy、CloudShell専用SSH鍵、Session Manager tunnel、Ubuntu初期設定、M1～M7の初期resetを自動実行します。Security Groupのinbound ruleは0件です。TCP 22をInternetへ公開しません。

Ubuntuへ接続します。

```bash
ssh jdu-ubuntu
```

## 学生用command

Missionの状態を確認します。

```bash
jdu-check M1
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
| `scripts/jdu-cloud-reset` | CloudShell側M6 reset本体 |
| `scripts/jdu-cloudcheck` | CloudShell側M6 checker本体 |
| `MISSION_GUIDE.md` | 学生向け課題本文 |
| `tests/run-tests.sh` | Local acceptance test |
| `SHA256SUMS` | 配布物のchecksum |

## v1.3.0変更点

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
