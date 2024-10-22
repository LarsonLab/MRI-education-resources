# Key MRI Concepts and Equations

SEE ALSO MRI Math Concepts

[MRI Math Concepts](./MRI%20Math%20Concepts.ipynb)

## Spin Physics

Larmor Frequency

M0

Polarization

$$M_{XY}(\vec{r},t) = M_{XY}(\vec{r},0) e^{-t/T_2(\vec{r})}$$

$$M_Z(\vec{r},t) = M_Z(\vec{r},0)e^{-t/T_1} + M_0(\vec{r})(1- e^{-t/T_1(\vec{r})})$$

## Contrast

T2/T2*

T1

spoiled GRE contrast

$$S \propto M_0 \sin(\theta) \exp(-TE/T_2) \frac{1- \exp(-TR/T_1)}{1- \cos(\theta) \exp(-TR/T_1)}$$


Inversion Recovery
$$S_{IR} \propto M_0  \exp(-TE/T_2) (1 - 2\exp(-TI/T_1) + \exp(-TR/T_1) )$$

## RF Pulses

flip angle

SAR

TBW = BW_RF T_{RF}

Slice thickness

slice shifting


## Spatial Encoding

k-space

$$\vec{k}(t) = \frac{\gamma}{2\pi} \int_0^t \vec{G}(\tau) d\tau$$

$$M_{XY}(\vec{r}, t) = M_{XY}(\vec{r}, 0) e^{ -i 2 \pi \vec{k}(t) \cdot \vec{r} }$$ 

$$\begin{align}
s(t) & = \int_\mathrm{Volume} M_{XY}(\vec{r},t) \ d\vec{r} \\
 & =  \int_{\textrm{Volume}} M_{XY}(\vec{r},0) \exp(-i2\pi \vec{k}(t) \cdot \vec{r}) \ d\vec{r}
 \end{align}$$ 

$$s(t) = \int m(\vec{r})\  e^{-i 2 \pi \vec{k}(t) \cdot \vec{r}} \  d\vec{r}$$


$$s(t) = \mathcal{F}\{m(\vec{r}) \} |_{\vec{k} = \vec{k}(t)}$ = M(\vec{k}(t))$$

## Image Characeristics

SNR

FOV/resolution - in general, in Cartesian sequence


## MRI Signal Equation

## Fast Imaging

Scan times

effective TE