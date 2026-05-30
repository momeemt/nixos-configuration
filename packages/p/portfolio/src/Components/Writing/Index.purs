module Writing where

import Prelude

import ExternalLink (external_link)
import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))


writing_li :: forall m. String -> Component m -> Component m
writing_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

writing :: forall m. Component m
writing = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    text "執筆活動"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    writing_li "WORD 入学祝い号2024 (2024/04)" do
      JE.li' do
        text "『発熱』"
      JE.li' do
        external_link "https://www.word-ac.net/post/2024/0409-iwai2024/" do
          text "PDF版のダウンロード"
    writing_li "WORD 54号 (2023/12)" do
      JE.li' do
        text "『メールバトル2023』 w/"
        external_link "https://github.com/raspi0124" do
          text "@raspi0124"
      JE.li' do
        external_link "https://www.word-ac.net/post/2023/1225-word54/" do
          text "PDF版のダウンロード"
    writing_li "2023年度 筑波大学情報科学類 新歓パンフレット (2023/04)" do
      JE.li' do
        text "『連絡事項・今後の予定』、『履修について』、組版など"
      JE.li' do
        text "w/"
        external_link "https://github.com/puripuri2100" do
          text "@puripuri2100"
        text ", "
        external_link "https://github.com/uekann" do
          text "@uekann"
        text ", et al."
    writing_li "WORD 引越し準備号2023 (2023/03)" do
      JE.li' do
        text "『アパート暮らし』"
    writing_li "メタプログラミングNim (2022/09)" do
      JE.li' do
        text "Nim言語のメタプログラミングに焦点を当てた技術同人誌"
      JE.li'  do
        text "初出イベント: "
        external_link "https://techbookfest.org/product/9MmhQfKjFRcRUFChKUqDLM" do
          text "技術書典13" 
    writing_li "プログラミングNim (2021/08)" do
      JE.li' do
        text "システムプログラミング言語であるNimの日本語解説書"
      JE.li' do
        text "発行: 株式会社インプレス"
      JE.li' do
        external_link "https://nextpublishing.jp/book/13584.html" do
          text "本書のWebサイト"

