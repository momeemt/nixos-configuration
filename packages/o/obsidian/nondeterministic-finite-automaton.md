---
aliases:
  - 非決定性有限オートマトン
  - NFA
tags:
  - オートマトンと形式言語
---
非決定性有限オートマトンは、5つ[[tuple|組]] $(Q, \Sigma, \delta, q_0, F)$ である。
ここで、

1. $Q$ は[[状態]]の[[有限集合]]
2. $\Sigma$ は有限の[[alphabet|アルファベット]]
3. $\delta: Q\times \Sigma_\epsilon \to \mathcal{P}(Q)$ は[[遷移関数]]
4. $q_0 \in Q$ は[[開始状態]]
5. $F \subseteq Q$ は[[受理状態]]の[[set|集合]]

とする。