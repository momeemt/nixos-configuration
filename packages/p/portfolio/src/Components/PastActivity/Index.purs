module PastActivity where

import Prelude

import ExternalLink (external_link)
import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))

past_activity_li :: forall m. String -> Component m -> Component m
past_activity_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

past_activity :: forall m. Component m
past_activity = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    text "過去の活動"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    past_activity_li "Nix meetup #3 登壇『❄️ tmux-nixの実装を通して学ぶNixOSモジュール』(2025/05)" do
      JE.li' do
        external_link "https://nix-ja.connpass.com/event/353532/" do
          text "Nix meetup #3 大阪"
        text " / "
        external_link "https://speakerdeck.com/momeemt/tmux-nixnoshi-zhuang-wotong-sitexue-bunixosmoziyuru" do
          text "スライド"
      JE.li' do
        text "ターミナルマルチプレクサのtmuxの設定をNixで記述するためのNixOSモジュールの実装について説明しました"
    past_activity_li "Nix meetup #2 登壇『❄️ NixOS/nixpkgsにSATySFiサポートを実装する』(2025/03)" do
      JE.li' do
        external_link "https://nix-ja.connpass.com/event/342908/" do
          text "Nix meetup #2"
        text " / "
        external_link "https://speakerdeck.com/momeemt/nixpkgsni-satysfisapotowoshi-zhuang-suru" do
          text "スライド"
      JE.li' do
        text "組版システムであるSATySFiのパッケージのNixビルドサポートの比較と実装について説明しました"
    past_activity_li "オープンソースカンファレンス2024 Tokyo/Fall 出展 (2024/10)" do
      JE.li' do
        text "サイボウズ・ラボユースのブース内で、Brack言語の展示を行いました"
      JE.li' do
        external_link "https://event.ospn.jp/osc2024-fall/exhibit#:~:text=%E3%82%B5%E3%82%A4%E3%83%9C%E3%82%A6%E3%82%BA%E3%83%BB%E3%83%A9%E3%83%9C%E6%A0%AA%E5%BC%8F%E4%BC%9A%E7%A4%BE,%E3%82%92%E8%A1%8C%E3%81%84%E3%81%BE%E3%81%99%E3%80%82" do
          text "公式Webサイト"
    past_activity_li "セキュリティ・キャンプ全国大会2024 (2024/08)" do
      JE.li' do
        text "S09 サニタイザ自作ゼミ (講師: "
        external_link "https://github.com/m1kit" do
          text "@m1kit"
        text ", 同ゼミ: "
        external_link "https://github.com/jippo-m" do
          text "@jippo_m"
        text ")"
    past_activity_li "技育CAMPハッカソン 最優秀賞 (2022/12)" do
      JE.li' do
        text "担当: フロントエンドのデザイン、ロゴ作成、スライド作成、発表"
      JE.li' do
        text "GitHub: "
        external_link "https://github.com/momeemt/girigiri-meshi" do
          text "momeemt/girigiri-meshi"
        text " w/"
        external_link "https://github.com/sonarAIT" do
          text "@sonarAIT"
        text ", "
        external_link "https://github.com/TakabayaP" do
          text "@TakabayaP"
    past_activity_li "技術書典13 サークル参加 (2022/09)" do
      JE.li' do
        text "『メタプログラミングNim』 - momeemt"
      JE.li' do
        external_link "https://techbookfest.org/product/9MmhQfKjFRcRUFChKUqDLM?productVariantID=tMP44hVh3xbeKv8D8eLTqP" do
          text "公式サイト"
    past_activity_li "SWEST24 講師 (2022/09)" do
      JE.li' do
        text "組み込みシステムの合宿方ワークショップでNim言語のセッションを担当させていただきました"
      JE.li' do
        external_link "https://swest.toppers.jp/SWEST24/program/s5b.html#s5" do
          text "2022/09/02 セッションs5b"
    past_activity_li "セキュリティ・ミニキャンプ in 山梨 2022 チューター (2022/09)" do
      JE.li' do
        text "講師のヘルプ、受講生のサポートなど"
      JE.li' do
        external_link "https://www.security-camp.or.jp/minicamp/yamanashi2022.html" do
          text "公式Webサイト"
    past_activity_li "WCCE2022 ポスター発表 (2022/08)" do
      JE.li' do
        text "情報科学の達人で取り組んだ内容についてポスター発表する機会をいただきました"
      JE.li' do
        external_link "https://wcce2022.org/" do
          text "公式サイト"
    past_activity_li "技育展2021 最優秀賞 (2021/10)" do
      JE.li' do
        text "事業化目指してます部門 "
        JE.span ["class" := "text-slate-400"] do
          text "(今は目指していません)"
      JE.li' do
        external_link "https://talent.supporterz.jp/geekten/2021/" do
          text "公式Webサイト"
    past_activity_li "未踏ジュニア (2021/06 - 2021/11)" do
      JE.li' do
        external_link "https://jr.mitou.org/projects/2021/mock_up" do
          text "mock up: 動画編集ソフトウェアフレームワーク"
      JE.li' do
        text "メンター: "
        external_link "https://github.com/kyasbal" do
          text "@kyasbal"
    past_activity_li "情報科学の達人 (2021/05 - 2022/02)" do
      JE.li' do
        external_link "https://www.ipsj.or.jp/event/taikai/84/84PosterSession/contents/pdf/8094.pdf" do
          text "『特定領域における顕著性の最適化』"
        text ", 情報処理学会第84回全国大会"
      JE.li' do
        text "メンター: "
        external_link "https://github.com/yonetaniryo" do
          text "@yonetaniryo"
    past_activity_li "セキュリティ・キャンプ全国大会2021 オンライン (2021/08)" do
      JE.li' do
        text "Y-I OS自作ゼミ (講師: "
        external_link "https://github.com/uchan-nos" do
          text "@uchan-nos"
        text ")"
    past_activity_li "技術書典10 サークル参加 (2020/12 - 2021/01)" do
      JE.li' do
        text "『NimXD Book1』, 『NimXD Book2』 - momeemt"
      JE.li' do
        text "w/"
        external_link "https://github.com/50m-regent" do
          text "@50m-regent"
      JE.li' do
        external_link "https://techbookfest.org/organization/5762036657029120" do
          text "あーるえむ サークルページ"
    past_activity_li "SecHack365 (2020/05 - 2021/02)" do
      JE.li' do
        external_link "https://sechack365.nict.go.jp/achievement/2020/pdf/2020_10.pdf" do
          text "初心者にもやさしいコンポーネント指向 動画編集ソフトウェア"
      JE.li' do
        text "学習駆動コース 坂井ゼミ (講師: "
        external_link "https://kozos.jp/" do
          text "坂井弘亮さん"
        text ")"
    past_activity_li "理数研究ラボ 集中型 (2019/08)" do
      JE.li' do
        text "RSA暗号、楕円曲線暗号の学習と発表など"
    past_activity_li "Life is Tech! (2018 - 2019)" do
      JE.li' do
        text "Unity → Web Design"
      JE.li' do
        external_link "https://life-is-tech.com/news/member/2019-memberinterview-04" do
          text "インタビュー記事"
    past_activity_li "Tiprint (2018 - 2019)" do
      JE.li' do
        text "Minecraft 統合版に関する記事を投稿するメディア"
      JE.li' do
        external_link "https://web.archive.org/web/20190411042137/https://tiprint.net/" do
          text "tiprint.net (Wayback Machine)"
