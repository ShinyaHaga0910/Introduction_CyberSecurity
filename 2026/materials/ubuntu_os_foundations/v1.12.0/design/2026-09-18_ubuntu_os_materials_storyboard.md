# オペレーティングシステムとLinuxの基本操作 章・節別執筆設計

改訂日: 2026-09-21  
旧名は参照継続のため残すが、本書はスライドのstoryboardではない。  
上位: [制作仕様](./2026-09-18_ubuntu_os_materials_production_spec.md)  
対応根拠: [演習からの知識抽出](./2026-09-18_ubuntu_os_textbook_exercise_map.md)

## 読み方

以下はSolが執筆する章の設計であり、学生へ配る完成本文ではない。各節番号をMarkdown見出しまたは安定したanchorに使う。本文は段落で説明する。設計表の文言をそのまま印刷して納品しない。

図のF番号は説明目的の識別子で、枚数ではない。一つの比較を複数画像に分けてもよい。図と説明の間に対応があることを優先する。原稿は`docs/ja/textbook/`へ章別に置く。

## 01 コンピューターとオペレーティングシステム

原稿: `01-os-and-system.md`  
問い: コンピューターの部品、アプリケーション、OSはどのようにつながり、パソコンとサーバーは何を共有するのか。  
採用理由: OSを課題の確認項目としてではなく、コンピューター全体を動かす基盤として理解するため。

### 執筆する節

- 1.1 コンピューターの構成: CPU、メモリ、ストレージ、入力装置、出力装置、ネットワークの役割を説明する。
- 1.2 パソコンとサーバー: 基本構成は共通で、主な違いは用途、接続方法、性能、連続稼働要件であることを説明する。EC2は仮想的なコンピューターとして位置付ける。
- 1.3 OSの管理対象: 実行、メモリとファイル、利用者と保護、通信を共通機能として説明する。
- 1.4 GUI・CLI・コマンド: CLIとコマンドを定義してから、`cat`を一例として導入する。未定義のコマンドを突然提示しない。
- 1.5 ユーザー空間とカーネル空間: GUI関連プログラム、CLI関連プログラム、アプリケーション、サービスはユーザー空間で動き、カーネル空間の機能を利用すると説明する。
- 1.6 LinuxとUbuntu: Linuxを中心に説明し、Ubuntuは授業で使用するLinuxディストリビューションの一例として短く位置付ける。
- 1.7 起動順序: ファームウェア、ブートローダー、カーネル、PID 1のsystemd、サービスプロセスという概略を説明する。プロセスとサービスを先に定義し、詳細は8・10章へ送る。
- 1.8 ホストと識別: 一般的なホスト、ホスト名、ユーザー名、UID、GIDを説明してから、学生PC、CloudShell、Ubuntu EC2の違いへ接続する。
- 章末確認: 問題直後に答えを置く。M0の提出項目一覧は課題冊子へ任せ、教科書本文へ重複掲載しない。

必要な図: F01「パソコンとサーバーに共通する構成」、F02「ユーザー空間とカーネル空間」、F02b「電源投入からサービスまで」、F02c「ホストとユーザーの識別」。図中の副題は置かず、各キャプションは一文にする。

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

- 8.1 プログラムとプロセス: 保存された実行ファイル、実行中のプロセス、配布単位のパッケージ、管理単位のサービスを区別する。
- 8.2 PIDと親子関係: `ps`でPID・PPID・実行user・コマンド名を観察する。PIDは動的で再利用され得る。
- 8.3 フォアグラウンドとバックグラウンド: シェルが待機する実行と、`&`で次の入力を受け付ける実行を説明する。
- 8.4 シグナル: TERM、KILL、INTの役割と、PID指定の`kill`と名前パターン指定の`pkill`を区別する。
- 8.5 プロセスとファイル: プロセス終了は実行ファイルの削除ではない。systemdの`Restart=`により、サービスが再起動される場合がある。
- 8.6 `/proc/PID`: `$$`で現在のシェルのPIDを確認し、cmdlineとcwdから実行状態を見る。

現行本文の図: fig12「パッケージ・プログラム・プロセス・サービスの関係」。

読了時の説明: 「PIDはなぜ固定できないか」「killしてもインストール済みprogramは残るか」。

## 09 パッケージと導入

原稿: `09-packages-and-apt.md`  
前提: 4章、8章のprogram/process。問い: コマンドが使えるようになるまで、何がどこへ追加されるか。

### 執筆する節

- 9.1 package: program、関連file、依存情報を管理可能な単位へまとめる。一つのpackageが複数fileを含み、package名とcommand名が常に一致するわけではない。
- 9.2 repositoryとindex: 配布元とlocalのindexを区別する。`apt update`で一覧、`apt show`でpackage情報を確認し、`apt upgrade`で導入済みpackageを更新する。
- 9.3 導入と実行: `apt install`で取得・導入する。依存関係と管理権限を説明する。package導入とprocess起動は別の状態であり、導入時にserviceが起動するpackageもある。
- 9.4 導入を確認: version、`command -v`、`dpkg -S`、`dpkg-query -W`の対応。単に実行できるだけで提供packageの説明は終わらない。
- 9.5 削除とクリーンアップ: `remove`、`purge`、`autoremove`の影響範囲を区別する。

必要な図: F20「repository→indexとpackage取得→配置file→実行process」。`apt update`と`install`の矢印を別にする。

読了時の説明: 「apt updateだけではcmatrixが使えるようにならない理由」「apt upgradeとapt installの違い」「dpkg -Sで何を照会しているか」。

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

- 11.1 service・process・socket: systemdの管理、サービスプロセスの実行、カーネルの通信機能を分ける。
- 11.2 protocol・IP address・port: TCPを通信方式として紹介し、127.0.0.1、0.0.0.0、[::]の待受範囲を区別する。0.0.0.0だけでInternet到達可能とはしない。
- 11.3 ssの読み方: `-l -n -t -p`、LISTEN、Local Address:Port、users/pid。sudoは他userのprocess情報確認に必要となる場合がある。
- 11.4 client/serverとHTTP: `curl -i`、URLのhost/port/path、request、status、header、body。接続とHTTP応答は別である。
- 11.5 開いたportと閉じたport: 待受socketの有無を説明する。待受なしの接続拒否とタイムアウトを同一視せず、待受とHTTP応答を区別する。
- 11.6 service userの読取権限: 親directoryを通過してfileを読める必要がある。`sudo -u`と`test -r`で確認できる。
- 11.7 log: programの出力をjournaldが収集する場合と、`journalctl`での閲覧を説明する。記録内容はprogramの実装と設定に依存する。
- 11.8 Webサービスの処理の流れ: unit設定、process、待受socket、client要求、HTTP応答、logの役割を一般的な例として結ぶ。

本文の図: 図11-1「systemd、service process、socket、clientの関係」、図11-2「ss出力の読み取り」。

読了時の説明: 「activeなのに期待したHTTP応答を得られない例」「ssのPIDとMainPIDを比べる意味」「待受とHTTP応答が別である理由」。

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
