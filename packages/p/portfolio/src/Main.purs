module Main where

import Prelude

import Data.Foldable (traverse_)
import Educational (educational)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Grants (grants)
import Jelly.Aff (awaitBody)
import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Hooks (runHooks_)
import Jelly.Hydrate (mount)
import Jelly.Prop ((:=))
import OSS (oss)
import PastActivity (past_activity)
import Qualification (qualification)
import Scholarship (scholarship)
import Software (software)
import Volunteer (volunteer)
import WorkExperience (work_experience)
import Writing (writing)

main :: Effect Unit
main = launchAff_ do
  appMaybe <- awaitBody
  liftEffect $ runHooks_ $ traverse_ (mount component) appMaybe

component :: forall m. Component m
component = do
  JE.div ["class" := "text-slate-50 px-8 py-8"] do
    header
    mainComponent

header :: forall m. Component m
header = do
  JE.header ["class" := "mt-2 flex justify-center text-left"] do
    JE.div ["style" := "width: 32rem;", "class" := "font-semibold"] do
      text "momee.mt"

external_media :: forall m. String -> String -> String -> Boolean -> Component m
external_media name href src is_white = do
  JE.a ["href" := href, "target" := "_blank", "rel" := "noopener noreferrer"] do
    JE.div ["class" := "w-16 text-center text-xs flex items-center flex-col"] do
      JE.img ["src" := src, "class" := "h-12 object-contain w-12" <> if is_white then " bg-slate-50 rounded-lg p-1" else ""]
      JE.div ["style" := "margin-top: 8px;"] do
        text name

mainComponent :: forall m. Component m
mainComponent = do
  JE.main ["class" := "mt-8"] do
    JE.div ["class" := "w-100"] do
      JE.img ["src" := "./mutsuha_asada.png", "class" := "size-48 mx-auto object-contain"]
    -- JE.div ["style" := "position: relative; width: 10px; height: 10px; background-color: white; top: -47px; left: 270px;"] do
    --   on "click" \_ -> do
    JE.div ["class" := "text-center mt-2"] do
      JE.h1 ["class" := "text-3xl mt-4"] do
        text "浅田 睦葉"
      JE.div [] do
        text "Mutsuha Asada"
      JE.div ["class" := "mt-3"] do
        text "コンパイラやサニタイザ、ビルドシステムなどに興味があります"
    JE.div ["class" := "flex mt-10 justify-center"] do
      JE.div ["class" := "flex flex-wrap gap-x-2 gap-y-6 justify-center"] do
        external_media "Blog" "https://blog.momee.mt" "./blog.png" false
        external_media "GitHub" "https://github.com/momeemt" "./github.png" false
        external_media "Twitter" "https://x.com/mutsuha_asada" "./x.svg" false
        external_media "Cosense" "https://cosen.se/momeemt" "./cosense.svg" false
        external_media "Keybase" "https://keybase.io/momeemt" "./keybase.svg" false
        external_media "Zenn" "https://zenn.dev/momeemt" "./zenn.svg" false
        external_media "sizu.me" "https://sizu.me/momeemt" "./sizume.svg" true
        external_media "Linkedin" "https://www.linkedin.com/in/momeemt/" "./linkedin.png" true
    JE.div ["class" := "mt-10 flex justify-center"] do
      JE.div ["class" := "max-w-lg"] do
        JE.div ["class" := "my-2 text-slate-400"] do
          text "各項目はクリックして展開できます"
        educational
        software
        scholarship
        oss
        grants
        work_experience
        volunteer
        writing
        qualification
        past_activity

