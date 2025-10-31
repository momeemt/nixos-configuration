# ❄️ nixos-configuration

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

私の開発環境や自宅サーバを支える設定集です。

## インストール

すでにホストが登録されている場合、gnumakeを使うのが便利です。

```sh
make apply
make        # 同等
```

### NixOS

```sh
sudo nixos-rebuild switch --flake '.#<host>'
```

### macOS

```sh
nix build '.#darwinConfigurations.<host>.system' --extra-experimental-features 'nix-command flakes'
sudo ./result/sw/bin/darwin-rebuild switch --flake '.#<host>'
```

## 環境構築

できるだけ[direnv](https://github.com/direnv/direnv)を利用してください。

```sh
echo "use flake" > .envrc
direnv allow
```

そうでない場合は、`nix develop`を利用してください。

```sh
nix develop .
```

## hosts

### [uguisu](https://upload.wikimedia.org/wikipedia/commons/6/66/Cettia_diphone.jpg)

```
❯ neofetch
                    c.'          momeemt@uguisu 
                 ,xNMM.          -------------- 
               .OMMMMo           OS: macOS 15.4.1 24E263 arm64 
               lMM"              Host: MacBookPro18,2 
     .;loddo:.  .olloddol;.      Kernel: 24.4.0 
   cKMMMMMMMMMMNWMMMMMMMMMM0:    Uptime: 12 days, 19 hours, 4 mins 
 .KMMMMMMMMMMMMMMMMMMMMMMMWd.    Packages: 120 (nix-system), 873 (nix-user) 
 XMMMMMMMMMMMMMMMMMMMMMMMX.      Shell: zsh 5.9 
;MMMMMMMMMMMMMMMMMMMMMMMM:       Resolution: 3456x2234 
:MMMMMMMMMMMMMMMMMMMMMMMM:       DE: Aqua 
.MMMMMMMMMMMMMMMMMMMMMMMMX.      WM: Quartz Compositor 
 kMMMMMMMMMMMMMMMMMMMMMMMMWd.    WM Theme: Blue (Dark) 
 'XMMMMMMMMMMMMMMMMMMMMMMMMMMk   Terminal: vscode 
  'XMMMMMMMMMMMMMMMMMMMMMMMMK.   CPU: Apple M1 Max 
    kMMMMMMMMMMMMMMMMMMMMMMd     GPU: Apple M1 Max 
     ;KMMMMMMMWXXWMMMMMMMk.      Memory: 47492MiB / 65536MiB 
       "cooc*"    "*coo'"
```

### [emu](https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/Emu-wild.jpg/1280px-Emu-wild.jpg)

```
❯ neofetch
          ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖                             momeemt@emu 
          ▜███▙       ▜███▙  ▟███▛                             ----------- 
           ▜███▙       ▜███▙▟███▛                              OS: NixOS 25.05.20251022.c8aa8cc (Warbler) x86_64 
            ▜███▙       ▜██████▛                               Host: ASRock Z790 Nova WiFi 
     ▟█████████████████▙ ▜████▛     ▟▙                         Kernel: 6.1.84 
    ▟███████████████████▙ ▜███▙    ▟██▙                        Uptime: 6 days, 39 mins 
           ▄▄▄▄▖           ▜███▙  ▟███▛                        Packages: 1021 (nix-system), 666 (nix-user) 
          ▟███▛             ▜██▛ ▟███▛                         Shell: zsh 5.9 
         ▟███▛               ▜▛ ▟███▛                          Terminal: /dev/pts/1 
▟███████████▛                  ▟██████████▙                    CPU: Intel i9-14900 (32) @ 5.500GHz 
▜██████████▛                  ▟███████████▛                    GPU: NVIDIA GeForce RTX 3060 
      ▟███▛ ▟▙               ▟███▛                             Memory: 13692MiB / 64062MiB 
     ▟███▛ ▟██▙             ▟███▛
    ▟███▛  ▜███▙           ▝▀▀▀▀                                                       
    ▜██▛    ▜███▙ ▜██████████████████▛                                                 
     ▜▛     ▟████▙ ▜████████████████▛
           ▟██████▙       ▜███▙
          ▟███▛▜███▙       ▜███▙
         ▟███▛  ▜███▙       ▜███▙
         ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘
```

### [shime](https://upload.wikimedia.org/wikipedia/commons/6/67/Coccothraustes_coccothraustes_1_%28Marek_Szczepanek%29.jpg)

```
❯ neofetch
          ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖            momeemt@shime 
          ▜███▙       ▜███▙  ▟███▛            ------------- 
           ▜███▙       ▜███▙▟███▛             OS: NixOS 25.05.20251022.c8aa8cc (Warbler) x86_64 
            ▜███▙       ▜██████▛              Host: Alienware 026CD3 
     ▟█████████████████▙ ▜████▛     ▟▙        Kernel: 6.6.113 
    ▟███████████████████▙ ▜███▙    ▟██▙       Uptime: 2 days, 16 hours, 6 mins 
           ▄▄▄▄▖           ▜███▙  ▟███▛       Packages: 599 (nix-system), 531 (nix-user) 
          ▟███▛             ▜██▛ ▟███▛        Shell: zsh 5.9 
         ▟███▛               ▜▛ ▟███▛         Resolution: 3840x2160 
▟███████████▛                  ▟██████████▙   Terminal: /dev/pts/0 
▜██████████▛                  ▟███████████▛   CPU: Intel i7-6700 (8) @ 4.000GHz 
      ▟███▛ ▟▙               ▟███▛            GPU: Intel HD Graphics 530 
     ▟███▛ ▟██▙             ▟███▛             GPU: NVIDIA GeForce GTX 960 
    ▟███▛  ▜███▙           ▝▀▀▀▀              Memory: 3336MiB / 15897MiB 
    ▜██▛    ▜███▙ ▜██████████████████▛
     ▜▛     ▟████▙ ▜████████████████▛                                 
           ▟██████▙       ▜███▙                                       
          ▟███▛▜███▙       ▜███▙
         ▟███▛  ▜███▙       ▜███▙
         ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘
```

## Kubernetesクラスタ

emuとshimeに合わせて4台のVMを建てて、Kubernetesクラスタを運用しています。
マニフェストは[./k8s](./k8s/)をご覧ください。

- master
    - kube-master (emu)
- worker
    - kube-worker-emu-1 (emu)
    - kube-worker-emu-2 (emu)
    - kube-worker-shime-1 (shime)

```sh
ubuntu@kube-master:~$ kubectl get nodes
NAME                  STATUS   ROLES           AGE   VERSION
kube-master           Ready    control-plane   17h   v1.34.1
kube-worker-emu-1     Ready    <none>          17h   v1.34.1
kube-worker-emu-2     Ready    <none>          17h   v1.34.1
kube-worker-shime-1   Ready    <none>          17h   v1.34.1
```

## License

MIT OR Apache 2.0