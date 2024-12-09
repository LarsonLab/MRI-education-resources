# Key MRI Concepts and Equations

SEE ALSO MRI Math Concepts

[MRI Math Concepts](./MRI%20Math%20Concepts.ipynb)

## Spin Physics

Larmor Frequency

Polarization and Net Magnetization 

M0

Excitation
* RF Pulses

Relaxation

$$M_{XY}(\vec{r},t) = M_{XY}(\vec{r},0) e^{-t/T_2(\vec{r})}$$

$$M_Z(\vec{r},t) = M_Z(\vec{r},0)e^{-t/T_1} + M_0(\vec{r})(1- e^{-t/T_1(\vec{r})})$$

## MRI System

Main magnet

RF coils

Gradient coils

## MRI Experiment

1. Polarization
1. Excitation
1. Signal Acquisition
* Spatial Encoding during Excitation and Acquisition
* Repeat Excitation and Acquisition as needed

Described by a "Pulse Sequence"

## Contrast

spoiled GRE contrast

$$S \propto M_0 \sin(\theta) \exp(-TE/T_2) \frac{1- \exp(-TR/T_1)}{1- \cos(\theta) \exp(-TR/T_1)}$$

Contrast weightings: T1w, T2w, PDw

Magnetization Preparation:

Inversion Recovery
$$S_{IR} \propto M_0  \exp(-TE/T_2) (1 - 2\exp(-TI/T_1) + \exp(-TR/T_1) )$$

## RF Pulses

Pulse Characteristics
* flip angle
* SAR
* TBW = BW_RF T_{RF}

Slice Selection
* Slice thickness
* Slice shifting

## Spatial Encoding

Frequency encoding

Phase encoding

k-space

$$\vec{k}(t) = \frac{\gamma}{2\pi} \int_0^t \vec{G}(\tau) d\tau$$

$$M_{XY}(\vec{r}, t) = M_{XY}(\vec{r}, 0) e^{ -i 2 \pi \vec{k}(t) \cdot \vec{r} }$$ 

$$\begin{align}
s(t) & = \int_\mathrm{Volume} M_{XY}(\vec{r},t) \ d\vec{r} \\
 & =  \int_{\textrm{Volume}} M_{XY}(\vec{r},0) \exp(-i2\pi \vec{k}(t) \cdot \vec{r}) \ d\vec{r}
 \end{align}$$ 

$$s(t) = \int m(\vec{r})\  e^{-i 2 \pi \vec{k}(t) \cdot \vec{r}} \  d\vec{r}$$


$$s(t) = \mathcal{F}\{m(\vec{r}) \} |_{\vec{k} = \vec{k}(t)} = M(\vec{k}(t))$$



## Image Characeristics

SNR

resolution

FOV

## 2D FT Imaging Sequence

Show sequence

Parameters

FOV, resolution

Scan Time

## Fast Imaging Pulse Sequences

EPI

Multiple Spin-echoes

Gradient Echo methods

## Accelerated Imaging Methods

Partial Fourier

Parallel Imaging

Compressed Sensing and Deep Learning Reconstructions

## Artifacts

