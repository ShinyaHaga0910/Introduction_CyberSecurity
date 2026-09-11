# Introduction to CyberSecurity Labs — September 2026

Japan Digital Universityのサイバーセキュリティ授業で使用する公開実習ファイルです。大学メールアドレスを登録した授業担当者の個人GitHubアカウントで管理します。

## Repository structure

```text
2026/
└── v1.0.0/
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

ローカル自動試験済みのdraftです。AWS Academy Learner Lab実機での受入試験は未完了です。

## Version policy

- 授業では、`main`ではなく固定したversionのURLを使用します。
- 公開済みversionの内容は変更しません。
- 修正時は、新しいversion directoryを作成します。
- AWS認証情報、password、学生情報、正式な採点基準は保存しません。

## Planned student workflow

1. AWS Academy Learner Labへログインします。
2. `Start Lab`を押します。
3. AWS CloudShellを開きます。
4. 指定された`install.sh`をダウンロードします。
5. checksumを確認します。
6. CloudFormation stackを作成します。
7. EC2画面の`Connect`から`Session Manager`を選びます。SSH keyは使用しません。

教員が学生と同じ手順を試す場合は、[2026 Student trial guide](./2026/STUDENT_TRIAL.md)を使用します。

## License

ライセンスは公開前に確定します。現時点では、明示的な利用許諾はありません。
