# eeg_hfo_diffusion_map

This repository contains tools created in MATLAB for detecting high-frequency oscillations (HFOs) in EEG. It also implements [diffusion maps](https://www.pnas.org/content/102/21/7426) and two distance metrics: 1) a cross-correlation-based Euclidean distance is crucial for clustering fast-oscillatory data [(Liu et. al 2020)](https://dl.acm.org/doi/10.5555/3408207.3408276) and 2) a parallelized Mahalanobis distance. While Matlab does have a function for computing the pair-wise Mahalanobis distance matrix, the function performs extremely poorly for large matrices. The function fast_mahal_dist utilizes a Choleskly factorization to invert the covariance matrix and parallelizes the entire computation (no for loops).

## Results from the visualization tools

Figures 1 and 2 (created by make_vid_from_scatter.m): Diffusion map embeddings separating HFOs (red), normal EEG (green), and artifacts (orange). Shifting before computing the diffusion map (bottom) allows events to be separated more accurately than the standard diffusion map (top).

![euclidean_diff_map](/images/l2_euclidean.gif)

![shifted_diff_map](/images/shifted_l2.gif)

Figure 3 (created by plot_shift_many.m): Shifting reveals that 1981 detections are have similar morphology and their mean Euclidean distance changes from 18.6097 to 5.1323.
![diff_map_video](/images/shift_plot.png)

## Dependencies
[EEGLAB](https://github.com/sccn/eeglab)

[RIPPLELAB](https://github.com/BSP-Uniandes/RIPPLELAB)
