# 使用資料・確認記録

詳細な採用理由と取得失敗は`lesson_plans/2026-09-18_ubuntu_os_textbook_sources.md`を正本とする。

| 分野 | 主資料 | 確認日 | 採用箇所 |
| --- | --- | --- | --- |
| Unix史 | Dennis Ritchie, The Evolution of the Unix Time-sharing System | 2026-09-18 | 第2章 |
| Unix史写真 | Wikimedia Commons, DEC PDP-7.jpg（ComputerGeek7066、CC BY-SA 4.0） | 2026-09-24 | 第2章。保存機の2018年の写真 |
| 初期Unixの機種 | Bell Labs史料, A history of computing at Bell Research Laboratories | 2026-09-24 | 第2章。1969年PDP-7、後にPDP-11 |
| GNU | GNU Initial Announcement / GNU System Overview | 2026-09-18 | 第2章 |
| Shell / Bash | GNU Bash Reference Manual, What is a shell? / What is Bash? | 2026-09-21 | 第2・3章 |
| Linux | kernel.org What is Linux / Kernel documentation Introduction | 2026-09-18 | 第1・2章 |
| macOS/Darwin | Apple Kernel Architecture Overview | 2026-09-18 | 第2章。旧archiveのため歴史・構成のみ |
| Windows | Microsoft Windows NT history / user and kernel mode | 2026-09-18 | 第1・2章 |
| Windows shell | Microsoft Learn, Windows commands | 2026-09-21 | 第2章 |
| Ubuntu user | Ubuntu Server User management | 2026-09-24 | 第6章。root、一般・システム用ユーザー、sudo、アカウント登録 |
| SSH認証 | Ubuntu Server OpenSSH server | 2026-09-24 | 第6章。公開鍵と秘密鍵、authorized_keys、認証 |
| サービス用ユーザー | Ubuntu 24.04 adduser(8)、systemd.exec(5) | 2026-09-24 | 第6章。nologinとUser=の役割 |
| プロセスの資格情報 | Linux man-pages passwd(5)、credentials(7) | 2026-09-24 | 第6章。UID/GIDと権限判定 |
| 現在のシェルのPID | GNU Bash Reference Manual, Special Parameters | 2026-09-24 | 第8章。`$$`の意味 |
| サービス再起動 | Ubuntu 24.04 systemd.service(5) | 2026-09-24 | 第8章。`Restart=`の設定 |
| APT | Ubuntu Server [Install and manage packages](https://ubuntu.com/server/docs/how-to/software/package-management/) / [Managing your software](https://ubuntu.com/server/docs/tutorial/managing-software/) | 2026-09-24 | 第9章。`update`、`upgrade`、`install`の違い |
| systemdと作業ディレクトリ | Ubuntu 24.04 [systemctl(1)](https://manpages.ubuntu.com/manpages/noble/man1/systemctl.1.html)、[systemd.exec(5)](https://manpages.ubuntu.com/manpages/noble/man5/systemd.exec.5.html)、[proc_pid_cwd(5)](https://manpages.ubuntu.com/manpages/noble/man5/proc_pid_cwd.5.html) | 2026-09-24 | 第10章。`cat`の表示対象、`MainPID`、`WorkingDirectory=`、`/proc/PID/cwd` |
| path/socket | Linux man-pages path_resolution(7), socket(7) | 2026-09-18 | 第4・7・11章 |
| 接続拒否とcurl | Linux man-pages [connect(2)](https://www.man7.org/linux/man-pages/man2/connect.2.html)、curl [How to use curl](https://curl.se/docs/manpage.html) | 2026-09-24 | 第11章。待受なしの接続拒否、`--max-time` |
| SSH over SSM | AWS Systems Manager official guide | 2026-09-18 | 第12章 |
| Lab固有値 | 公開Lab v1.5.0 commit 8a1cc4c... | 2026-09-18 | P/M、各章の例 |

## 未確認として残すもの

- Ubuntu 24.04実機での全P手順の通し実行。
- 現行Lab imageでnanoが初期導入済みか。treeはinstall時導入をコード確認済み。
- Web取得できなかったsystemd、Ubuntu Noble man pageの本文。制作内容は実機manualで再確認する。
- 実学生による読解時間、誤読箇所、A4印刷物の授業利用結果。

静的なコード照合と、実機実行・学生試行を同じ「確認済み」にしない。
