# 制作・検証記録

更新: 2026-09-21。

## 内容検査

- [x] 13章のMarkdownが存在する。
- [x] OS、history、interface、file、text、identity、permission、process、package、service、socket/HTTP/log、SSH、統合を説明した。
- [x] CPU・memory・storageの役割を説明し、内部algorithmは対象外にした。
- [x] パソコンとサーバーの共通構成、入力・出力装置、仮想サーバーを第1章のOS説明より前に置いた。
- [x] UnixからLinuxへsource継承の実線を引かず、macOS/WindowsをLinux系にしていない。
- [x] Windows NT系をUnix系・Unix互換系と別枠にし、command体系の互換性を前提にしていない。
- [x] shellをcommand interpreterとして定義し、Bashをkernelやterminalと区別した。
- [x] GUI/CLI、terminal/shell、program/process、package/service、service/socketを本文と図で区別した。
- [x] P1～P6とM0～M7を公開Lab v1.5.0から内容同一で教材へ接続した。
- [x] coverage上でP27、M39、M6 Ubuntu 2 / CloudShell 4を確認した。
- [x] command早見表に用途、必要option、危険、確認方法を記載した。

## 図検査

- [x] 本文参照21点のSVGを生成した。
- [x] 第2章の歴史写真1点について、Public domainの表示、出典、作者、確認日を記録した。
- [x] D2 19点、Typst 1点、Freeze + Typst 1点へ分類した。
- [x] 旧版PNG 21点を保持し、現行本文からは参照していない。
- [x] 21点すべてに専用の問いがあり、無関係な図を代用していない。
- [x] 配色、字体、枠線、余白、線種を共通仕様へ統一した。
- [x] 図中の見出し下の副題を削除し、本文キャプションを原則一文にした。
- [x] contact sheetで全図を目視した。
- [x] A4 PDF内の実寸で全図を確認した。

## 変換・PDF検査

- [x] HTMLへ13章・図・表・codeが欠落なく変換される。
- [x] A4縦PDFを4冊生成した。
- [x] PDF text抽出で章・P/M・早見表を照合した。
- [x] 改訂対象の教科書54ページをPNG化し、重なり、切れ、空白、図・写真の縮小を確認した。
- [x] page count、A4寸法、font埋込み、header/footer/page numberを確認した。

## 出力結果

| 冊子 | ページ | 文字抽出 | 図 | A4 | 目視 |
|---|---:|---:|---:|---|---|
| 教科書 | 54 | 58,078文字 | 21図・1写真 | PASS | PASS |
| 完全手順P1～P6 | 11 | 8,726文字 | 0 | PASS | PASS |
| 自力課題M0～M7 | 9 | 9,284文字 | 0 | PASS | PASS |
| 用語集・コマンド早見表 | 7 | 6,332文字 | 0 | PASS | PASS |

- Antigravity CLI 1.2.6の`gemini-3.8-flash-high`で、13章、用語集、図中文字、READMEの日本語を校閲した。
- 実行用bashコードブロックは校閲前後で完全一致した。
- 現行図はD2、Typst、Freezeのテキスト形式の生成元から再生成できる。
- 13章、本文参照21図、歴史写真1点、HTML内画像22点に参照切れなし。
- 第1章は、コンピューターの構成、PCとサーバー、OS、GUI/CLIとコマンド、ユーザー空間とカーネル空間、Linux、起動順序、ホストとユーザーの順へ改訂した。
- 第1章のM0提出項目表を削除し、章末確認の各設問直後に答えを掲載した。
- P冊子とM冊子は公開Lab v1.5.0の原文とSHA-256が一致した。
- P27判定、M39判定、M6 Ubuntu 2件／CloudShell 4件をcoverageで照合した。
- HTML/PDFのcodeにHTML entityが文字として残っていない。
- 日本語本文フォントはPDFへ埋め込まれている。
- 公開Lab v1.5.0のCloudFormation、install、採点スクリプトは変更していない。

## 実機・教育検査

- [ ] 新規Ubuntu 24.04 LabでP1～P6を通し実行する。
- [ ] nanoの導入状態と表示を現行imageで確認する。
- [ ] 学生による試読を行い、未定義語、停止点、誤解を記録する。

上記3項目は静的検証では代替しない。教材制作は完了だが、授業投入前の実機・学生検証として残す。
