module Qualification where

import Prelude

import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))

qualification_li :: forall m. String -> Component m -> Component m
qualification_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

qualification :: forall m. Component m
qualification = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    text "資格"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    qualification_li "CGエンジニア検定 エキスパート (2023/12)" do
      JE.li' do
        text "公益社団法人 画像情報教育振興協会"
    qualification_li "応用情報技術者 (2022/06)" do
      JE.li' do
        text "独立行政法人 情報処理推進機構"
    qualification_li "基本情報技術者 (2021/03)" do
      JE.li' do
        text "独立行政法人 情報処理推進機構"

