---
aliases:
  - 一般化非決定有限オートマトン
  - generalized nondeterministic finite automaton
tags:
  - オートマトンと形式言語
---
一般化非決定有限オートマトンは5個[[tuple|組]] $(Q, \Sigma, \delta, q_{\text{start}}, q_{\text{accept}})$ であって

1. $Q$ は[[状態]]の[[有限集合]]
2. $\Sigma$ は入力[[alphabet|アルファベット]]
3. $\delta: (Q - \{q_\text{accept}\}) \times (Q - \{q_\text{start}\}) \to \mathcal{R}$ は[[遷移関数]]
4. $q_\text{start}$ は[[開始状態]]
5. $q_\text{accept}$ は[[受理状態]]

である

- $\mathcal{R}$ はアルファベット $\Sigma$ 上のすべての[[regular-expression|正規表現]]の集まりを表す
