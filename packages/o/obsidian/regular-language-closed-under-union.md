---
aliases:
  - 正規言語は和集合に関して閉じている
tags:
  - オートマトンと形式言語
  - 定理
---
## 主張

- [[regular-language|正規言語]]のクラスは、[[和集合演算]]に関して[[closed|閉じている]]
- 言い換えれば、$A_1, A_2$ が正規言語であれば、$A_1 \cup A_2$ も正規言語である

## [[finite-automaton|DFA]]による証明

$M_1$ は $A_1$ を[[recognizes-language|認識]]し、$M_1 = (Q_1, \Sigma, \delta_1, q_1, F_1)$ であり、$M_2$ は $A_2$ を認識し、$M_2 = (Q_2, \Sigma, \delta_2, q_2, F_2)$ とする。
$A_1 \cup A_2$ が正規言語であることを示すため、$A_1 \cup A_2$ を認識する $M$ を構成する。ここで、$M = (Q, \Sigma, \delta, q_0, F)$ である。

1. $Q = Q_1 \times Q_2$ とする
2. 各 $(r_1, r_2) \in Q$ と、各 $a \in \Sigma$ に対して、以下のように遷移関数 $\delta$ を定義する。
$$
\delta((r_1, r_2), a) = (\delta_1(r_1, a), \delta_2(r_2, a))
$$
3. $q_0 = (q_1, q_2)$ とする
4. $F = (F_1 \times Q_2) \cup (F_2 \times Q_1)$ とする

これにより、$A_1 \cup A_2$ を認識する有限オートマトン $M$ が構成できた。

## [[nondeterministic-finite-automaton|NFA]]による証明

$N_1 = (Q_1, \Sigma, \delta_1, q_1, F_1)$ は $A_1$ を認識し、$N_2 = (Q_2, \Sigma, \delta_2, q_2, F_2)$ は $A_2$ を認識するものとする。$A_1 \cup A_2$ を認識する $N = (Q, \Sigma, \delta, q_0, F)$ を構成する。

1. $Q = \{q_0\} \cup Q_1 \cup Q_2$
2. 状態 $q_0$ は $N$ の開始状態
3. $F = F_1 \cup F_2$
4. $\delta$ を次のように定義する
$$
\begin{flalign*}
\forall q \in Q \; \forall a \in \Sigma_\epsilon	\; \delta(q, a) =
\begin{cases}
\delta_1(q, a) &\quad q\in Q_1 \\
\delta_2(q, a) &\quad q\in Q_2 \\
\{q_1, q_2\} &\quad q = q_0 \land a = \epsilon \\
\emptyset &\quad q = q_0 \land a \neq \epsilon
\end{cases}
&&
\end{flalign*}
$$

これにより、$A_1 \cup A_2$ を認識する非決定性有限オートマトン $N$ が構成できた。