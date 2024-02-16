import FAWS
import Foundation

//validate_all_functions()

func printSph(_ p: [Double], _ text: String) -> () {
    let (w, r) = c2s(p)
    let d = anp(w)
    print("\(text): \(r*DR2D) \(d*DR2D)")
}

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


/*
We can easily get the Bias-Precession-Nutation (BPN) matrix by calling
pnm06a(tt1, tt2). But, here we want more control over the calculations:
we want to apply IERS corrections (dx and dy). So, after getting the intial
BPN, we get the CIP coordinates from this matrix by calling bpn2xy. Then, we
apply the corrections (adding dx and dy to x and y). Now that we have the
exact coordinates of the CIP (x, y), we can get the CIO locator s by calling
s06. By passing x, y and s to c2ixys we get more precise BPN matrix.
*/

// Initial BPN matrix
let r = pnm06a(tt1, tt2)
var (x, y) = bpn2xy(r)
x += dx // Apply IERS corrections
y += dy // Apply IERS corrections
let s = s06(tt1, tt2, x, y)

// More precise BPN matrix
let bpn = c2ixys(x, y, s)

/*
Note that the BPN matrix is for rotating GCRS to....
So we need to convert the ICRS coordinates of the star into GCRS.
For this reason, we need heliocentric and barycentric position-velocity
vectors of the Earth. We can use epv00 or get it from other resources (for
example JPL). We use it to calculate some factors (em, eh, v, m1) as described
in the code. We need these factors later.
*/

// Earth heliocentric and barycentric position-velocity vectors
let (pvh, pvb) = epv00(tt1, tt2)

// distance from Sun to observer (au) & Sun to observer (unit vector)
let (em, eh) = pn(pvh[0])

// barycentric observer velocity (vector, c)
let v = sxp(AULT / DAYSEC, pvb[1])
let v2 = v[0]*v[0] + v[1]*v[1] + v[2]*v[2]
// reciprocal of Lorenz factor
let bm1 = sqrt(1.0 - v2)

/*
Until here, we had nothing to do with the coordinates of the star.
Now we start by applying proper motion and parallax to the catalog
coordinates of the star, using pmpx. Note that this function take the
time as julian years.
*/

// Proper motion and parallax, giving BCRS coordinate direction
let pmt = ((tt1 - DJ00) + tt2) / DJY // time in julian years
let pco = pmpx(rc, dc, pr, pd, px, rv, pmt, pvb[0])
printSph(pco, "BCRS1")

/*
We apply the light deflection by the Sun, using ldsun.
*/

// Light deflection by the Sun, giving BCRS natural direction
let pnat = ldsun(pco, eh, em)
printSph(pnat, "BCRS2")

/*
Applying the aberration, using ab, gives us the GCRS coordinates of the star.
*/

// Aberration, giving GCRS proper direction
let ppr = ab(pnat, v, em, bm1)
printSph(ppr, "GCRS ")

/*
Now that we have the GCRS coordinates of the star, we can multiply the
BPN matrix to it in order to get CIRS coordinates of the star.
*/

// Bias-precession-nutation, giving CIRS proper direction
let pi = rxp(bpn, ppr)
printSph(pi, "CIRS ")

// CIRS RA,Dec
let (w, di) = c2s(pi)
let ri = anp(w)

/*
We have now the CIRS coordinates of the star (ri, di). The remaining part
can be achieved by calling a single function atio13, which converts CIRS
to observed. If your provide the atmospheric condition of the obseving site
(applying refraction) you will get the observed coordinates. Thses variables
are ambient pressure (phpa), temperature (tc), relative humidity (rh) and
wavelength (wl). If you don't provide them by passing zero, you will get the
topocentric coordinates. We will try both.
*/

//-------------------------------------

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
