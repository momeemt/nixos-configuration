---
aliases:
  - NFAとDFAの等価性
tags:
  - オートマトンと形式言語
  - 定理
---
## 主張

- すべての[[nondeterministic-finite-automaton|非決定性有限オートマトン]]は、[[equivalent|等価]]な[[finite-automaton|決定性有限オートマトン]]を持つ

## 証明

$N = (Q, \Sigma, \delta, q_0, F)$ を、ある[[language|言語]] $A$ を認識する[[nondeterministic-finite-automaton|NFA]]とする。ここでは、$A$ を認識する[[finite-automaton|DFA]] $M = (Q', \Sigma, \delta', q_0', F')$ を構成する。まず、$N$ が $\epsilon$ による[[遷移]]を持たないケースについて考える。

1. $Q' = \mathcal{P}(Q)$
2. $R \in Q'$ かつ $a \in \Sigma$ に対して、$\delta'(R, a) = \{q \in Q \mid \exists r \in R, \; q\in \delta(r, a)\}$
3. $q_0' = \{q_0\}$
4. $F' = \{ R \in Q' \mid R \cap F \neq \emptyset \}$

次に、$\epsilon$ の遷移を持つケースについて考える。ここで、[[relation|関係]] $\to_\epsilon$ を以下のように定義する。

$$
p\to_\epsilon q \Leftrightarrow q \in \delta(p, \epsilon)
$$

このとき、その[[反射推移閉包]]を $\to_\epsilon^*$ と書けば、$M$ の任意の状態 $R$ について、$R$ の[[element|要素]]から $\epsilon$ による遷移だけで到達できる状態の集まり $E(R)$ を、以下のように定義できる。

$$
E(R) = \{q \in Q \mid \exists r \in R, \; r \to_\epsilon^* q\}
$$

また、遷移関数 $\delta'(R, a)$ は次のように置き換えられる。

$$
\delta'(R, a) = \{ q\in Q \mid \exists r \in R, \; q\in E(\delta(r, a))\}
$$

さらに、$N$ の開始状態から $\epsilon$ 遷移だけで到達できる状態が含まれるので、$q_0' = E(\{q_0\})$ とする。
以上が、NFA $N$ をシミュレートするDFA $M$ の構成である。

入力に対する $M$ の計算の各ステップにおいて、$N$ がこの時点で取る状態の部分集合に対応した状態に $M$ は正しく入るので、このように構成した $M$ が正しく動作するのは明らかである。