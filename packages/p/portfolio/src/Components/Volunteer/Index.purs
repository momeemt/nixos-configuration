module Volunteer where

import Prelude

import ExternalLink (external_link)
import Jelly.Component (Component, doctype, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))

volunteer_li :: forall m. String -> Component m -> Component m
volunteer_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

volunteer :: forall m. Component m
volunteer = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    text "ボランティア"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    volunteer_li "筑波大学情報学群情報科学類 オープンキャンパス 学生スタッフ (2022, 2025)" do
      JE.li' do
        text "企画セッション・座談会（2025）"
      JE.li' do
        text "受験生からの質疑応答（2022）"
    volunteer_li "情報科学若手の会 幹事 (2024/12 - 現在)" do
      JE.li' do
        external_link "https://wakate.org/" do
          text "公式サイト"
    volunteer_li "筑波大学情報学群情報科学類 新入生歓迎委員会 (2022/12 - 2023/05)" do
      JE.li' do
        text "会計、パンフレット組版、新歓Web開発など"
      JE.li' do
        text "GitHub: "
        external_link "https://github.com/hello-coins" do
          text "@hello-coins"
    volunteer_li "学園祭実行委員会 情報メディアシステム局 (2022/06 - 2023/10)" do
      JE.li' do
        text "jsys22, jsys23(ネットワーク部門長)"

