---
aliases:
  - 正規言語は連結に関して閉じている
tags:
  - オートマトンと形式言語
---
## 主張

- [[regular-language|正規言語]]のクラスは、[[連結演算]]に関して閉じている
- 言い換えれば、$A_1, A_2$ が正規言語ならば、$A_1 \circ A_2$ も正規言語である

## 証明

$N_1 = (Q_1, \Sigma, \delta_1, q_1, F_1)$ は $A_1$ を[[recognizes-language|認識]]し、$N_2 = (Q_2, \Sigma, \delta_2, q_2, F_2)$ は $A_2$ を認識するものとする。$A_1 \circ A_2$ を認識する $N = (Q, \Sigma, \delta, q_1, F_2)$ を構成する。

1. $Q = Q_1 \cup Q_2$
2. 状態 $q_1$ は、$N_1$ の[[開始状態]]と同じである
3. [[受理状態]] $F_2$ は、$N_2$ の受理状態と同じである
4. $\delta$ を次のように定義する
$$
\begin{flalign*}
\forall q \in Q \; \forall a \in \Sigma_\epsilon	\; \delta(q, a) =
\begin{cases}
\delta_1(q, a) &\quad q\in Q_1 \land q \notin F_1 \\
\delta_1(q, a) &\quad q \in F_1 \land a \neq \epsilon \\
\delta_1(q, a) \cup \{q_2\} &\quad q \in F_1 \land a = \epsilon \\
\delta_2(q, a) &\quad q\in Q_2
\end{cases}
&&
\end{flalign*}
$$

これにより、$A_1 \circ A_2$ を認識する[[nondeterministic-finite-automaton|非決定性有限オートマトン]] $N$ が構成できた。