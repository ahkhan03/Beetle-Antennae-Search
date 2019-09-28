# Beetle-Antennae-Search

## Papers
- **BAS: Beetle Antennae Search Algorithm for Optimization Problems.** [[arXiv:1710.10724](https://arxiv.org/abs/1710.10724)]
- **Convergence analysis of beetle antennae search algorithm and its applications.** [[arXiv:1904.02397](https://arxiv.org/abs/1904.02397)]

## Example

Solve the following problem,

<a href="https://www.codecogs.com/eqnedit.php?latex=x*&space;=&space;\min_x&space;||x||_2,&space;\quad&space;x&space;\in&space;\mathbb{R}^{10}." target="_blank"><img src="https://latex.codecogs.com/gif.latex?x*&space;=&space;\min_x&space;||x||_2,&space;\quad&space;x&space;\in&space;\mathbb{R}^{10}." title="x* = \min_x ||x||_2, \quad x \in \mathbb{R}^{10}." /></a>

```matlab
[X, f, info] = bas(@(x) sum(x.^2), rand(1,10), ...
  'max_iter', 100, ...
  'antennae_length', 0.1, ...
  'stop_fun', @(x) x < 0.1, ...
  'retain_best', 1);
```
