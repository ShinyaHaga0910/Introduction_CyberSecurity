# Ubuntu・OS基礎 教科書の章・節別執筆設計

改訂日: 2026-09-18  
旧名は参照継続のため残すが、本書はスライドのstoryboardではない。  
上位: [制作仕様](./2026-09-18_ubuntu_os_materials_production_spec.md)  
対応根拠: [演習からの知識抽出](./2026-09-18_ubuntu_os_textbook_exercise_map.md)

## 読み方

以下はSolが執筆する章の設計であり、学生へ配る完成本文ではない。各節番号をMarkdown見出しまたは安定したanchorに使う。本文は段落で説明する。設計表の文言をそのまま印刷して納品しない。

図のF番号は説明目的の識別子で、枚数ではない。一つの比較を複数画像に分けてもよい。図と説明の間に対応があることを優先する。原稿は`docs/ja/textbook/`へ章別に置く。

## 01 OSの役割とシステム全体

原稿: `01-os-and-system.md`  
問い: 「ファイルを読む」「プログラムを動かす」「複数の人が同じサーバーを使う」とき、誰が調整するのか。  
採用理由: M0の前提、全Missionの操作対象。

### 執筆する節

- 1.1 コンピュータで仕事が行われるまで: CPUは処理、メモリは実行中の作業領域、ストレージは保存先。アプリケーションとデータを分ける。
- 1.2 OSが必要な理由: 複数のプログラムが資源を使うこと、共通のファイル・通信機能、利用者間の保護。単なる「仲介役」で終えない。
- 1.3 OSとカーネル: カーネル、利用者側のプログラム、ライブラリ・ツール・管理機能の役割。ユーザー空間は「一般ユーザーだけが使う場所」ではない。
- 1.4 OSへ処理を依頼する: `cat`がファイルを開いて読む例。システムコールはプログラムからカーネルへ依頼する窓口として紹介する。API実装は扱わない。
- 1.5 実行中の単位: プロセスと実行ユーザーを先に短く定義する。PIDは実行中の識別番号。起動したUbuntuではPID 1にsystemdがあることをM0へ接続する。詳細は8・10章。
- 1.6 今回の環境: 学生PCのブラウザ、CloudShell、Ubuntu EC2を別の実行環境として説明。EC2は仮想的なコンピュータ。ブラウザの画面と実際の実行先を混同しない。

必要な図: F01「OSの構成と責任分担」、F02「ファイルを読む要求と結果」。Ubuntuの範囲を囲み、カーネルとの包含関係を示す。

読了時の説明: 「OSの仕事を三つ挙げ、それぞれ演習のどの操作で使うか」「カーネルとシェルの違い」。

深さの上限: CPU命令、ページテーブル、コンテキストスイッチの実装は説明しない。並行実行は概念だけとし、すべてのCPUが一度に一つしか実行しないと一般化しない。

## 02 Unixから現在のOSへ

原稿: `02-unix-linux-os-history.md`  
前提: 1章。問い: 同じようなコマンドが使えるOSと、使い方が違うOSがあるのはなぜか。

### 執筆する節

- 2.1 Unixの誕生: 1969年のBell Labsを起点とし、ファイル階層、プロセス、複数ユーザー、パイプが発展したことを説明。小さなコマンドを組み合わせる考え方をM1へつなぐ。
- 2.2 UnixとUnix系: 歴史的なOS、互換性のある考え方、UNIX認証を区別。全系統を列挙しない。
- 2.3 LinuxとGNU: Linuxは独立に実装されたUnix-likeなカーネル。GNU等のツール群と組み合わせて使われる。Linuxという語がカーネルとシステム全体の両方に使われることを説明。
- 2.4 ディストリビューションとUbuntu: カーネル、ツール、パッケージ管理、既定設定、更新の提供を一つにまとめる。UbuntuとDebianの関係を位置付ける。Ubuntuの版とkernelの版が別である理由をM0の二つの値へ接続する。
- 2.5 macOS: BSD・Mach・NeXTの技術、Darwin、Mac OS XからmacOSへ。古いMac OSを同一のカーネル系列として描かない。Appleのアーカイブは系譜確認に使い、現行機能の根拠にはしない。
- 2.6 Windows: 初期のDOS系WindowsとNT系を区別する。現代WindowsはNT系。Unix→Windowsという単純な枝を描かない。CLIを備えることとUnix由来であることは別。
- 2.7 共通点と違い: どのOSにもプロセス・ファイル・権限・通信という役割があるが、管理コマンドや具体的な仕組みは異なる。Linuxの`systemctl`をmacOS/Windows共通のコマンドと説明しない。

必要な図: F03「影響と継承を分けた歴史図」、F04「Linuxカーネル＋ツール群＋管理・配布＝Ubuntuという構成図」。F03の年号は[資料台帳](./2026-09-18_ubuntu_os_textbook_sources.md)で確認できたものだけを使う。

読了時の説明: 「UbuntuとLinuxはどう違うか」「macOSとLinuxは似ているが同じ系列ではない理由」「WindowsをUnixの直接の子孫として描けない理由」。

深さの上限: 全Unix商用製品の年表、ライセンス論争、MachとLinuxの設計比較、NT内部構造には進まない。

## 03 GUI・CLI・ターミナル・シェル

原稿: `03-interfaces-and-shell.md`  
前提: 1章。問い: 画面へ入力した文字は、誰が解釈して実行するのか。

### 執筆する節

- 3.1 GUIとCLI: 操作方法の違い。GUIアプリとCLIプログラムはどちらもOS機能を使える。GUIが必ずCLIを呼ぶわけではない。
- 3.2 ターミナルとシェル: ターミナルは入力・出力の画面、シェルは入力を解釈するプログラム。Bashを今回のシェルとして紹介。
- 3.3 コマンドの読み方: コマンド名、option、引数、空白、大小文字、引用符。`$`やpromptは入力対象ではない。
- 3.4 組込みと外部プログラム: `cd`は現在のシェルの作業場所を変える。`cat`等は外部プログラム。`PATH`と`command -v`を導入し、PATHを編集させない。
- 3.5 入力から結果まで: シェルによる解釈、外部プログラムの実行、結果表示、promptの復帰。成功時に無出力でも正常な場合がある。
- 3.6 操作場所の確認: `id -un`、`hostname`、`pwd`の違い。root userと`ssm-user`、CloudShellのuserを区別する。既定のuser名からOSの種類を推測しない。
- 3.7 中断と終了: Enter、Ctrl+C、pagerの`q`、shellの`exit`。前景で動くコマンドとpromptの状態を説明する。
- 3.8 調べ方: `man`、`--help`、optionの意味を読む方法。終了値0と非0、`echo $?`は直前の結果という入口を置く。

必要な図: F05「GUIとCLIがOSへ到達する二つの経路」、F06「prompt・入力・出力の注釈図」。

読了時の説明: 「黒い画面がカーネルではない理由」「cdでファイルが移動するわけではない理由」「q、Ctrl+C、exitの使い分け」。

## 04 ファイル、ディレクトリ、パス、編集

原稿: `04-files-paths-editor.md`  
前提: 3章。問い: 同じファイル名なのに見つからないのはなぜか。

### 執筆する節

- 4.1 ファイルとディレクトリ: 内容、名前、属性を区別。拡張子だけでOSが全動作を決めるわけではない。
- 4.2 ファイルシステム: 名前で保存内容へアクセスする仕組み。`/`からの一つの階層。保存先と論理的なpathを分け、mountを概念だけ紹介。
- 4.3 `/`、`/root`、root user、home: 同じrootという語の違い。`~`は現在のuserのhome。
- 4.4 絶対・相対パス: `/`、`.`、`..`。現在地を二つに変え、同じ相対パスが別の対象になる例を説明する。
- 4.5 ディレクトリの役割: `/home`、`/etc`、`/usr`、`/srv`、`/var/log`、`/tmp`、`/proc`。`/proc`は実行状態を見せる仮想的な仕組み。名称一覧の暗記にしない。
- 4.6 作成・コピー・削除: `mkdir`、`cp`、`rm`、`find`、`touch`。コピーは別のfileを作ること、削除は通常の端末操作ではごみ箱へ移らないこと。削除範囲を先に読む。
- 4.7 中身と属性を読む: `cat`、`ls -l`、`tree`、`stat`。所有者の概念を先に短く定義し、M1ではssm-userで作業する。詳細は6・7章。
- 4.8 nanoで編集する: 先に`cd`と`pwd`。開く、入力する、Ctrl+O、Enter、Ctrl+X、`cat`で結果を見る。nano画面の模式図を実際に作る。
- 4.9 M0の観察: `/etc/os-release`、`uname -r`、`ps -p 1 -o comm=`、`id -un`、`hostname`。6つのkeyにどの情報を記すかを説明する。値は実機で取得し、解答fileを自動生成しない。

必要な図: F07「現在地と絶対・相対パス」、F08「コピー前後の二つのfile」、F09「nanoの保存・終了画面」。

読了時の説明: 「../../の二段はどこか」「unameの版とUbuntuの版が違ってよい理由」。

## 05 テキストと入出力

原稿: `05-text-and-streams.md`  
前提: 3・4章。問い: 画面に出た結果を、別のコマンドやファイルへ渡すにはどうするか。

### 執筆する節

- 5.1 設定ファイルとログ: 設定はプログラムが読む条件、ログはプログラムが記録した出来事。時刻やERRORは文字列であり、書式はプログラムによる。
- 5.2 標準入力・標準出力・標準エラー出力: 別々の流れ。画面の文字がすべて同じ出力先ではない。
- 5.3 検索と末尾表示: `grep`は一致する完全な行、`tail -n`は末尾の行数。元の順序を保つ。`grep -n`は表示に便利だが保存内容を変える。
- 5.4 保存と上書き: `>`と`>>`はシェルが処理する。空になる危険があるため入力元と出力先を同名にしない。
- 5.5 パイプ: 左の標準出力を右の標準入力へ渡す。`ss ... | grep ...`を後の11章へ接続。通常は標準エラーを渡さない。
- 5.6 引用符とワイルドカード: `find -name '*.tmp'`で引用する理由。正規表現とshellのglobは別。今回必要な範囲のみ。
- 5.7 変数とコマンド置換: `NAME=value`、`"$NAME"`、`$(...)`、`&&`、`printf`。PID取得とSSHに備える。代入の`=`の前後に空白を入れない。
- 5.8 終了値で判断する: grepの不一致、testの偽、一般的エラーを区別。非0をすべて故障と呼ばない。

必要な図: F10「入力・出力・エラーの流れ」、F11「grep＋>の入力fileと保存先」、F12「引用符で展開される場所の違い（12章でも使用）」。

読了時の説明: 「grep自体がerrors.txtを指定されていないのに保存される理由」「>と>>で既存内容がどう変わるか」。

## 06 ユーザー、グループ、ログイン

原稿: `06-users-groups-sessions.md`  
前提: 1章のプロセスの概要、3・4章。問い: 同じサーバーの利用者やプログラムをどう区別するか。

### 執筆する節

- 6.1 user名とUID、group名とGID: OSが管理する識別子。ファイルの所有情報とプロセスの実行主体。
- 6.2 主グループと補助グループ: 一人が複数groupへ所属する意味。userと同名groupの作成はツール・設定依存であり絶対規則ではない。
- 6.3 名前と所属を調べる: `id`、`groups`、`getent passwd`、`getent group`。getentは設定された名前サービスを照会する。groupのメンバー欄だけでは主グループ所属を網羅しない。
- 6.4 所属変更: `usermod -aG`、`gpasswd -d`。`-a`省略の影響。設定の変更と既存セッションの所属情報が同時に更新されるとは限らない。
- 6.5 sudoとsu: 認証・許可の役割、対象user、login shell。ssm-userはrootそのものではなく、Labでsudoが許可された管理user。
- 6.6 切替と復帰: ssm-user→演習user→exit→ssm-user。異なるuserへ切り替える前に元へ戻る理由。`id -un`で確認する。
- 6.7 service user: 対話loginを許可しないuserでもprocessを実行できる。`nologin`と`sudo -u USER -- COMMAND`。

必要な図: F13「user・主group・補助group」、F14「セッションの入れ子とexit」。

読了時の説明: 「groupから外したのに古いshellの権限が残る場合」「service userへsuできなくてもserviceが動く理由」。

## 07 アクセス権と共有ディレクトリ

原稿: `07-permissions-and-sharing.md`  
前提: 4・6章。問い: 読む・書く・作る・通過する許可は、どの対象のどの情報から決まるか。

### 執筆する節

- 7.1 カーネルによるアクセス確認: processのuser/groupと対象fileの属性。通常のUnix modeによる判定を対象とし、rootやACL等の例外範囲を明示する。
- 7.2 owner/group/other: 該当するクラスを選ぶ。三組を合算しない。所有者なのにowner権限がない場合、otherへ自動的に回らない。
- 7.3 fileのrwx: 内容の読取、変更、実行。実行可能にするだけでは有効なプログラムになるわけではない。
- 7.4 directoryのrwx: 名前の一覧、項目の追加・削除、通過。file読取とdirectory内での作成を別々に説明。親directoryのxが必要。
- 7.5 数値表現: r=4、w=2、x=1、三つの桁。664、775を分解。`chown`と`chmod`が変える属性を比較。
- 7.6 setgid: 共有先で新規fileのgroupが揃う理由。設定なし／ありで同じuserが作成する例。2775の先頭2と通常rwxを区別。s/Sはgroup xの有無との組合せ。
- 7.7 新規fileのmode: group継承とpermission継承は別。作成時のmodeとumaskの役割を説明し、必要に応じて後からmodeを設定する。今回umaskの変更課題は追加しない。
- 7.8 実効的な確認: `stat`、`namei -l`、`sudo -u ... test -r`、`echo $?`。group所属を見ただけで実際の読取可否を断定しない。
- 7.9 許可と拒否: writerは作成、viewerは読取のみ。拒否は設定が正しい結果の場合もある。setgidは全directoryに必須の設定ではない。

必要な図: F15「どの権限クラスを使うか」、F16「file操作と親directoryの権限」、F17「setgidなし／ありのgroup継承比較」。

読了時の説明: 「viewerが読めるのに作れない理由」「2775にしても新規fileが2775にならない理由」。

深さの上限: ACL、capability、AppArmor、SELinux、setuidの詳細は補足への誘導だけ。sticky/setuidは先頭桁の他の値として紹介できるが必須操作にはしない。

## 08 プログラムとプロセス

原稿: `08-processes-and-signals.md`  
前提: 1・3・5・6章。問い: 同じプログラムを三回動かすと何が三つになるか。

### 執筆する節

- 8.1 保存されたプログラムと実行中のプロセス: 実行にはメモリ等が必要。PID、実行user、作業directory、引数は実行中の状態。
- 8.2 複数プロセス: 同じprogramから複数の実行。親子関係、foreground/backgroundの概念。serviceと背景実行を同義にしない。
- 8.3 状態の観察: `ps -fp PID`の列、動的PID、`/proc/PID`。対象が終了すると観察結果も変わる。
- 8.4 M3に必要なserviceの入口: systemdは起動を管理するプログラム、unit名は管理対象の名前、MainPIDは主processの番号。`systemctl status/show/list-units`を名前からPIDを探す用途に限定して先行紹介。設定全体は10章。
- 8.5 シグナルと終了: TERMは終了要求、KILLは強制。`kill`はfile削除ではない。PIDに対するkillと名前等を条件にするpkillを区別。
- 8.6 対象を確かめる: PID取得→psで対象確認→TERM→対象と非対象の状態確認。PIDは直前に取得し、空、0、1、非数値、不一致なら進まない。
- 8.7 管理者による再起動: process終了後にmanagerが再起動する場合がある。本LabのM3/P3はRestart=noなので再起動しない。一般的なserviceの挙動と分ける。

必要な図: F18「一つのprogramから三つのprocess」、F19「process2へのTERMと1/3の継続」。

読了時の説明: 「PIDはなぜ固定できないか」「killしてもインストール済みprogramは残るか」。

## 09 パッケージと導入

原稿: `09-packages-and-apt.md`  
前提: 4章、8章のprogram/process。問い: コマンドが使えるようになるまで、何がどこへ追加されるか。

### 執筆する節

- 9.1 package: program、関連file、依存情報を管理可能な単位へまとめる。一つのpackageが複数fileを含み、package名とcommand名が常に一致するわけではない。
- 9.2 repositoryとindex: 配布元、利用可能packageの情報、localのindexを区別。
- 9.3 aptの役割: `show`で調査、`update`でindex更新、`install`で取得・導入。updateとupgradeも意味だけ区別。
- 9.4 依存関係: 必要な別packageも解決されること。管理権限が必要な理由。
- 9.5 導入を確認: version、`command -v`、`dpkg -S`、`dpkg-query -W`の対応。単に実行できるだけで提供packageの説明は終わらない。
- 9.6 導入と起動: packageが入った状態とprocessが動く状態は別。install時にserviceが起動するpackageもあるため「絶対に起動しない」としない。

必要な図: F20「repository→indexとpackage取得→配置file→実行process」。`apt update`と`install`の矢印を別にする。

読了時の説明: 「apt updateだけではfigletが使えるようにならない理由」「dpkg -Sで何を照会しているか」。

## 10 systemdとサービス

原稿: `10-services-and-systemd.md`  
前提: 6～9章。問い: loginしていなくてもサーバーの機能が動くのはなぜか。

### 執筆する節

- 10.1 serviceとは: 継続的な機能を提供するプログラム群と、その実行を管理する単位。一般的なserviceとsystemdのservice unitを使い分けて説明。
- 10.2 systemdとPID 1: Labでは起動後の管理をsystemdが担う。systemdはLinuxカーネルそのものではない。全Linuxで必須とはしない。
- 10.3 unitとprocess: ファイルの存在、設定の読込、実行中状態を区別。`User`、`WorkingDirectory`、`ExecStart`を配布unitの実例で読む。
- 10.4 start/stop/restartとenable/disable: 現在状態と起動時設定の二軸。4状態表を実際に掲載し、enabled＋inactiveの例を説明する。
- 10.5 実行状態の照合: MainPID、psのuserとcommand、`/proc/PID/cmdline`とcwd。`tr '\0' ' '`、`readlink -f`を補助読取として説明。暗記は求めない。
- 10.6 serviceの権限: loginしたssm-userの権限と、User=で実行されるprocessの権限は別。管理者が起動したからrootで動くとは限らない。
- 10.7 状態だけで保証しない: activeはHTTP成功やdata読取を保証しない。次章で確認対象を広げる。

必要な図: F21「unit→systemd→processの責任分担」、F22「active/enabledの4状態」。

読了時の説明: 「enableしたが動いていないことはあり得るか」「WorkingDirectoryは学生のcdと何が違うか」。

## 11 ソケット、HTTP、ログ

原稿: `11-sockets-http-and-logs.md`  
前提: 5～8・10章。問い: 動いているserviceへ通信が届き、内容が返るまでに何が必要か。

### 執筆する節

- 11.1 client/server: 要求する側と待つ側。同じUbuntu内でも両者は成立する。
- 11.2 socket: processがOSの通信機能を使う窓口。programの要求に応じてkernelが管理する。service起動だけで全processにportが自動的に付くわけではない。
- 11.3 IP address・port・protocol: 今回の待受を識別する情報。TCPは方式名まで。portを単独で「プログラム番号」と定義しない。
- 11.4 localhost: 127.0.0.1、0.0.0.0、[::]の違い。0.0.0.0はそのホストの全IPv4 interfaceへのbindであり、Internet到達可能性の保証ではない。
- 11.5 待受と接続: listenして待つ側とrequestする側。listenerの有無と通信成功を分ける。UDPやUnix domain socketの詳細へ展開しないが、全socketがTCP listenerではないと補足する。
- 11.6 ssの読み方: `-l -n -t -p`、LISTEN、Local Address:Port、users/pid。実例の各欄へ注釈。sudoは他userのprocess情報確認のために必要となる場合がある。
- 11.7 HTTP: `curl -i`、URLのhost/port/path、request、status、header、body。200とbody内容が別の確認であること。
- 11.8 content読取: service userが親directoryを通過してfileを読める必要がある。`test -r`直後の終了値を読む。
- 11.9 log: applicationの出力をjournalへ収集し、journalctlで読む。本Labのprogramがrequestを記録するのであり、OSがすべてのHTTPを自動記録するわけではない。
- 11.10 起動ごとのlog: 同じURLへの繰返しrequest、再起動前後、時刻の表示。現在の起動に対応するrequestを確認する。UTC転記を要求しない。
- 11.11 成功と失敗の比較: 稼働portと未使用port。接続失敗だけで原因を一意に決めず、ss、service状態、応答、logを対応させる。

必要な図: F23「processとkernel内のsocket」、F24「待受addressの範囲」、F25「ss出力の読み取り」、F26「curl→socket→service→content→response、logへの別経路」。

読了時の説明: 「activeなのにcurlが失敗する例」「ssのPIDとMainPIDを比べる意味」「curlを二回実行したlogをどう読むか」。

## 12 SSHと二つの環境

原稿: `12-ssh-and-file-transfer.md`  
前提: 3～7・11章。問い: 接続すると、自分のコマンドとファイルの所在はどう変わるか。

### 執筆する節

- 12.1 local/remoteは視点: 今回はCloudShellをlocal、Ubuntuをremoteと呼ぶ。localという語が必ず手元PCを意味するわけではない。
- 12.2 SSHの役割: 暗号化された通信、接続先の確認、user認証、remote command。暗号方式の数学や実装は不要。
- 12.3 鍵と接続設定: private keyは接続元、公開鍵は接続先の許可情報に対応。ホスト鍵の接続先確認はuser認証鍵と役割が違う。`jdu-ubuntu`はHost設定名であり、必ずしもDNS名ではない。
- 12.4 本Labの経路: CloudShell→Session Manager tunnel→Ubuntuのsshd。AWS権限とSSH user認証は別の確認。private IPへ直接届く構成やInternetの22番公開として描かない。
- 12.5 login前後: id、hostname、pwd、home、ファイルの所在。exitでCloudShellへ戻る。sudo sshでroot側の設定を参照する問題も説明。
- 12.6 scp: upload/downloadでsourceとdestinationが逆。colon後のpathと`~`が指すuser。転送後のowner/modeと内容を別々に確認。
- 12.7 remote command: 外側のシェルと内側のシェル。単一引用符、二重引用符、`$HOME`、`$(...)`、`>`をどちらが解釈するか、具体例で追う。
- 12.8 内容の一致: SHA-256をfile内容の比較に使う。filenameやownerはhashへ含まれない。hash一致だけで転送経路を証明するわけではない。
- 12.9 二つの判定: Ubuntu側2件、CloudShell側4件、合計6件。RESULTとREPORT、送信失敗時のDashboardの古い値を区別。

必要な図: F27「SSH経路・鍵・二つのOS」、F28「upload/download前後のfile」、F12の展開位置図、F29「二つの結果とDashboard」。

読了時の説明: 「Ubuntu内でlocalhostを指定する場合とCloudShellの場合」「鍵をコピーするだけではprivate IPへの経路ができない理由」。

## 13 OSの機能を組み合わせる

原稿: `13-integrated-system.md`  
前提: 1～12章。問い: 一つのサービスを説明するには、どの状態を結び付ければよいか。

### 執筆する節

- 13.1 設定・実体・観察: content、owner/group/mode、service user、unit、process、socket、HTTP、journalを対応させる。
- 13.2 M7への橋渡し: 何をどの手段で確認できるかの表と概念図。解答コマンド列は載せない。新しい課題やunit自作を追加しない。
- 13.3 後続への接続: Nginx、BIND 9、PostgreSQLも実行user、data/config、process、通信、logで観察できる。今回の構成に全く同じ値や起動方式を適用できるとはしない。
- 13.4 自分の言葉で説明する: 任意の概念問題と解説。追加の必須レポートにしない。

必要な図: F30「file・権限・service・process・socket・logを一つの実行状態として結ぶ」。

読了時の説明: 「設定fileがあること、processが動くこと、応答が正しいことの違い」。

## 読む順序と演習の接続

| 演習開始地点 | 読む箇所 | 前提循環への対処 |
| --- | --- | --- |
| M0 | 1～3章、4.1～4.4・4.8～4.9 | process/PID/systemdは1.5で最小定義し、詳細学習は後で行う |
| P1/M1 | 4章、5.1～5.6 | ownerは4.7で導入。chmodやgroup操作を先取りさせない |
| P2/M2 | 6～7章、5.8 | userとprocessの関係は1.5で導入済み |
| P3/M3 | 5.7、8～9章 | service名→MainPIDの読取だけ8.4で扱い、10章未読でも進める |
| P4/M4 | 10章 | PID・user・cwdは既出として再接続 |
| P5/M5 | 11章 | 7章の読取権限と5章の入出力を参照 |
| P6/M6 | 12章、5.7の再確認 | 引用符・置換の説明を長文SSHの前に置く |
| M7 | 13章 | 全手順付きP7を追加しない |

各章末に「この章の機能を使う演習」と必要な節への戻り先を置く。歴史を含む本文はいつでも読み返せる。説明直後の操作や全員同時進行を必須にしない。
