module Grants where

import Prelude

import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))

grants_li :: forall m. String -> Component m -> Component m
grants_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

grants :: forall m. Component m
grants = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    text "助成金"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    grants_li "先導的研究者体験プログラム (種目A), ¥78,508, 筑波大学 (2023/05 - 2024/01)" do
      JE.li' do
        text "紙書籍に対するARデバイスの開発とインタフェースの実装"
    grants_li "先導的研究者体験プログラム (種目B), ¥90,000, 筑波大学 (2022/05 - 2023/01)" do
      JE.li' do
        text "動画への顕著性最適化の適用"

