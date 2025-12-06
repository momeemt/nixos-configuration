# modules/hm/accounts/email

`nixos-rebuild switch`を実行すると`$XDG_DATA_HOME/mail/<account>`ディレクトリが作成されますが、いくつか手作業が必要です。
次にこの作業をするときには上手いこと自動化しておいてください。ブラウザ認証が自動化できるのかは調べていないです。

```sh
cd $XDG_DATA_HOME/mail/<account>
mkdir -p mail/{cur,new,tmp}
(cd ../ && notmuch new)
gmi auth # => ブラウザが立ち上がるので認証
gmi pull
```
