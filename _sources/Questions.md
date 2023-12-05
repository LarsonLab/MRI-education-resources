# MRI Questions


## MRI System



## MR Physics



## Magnetic Fields and RF Coils


## Contrast

1. What flip angle gives the highest SNR for a spoiled gradient echo pulse sequence?
   - 45-degrees
   - 90-degrees
   - 180-degrees
   - $\cos^{-1} ( \exp(-TR/T_1) )$



1. What magnetic resonance  property is used to perform fat/water (Dixon) imaging?
   - Proton density
   - T1
   - T2
   - T2*
   - Chemical Shift

1. What are the minimum measurements required to create separate fat and water images?
   - In-phase TE
   - Out-of-phase TE
   - In-phase TE & Out-of-phase TE

1. What is "magnetization preparation" used for?
   - polarization
   - data acquisition
   - create additoinal contrast
   - tissue suppression

1. (T/F) Multiple readouts can be used following a magnetization preparation pulse to improve efficiency


## Pulse Sequence

In a typical pulse sequence, identify the gradients that serve the following functions:
1. spoil transverse magnetization
1. refocus Mxy phase across the slice
1. move to the edge of k-space


Which of the following statement is true for the slice select refocusing gradient?
* The slice select refocusing gradient must have the same gradient amplitude with the slice selective excitation pulse.
* The slice select refocusing gradient must have the same gradient area with the slice selective excitation pulse.
* The slice select refocusing gradient can overlap with the prewinder of the frequency encoding gradient.
* The slice select refocusing gradient can overlap with the gradient echo.

(T/F) For 2D FT imaging, gradient spoiling is usually applied in the slice select direction because the voxel size is larger thus more dephasing can happen within a voxel in that direction.

(T/F) For a GRE or SE with no phase encoding gradient, the k-space position at TE equals 0 (i.e, $\vec{k}(TE) = 0$).

## RF Pulses


## Spatial Encoding

Which k-space line is acquired by the following magnetic field gradients?

In 3DFT imaging, the gradient added to the slice encoding axis (compared to a 2DFT) is a ...
* frequency encoding gradient
* phase encoding gradient
* either frequency or phase encoding gradient

## Image Reconstruction

For a real-valued image $m(x,y)$, which of the following equation holds for its k-space data $M(k_x,k_y)$?
* $M(k_x,k_y) = M(-k_x,-k_y)$
* $M(k_x,k_y) = -M(-k_x,-k_y)$
* $\mathcal{Real}\{M(k_x,k_y)\} = \mathcal{Real}\{ M(-k_x,-k_y) \}$
* $\mathcal{Imag}\{M(k_x,k_y) \} = \mathcal{Imag}\{M(-k_x,-k_y) \}$

(T/F) In MRI we only look at the magnitude images.

(T/F) The center of k-space always contains the maximum signal.

## Image Characteristics (FOV and Resolution)

The field of view is inversely proportional to...
* receiver BW (RBW)
* readout gradient strength (Gxr)
* TR
* TE

The field of view is directly proportional to...
* receiver BW (RBW)
* readout gradient strength (Gxr)
* TR
* TE

(T/F) An anti-aliasing filter can be applied in the phase encoding direction.

The resolution in frequency encoding direction ( $\delta_x$ ) is equal to ...
* $ \frac{1}{W_{kx}} $
* $ \frac{1}{\frac{\gamma}{2\pi} G_{xr} t_{read}} $
* $ \frac{FOV_x}{N_{FE}} $
* None of the above


## SNR

SNR can be increased by ...
* decreasing voxel size
* increasing total time
* increasing NEX


## Artifacts

Chemical shift displacement artifact is characterized by ...
* signal stretch and pile-up
* bright and dark bands
* Gibbs ringing
* ghosting

Susceptibility displacement artifact is characterized by ...
* signal stretch and pile-up
* bright and dark bands
* Gibbs ringing
* ghosting

Truncation artifacts can be reduced by ...
* improving resolution
* filtering in k-space
* increasing FOV
* increasing NEX

(T/F) Motion artifacts occur only along the phase-encoding direction.

## Fast Imaging Pulse Sequences

What does it mean to use a multiple spin echo pulse sequence?
- multiple spin echoes are created following a single excitation pulse
- multiple k-space lines acquired sequentially
- multiple gradient-echo repetitions after a magnetization preparation pulse
- fully refocused gradients and no spoiling in every TR

What types of contrast can be created with a multiple spin echo pulse sequence?
* proton density weighted
* T1 weighted
* T2 weighted
* T2* weighted

What are the limitations of multiple spin echo pulse sequences?
- Chemical shift and susceptibility displacement artifacts
- T2 blurring artifacts
- ghosting
- SAR

What does it mean to use echo planar imaging (EPI)?
- multiple spin echoes are created following a single excitation pulse
- multiple k-space lines acquired sequentially
- multiple gradient-echo repetitions after a magnetization preparation pulse
- fully refocused gradients and no spoiling in every TR

What are the advantages of EPI?
- Create additional T1, T2, and/or T2* contrast
- Rapidly acquire k-space
- Robust to motion
- Repeated refocusing of intravoxel dephasing

What are the artifacts associated with EPI?
- Chemical shift displacement
- Distortion due to magnetic susceptibility differences
- T2* blurring
- ghosting

What does it mean to use balanced steady-state free-precession (bSSFP)?
- multiple spin echoes are created following a single excitation pulse
- multiple k-space lines acquired sequentially
- multiple gradient-echo repetitions after a magnetization preparation pulse
- fully refocused gradients and no spoiling in every TR

## Accelerated Imaging Methods

Match the acceleration methods
* Partial Fourier
* Parallel Imaging
* Compressed Sensing
* Deep Learning

with the following concept they rely on:
- conjugate symmetry in k-space
- spatial encoding from receive coil arrays
- a sparse representation of the image
- training on prior images to learn expected patterns

(T/R) Partial Fourier, parallel imaging, and compressed sensing or deep learning reconstructions can be used simultaneously.

How is coil sensitivity information gathered for parallel imaging?
- It is stored in a database on the scanner
- A separate scan to measure coil sensitivity maps
- Using fully-sampled data from the center of k-space
- Using fully-sampled data from outer k-space

What is the "g-factor" in parallel imaging?
- How much faster scan can be performed
- Describes noise amplification
- Describes SNR loss
- Describes magnetic field gradients


Compared to the SNR a fully sampled acquistion ($SNR_{full}$), the SNR Of a parallel imaging acquisition ($SNR_{PI}$) with an acceleration factor, $R$, and $g$-factor is
- $SNR_{PI} = SNR_{full}$
- $SNR_{PI} = SNR_{full} / \sqrt{R}$
- $SNR_{PI} = SNR_{full} / g(\vec{r}) $
- $SNR_{PI} = SNR_{full} / (g(\vec{r}) \sqrt{R})$

(T/F) Parallel imaging undersampling can be performed in any direction, regardless of the RF coil configuration. 

Simultaneous multi-slice parallel imaging
- enables acceleration in the slice direction
- requires no modifications to the pulse sequence
- requires RF pulses that excite multiple slices
- requires coil sensitivity information

What type of k-space sampling is required for compressed sensing?
- full sampling
- equally spaced undersampling
- equally spaced undersampling with fully-sampled center of k-space
- pseudo-random undersampling

At least how many training datasets are typically required to develop deep learning MRI reconstruction methods?
- 1
- 10-100
- 1000-10,000
- 100,000-1,000,000

Generalization problems can arise in deep learning MRI reconstruction methods when applied to situations that area different from the training data in which of the following ways:
- different anatomy
- different contrasts
- different sampling patterns
- different B0

Which type of architecture is commonly used for physics-based deep learning MRI reconstruction networks?
- Encoder-decoder
- Unet
- Unrolled
- Recurrant