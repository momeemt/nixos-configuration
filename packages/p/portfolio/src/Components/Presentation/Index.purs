module Presentation where

import Prelude

import ExternalLink (external_link)
import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))

presentation_li :: forall m. String -> String -> Component m
presentation_li name href = do
  JE.li ["class" := "mt-1"] do
    external_link href do
      JE.span ["class" := "list-none cursor-pointer select-none"] do
        text name

presentation :: forall m. Component m
presentation = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    text "発表"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    presentation_li "Intel系FPGA上へのRISC-Vプロセッサの実装 (2025/01/14)" "https://speakerdeck.com/momeemt/intelxi-fpgashang-henorisc-vpurosetusanoshi-zhuang"
    presentation_li "情報科学若手の会 2024 LT「WebAssemblyで拡張可能な軽量マークアップ言語の開発」 (2024/09/15)" "https://speakerdeck.com/momeemt/qing-bao-ke-xue-ruo-shou-nohui-2024-lt-webassemblydekuo-zhang-ke-neng-naqing-liang-makuatupuyan-yu-nokai-fa"
    presentation_li "Nixでつくるdotfiles (2024/08/22)" "https://speakerdeck.com/momeemt/nixdetukurudotfiles"
    presentation_li "情報特別演習I 最終発表「理工学の紙書籍を用いた学習の効率を向上させるインタフェース」 (2024/01/16)" "https://speakerdeck.com/momeemt/qing-bao-te-bie-yan-xi-i-zui-zhong-fa-biao-li-gong-xue-nozhi-shu-ji-woyong-itaxue-xi-noxiao-lu-woxiang-shang-saseruintahuesu"
    presentation_li "SATySFi Conf 2023「SATySFiを使って学類新歓冊子を発行した」 (2023/10/22)" "https://speakerdeck.com/momeemt/satysfi-conf-2023-satysfiwoshi-tutexue-lei-xin-huan-ce-zi-wofa-xing-sita"
    presentation_li "主専攻実験（深層学習を用いたCG・画像処理）最終成果報告 (2023/07/26)" "https://speakerdeck.com/momeemt/zhu-zhuan-gong-shi-yan-shen-ceng-xue-xi-woyong-itacghua-xiang-chu-li-zui-zhong-cheng-guo-bao-gao"
    presentation_li "情報科学類新歓2023 履修の組み方 (2023/04/05)" "https://speakerdeck.com/momeemt/qing-bao-ke-xue-lei-xin-huan-2023-lu-xiu-nozu-mifang"
    presentation_li "情報科学特別演習 最終発表「動画編集ソフトウェアフレームワーク: mock up」 (2023/01/17)" "https://speakerdeck.com/momeemt/qing-bao-ke-xue-te-bie-yan-xi-zui-zhong-fa-biao-dong-hua-bian-ji-sohutoueahuremuwaku-mock-up"
    presentation_li "技育キャンプ ハッカソン vol.9「ギリギリ飯」 (2022/12/11)" "https://speakerdeck.com/momeemt/ji-yu-kiyanpu-hatukason-vol-dot-9-girigirifan"
    presentation_li "PIXIV SUMMER BOOT CAMP 2022 成果発表「GIFから12倍速くする」 (2022/09/28)" "https://speakerdeck.com/momeemt/pixiv-summer-boot-camp-2022-cheng-guo-fa-biao-gifkara12bei-su-kusuru"
    presentation_li "SWEST22「Nimです、こんばんは」 (2022/09/02)" "https://speakerdeck.com/momeemt/swest22-nimdesu-konbanha"
    presentation_li "WCCE2022 \"Optimize saliency in specified region in images\" (2022/08/22)" "https://speakerdeck.com/momeemt/wcce2022-optimize-saliency-in-specified-region-in-images"
    presentation_li "2021年 未踏ジュニア 成果報告「動画編集ソフトウェアフレームワーク: mock up」 (2021/11/03)" "https://speakerdeck.com/momeemt/2021nian-wei-ta-ziyunia-cheng-guo-bao-gao-dong-hua-bian-ji-sohutoueahuremuwaku-mock-up"

