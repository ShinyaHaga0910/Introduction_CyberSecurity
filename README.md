# Introduction to CyberSecurity Labs — September 2026

Japan Digital Universityのサイバーセキュリティ授業で使用する公開実習ファイルです。大学メールアドレスを登録した授業担当者の個人GitHubアカウントで管理します。

## Repository structure

```text
2026/
└── v1.0.0/
    ├── README.md
    ├── bootstrap.sh
    ├── template.yaml
    ├── SHA256SUMS
    └── scripts/
        ├── setup.sh
        └── jdu-labcheck
```

## Release status

準備中です。`2026/v1.0.0` の実行ファイルは、AWS Academy Learner Labでの検証後に公開します。

## Version policy

- 授業では、`main`ではなく固定したversionのURLを使用します。
- 公開済みversionの内容は変更しません。
- 修正時は、新しいversion directoryを作成します。
- AWS認証情報、password、学生情報、正式な採点基準は保存しません。

## Planned student workflow

1. AWS Academy Learner Labへログインします。
2. `Start Lab`を押します。
3. AWS CloudShellを開きます。
4. 指定された`bootstrap.sh`をダウンロードします。
5. checksumを確認します。
6. CloudFormation stackを作成します。

## License

ライセンスは公開前に確定します。現時点では、明示的な利用許諾はありません。
