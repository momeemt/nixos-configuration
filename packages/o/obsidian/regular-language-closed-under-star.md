---
aliases:
  - 正規言語はスター演算に関して閉じている
tags:
  - オートマトンと形式言語
---
## 主張

- [[regular-language|正規言語]]のクラスは、[[スター演算]]に関して閉じている

## 証明

$N_1 = (Q_1, \Sigma, \delta_1, q_1, F_1)$ は $A_1$ を[[recognizes-language|認識する]]ものとする。$A_1^*$ を認識する $N = (Q, \Sigma, \delta, q_0, F)$ を構成する。

1. $Q = \{q_0\} \cup Q_1$
2. 状態 $q_0$ は新しい開始状態である
3. $F = \{q_0\} \cup F_1$
4. $\delta$ を次のように定義する
$$
\begin{flalign*}
\forall q \in Q \; \forall a \in \Sigma_\epsilon	\; \delta(q, a) =
\begin{cases}
\delta_1(q, a) &\quad q\in Q_1 \land q \notin F_1 \\
\delta_1(q, a) &\quad q \in F_1 \land a \neq \epsilon \\
\delta_1(q, a) \cup \{q_1\} &\quad q \in F_1 \land a = \epsilon \\
\{q_1\} &\quad q = q_0 \land a = \epsilon \\
\emptyset &\quad q = q_0 \land a \neq \epsilon
\end{cases}
&&
\end{flalign*}
$$

これにより、$A_1^*$ を認識する[[nondeterministic-finite-automaton|非決定性有限オートマトン]] $N$ が構成できた。