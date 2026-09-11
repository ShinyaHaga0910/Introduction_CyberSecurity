# Scripts

このdirectoryには、CloudFormationとUbuntu EC2で使用する公開scriptを格納します。

- `setup-instance.sh`: EC2 UserDataから実行する。
- `check-aws-environment.sh`: CloudShellからAWS構成をread-onlyで確認する。
- `jdu-fixture`: Ubuntu内の課題fixtureをresetする。
- `jdu-labcheck`: Ubuntu内で学生の課題状態を確認する。
- `jdu-prepare-student-home`: Session Managerが作成した`ssm-user`の課題directoryを初期化する。

教師専用の採点条件、秘密情報、学生情報は格納しません。
