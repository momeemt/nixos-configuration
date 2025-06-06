# Home
[momeemt/nixos-configurations](https://github.com/momeemt/nixos-configurations)は、[momeemt](https://github.com/momeemt)の計算機環境を構築するためのリポジトリです。
主に[Nix](https://github.com/NixOS/nix)の宣言的なビルドシステムの恩恵を受けながら、日々の活動で依存しているOSやツールの設定を記述しています。

## ホスト
このリポジトリは、以下のホストの管理を対象にしています。

- uguisu (aarch64-darwin)
    - MacBook Pro 16-inch, 2021
    - Chip: Apple M1 Max
    - OS: MacOS Sequoia 15.4.1
    - メイン機として2023年1月から利用しています
- emu (x86_64-linux)
    - CPU: Intel Core i9 14900
    - GPU: GeForce RTX 3060
    - OS: NixOS 24.11
    - サーバとして2024年4月から利用しています
- oshidori (x86_64-linux)
    - CPU: AMD Ryzen 7 2700X
    - GPU: AMD ATI Radeon
    - OS: NixOS 25.05
    - [システムセキュリティ研究室](https://syssec.cs.tsukuba.ac.jp/wp/)に所属中の計算機として利用しています
- kasasagi (aarch64-linux)
    - OS: NixOS 25.05
    - uguisu上で動作するVMで動かしています
    - 主にNixOSのテストやnixpkgs-reviewの実行に利用しています

## プロジェクトツリー

```
❯ ls -T -L=1
.
├── doc              # nixos-configurationsのドキュメント
├── flake.lock
├── flake.nix        # devShellsやnixosConfigurationsなどの記述
├── home             # ユーザ空間の設定
├── hosts            # システム空間の設定
├── LICENSE-APACHE
├── LICENSE-MIT
├── Makefile         # `make apply`の定義
├── modules          # 各モジュールの設定
├── packages         # パッケージ
├── README.md
└── secrets          # Confidentialの管理
```

