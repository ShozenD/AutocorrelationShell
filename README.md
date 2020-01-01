# AutocorrelationShell.jl

This library is an implementation of autocorrelation wavelets in Julia. It was
made by Rishi Subramanian and Christina Chang under the supervision of Professor
 Naoki Saito at UC Davis.

## Prerequisites
The required packages are 
+ `DSP`
+ `StatsBase`
+ `Wavelets`

Here is an example of how to install a package via the package manager and load with `using`
```{julia}
Pkg.add("PackageName")
using PackageName
```

## Usage
Load the autocorrelation module
```{julia}
include("./autocorrelation-shell.jl")
using .AutocorrelationShell
```

## Autocorrelation Wavelet Transform
```{julia}
# Forward Autocorrelation Wavelet Transform
fwt_ac(x,L,P,Q)

# Inverse Autocorrelation Wavelet Transform
iwt_ac(y)
```

## Example
Load the `Plots` package and the `wiggle` function
```{julia}
using Plots
include("./wiggle.jl")
```

Perform forward autocorrelation wavelet transform on the vector x
```{julia}
H = wavelet(WT.db2)
L = 2
Q = qfilter(H)
P = pfilter(H)

x = zeros(256)
x[128] = 1

decomposition = fwt_ac(x,L,P,Q)

wiggle(decomposition, Overlap = false)
```

Result:

![Result](Presentation/auto_decomposition.png)