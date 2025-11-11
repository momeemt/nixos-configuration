# Contributing to NixOS Configuration

このリポジトリへの貢献方法をまとめたドキュメントです。

## 開発環境のセットアップ

### 必要なツール

- Nix (with flakes support)
- direnv (推奨)

### 環境構築

1. リポジトリをクローン

```sh
git clone https://github.com/momeemt/nixos-configuration.git
cd nixos-configuration
```

2. direnv を使用する場合

```sh
echo "use flake" > .envrc
direnv allow
```

3. direnv を使用しない場合

```sh
nix develop
```

## 開発ワークフロー

### 設定変更の流れ

1. **ブランチを作成**

```sh
git checkout -b feature/my-new-feature
```

2. **変更を加える**
   - Nix ファイルを編集
   - 必要に応じて新しいモジュールやパッケージを追加

3. **フォーマットとリント**

```sh
# すべてのファイルをフォーマット
nix fmt

# または treefmt を直接使用
treefmt
```

4. **ビルドとテスト**

```sh
# 現在のホスト用にビルド
make

# 特定のホスト用にビルド（適用はしない）
nix build .#nixosConfigurations.emu.config.system.build.toplevel
nix build .#darwinConfigurations.uguisu.system
```

5. **設定を適用**

```sh
# 現在のホストに適用
make apply

# または quick-switch を使用
nix run .#quick-switch
```

### 便利なコマンド

#### Flake の更新

```sh
# flake.lock を更新
nix run .#nix-update

# 特定の入力のみ更新
nix flake lock --update-input nixpkgs
```

#### 古い世代のクリーンアップ

```sh
# 30日以上古い世代を削除し、ガベージコレクションを実行
nix run .#nix-clean
```

#### 設定の素早い適用

```sh
# フォーマット → ビルド → 適用を一度に実行
nix run .#quick-switch
```

## コードスタイル

### Nix

- インデントは 2 スペース
- `alejandra` フォーマッタを使用
- `statix` と `deadnix` でリント

### Shell Scripts

- インデントは 2 スペース
- `shfmt` と `shellcheck` を使用
- `set -euo pipefail` を先頭に記述

### Python

- インデントは 4 スペース
- `ruff` を使用

## Pre-commit Hooks

このリポジトリでは pre-commit hooks が設定されています：

```sh
# hooks を有効化
nix develop

# 手動で実行
pre-commit run --all-files
```

Hooks:
- `treefmt`: すべてのファイルをフォーマット
- `statix`: Nix ファイルの静的解析
- `deadnix`: 使用されていない Nix コードを検出

## ディレクトリ構造

```
.
├── flake.nix              # Flake のエントリポイント
├── nix/
│   ├── flakes/            # Flake 設定
│   │   ├── hosts.nix      # ホスト定義
│   │   └── per-system.nix # システム別設定
│   ├── home/              # Home Manager 設定
│   │   ├── uguisu/        # macOS (uguisu) 用
│   │   ├── emu/           # NixOS (emu) 用
│   │   └── shime/         # NixOS (shime) 用
│   ├── lib/               # 共通ライブラリ関数
│   ├── modules/           # 再利用可能なモジュール
│   │   ├── hm/            # Home Manager モジュール
│   │   ├── nixvim/        # Neovim 設定
│   │   └── tmux/          # tmux 設定
│   └── packages/          # カスタムパッケージ
├── k8s/                   # Kubernetes マニフェスト
└── scripts/               # ユーティリティスクリプト
```

## 新しいホストの追加

1. `nix/home/<hostname>/default.nix` を作成
2. `nix/flakes/hosts.nix` にホスト定義を追加
3. `Makefile` に対応するターゲットを追加

## トラブルシューティング

### ビルドエラー

```sh
# キャッシュをクリア
nix-collect-garbage -d

# flake.lock を再生成
rm flake.lock
nix flake lock
```

### 設定が反映されない

```sh
# 現在の世代を確認
nix-env --list-generations --profile /nix/var/nix/profiles/system

# 特定の世代にロールバック
sudo nixos-rebuild switch --rollback  # NixOS
darwin-rebuild switch --rollback      # macOS
```

## ヘルプとサポート

問題が発生した場合は、Issue を作成してください。
