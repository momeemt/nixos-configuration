module Educational where

import Prelude

import ExternalLink (external_link)
import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))

educational_li :: forall m. String -> Component m -> Component m
educational_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

educational :: forall m. Component m
educational = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    text "学歴"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    educational_li "筑波大学情報学群情報科学類 (2022/04 - 現在)" do
      JE.li' do
        text "ソフトウェアサイエンス主専攻 (2024/04 - 現在)"
      JE.li' do
        external_link "https://syssec.cs.tsukuba.ac.jp/wp/" do
          text "システムセキュリティ研究室 所属 (2025/04 - 現在)"
      JE.li' do
        text "成績: 3.95 / 4.3 (3年次終了時, 146単位修得)"
    educational_li "都立桜修館中等教育学校 (2016/04 - 2022/03)" do
      JE.li' do
        text "11期"
