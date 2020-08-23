# eeg_hfo_diffusion_map

This repository contains tools created in MATLAB for detecting high-frequency oscillations (HFOs) in EEG. It also implements [diffusion maps](https://www.pnas.org/content/102/21/7426) and two distance metrics: 1) a cross-correlation-based Euclidean distance is crucial for clustering fast-oscillatory data [(Liu et. al 2020)](https://dl.acm.org/doi/10.5555/3408207.3408276) and 2) a parallelized Mahalanobis distance. While Matlab does have a function for computing the pair-wise Mahalanobis distance matrix, the function performs extremely poorly for large matrices. The function fast_mahal_dist utilizes a Choleskly factorization to invert the covariance matrix and parallelizes the entire computation (no for loops).

## Results from the visualization tools
test123

## Dependencies
[EEGLAB](https://github.com/sccn/eeglab)

[RIPPLELAB](https://github.com/BSP-Uniandes/RIPPLELAB)
