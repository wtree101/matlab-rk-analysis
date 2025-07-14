# RK Phase Diagram Analysis

MATLAB implementation for analyzing and comparing different variants of the Regularized Kaczmarz (RK) algorithm using quantile-based robust regression.

## Overview

This project implements robust linear system solvers using quantile regression and analyzes their convergence behavior across different corruption levels and algorithm parameters. The main focus is on comparing the performance of different RK variants through phase diagram analysis.

## Files

### Main Scripts
- **`draw_compare.m`** - Primary visualization script for comparing different D values and generating publication-quality plots
- **`Phasediagram_T.m`** - Phase diagram generation with temperature variation analysis
- **`Phasediagram_T_beta.m`** - Multi-beta phase diagram analysis

### Supporting Functions
- **`multipletrial.m`** - Single trial execution framework
- **`multipletrial_T.m`** - Multiple trial execution with temperature variation

## Key Parameters

### Problem Configuration
```matlab
n = 100                    % Signal dimension
m = 50000                  % Number of measurements
q = 0.5                    % Quantile parameter (robustness level)
beta = 0.01                % Corruption rate (1% corrupted measurements)
trial_num = 10             % Number of independent trials for averaging
```

### Algorithm Variants
```matlab
D_list = [4, 8, 12, 0]     % Different subspace dimensions
                           % D > 0: RK with D-dimensional subspace
                           % D = 0: Standard RK algorithm (labeled as 'RK')
```

### Robustness Settings
```matlab
is_theory_quantile = 1     % Use theoretical quantile (1) vs empirical (0)
is_replacement = 1         % Use replacement in sampling (1) vs without (0)
```

### Experiment Parameters
```matlab
lnT_all = [log(20000)]     % Log of maximum iterations (≈20K iterations)
points_num = 1             % Number of temperature points
```

## Usage

### Quick Start
```matlab
% Run the comparison analysis
run('draw_compare.m')
```

### Customizing Parameters
```matlab
% Modify key parameters at the top of draw_compare.m
beta_values = [0.01, 0.05, 0.1];  % Test different corruption levels
D_list = [2, 4, 8, 0];            % Test different subspace dimensions
q = 0.3;                          % Change robustness level
```

### Output Control
```matlab
output_to_paper = 1        % Enable publication-quality output
                          % 0: Display only, 1: Save EPS and PNG files
```

## Generated Outputs

### Plots
The script generates two comparison plots:

1. **Error vs Iteration**
   - Shows convergence behavior over algorithm iterations
   - Semi-log plot with error on log scale
   - Compares all D values on same plot

2. **Error vs Time**
   - Shows convergence behavior over wall-clock time
   - Semi-log plot with error on log scale
   - Useful for computational efficiency comparison

### File Outputs
When `output_to_paper = 1`:
- **EPS files**: Vector graphics for publications
- **PNG files**: Raster graphics for presentations

### Naming Convention
Files are automatically named with parameter information:
```
error_vs_iter_q_0.5000_beta_0.0100_D_4_8_12_0.eps
error_vs_time_q_0.5000_beta_0.0100_D_4_8_12_0.png
```

## Data Directory Structure

### Input Data Location
```
data_2/n_100_m_50000_beta_0.0100_q_0.50_theoryQ_1_repl_1/
├── D_4_lnT_9.9035_t_10_all.mat
├── D_8_lnT_9.9035_t_10_all.mat  
├── D_12_lnT_9.9035_t_10_all.mat
└── D_0_lnT_9.9035_t_10_all.mat
```

### Output Figures Location
```
/Users/wutong/Documents/LearningNote/PRKm/67dd28a13466e6105cc5e83d/PR_quantile/figs/
```

## Algorithm Details

### RK Algorithm Variants
- **Standard RK** (`D = 0`): Classical randomized Kaczmarz method
- **Subspace RK** (`D > 0`): RK with random D-dimensional subspace projection
- **Quantile-based**: Uses robust quantile regression instead of least squares

### Key Features
- **Quantile regression**: More robust than least squares to outliers
- **Configurable robustness**: Adjustable via `q` parameter
- **Multiple trials**: Averages results over multiple independent runs
- **Comprehensive comparison**: Side-by-side analysis of different variants

## Plot Customization

### Visual Settings
```matlab
'LineWidth', 2             % Thick lines for visibility
'FontSize', 18             % Large fonts for readability
'FontSize', 20             % Title font size
'FontSize', 16             % Legend font size
```

### Color and Style
- Automatic color cycling for different D values
- Grid enabled for better readability
- White background for publication quality
- Consistent color ordering between plots

## Requirements

### MATLAB Toolboxes
- Base MATLAB (R2018b or later)
- Statistics and Machine Learning Toolbox
- Parallel Computing Toolbox (optional, for faster execution)

### System Requirements
- 8GB+ RAM recommended for large problem sizes
- Multi-core CPU for parallel processing
- Sufficient disk space for figure outputs

## Configuration

### Modify Output Directory
```matlab
fig_dir = fullfile('/path/to/your/figures');
```

### Change Data Directory
```matlab
subdir = sprintf('your_data_directory/n_%d_m_%d_beta_%.4f...', ...);
```

## Troubleshooting

### Common Issues
1. **File not found errors**: Ensure data files exist in correct directory
2. **Memory issues**: Reduce problem size (`n`, `m`) or `trial_num`
3. **Figure directory errors**: Check write permissions and path existence

### Performance Tips
- Use smaller `trial_num` for faster testing
- Reduce iteration limit for quick debugging
- Consider parallel processing for multiple beta values

## Expected Results

### Typical Behavior
- **Lower D values**: Faster initial convergence
- **Higher D values**: Better final accuracy
- **Standard RK (D=0)**: Baseline performance
- **Time vs Iteration**: Different computational efficiency patterns

### Robustness Analysis
- Algorithm maintains performance up to corruption levels specified by `beta`
- Quantile parameter `q` controls robustness-efficiency trade-off

<!-- ## Citation

If you use this code in your research, please cite:
```
[Your paper/project citation here]
``` -->

<!-- ## License

[Specify your license here]

## Authors

Wu Tong  
[Your affiliation] -->

## Last Updated

July 2025