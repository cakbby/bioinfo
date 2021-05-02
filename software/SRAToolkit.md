<!-- title: SRA Toolkit - software -->
[link-return]: /bioinfo/bioinfo_database.html

# SRA Toolkit

update : 2021/05/03 (追加)

https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software

- [SRA Toolkit](#sra-toolkit)
  - [出来ること](#出来ること)
  - [インストール](#インストール)
    - [伝統的な方法](#伝統的な方法)
    - [conda を使う方法](#conda-を使う方法)
    - [確認](#確認)
  - [fasterq-dump コマンド, prefetch コマンド](#fasterq-dump-コマンド-prefetch-コマンド)
  - [その他のお話](#その他のお話)
    - [wget のインストール](#wget-のインストール)

## 出来ること

SRAをfastqファイルに変換・ダウンロードする fasterq-dump コマンドや SRA のダウンロードなどを行う prefetch コマンドが使えるようになる。

## インストール

### 伝統的な方法

上記ページから各種OSに対応したファイルを手に入れる。Ubuntu on WSL2 を使っている場合は、ダウンロードリンクをコピペしたのち [wget](#wget) を使って以下のようにダウンロードする。cd でまともな場所に移っておく！

```bash
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.11.0/sratoolkit.2.11.0-ubuntu64.tar.gz
```

ダウンロードしたファイルを展開

```bash
tar zxvf sratoolkit.2.11.0-ubuntu64.tar.gz
```

PATH に追加

```bash
export PATH=$PATH:$PWD/sratoolkit.2.11.0-ubuntu64/bin
```

### conda を使う方法

bioconda 環境があれば以下のコマンドでOK

```bash
conda install -c bioconda sra-tools
```

### 確認

```bash
which fasterq-dump
```

と打ってインストール場所が出るか確認

公式には以下のコマンドを打って機能してるか確かめるのがいいらしい。

```bash
fastq-dump --stdout SRR390728 | head -n 8
```

これの結果が次のように出力されればOK

```bash
@SRR390728.1 1 length=72
CATTCTTCACGTAGTTCTCGAGCCTTGGTTTTCAGCGATGGAGAATGACTTTGACAAGCTGAGAGAAGNTNC
+SRR390728.1 1 length=72
;;;;;;;;;;;;;;;;;;;;;;;;;;;9;;665142;;;;;;;;;;;;;;;;;;;;;;;;;;;;;96&&&&(
@SRR390728.2 2 length=72
AAGTAGGTCTCGTCTGTGTTTTCTACGAGCTTGTGTTCCAGCTGACCCACTCCCTGGGTGGGGGGACTGGGT
+SRR390728.2 2 length=72
;;;;;;;;;;;;;;;;;4;;;;3;393.1+4&&5&&;;;;;;;;;;;;;;;;;;;;;<9;<;;;;;464262
```

## fasterq-dump コマンド, prefetch コマンド

fasterq-dump コマンドを用いると、持っているSRAファイルをfastq形式に変換できる。

```bash
fasterq-dump SRR000001.sra
```

.sra がない場合でも、ダウンロードも兼ねてやってくれる。ただし、prefetch を使って落としてきてからの方がいいらしい。SRA形式に対し、FASTQ形式はおよそ7倍のファイルサイズになることが多いという。

```bash
prefetch SRR000001
fasterq-dump SRR000001
```

fasterq-dump は、初期設定で paired-end データを以下の3つのファイルに分ける（SRR000001を例に）。

SRR000001.fastq

SRR000001_1.fastq

SRR000001_2.fastq

他に以下のオプションがある

-O | --outdir : 出力先のディレクトリを指定

--split-spot : 分けたリードを一つのファイルに

--split-files : 分けたリードを別々のファイルに

-Z | --stdout : 出力を標準出力へ (bash に放流)

fasterq-dump と Run Selector の合わせ技で複数ファイルを一気に落としてくることもできる（詳細は[こちら](../database/SRA.html)）。

## その他のお話

より細かい詳細な使い方などは SRA Toolkit Wiki に書いてありそう。また、fastq-dump が高速になったのが fasterq-dump らしい。

### wget のインストール

Homebrew を入れておくことで、以下のコマンドで導入できる。

```bash
brew install wget
```

apt でもOK

[<戻る][link-return]