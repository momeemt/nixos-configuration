<h1 align="center">️❄️ config</h1>

システム、ユーザ環境、インフラストラクチャ、複数のノードなどを宣言的に管理する設定群です。

## 設定の反映

> [!WARNING]
> このconfigを試したい場合には、[使ってみる](#使ってみる)セクションで説明されている通り、Dockerコンテナで利用することをおすすめします。これらの設定はユーザ名やパス、[クレデンシャル](./secrets)など[作者](https://github.com/momeemt)個人の情報に大きく依存しており、あなたの環境にそのまま適用することはできません。ただし、ツールやシステムの設定はモジュールとして切り出されているため、十分にNixの知識がある場合にはこのリポジトリをフォークして、不要なファイルを削除して、設定項目を更新してから、自己責任で設定を反映するようにしてください。

設定の反映には、[Nix](https://github.com/NixOS/nix) が必要です。
以下のいずれかの方法でNixをインストールしてください。

- [nix-installer](https://github.com/DeterminateSystems/nix-installer) (推奨)
- [Nix Download](https://nixos.org/download/)

また、以下のOSに対する反映をサポートしています。

- [macOS Tahoe](https://www.apple.com/jp/os/macos/)
- [NixOS 25.05](https://nixos.org/download/)

### 初回の反映

最初にこのリポジトリをcloneしてください。

```sh
git clone https://github.com/momeemt/config
# もし gh が利用可能な環境なら
gh repo clone momeemt/config
# もし ghq が利用可能な環境なら
ghq get momeemt/config
```

次に、以下のスクリプトを実行してデフォルトの設定を作成してください。

```sh

```

最後に、以下のスクリプトを実行して設定を反映させてください。
ただし、一般的な Unix システムに存在する`/bin/sh`に依存します。

```sh
./assets/scripts/apply.sh
```

### 2回目以降の反映

devShell に入ると、タスクランナーツールである [just](https://github.com/casey/just) が利用できるようになります。
2回目以降は以下のコマンドを発行して設定を反映させてください。

```sh
just apply
```

## なぜ Nix/NixOS を選ぶのか

## 使ってみる

## ドキュメント

## 開発する

## ライセンス

このリポジトリのソースコードおよびリソースは、特に明記がない限り [Apache-2.0](https://licenses.opensource.jp/Apache-2.0/Apache-2.0.html) でライセンスされています。
したがって、このリポジトリの内容を商用利用含めた利用・複製・改変・再配布することは自由ですが、著作権表記を残し、ライセンス文を同梱し、変更箇所を明示する必要があります。

ただし、以下のように部分的に異なるライセンスが適用される場合があります。

1. ファイル内に明示的なライセンス表記がある場合、その表記が最も優先されます。
1. サブディレクトリ内に LICENSE ファイルがある場合、そのディレクトリ配下のファイルには、その LICENSE に記載されたライセンスが適用されます。

なお、本ライセンスの適用は利用者の属する地域で許容される範囲に限られます。
