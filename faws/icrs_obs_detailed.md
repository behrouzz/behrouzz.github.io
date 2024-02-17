# Catalog ICRS to observed (detailed)

In this example we will show step by step calculations to convert ICRS catalog coordinates of a star to its observed coordinates. We follow the steps shown by *Patrick Wallace* in this [PDF file](https://syrte.obspm.fr/iau/iauWGnfa/ExPW04.pdf).

The observation site is located at 9◦.712156 E, 52◦.385639 N, 200m above sea level. The time of observation is UTC 2003/08/26 00:37:38.973810.

The target of observation is a fictitious Tycho 2 star, epoch 2000:

- [ α, δ ] = 353◦.22987757, +52◦.27730247
– Proper motions: μα cos δ = +22.9mas/year, μδ = −2.1mas/year
– Parallax 23mas
– Radial velocity +25 km/s

The Earth orientation parameters (from IERS):
- DUT1: −0.349535 s
- δX, δY corrections: +0.038, −0.118 (mas)
- polar motion xp, yp = 0.259371, 0.415573 (arcsec)

Let's begin by assigning these data to variables.

```swift
import FAWS
import Foundation

// Star data
let rc = 353.22987757 * DD2R
let dc = 52.27730247  * DD2R
let pr = atan2(22.9 * DMAS2R, cos(dc))
let pd = -2.1 * DMAS2R
let px = 23.0 * 0.001 // ?????????????????
let rv = 25.0

// Time of observation (convert UTC to TT)
let (utc1, utc2) = dtf2d("UTC", 2003, 8, 26, 0, 37, 38.973810)
let (tai1, tai2) = utctai(utc1, utc2)
let (tt1, tt2) = taitt(tai1, tai2)

// Earth Orientation Parameters
let dut1 = -0.349535
let xp = 0.259371 * DAS2R
let yp = 0.415573 * DAS2R
let dx = 0.038  * DMAS2R
let dy = -0.118 * DMAS2R
```

In the following steps, we want to print the results. Since the results are in cartesian and radians, let's create a very simple function to convert them to spherical and degrees and print them to the output as well as a text message.

```swift
func printSph(_ p: [Double], _ text: String) -> () {
    let (w, r) = c2s(p)
    let d = anp(w)
    print("\(text): \(r*DR2D) \(d*DR2D)")
}
```

We can easily get the *Bias-Precession-Nutation (BPN)* matrix by calling `pnm06a(tt1, tt2)`. But, here we want more control over the calculations: we want to apply IERS corrections (`dx` and `dy`). So, after getting the intial *BPN*, we get the CIP coordinates from this matrix by calling `bpn2xy`. Then, we apply the corrections (adding `dx` and `dy` to `x` and `y`). Now that we have the exact coordinates of the CIP (`x` and `y`), we can get the CIO locator `s` by calling the function `s06`. By passing `x`, `y` and `s` to `c2ixys` we get more precise *BPN* matrix.

```swift
// Initial BPN matrix
let r = pnm06a(tt1, tt2)
var (x, y) = bpn2xy(r)
x += dx // Apply IERS corrections
y += dy // Apply IERS corrections
let s = s06(tt1, tt2, x, y)

// More precise BPN matrix
let bpn = c2ixys(x, y, s)
```

Note that the *BPN* matrix is for rotating GCRS to....
So we need to convert the ICRS coordinates of the star into GCRS. For this reason, we need heliocentric and barycentric position-velocity vectors of the Earth. We can use the function `epv00` or get it from other resources (for example JPL). We use it to calculate some factors (`em`, `eh`, `v`, `m1`) as described in the code. We need these factors later.

```swift
// Earth heliocentric and barycentric position-velocity vectors
let (pvh, pvb) = epv00(tt1, tt2)

// distance from Sun to observer (au) & Sun to observer (unit vector)
let (em, eh) = pn(pvh[0])

// barycentric observer velocity (vector, c)
let v = sxp(AULT / DAYSEC, pvb[1])
let v2 = v[0]*v[0] + v[1]*v[1] + v[2]*v[2]
// reciprocal of Lorenz factor
let bm1 = sqrt(1.0 - v2)
```

Until here, we had nothing to do with the coordinates of the star. Now we start by applying proper motion and parallax to the catalog coordinates of the star, using pmpx. Note that this function take the time as julian years.

```swift
// Proper motion and parallax, giving BCRS coordinate direction
let pmt = ((tt1 - DJ00) + tt2) / DJY // time in julian years
let pco = pmpx(rc, dc, pr, pd, px, rv, pmt, pvb[0])
printSph(pco, "BCRS1")
```

We apply the light deflection by the Sun, using `ldsun`.

```swift
// Light deflection by the Sun, giving BCRS natural direction
let pnat = ldsun(pco, eh, em)
printSph(pnat, "BCRS2")
```

Applying the aberration, using ab, gives us the GCRS coordinates of the star.

```swift
// Aberration, giving GCRS proper direction
let ppr = ab(pnat, v, em, bm1)
printSph(ppr, "GCRS ")
```

Now that we have the GCRS coordinates of the star, we can multiply the *BPN* matrix to it in order to get CIRS coordinates of the star.

```swift
// Bias-precession-nutation, giving CIRS proper direction
let pi = rxp(bpn, ppr)
printSph(pi, "CIRS ")

// CIRS RA,Dec
let (w, di) = c2s(pi)
let ri = anp(w)
```

We have now the CIRS coordinates of the star (`ri`, `di`). The remaining part can be achieved by calling a single function `atio13`, which converts CIRS to observed. If your provide the atmospheric condition of the obseving site (applying refraction) you will get the observed coordinates. Thses variables are ambient pressure (`phpa`), temperature (`tc`), relative humidity (`rh`) and wavelength (`wl`). If you don't provide them by passing zero, you will get the topocentric coordinates. We will try both.

```swift
let elong = 9.712156 * DD2R
let phi = 52.385639  * DD2R
let hm = 200.0
let phpa = 1000.0 //Ambient pressure (HPa)
let tc = 20.0     //Temperature (C)
let rh = 0.70     //Relative humidity (frac)
let wl = 0.55     //wavelength  (microns)

// CIRS to topocentric
let (aot, zot, hot, dot, rot) = atio13(
    ri, di, utc1, utc2, dut1,
    elong, phi, hm, xp, yp,
    0.0, 0.0, 0.0, 0.0
)
print("Topoce:, \(hot*DR2D), \(dot*DR2D)")
print("Topoce:, \(aot*DR2D), \(90-zot*DR2D)")

// CIRS to observed
let (aob, zob, hob, dob, rob) = atio13(
    ri, di, utc1, utc2, dut1,
    elong, phi, hm, xp, yp,
    phpa, tc, rh, wl
)
print("Observ:, \(aob*DR2D), \(90-zob*DR2D)")
```

The output:

```
```
