# Binary Transmission & RC Filter Monte Carlo Simulation

A MATLAB-based digital signal processing simulation evaluating the performance of a binary transmission system under Additive White Gaussian Noise (AWGN). This project utilizes Monte Carlo methods to estimate Bit Error Rate (BER) and optimize the bandwidth of an RC low-pass receiver filter.

## Overview

In digital communications, selecting the optimal receiver filter bandwidth is a critical compromise between mitigating high-frequency thermal noise and minimizing Inter-Symbol Interference (ISI). This simulation generates baseband binary rectangular pulses, injects AWGN, processes the signal through a custom-designed first-order IIR filter, and evaluates the timing and accuracy of the received bits.

**Key Technical Concepts:**
* Digital Filter Design (Bilinear Transformation)
* Power Spectral Density (PSD) Estimation
* Bit Error Rate (BER) Statistical Modeling
* Baseband Signal Processing (Eye Diagrams, Sampling Instants)

## Repository Structure

* `/src/`: Contains all MATLAB `.m` scripts and modular functions.
* `/assets/`: Contains generated signal visualizations and performance plots.
* `/docs/`: Contains the mathematical parameters.

## Pipeline & Execution

The project is split into two primary execution scripts located in `/src/`:

1. **`Signal_Visualizer.m` (Qualitative Analysis)**
   Isolates a specific bandwidth ($B = R_b$) and noise amplitude to visualize system physics. Generates the Power Spectral Density, signal histograms at the optimal sampling instant, and eye diagrams.

2. **`BER_Simulation_Sweep.m` (Quantitative Analysis)**
   Executes the Monte Carlo simulation, passing hundreds of thousands of bits through 39 discrete RC filter bandwidth configurations across three distinct SNR environments to identify the mathematically optimal filter bandwidth.

## System Performance

### Received Signal Eye Diagram & Histogram
*(Observe the signal timing and statistical distribution of the received states at the optimal sampling instant)*

![Eye Diagram](../assets/eye_diagram_clean.png)
![Histogram](../assets/histogram_noise_0.1.png)

### Bit Error Rate Optimization
*(The optimization curve balancing ISI and AWGN to find the optimal RC filter bandwidth)*

![BER vs Bandwidth](../assets/ber_vs_bandwidth.png)
