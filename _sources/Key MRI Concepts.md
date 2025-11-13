# Key MRI Concepts and Equations

## Background Material

[MRI Math Concepts](./MRI%20Math%20Concepts.ipynb)

Signals and Systems

Electricity and Magnetism

## MR Spin Physics

Resonance - nuclear spins in a magnetic field precess at a frequency proportional to the magnetic field strength

$$f = \bar{\gamma} \|\vec{B}\|$$

Polarization - equilibrium magnetization

$$M_0(\vec{r}) = \frac{N(\vec{r}) \bar{\gamma}^2 h^2 I_Z (I_Z +1) B_0}{3 k T}$$

Net Magnetization at Equilibrium

$$\vec{M}(\vec{r},0) = 
\begin{bmatrix}
0 \\
0 \\
M_0(\vec{r})
\end{bmatrix}$$

Excitation
* Apply magnetic field at resonant frequency to rotate net magnetization out of alignment with static magnetic field

Relaxation

$$M_{XY}(\vec{r},t) = M_{XY}(\vec{r},0) e^{-t/T_2(\vec{r})}$$

$$M_Z(\vec{r},t) = M_Z(\vec{r},0)e^{-t/T_1} + M_0(\vec{r})(1- e^{-t/T_1(\vec{r})})$$

## MRI System

1. Main magnet - $B_0$
1. Radiofrequency (RF) coils
    * transmit RF coil - $B_1^+(\vec{r},t)$: provide homogeneous excitation
    * receive RF coil - $B_1^-(\vec{r},t)$: detect signal with high sensitivity
1. Magnetic field gradient coils - $\vec{G}(t)$

## MRI Experiment

1. Polarization
1. Excitation
1. Signal Acquisition
* Gradients during Excitation and Acquisition for spatial encoding
* Repeat Excitation and Acquisition as needed

Experiment described by a "Pulse Sequence"

## MR Contrasts

Contrast weightings
* T1-weighted - short TE, short TR
* T2-weighted - long TE, long TR
* Proton Density (PD)-weighted - short TE, long TR

spoiled GRE contrast

$$S \propto M_0 \sin(\theta) \exp(-TE/T_2) \frac{1- \exp(-TR/T_1)}{1- \cos(\theta) \exp(-TR/T_1)}$$

Ernst angle - flip angle for maximum SNR

$$\theta_{optimal} = \cos^{-1}(\exp(-TR/T_1))$$

Magnetization Preparation:
Inversion Recovery

$$S_{IR} \propto M_0  \exp(-TE/T_2) (1 - 2\exp(-TI/T_1) + \exp(-TR/T_1) )$$

## In Vivo Spin Physics

Magnetic susceptibility effects 
* magnetic susceptibility is inherent property of materials
* differences in magnetic susceptibility lead to distortions of the magnetic field
* in vivo sources include: iron, oxygenated versus deoxygenated blood

Chemical Shift
* chemcial environment of an atom creates variations in local magnetic field
* in vivo consideration: "fat", assumed to have a -3.5 ppm chemcial shift from water protons

## In Vivo Contrasts

Phase - chemical shift and off-resonance (e.g. magnetic susceptibility effects) create phase differences in MR signal

T2*
* intra-voxel dephasing due to magnetic field inhomogeneity
* largely driven by magnetic susceptibility
* eliminate with spin-echo
* create susceptibility contrast

Fat
* fat/water imaging - separate fat and water images based on multiple echo times
* fat suppression - spectrally-selective RF pulses and/or inversion recovery

Contrast Agents
* Gadolinium (Gd)-based contrast agents - most common, primarily shortens $T_1$
* Iron-based contrast agents - less common, shortens $T_1$ but also can shorten $T_2$


## RF Pulses

Pulse Characteristics
* pulse profile - approximately proportional to the Fourier Transform of the pulse shape
* flip angle

$$\theta = \gamma \int_0^{T_{rf}} b_1(\tau) d\tau $$

* Time-bandwidth product - constant for a given pulse shape

$$ TBW = T_{rf} \cdot BW_{rf} $$

* SAR

$$ SAR \propto \int_0^{T_{rf}} |b_1(\tau)|^2 d\tau $$

Slice Selection
* Slice thickness

$$ \Delta z = \frac{BW_{rf}}{\bar{\gamma} G_{Z,SS}} $$

* Slice shifting

$$ f_{off} = \bar{\gamma} G_{Z,SS} \  z_{off} $$

## Spatial Encoding

Frequency encoding - turn on gradient during data acquisition to map frequency to position

$$ x = \frac{f}{\bar \gamma G_{xr}}$$

Phase encoding - perform step-wise frequency encoding, which appears in the phase versus position of the signals.   This measurement is repeated for $n = 1, \ldots, N_{PE}$

$$ \Phi(n) = \gamma (-G_{y,PE} + (n-1) G_{yi} ) t_y y$$ 

k-space - define spatial encoding based on the cumulative sum of the gradients (i.e. gradient areas) applied after excitation

$$\vec{k}(t) = \frac{\gamma}{2\pi} \int_0^t \vec{G}(\tau) d\tau$$

* Formulates image reconstruction as an inverse Fourier Transform

$$s(t) = \mathcal{F}\{m(\vec{r}) \} |_{\vec{k} = \vec{k}(t)} = M(\vec{k}(t))$$


* describes all MRI acquisitions including frequency and phase encoding
* effects of gradients can be refocused
* supports 2D and 3D imaging

## Image Characteristics

$$SNR \propto f_{seq}\ \mathrm{Voxel\ Volume}\ \sqrt{T_{meas}}$$

$$ FOV = \frac{1}{\Delta k}$$

$$ \delta = \frac{1}{2 k_{max}}$$

Scan Time

$$ T_{scan} = \frac{ TR \cdot N_{PE,total} \cdot NEX}{ETL \cdot R}$$

## FT Imaging Sequence

Typical acquisition uses frequency and phase encoding

See [Pulse Sequence](./Pulse%20Sequence.ipynb) for a typical 2D gradient-echo sequence

Can convert between sequence parameters (e.g. timings, gradient amplitudes) and the FOV, resolution and scan time, as well as predict relative SNR

## Fast Imaging Pulse Sequences

Volumetric coverage
* 2D multislice imaging - interleave multiple slices within a single TR
* 3D imaging - cover 3D k-space

EPI
* k-space trajectory that covers multiple k-space lines per excitation
* Echo spacing ($t_{esp}$), echo train length (ETL)

Multiple Spin-echo imaging (FSE/TSE/RARE)
* multiple spin-echoes per excitation used to acquire different k-space lines 
* Echo spacing ($t_{esp}$), echo train length (ETL)
* echo time, $TE = TE_{eff}$, defined when data closest to center of k-space is acquired.  Used to create different contrasts

Gradient Echo methods
* Contrast can be changed based on whether transverse magnetization is available or refocused in a subsequent TR
* Variations based on whether RF and/or gradient spoiling are used

## Accelerated Imaging Methods

Partial Fourier
* Why does it work?  MRI approximately satisfies conjugate symmetry property of k-space data
* How does it work?  Only sample slightly more than half of k-space 

Parallel Imaging
* Why does it work?  RF coil arrays with different elements provide spatial encoding
* How does it work?  Skip k-space data in the direction(s) that have variation in RF coil element sensitivity profiles 
* Key variations: May require measurement of coil sensitivity maps, also autocalibrated methods

Simultaneous Multi-slice
* Why does it work?  RF coil arrays with different elements provide spatial encoding
* How does it work?  Excite multiple slices simultaneously

Compressed Sensing
* Why does it work?  MRI data has typical patterns that can be predicted are represented by sparse coefficients
* How does it work?  Skip k-space data with a pseudo-random pattern.  Define a sparsity domain

Deep Learning Reconstruction
* Why does it work?  MRI data has typical patterns that can be learned
* How does it work?  Skip k-space data.  Train a neural network using a large MRI dataset.

## Artifacts

See [Artifacts](./Artifacts.ipynb) for high-level comparison