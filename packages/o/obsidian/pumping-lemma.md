---
aliases:
  - ポンピング補題
  - pumping lemma
tags:
  - オートマトンと形式言語
---
$A$ が[[regular-language|正規言語]]であるならば、ある数 $p$ （ポンピング長）が存在して、$s$ が少なくとも長さ $p$ である $A$ の任意の文字列であるとき、$s$ は条件

1. 各 $i \ge 0$ について $xy^iz \in A$
2. $|y| > 0$
3. $|xy| \le p$

を満足する3つの[[substring|部分文字列]]、$s = xyz$ に分割できる