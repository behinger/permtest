# permtest
Permutation Test in matlab. Approximation / Correction by Phipson &amp; Smyth 2010 implemented

I couldn't find a simple permutation test for matlab, thus I decided to implement it on my own. I got inspired by the "statmod"-R package and followed Phipson & Smyth 2010's recommendations.


### How to Use:
```matlab
permtest(randi([1,5],100),randi([3,8],100))
permtest(randi([1,5],100),randi([3,8],100),10000)
permtest(randi([1,5],100),randi([3,8],100),[],'conservative') % usually the fastest implementation
```

### Permutations / Randomization
I chose to do permutations with repeats. This complicates p-values, but in the end I found it to be faster (and scales better).

### P-Values
There are three methods implemented to get the p-value:

`b = permutations with greater value than test-statistic`

`m_t = number of possible permutations`

P-values of complete permutations cannot be exactly 0, because the original permutation is included in the set of permutations, thus the minimal p-value has to be `1/nPerm`. This first formula makes sure of that and is most commonly used. If you use an implementation that does not allow for repeated permutations, you can stick with this one (but thats not my implementation ;)).

`p_u = p_t = (b+1)/(nPerm+1)` (method = 'conservative')

`p_e = 1/(m+1) + sum_from{p=1/m_t}_to{1}(binocdf(b,nperm,p)` (method = 'exact')

`p_e ~ p_a = p_u - integral_from{p=0}_to{0.5/(m_t+1)}(binocdf(b,nperm,p)` (method = 'approximate')

It is true that `p_u >p_e` (see Phipson & Smyth 2010).

### Checks

- I can repeat Figure 1 from Phipson & Smyth 2010
- I get a flat histogram for two null effects
- I get 5% false positives at alpha=0.05

### Future Implementation

- Add custom - function ability to select your own test-statistic (now its simply mean between groups). e.g. t-stat
- Add non-repeated permutations
- Parallelize calculations similar to the statmod-R implementation. This allows for many tests to be calculated at the same time. I recommend to use the "GaussQuad.m" function from matlab to do it (have a look at the perm function from statmod).
