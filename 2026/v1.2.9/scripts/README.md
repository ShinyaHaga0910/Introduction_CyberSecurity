# Scripts

このdirectoryには、CloudFormationとUbuntu EC2で使用する公開scriptを格納します。

- `setup-instance.sh`: EC2 UserDataから実行する。
- `check-aws-environment.sh`: CloudShellからAWS構成をread-onlyで確認する。
- `jdu-fixture`: Ubuntu内の課題fixtureをresetする。
- `jdu-labcheck`: Ubuntu内で学生の課題状態を確認する。
- `jdu-probe`: M2、M5、M6の安全な負試験を実行して最小記録を残す。
- `jdu-cloudcheck`: CloudShell側からM6の鍵と接続を確認する。
- `jdu-worker`: M3のprocess観察用program。
- `jdu-http-service`: M4、M5、M7のservice、socket、HTTP、journal観察用program。
- `jdu-prepare-student-home`: Session Managerが作成した`ssm-user`の課題directoryを初期化する。

教師専用の採点条件、秘密情報、学生情報は格納しません。
