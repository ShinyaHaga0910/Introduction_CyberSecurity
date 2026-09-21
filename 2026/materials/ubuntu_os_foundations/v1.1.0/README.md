# オペレーティングシステムとLinuxの基本操作

更新: 2026-09-21。状態: **日本語版を改訂し、再生成・静的再検証済み。実機検証と学生試読は未実施。**

Linux未経験の学生が、コンピューター、OS、Linuxの機能を理由と仕組みから学ぶA4縦の教科書である。章別Markdownを内容の正本とし、専用の説明図21点を組み込んだ。PPTXは作成していない。公開Lab v1.5.0、CloudFormation、install、採点スクリプトは変更していない。

## 教材

- 教科書正本: [`docs/ja/textbook/`](./docs/ja/textbook/)
- 完全手順P1～P6: [`docs/ja/practice.md`](./docs/ja/practice.md)
- 自力課題M0～M7: [`docs/ja/missions.md`](./docs/ja/missions.md)
- 用語集・コマンド早見表: [`docs/ja/reference.md`](./docs/ja/reference.md)
- 説明図21点: [`assets/figures/`](./assets/figures/)
- HTML 4冊: [`output/html/`](./output/html/)
- A4 PDF 4冊: [`output/pdf/`](./output/pdf/)
- 多言語化の管理: [`localization/`](./localization/)
- 再生成手順: [`BUILD.md`](./BUILD.md)

PDFは、教科書54ページ、練習11ページ、課題9ページ、参照資料7ページである。合計81ページである。改訂対象の教科書54ページを画像化し、文字や図の重なり、見切れ、不自然な空白、図とコードの可読性を目視で確認した。

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

静的に確認済みなのは、13章と21図の存在、MarkdownからHTML/PDFへの変換、A4寸法、文字抽出、日本語フォント埋め込み、P27判定・M39判定・M6のUbuntu 2件／CloudShell 4件との対応、公開版P/M本文とのSHA-256一致である。

新規Ubuntu 24.04 LabでのP1～P6通し実行、現行イメージでのnano確認、学生試読は未実施である。これらはPDFの制作完了とは分けて扱う。

旧成果物専用の退避フォルダーは、ユーザーの指定により完全削除の対象である。削除実行はツール制限により拒否されたため、現在は削除待ちの状態である。なお、旧成果物は教材として使用しない。
