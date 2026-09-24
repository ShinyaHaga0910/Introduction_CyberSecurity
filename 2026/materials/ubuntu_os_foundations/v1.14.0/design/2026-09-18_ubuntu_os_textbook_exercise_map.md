# 演習から抽出するOS知識と教科書の対応

確認日: 2026-09-18。制作担当: GPT-5.6 Solへの引継ぎ資料。

## 1. 正本と抽出方法

公開Lab `Introduction_CyberSecurity` の `2026/v1.5.0/`、commit `8a1cc4c353f8e757f186de5a89adec939d7058fa`を基準とする。

- 学生要件: [MISSION_GUIDE.md](https://github.com/ShinyaHaga0910/Introduction_CyberSecurity/blob/8a1cc4c353f8e757f186de5a89adec939d7058fa/2026/v1.5.0/MISSION_GUIDE.md)
- 練習手順: [GUIDED_PRACTICE.md](https://github.com/ShinyaHaga0910/Introduction_CyberSecurity/blob/8a1cc4c353f8e757f186de5a89adec939d7058fa/2026/v1.5.0/GUIDED_PRACTICE.md)
- 判定実装: 同版の`scripts/jdu-labcheck`、`scripts/jdu-cloudcheck`。
- 初期状態: 同版の`scripts/setup-instance.sh`、`scripts/jdu-fixture`、install、CloudFormation。
- ローカル参照先: `C:/Users/user/Documents/JDU-public/Introduction_CyberSecurity/2026/v1.5.0/`。

抽出は「要求される操作 → 対象となるOSの機能 → 理解に必要な前提 → 説明する章」の順で行う。チェッカーを通す最短手順から章を作らない。判定されない概念でも、操作の意味を理解するために必要なら教える。逆に、チェッカー内部の実装をすべて学生の学習対象にはしない。

章番号は[章・節別設計](./2026-09-18_ubuntu_os_materials_storyboard.md)と対応する。

## 2. 全Missionの知識抽出

| 対象 | 学生が行うこと | 説明が必要な機能・関係 | 読む章 | 理解できたかを問う例 |
| --- | --- | --- | --- | --- |
| M0 | 稼働中のOS、kernel、PID 1、利用者、hostを調べて記録 | OSとkernelの違い、Ubuntuというdistribution、実行中のprocess、hostとuserの違い、端末・shell・ファイル編集 | 1～3、4の基本操作 | Ubuntuのversionとkernelのversionが違ってよい理由は何か |
| P1/M1 | directoryを作る、copy、不要fileの削除、所有者確認、logの行を抽出 | 階層、path、現在位置、内容とmetadata、text、標準入出力、redirect、検索と末尾抽出 | 4・5 | `grep ... > errors.txt`で入力fileと出力fileの役割はどう違うか |
| P2/M2 | groupの追加・除外、共有directoryの権限、別userで操作 | user識別、primary/supplementary group、processが持つ所属情報、認証と権限、suとsudo、file/dirのrwx、setgid、新規fileの作成 | 6・7 | directoryが2775でも既存fileのgroupが自動で変わらないのはなぜか |
| P3/M3 A | 3個から対象processを特定して終了 | programとprocess、PID、unitとMainPIDの最小知識、signal、TERMとKILL、終了とfile削除の違い | 8（serviceの詳説は10） | programのfileを消すことと実行中processを終えることは同じか |
| P3/M3 B | 未導入packageを導入し実行確認 | repository、index、package、依存、実行file、PATH、導入済みと起動中の違い | 9 | apt updateだけで新しいcommandを使えるとは限らないのはなぜか |
| P4/M4 | 既存serviceを起動・自動起動にして実行主体を観察 | systemd、unit、User/WorkingDirectory/ExecStart、active/enabled、設定と稼働状態 | 10 | enabledなのにinactiveという状態は矛盾するか |
| P5/M5 | local HTTPを起動、待受IP/port/PID、読取権限、requestとlog、未使用portとの違い | kernelが提供するsocket、programが要求する待受、TCPの最小概念、loopback、client/server、HTTP、journal、終了状態 | 11 | serviceがactiveでもHTTPで必要な内容が返らないことはあるか |
| P6/M6 | SSHでcommand実行、SCP往復、実行場所とfile内容を比較 | client/server、local/remote、SSH鍵とhost鍵、aliasとDNS、SSM tunnel、shellの引用・展開、home、owner/mode、hash | 12（引用は5） | CloudShellとUbuntuの`~/jdu-lab/m6`は同じ保存場所か |
| M7 | 共有contentと権限、既存service、HTTP、logを組み合わせる | 6・7・10・11章の既習事項。設定・稼働・観測の区別、証拠に基づく状態確認 | 6・7・10・11 | HTTPの結果から逆にfile、process、socketの関係を説明できるか |

M0に必要な「PID 1はOS起動時から動く管理process」「本環境ではsystemd」という最小説明は第1章に置く。第8・10章を先に読まないとM0が成立しない構成にしない。第4章には所有者の最小説明を置き、M1のために第6章全体の先取りを要求しない。

## 3. 現行採点契約を維持する

下表は教材著者用。学生本文に採点内部の条件を機械的に列挙する代わりに、学生の問題文を明確にする。

| 対象 | 判定数 | 判定対象のまとまり |
| --- | ---: | --- |
| M0 | 6 | OS_ID、OS_VERSION_ID、KERNEL_RELEASE、PID1_COMM、USER_NAME、HOST_NAMEを実機と照合 |
| P1/M1 | 各6 | directory、copy内容、不要file不在、所有者、検索行、末尾行 |
| P2/M2 | 各6 | writer/viewerの所属、dir所有者/group、dir2775、file664、writer作成とgroup継承、viewer読取可・作成不可 |
| P3/M3 | 各2 | process2のみ停止・1と3を維持、指定packageの導入・実行file確認 |
| P4/M4 | 各3 | active、enabled、元unitを維持して指定user/command/作業directoryで稼働 |
| P5/M5 | 各4 | 元unitのserviceとloopback待受PID、HTTP内容と読取権限、指定pathの現起動分journal、使用portと未使用portの違い |
| P6/M6 Ubuntu | 各2 | uploadの内容・ssm-user所有・644、remote実行結果の実機一致 |
| P6/M6 CloudShell | 各4 | local原稿、uploadとのhash一致、remote実行結果、downloadとのhash一致 |
| M7 | 6 | contentと所有権、writer/viewerのアクセス、service、socket、HTTP、journal |

集計: P1～P6は27判定、M0～M7は39判定。M6のUbuntu 2件とCloudShell 4件は別区分。IDの末尾が同じでも「実行側＋ID」で区別する。Dashboardとの対応もこの区分で説明する。

チェックの限界:

- 最終状態の合格は、学生がすべてのcommandを自分で入力した証明ではない。
- P2/M2の許可・拒否はcheckerが別userで試験できる。学生の過去の操作履歴は証明しない。
- P5/M5の未使用portもchecker自身が通信する。学生が実際に失敗を体験した証明とは分ける。
- HTTP採点自体がrequestとlogを発生させる。logが一件だけ存在するという説明をしない。
- Ubuntu側checkは`ssm-user`へ戻って行う。演習userのsudo権限を広げて解決しない。
- check/resetの短い入口は現行実装を再確認して掲載する。resetは通常の初回手順ではなく、対象課題をやり直す操作である。影響対象を明示する。

## 4. PとMを混同しないための固定値

この表は正本の読み取り補助である。実際に本文へ転記する直前にも公開版を照合する。

| 対象 | Pの値 | Mの値 |
| --- | --- | --- |
| 1 作業root | `~/jdu-lab/p1/practice01` | `~/jdu-lab/m1/case01` |
| 1 抽出 | WARN行、末尾4行 | ERROR行、末尾5行 |
| 2 共有dirとfile | `/srv/jdu-practice-share/GUIDE.txt` | `/srv/jdu-share/README.txt` |
| 2 group / writer / viewer | `practiceops` / `jdupracticewriter` / `jdupracticeviewer` | `ops` / `jduops` / `jduviewer` |
| 2 metadata | dir `root:practiceops 2775`、file `root:practiceops 664` | dir `root:ops 2775`、file `root:ops 664` |
| 3 process unit | `jdu-p3-process1/2/3.service`の2だけ停止 | `jdu-m3-process1/2/3.service`の2だけ停止 |
| 3 package | `figlet` | `cmatrix` |
| 4 service / user | `jdu-practice-status.service` / `jdupracticeapp` | `jdu-status.service` / `jduapp` |
| 4 作業dir | `/srv/jdu-practice-status` | `/srv/jdu-status` |
| 5 service / user | `jdu-practice-web.service` / `jdupracticeweb` | `jdu-web.service` / `jduweb` |
| 5 content | `/srv/jdu-practice-web/index.txt` | `/srv/jdu-web/index.txt` |
| 5 待受 / 未使用port | `127.0.0.1:8181` / `18181` | `127.0.0.1:8081` / `18081` |
| 5 log照合path | `/p5-check` | `/m5-check` |
| 6 directory（各端末に別々に存在） | `~/jdu-lab/p6` | `~/jdu-lab/m6` |
| 6 source / upload | `practice-source.txt` / `practice-upload.txt` | `local-source.txt` / `upload.txt` |
| 6 remote result / download | `practice-remote-result.txt` / `practice-downloaded-result.txt` | `remote-result.txt` / `downloaded-result.txt` |
| 6 sourceの一行 | `JDU SSH guided transfer` | `JDU SSH transfer test` |

M7は`/srv/jdu-final/index.txt`、`root:finalops`、dir2775・file664、writer=`jduwriter`、viewer=`jduviewer`、service user=`jdufinal`、`jdu-final.service`、`127.0.0.1:8090`、`/m7-check`。markerは実環境の指定fileから読む。値を教科書に固定しない。P7は作らない。

## 5. commandの扱いと教える深さ

「必須」は用途と基本形を理解して選べる水準であり、すべてのoptionの暗記を意味しない。下表を本文と早見表の点検に用いる。

| 分類 | command / 構文 | 教える点・必要なoption | リスクと確認 |
| --- | --- | --- | --- |
| 必須 | `pwd`、`cd` | absolute/relative、`..`、`~`、引数なし | 変更先を`pwd`で確認。root directoryとroot userを区別 |
| 必須 | `ls`、`tree` | `ls -l -a -d`、treeの階層 | 名前一覧だけでは内容・全権限を確認できない |
| 必須 | `mkdir`、`cp`、`mv`、`rm` | `mkdir -p`、fileコピー、移動と改名 | 上書き・削除前にpath確認。初心者課題に`rm -rf`を使わせない |
| 必須 | `nano` | 開く、編集、Ctrl+O、Enter、Ctrl+X | 保存名・保存先を確認して再読。未導入なら教員準備へ |
| 必須 | `cat`、`less`、`head`、`tail`、`grep` | `-n`の意味はcommandごとに違う。grepの`-n`は行番号、tailの`-n N`は行数。`grep -F` | 出力fileを入力と同名にしない。課題のlog抽出へ行番号を混ぜない |
| 必須 | `>`、`>>`、`|` | shellの入出力接続、上書き・追記、stdoutとstderr | `>`は実行前にfileを切り詰め得る。pipeと引数を区別 |
| 必須 | `id`、`groups` | 自分と指定user、`id -un`、主groupと補助group | 既存sessionのgroup情報と登録情報を混同しない |
| 必須 | `sudo`、`su`、`exit` | `su - USER`、`sudo -u USER -- COMMAND`、新shellと一command | 戻る先をid/pwdで確認。service userへ対話loginは不要 |
| 必須 | `usermod`、`gpasswd` | `usermod -aG GROUP USER`、`gpasswd -d USER GROUP` | `-a`なしの`-G`は他の補助groupを失う。再loginとidで確認 |
| 必須 | `chmod`、`chown` | u/g/o、rwx、664/775/2775、`OWNER:GROUP` | recursive変更を常用しない。`stat`/`ls -ld`と別user試験 |
| 必須 | `ps`、`kill` | `ps -p PID -o ...`、一覧、`kill -TERM PID` | PIDの実値を確認。0、負値、1、空値を使わない。pkillへPIDを渡さない |
| 必須 | `apt` | show、update、install、upgradeとの違い | sudo、依存と容量確認。授業外の一括upgradeを課題にしない |
| 必須 | `systemctl` | status、start/stop/restart、enable/disable、is-active/is-enabled、show `-p MainPID` | 起動と自動起動は別。unit変更しない課題で編集しない |
| 必須 | `ss` | `-l -n -t -p`、`sudo ss -lntp` | Listeningを「通信相手待ちの入口」と説明。PIDは権限不足で非表示になり得る |
| 必須 | `curl` | URL、`-i`、必要時`--max-time`、`-f`の有無とHTTPエラー | 本文・HTTP status・終了statusを混同しない |
| 必須 | `journalctl` | `-u UNIT`、`-n N`、`--no-pager` | 時刻一件を転記させない。現在の起動分とrequest pathに注目 |
| 必須 | `ssh`、`scp` | alias、remote command、`host:path`、送受信方向 | 実行場所とuser、鍵の扱い、上書きを確認。安易な`sudo ssh`禁止 |
| 授業内・暗記不要 | `uname -r`、`hostname`、`/etc/os-release`、`/proc/1/comm` | M0で実値を読む | 出力例を提出値にしない |
| 授業内・暗記不要 | `getent passwd/group`、`stat -c`、`namei -l` | 登録DB、metadata、親dirの探索権限 | getent groupの末尾だけではprimary所属者を列挙できない |
| 授業内・暗記不要 | `test -r/-w`、`echo $?` | 指定userのアクセス、終了status | 直後に読む。rootでの成功はservice userの許可を証明しない |
| 授業内・暗記不要 | `printf`、変数、`$(...)`、引用、`&&` | P/Mの実例を一つずつ解体して説明 | local/remoteのどちらのshellが展開するかを明示 |
| 授業内・暗記不要 | `find`、`touch`、`command -v`、`dpkg-query`、`sha256sum` | 観測・確認、package情報・内容比較 | touchは内容消去ではない。hashは所有者・権限を比較しない |
| 授業内・暗記不要 | `readlink`、`tr`、`/proc/PID/` | cwd、NUL区切りcommand lineの観察 | kernel内部解析へ広げない。読取例に限定 |
| 後続単元 | `ip`、`ping`、`dig`、`tcpdump`、`mount`、`df`、`psql` | network、storage、DNS、DBの対応単元で操作 | 本書は関連を紹介するだけ。設定演習を増やさない |
| 対象外 | kernel build/debug、CPU命令、I/O scheduler操作、`mkfs`/partition操作 | 本演習の理解に不要な内部実装・破壊的操作 | 本書に実行手順を入れない |

## 6. 教科書だけでは代替できない確認

各節末に「理由を説明する」「図のどこが変わるか」「二つの出力を読み比べる」問いを置く。任意の理解確認であり、新しい提出物や自動採点条件にはしない。解説は巻末へ付け、M7の完成手順にはしない。

初学者向けPでは、場所・user・`cd`・編集・保存・確認・戻る操作を省略しない。Mでは要件を残し、Pと同じ完成command列を答えとして掲載しない。OSの教科書本文は両方から参照できる共通の説明とする。
