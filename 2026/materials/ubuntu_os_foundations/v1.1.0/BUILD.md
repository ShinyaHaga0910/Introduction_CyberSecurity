# 教材の再生成

このディレクトリのMarkdownとPythonプログラムから、図、HTML、A4 PDFを再生成できる。

## 必要環境

- Python 3.11以降
- `requirements.txt`に記載したPython package
- Noto Sans JPとNoto Serif JPのTrueType font

Windowsの標準配置では、次のfontを使用する。

```text
C:\Windows\Fonts\NotoSansJP-VF.ttf
C:\Windows\Fonts\NotoSerifJP-VF.ttf
```

別の場所へ導入した場合は、環境変数でTrueType font fileを指定する。

```powershell
$env:JDU_FONT_SANS='C:\path\to\NotoSansJP-Regular.ttf'
$env:JDU_FONT_SERIF='C:\path\to\NotoSerifJP-Regular.ttf'
```

Linuxでは同じ名前の環境変数をexportする。

## 生成順序

repositoryの教材version directoryで実行する。

```bash
python -m pip install -r requirements.txt
python build/generate_figures.py
python build/build_materials.py
```

生成先は`assets/figures/`、`output/html/`、`output/pdf/`である。出力file名には`_ja`などのlanguage codeを付ける。将来の英語、ウズベク語、ロシア語も同じ規則を使用する。

## 正本と生成物

- 内容の正本: `docs/<language-code>/`
- 共通図の生成元: `build/generate_figures.py`
- HTML/PDF生成元: `build/build_materials.py`
- 訳語管理: `localization/terminology.csv`
- 制作状態: `localization/manifest.json`
- `output/`は配布用生成物であり、本文修正は`docs/`へ行う。

## 検証

生成後はPDFを全ページ画像化し、文字切れ、図の分断、コード欠落、表の重なり、空白ページを確認する。P/M本文を変更していない場合は、公開Lab v1.5.0とのhash一致も確認する。
