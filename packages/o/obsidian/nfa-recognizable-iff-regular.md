---
aliases:
  - NFAで認識可能な言語と正規言語は同値
tags:
  - オートマトンと形式言語
---
## 主張

- ある[[nondeterministic-finite-automaton|非決定性有限オートマトン]]が[[language|言語]]を[[recognizes-language|認識する]]とき、かつそのときに限り、その言語は[[regular-language|正規言語]]である

## 証明

[[nfa-dfa-equivalence|NFAとDFAの等価性]]より、NFAは[[equivalent|等価]]なDFAに変換できるので、NFAがある言語を認識するならばDFAも認識し、従ってその言語は正規である。
また、正規言語はそれを認識するDFAを持ち、また任意のDFAはNFAである。
以上より、あるNFAが言語を認識するとき、かつそのときに限り、その言語は正規言語である。