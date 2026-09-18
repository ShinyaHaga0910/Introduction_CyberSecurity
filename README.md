# Introduction to CyberSecurity Labs — September 2026

Japan Digital Universityのサイバーセキュリティ授業で使用する公開実習ファイルです。大学メールアドレスを登録した授業担当者の個人GitHubアカウントで管理します。

## Repository structure

```text
2026/
├── v1.0.0/
├── v1.1.0/
├── v1.2.0/
├── v1.2.1/
├── v1.2.2/
├── v1.2.3/
├── v1.2.4/
├── v1.2.5/
├── v1.2.6/
├── v1.2.7/
├── v1.2.8/
├── v1.2.9/
├── ...
└── v1.4.3/
    ├── README.md
    ├── install.sh
    ├── cloudformation/
    │   └── lab-environment.json
    ├── SHA256SUMS
    └── scripts/
        ├── setup-instance.sh
        ├── check-aws-environment.sh
        ├── jdu-prepare-student-home
        ├── jdu-fixture
        └── jdu-labcheck
```

## Release status

`v1.4.3`が現在の推奨版です。M0～M7の8課題、CloudShellからSession Manager経由のSSH、学生ごとの自動判定、教員用HTTPS進捗Dashboardを実装しています。M6はUbuntu側2件とCloudShell側4件を別々に記録し、両方の全件PASSで完了とします。ローカル自動試験済みですが、AWS Academy Learner Lab実機での全Mission受入試験は未完了です。

## Version policy

- 授業では、`main`ではなく固定したversionのURLを使用します。
- 公開済みversionの内容は変更しません。
- 修正時は、新しいversion directoryを作成します。
- AWS認証情報、password、学生情報、正式な採点基準は保存しません。

## Planned student workflow

1. AWS Academy Learner Labへログインします。
2. `Start Lab`を押します。
3. AWS CloudShellを開きます。
4. `2026/v1.4.3/install.sh`をダウンロードします。
5. checksumを確認します。
6. CloudFormation stackを作成します。
7. `install.sh`がCloudShell専用SSH鍵と接続設定を作成します。
8. `ssh jdu-ubuntu`で、Session Manager経由でUbuntuへ接続します。
9. `MISSION_GUIDE.md`の要件に従い、M0～M7を自分の速度で進めます。

Security Groupのinbound ruleは0件のままです。SSHのTCP 22をInternetへ公開しません。秘密鍵はCloudShellから持ち出しません。

教員が学生と同じ手順を試す場合は、[2026 Student trial guide](./2026/STUDENT_TRIAL.md)を使用します。

## License

ライセンスは公開前に確定します。現時点では、明示的な利用許諾はありません。
