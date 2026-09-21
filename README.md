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
├── v1.4.3/
└── v1.5.0/
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

`v1.5.0`が現在の推奨版です。完全手順付き演習P1～P6と、自力課題M0～M7を実装しています。M0には練習問題を設けません。M7は統合課題のため、対応するP7を設けません。P6とM6はUbuntu側2件とCloudShell側4件を別々に記録します。ローカル自動試験済みですが、AWS Academy Learner Lab実機での全受入試験は未完了です。

## Course materials

オペレーティングシステムとLinuxの基本操作に関する教科書と生成元は、Labのversion directoryから分離して管理します。

- [教材 v1.3.0（現在の推奨版）](./2026/materials/ubuntu_os_foundations/v1.3.0/README.md)
- [教材 v1.2.0](./2026/materials/ubuntu_os_foundations/v1.2.0/README.md)
- [教材 v1.1.0](./2026/materials/ubuntu_os_foundations/v1.1.0/README.md)
- [教材 v1.0.0](./2026/materials/ubuntu_os_foundations/v1.0.0/README.md)

教材には、章別Markdown、言語別directory、用語管理、図、図生成program、HTML/PDF生成program、設計・検証資料、配布用HTML/PDFを含みます。v1.3.0では、第2章へPublic domainのUnix開発者写真、shellとBashの説明、Unix系とWindows NT系を分離した図、章末解答を追加しました。現行図21点と旧版PNG 21点も保持しています。英語を将来の翻訳原本とし、日本語、ウズベク語、ロシア語を同じ章IDで管理します。

## Version policy

- 授業では、`main`ではなく固定したversionのURLを使用します。
- 公開済みversionの内容は変更しません。
- 修正時は、新しいversion directoryを作成します。
- AWS認証情報、password、学生情報、正式な採点基準は保存しません。

## Planned student workflow

1. AWS Academy Learner Labへログインします。
2. `Start Lab`を押します。
3. AWS CloudShellを開きます。
4. `2026/v1.5.0/install.sh`をダウンロードします。
5. checksumを確認します。
6. CloudFormation stackを作成します。
7. `install.sh`がCloudShell専用SSH鍵と接続設定を作成します。
8. `ssh jdu-ubuntu`で、Session Manager経由でUbuntuへ接続します。
9. `GUIDED_PRACTICE.md`のP1～P6と、`MISSION_GUIDE.md`のM0～M7を自分の速度で進めます。

Security Groupのinbound ruleは0件のままです。SSHのTCP 22をInternetへ公開しません。秘密鍵はCloudShellから持ち出しません。

教員が学生と同じ手順を試す場合は、[2026 Student trial guide](./2026/STUDENT_TRIAL.md)を使用します。

## License

ライセンスは公開前に確定します。現時点では、明示的な利用許諾はありません。
