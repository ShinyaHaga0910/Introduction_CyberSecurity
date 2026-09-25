# 教科書・演習・採点対応表

基準: 公開Lab v1.5.1。確認日: 2026-09-25。v1.5.0から採点条件は変更していない。

| 対象 | 本文章 | 完全練習 | 自力課題 | 採点数 | 教材で説明する判定根拠 |
| --- | --- | --- | --- | ---: | --- |
| M0 | 1、3、4 | なし | missions M0 | 6 | OS ID/version、kernel、PID1、user、hostを別の観測元から取得 |
| 1 | 4、5 | P1 | M1 | P6 / M6 | path、directory、copy、削除、owner、grep、tail、redirect |
| 2 | 6、7 | P2 | M2 | P6 / M6 | group登録、2775、664、setgid、writer作成、viewer read/write |
| 3 | 8、9 | P3 | M3 | P2 / M2 | Main PID照合とTERM、指定packageの導入・実行file・version |
| 4 | 10 | P4 | M4 | P3 / M3 | active、enabled、unit不変、live user/command/cwd |
| 5 | 6、7、10、11 | P5 | M5 | P4 / M4 | loopback socketとPID、HTTP/permission、current log、closed port |
| 6 Ubuntu | 5、12 | P6 | M6 | P2 / M2 | upload内容・owner・644、remote値 |
| 6 CloudShell | 5、12 | P6 | M6 | P4 / M4 | local source、upload hash、remote値、download hash |
| 7 | 6、7、10、11 | なし | M7 | 6 | file、writer/viewer、service、socket、HTTP、journal |

合計: P1～P6は27判定、M0～M7は39判定。M6はUbuntu 2件とCloudShell 4件を分ける。

## 理解を自動採点で代替しない項目

- OSとkernel、distributionの区別。
- Unix、Linux、macOS、Windowsの歴史的位置付け。
- GUI/CLI、terminal/shellの区別。
- なぜそのpermission classが選ばれるか。
- installed、running、active、enabled、listening、HTTP成功の区別。
- local/remote、Host alias/DNS、AWS認証/SSH認証の区別。

これらは章末問いと授業中の説明で確認する。新しい必須提出物やchecker条件にはしない。

## checkerで確認できることの限界

- 最終状態は確認できるが、学生が指定の学習経路で操作したことまでは証明しない。
- checker自身のHTTP requestもlogを作る。
- permission probeはcheckerが別userで実行するため、学生自身の失敗体験の証明ではない。
- M6は実行環境ごとにcheckerが異なる。Dashboardの二欄を合算して完了とする。
