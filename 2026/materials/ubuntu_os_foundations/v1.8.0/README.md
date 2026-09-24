# オペレーティングシステムとLinuxの基本操作

更新: 2026-09-24。状態: **日本語版を改訂し、再生成・静的再検証済み。実機検証と学生試読は未実施。**

Linux未経験の学生が、コンピューター、OS、Linuxの機能を理由と仕組みから学ぶA4縦の教科書である。章別Markdownを内容の正本とし、専用の説明図21点と歴史写真1点を組み込んだ。PPTXは作成していない。公開Lab v1.5.0、CloudFormation、install、採点スクリプトは変更していない。

教材v1.4.0では、第2章の系統図へUbuntu、Debian、Fedoraを追加した。第3章はAWS固有の説明と権限の先取りを除き、ターミナル、シェル、組み込みコマンド、外部コマンド、エイリアス、基本的な調査方法を初学者向けの順序で説明する構成へ改訂した。

教材v1.5.0では、第2章の歴史写真をDEC PDP-7の保存機の写真へ変更した。第4章はディレクトリ階層の図、ホームディレクトリとルートディレクトリの違い、親ディレクトリの通過権限を説明し直し、不要な節を削除した。章末確認は各問の直下に答えを置いた。

教材v1.6.0では、第5章から演習番号や課題の採点条件に関するコメントを削除した。各コマンドの一般的な機能説明は残し、章末確認の3問に答えを追加した。

教材v1.7.0では、第6章の冒頭でroot・一般ユーザー・サービス用ユーザーの役割を説明した。アカウント、認証、認可はSSH接続の例を使って詳しく区別した。課題固有の指示文を削除し、章末3問に答えを追加した。

教材v1.8.0では、第7章から演習・課題に固有の指示やコメントを削除した。アクセス権、setgid、umaskの一般的な説明は維持し、章末3問に答えを追加した。

## 教材

- 教科書正本: [`docs/ja/textbook/`](./docs/ja/textbook/)
- 完全手順P1～P6: [`docs/ja/practice.md`](./docs/ja/practice.md)
- 自力課題M0～M7: [`docs/ja/missions.md`](./docs/ja/missions.md)
- 用語集・コマンド早見表: [`docs/ja/reference.md`](./docs/ja/reference.md)
- 現行説明図21点と旧版PNG 21点: [`assets/figures/`](./assets/figures/)
- 図の分類と生成元: [`assets/figure-sources-v1.2/`](./assets/figure-sources-v1.2/)
- 歴史写真とライセンス記録: [`assets/historical/`](./assets/historical/)
- HTML 4冊: [`output/html/`](./output/html/)
- A4 PDF 4冊: [`output/pdf/`](./output/pdf/)
- 多言語化の管理: [`localization/`](./localization/)
- 再生成手順: [`BUILD.md`](./BUILD.md)

PDFは、教科書56ページ、練習11ページ、課題9ページ、参照資料7ページである。合計83ページである。今回変更した第7章の全ページを画像化し、文字や図の重なり、見切れ、不自然な空白、図・コードの可読性を目視で確認した。その他のページは前版で確認済みである。

現行の21図は、内容に応じてD2、Typst、Freeze + Typstへ分類した。同じ配色、字体、枠線、余白の規則で統一している。旧版PNG 21点は比較と復元のために保持しているが、本文からは参照しない。

## 言語構成

英語版を将来の翻訳原本とし、同じファイル名・章番号を日本語、ウズベク語、ロシア語で維持する。

| 言語 | ディレクトリ | 現在の状態 |
|---|---|---|
| 英語 | `docs/en/` | 原本を今後作成 |
| 日本語 | `docs/ja/` | 現行版あり。Antigravity校閲済み |
| ウズベク語 | `docs/uz/` | 英語原本から今後翻訳 |
| ロシア語 | `docs/ru/` | 英語原本から今後翻訳 |

章ID、図ID、コマンド、パス、ユーザー名、グループ名、ユニット名、チェックIDは全言語で共通とする。訳語は[`localization/terminology.csv`](./localization/terminology.csv)、制作状態は[`localization/manifest.json`](./localization/manifest.json)で管理する。

## 設計と検証

1. [制作仕様](./design/2026-09-18_ubuntu_os_materials_production_spec.md)
2. [13章の章・節別設計](./design/2026-09-18_ubuntu_os_materials_storyboard.md)
3. [演習からの知識抽出・採点との対応](./design/2026-09-18_ubuntu_os_textbook_exercise_map.md)
4. [一次資料・確認記録](./design/2026-09-18_ubuntu_os_textbook_sources.md)
5. [GPT-5.6 Solへの制作手順](./design/2026-09-18_ubuntu_os_materials_sol_handoff.md)
6. [演習対応表](./instructor/coverage.md)
7. [制作・検証記録](./instructor/validation.md)
8. [一次資料記録](./instructor/sources.md)

## 章構成

1. コンピューターとオペレーティングシステム
2. Unixから現在のOSへ
3. GUI・CLI・ターミナル・シェル
4. ファイル、ディレクトリ、パス、編集
5. テキストと入出力
6. ユーザー、グループ、ログイン
7. アクセス権と共有ディレクトリ
8. プログラムとプロセス
9. パッケージと導入
10. systemdとサービス
11. ソケット、HTTP、ログ
12. SSHと二つの環境
13. OSの機能を組み合わせる

章の番号は授業回（コマ）と1対1で対応しているわけではない。演習の進度に応じて必要な章を読み、P1～P6で練習し、M0～M7の課題へ取り組む構成である。CPUやディスク内部の詳細は対象外とするが、CPU・メモリ・保存領域の役割と、OSがそれらを管理する理由は明確に説明している。

## 検証範囲

静的に確認済みなのは、13章、21図、歴史写真1点の存在、MarkdownからHTML/PDFへの変換、A4寸法、文字抽出、日本語フォント埋め込み、P27判定・M39判定・M6のUbuntu 2件／CloudShell 4件との対応、公開版P/M本文とのSHA-256一致である。

新規Ubuntu 24.04 LabでのP1～P6通し実行、現行イメージでのnano確認、学生試読は未実施である。これらはPDFの制作完了とは分けて扱う。

旧成果物専用の退避フォルダーは、ユーザーの指定により完全削除の対象である。削除実行はツール制限により拒否されたため、現在は削除待ちの状態である。なお、旧成果物は教材として使用しない。
