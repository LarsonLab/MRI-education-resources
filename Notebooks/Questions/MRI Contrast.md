# MRI Contrast Questions

## Choosing scan parameters

In this question we are imaging the knee at 3T. The tissues of interest are:

- **Muscle**: $ T_1 = 1000 $ ms, $ T_2 = 35 $ ms.
- **Fat**: $ T_1 = 350 $ ms, $ T_2 = 120 $ ms.
- **Fluid (inflammation)**: $ T_1 = 2000 $ ms, $ T_2 = 300 $ ms.

Assume identical proton density across all tissues, and $ T_2 = T_{2}^{*} $, and a flip angle of 90-degrees.

**Note**: You can use `MRsignal_spoiled_gradient_echo.m` in this repositoryto calculate/verify the results of (a, b, c).

1. Choose a TE and TR to make Fluid have the highest signal between the tissues of interest. Verify your choice by calculating the expected signal for each tissue of interest.
<!--
    Tissue with long $ T_2 $ have high signal in $ T_2 $-weighted image, which has a long TE and long TR.  
    *Answers may vary, e.g. TE=300ms, TR=6000ms.*
-->
2. Choose a TE and TR to make Fat have the highest signal between the tissues of interest. Verify your choice by calculating the expected signal for each tissue of interest.
<!--
    Tissue with short $ T_1 $ have high signal in $ T_1 $-weighted image, which has a short TE and short TR.  
    *Answers may vary, e.g. TE=10ms, TR=100ms.*
-->
3. Choose a TE and TR such that Muscle signal is brighter than Fluid. Verify your choice by calculating the expected signal for each tissue of interest.
<!--

    Tissue with short $ T_1 $ have high signal in $ T_1 $-weighted image, which has a short TE and short TR.  
    *Answers may vary, e.g. TE=10ms, TR=100ms.*
-->

4. Choose parameters for an inversion recovery sequence (TI, TR) to suppress Fat signal. Verify your choice by calculating the expected signal for each tissue of interest.
<!--

    To suppress fat signal we want to choose a $ TI = T_{1} \cdot \ln(2) $ where $ T_{1} $ corresponds to the $ T_{1} $ of the tissue we want to suppress. For fat at 1.5T, $ T_{1} = 260 $ ms and so an appropriate TI = 180 ms. The TR should be long enough to acquire slices; an appropriate TR = 2500 ms.
-->


## Choosing contrast agents

The two most common types of MRI contrast agents are:
    - Gadolinium chelate, which will shorten $ T_1 $ but $ T_2 $ is effectively unchanged at typical concentrations and pulse sequence parameters
    - Iron Oxide nano-particles, which will shorten $ T_2 $ and shorten $ T_1 $

These agents shorten the relaxation times when they enter into a tissue or the blood.

1. After applying a RF pulse excitation, does the magnetization return to equilibrium faster, slower or the same with these contrast agents? Justify your answer for each contrast agent.

<!--
     **Solution:** Because $ T_1 $ is shortened after applying either of the contrast agents, both of them can make magnetization return to equilibrium faster.
-->
2. After applying RF pulse excitation, does the signal measured decay to zero faster, slower, or the same with these contrast agents? Justify your answer for each contrast agent.

<!--
     **Solution:** Because $ T_2 $ is shortened after applying Iron Oxide nano-particles, this contrast agent will cause faster signal decay. Gadolinium chelate will not affect signal decay since it doesn't change $ T_2 $.
-->
3. Suppose you measure a $ \hat{T}_1 = 355 $ ms, $ \hat{T}_2 = 63 $ ms for a gadolinium chelate concentration of 0.2 mM in white matter at 1.5T. What are the relaxivities of this agent?

<!--
     **Solution:**

     Since 
     \[
     \frac{1}{\hat{T_1}} = \frac{1}{T_1} + r_1 \cdot [CM],
     \]
     then,  
     \[
     \frac{1}{350} = \frac{1}{510} + 0.2 \cdot r_1
     \]
     \[
     r_1 = \frac{\left(\frac{1}{355} - \frac{1}{510}\right)}{0.2} = 4.28 \times 10^{-3} \, [\text{mM} \cdot \text{ms}]^{-1}
     \]
     Similarly,
     \[
     r_2 = \frac{\left(\frac{1}{63} - \frac{1}{67}\right)}{0.2} = 4.74 \times 10^{-3} \, [\text{mM} \cdot \text{ms}]^{-1}
     \]
-->
4. Suppose the relaxivities of a superparamagnetic iron oxide agent are $ r_1 = 7 $ [1/(mM s)], $ r_2 = 77 $ [1/(mM s)]. If this agent has a concentration of 0.1 mM in white matter at 1.5T, what do you expect the resulting $ \hat{T}_1, \hat{T}_2 $ are the relaxation time constants to be?

<!--
     **Solution:** $ \hat{T_1} = 376 $ ms, $ \hat{T_2} = 44 $ ms
-->
