module WorkExperience where

import Prelude

import ExternalLink (external_link)
import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))

work_experience_li :: forall m. String -> Component m -> Component m
work_experience_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

work_experience :: forall m. Component m
work_experience = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    text "就労経験"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    work_experience_li "LINEヤフー株式会社 インターンシップ (2024/09)" do
      JE.li'  do
        text "インフラエンジニア"
      JE.li' do
        external_link "https://www.lycorp.co.jp/ja/recruit/landingpage/INFRA-02-02/" do
          text "内製分散データベースシステム FractalDB の開発業務"
    work_experience_li "サイボウズ・ラボ株式会社 (2024/06 - 現在)" do
      JE.li' do
        text "サイボウズ・ラボユース 14期 言語処理系開発ゼミ"
      JE.li' do
        external_link "https://labs.cybozu.co.jp/youth/requirements.html" do
          text "WebAssemblyで拡張可能なマークアップ言語 Brackの開発"
    work_experience_li "ピクシブ株式会社 インターンシップ (2022/09)" do
      JE.li' do
        text "画像配信エンジニア"
      JE.li' do
        text "ImageFluxにおけるGIF画像の配信を高速化する業務に従事"
      JE.li' do
        text "参加記: "
        external_link "https://zenn.dev/momeemt/articles/pixiv-summer-boot-camp-2022" do
          text "ピクシブのインターンに参加してアニメーションのエンコードをGIFから12倍高速にした"
    work_experience_li "インヴァスト株式会社 インターンシップ (2022/01 - 08)" do
      JE.li' do
        text "フロントエンドエンジニア"
      JE.li' do
        text "内製アプリケーションのフロントエンド開発に従事"
