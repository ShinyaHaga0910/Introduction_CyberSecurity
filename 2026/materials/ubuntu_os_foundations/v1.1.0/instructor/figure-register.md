# 図台帳

すべて本教材用の自作図。生成元: `build/generate_figures.py`。確認日: 2026-09-21。

| 図 | 参照章 | 解消する疑問 | 正確さの注意 |
| --- | --- | --- | --- |
| fig01 | 1 | パソコンとサーバーは何を共有するか | 用途の違いを機械原理の違いとして描かない |
| fig02 | 1 | ユーザー空間とカーネル空間の関係 | GUI/CLIを空間そのものとせず、ユーザー空間の関連プログラムとして描く |
| fig02b | 1 | 電源投入後にサービスが動くまでの順序 | systemd自身をWebやDBの処理主体として描かない |
| fig02c | 1 | ホスト名とユーザー識別の違い | 学生PC、CloudShell、Ubuntuを独立したOS環境として描く |
| fig03 | 2 | Unix、GNU、Linux、Ubuntu、macOS、Windowsの関係 | 継承と影響を線種で分け、WindowsをUnixの子にしない |
| fig04 | 2 | Linux kernelとUbuntuの違い | Ubuntuはkernelだけではない |
| fig05 | 3 | terminal、shell、commandの役割 | SSH時は解釈hostが変わる |
| fig06 | 4 | absolute/relative pathの起点 | directoryを単なる物理箱に固定しない |
| fig07 | 4 | nanoの保存操作 | 実画面に近いキー表示、保存後の再読を含む |
| fig08 | 5 | stdin/stdout/stderrとredirect | `>`はstdout、stderrは別 |
| fig09 | 6 | primary/supplementary group | 登録と既存sessionの資格を分ける |
| fig10 | 7 | u/g/oのどの欄を使うか | 権限を単純加算しない。ACLは範囲外 |
| fig11 | 7 | setgidが何を継承するか | groupのみ。modeはumask等も影響 |
| fig12 | 8 | package/program/process/serviceの違い | 終了と削除を混同しない |
| fig13 | 9 | apt update/installの違い | indexとpackage本体を分ける |
| fig14 | 10 | unit/systemd/process/kernel | 設定とlive状態を分ける |
| fig15 | 11 | service/process/socket/client | serviceとsocketを常に一対一にしない |
| fig16 | 11 | ss出力のどこを読むか | PIDは例、権限不足でprocess欄が見えない場合あり |
| fig17 | 12 | SSH over Session Managerの層 | AWS認証とSSH認証、aliasとDNSを分ける |
| fig18 | 12 | SCPのupload/download方向 | CloudShellをlocal基準とする |
| fig19 | 13 | M7で何を結ぶか | 設定・保存・実行・通信・観測を分ける |

## 目視確認

21点をcontact sheetで確認済み。各図は異なる問いに専用化され、本文の参照と一致する。最終判定はA4 PDF内の実寸で再確認する。
