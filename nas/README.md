# kitsutsuki

> [!WARNING]
> このドキュメントは単なる個人用のメモで、執筆中です。

- Synology DS220j
  - DSM 7.3.2-86009
- Western Digital, WD Red HDD 6TB x 2
  - RAID1
- 本来は Nix で管理したいが、システム空間にインストールしたツールは DSM のアップデートのタイミングで破壊的にな変更が加えられる可能性があるので、よく調べてから導入する
  - あと、DS220j はあまりマシンパワーがないので Nix を常駐させて利用に影響がないかも心配

## 作業ログ

- Quickconnect を長らく使っていたが、外からのアクセススピードが悪すぎるため基本使わない
- Tailscale をインストールして、Photos Mobile から写真や動画をアップロードできるかどうかを確認する

## Synology Photos のインストール

WebUI からインストールした

### Tailscale のインストール

```
./install-tailscale.sh
```

### Git のインストール

```
./install-git.sh
```

その後、`sudo synopkg start git` で起動できるようになる

### GitHub に鍵を登録する

```
mkdir -p ~/.ssh/keys
cd ~/.ssh/keys
ssh-keygen -t ed25519 -f git
```

```sh
chmod 700 ~/.gnupg
chmod 600 ~/.gnupg/*
echo 'allow-loopback-pinentry' >> ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent 2>/dev/null || pkill gpg-agent 2>/dev/null || true
# 鍵の生成
gpg --full-gen-key --pinentry-mode loopback
gpg --list-secret-keys --keyid-format LONG
# 公開鍵の生成
gpg -a --export A5C06A7203EA42626C5F194122799E1F6D423314
```

その後、SSH と GPG の公開鍵を config に置いて Terraform で登録した。

### SSH

uguisu からローカルに kitsutsuki がある場合のみアクセスできるようにした。
詳細については SSH config を参照。

```
ssh kitsutsuki
```
