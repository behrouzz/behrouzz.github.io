import FAWS
import Foundation

// convert to spherical in degrees
func printSph(_ p: [Double], _ text: String) -> () {
    let (w, r) = c2s(p)
    let d = anp(w)
    print("\(text): \(r*DR2D), \(d*DR2D)")
}

// Star data
let rc = 353.22987757 * DD2R
let dc = 52.27730247  * DD2R
let pr = atan2(22.9 * DMAS2R, cos(dc))
let pd = -2.1 * DMAS2R
let px = 23.0 * 0.001
let rv = 25.0

// Time of observation
let (utc1, utc2) = dtf2d("UTC", 2003, 8, 26, 0, 37, 38.973810)
let (tai1, tai2) = utctai(utc1, utc2)
let (tt1, tt2) = taitt(tai1, tai2)

// Earth Orientation Parameters
let dut1 = -0.349535
let xp = 0.259371 * DAS2R
let yp = 0.415573 * DAS2R
let dx = 0.038  * DMAS2R
let dy = -0.118 * DMAS2R


// Initial BPN matrix
let r = pnm06a(tt1, tt2)
var (x, y) = bpn2xy(r)
x += dx // Apply IERS corrections
y += dy // Apply IERS corrections
let s = s06(tt1, tt2, x, y)

// More precise BPN matrix
let bpn = c2ixys(x, y, s)


// Earth heliocentric and barycentric position-velocity vectors
let (pvh, pvb) = epv00(tt1, tt2)

// distance from Sun to observer (au) & Sun to observer (unit vector)
let (em, eh) = pn(pvh[0])

// barycentric observer velocity (vector, c)
let v = sxp(AULT / DAYSEC, pvb[1])
let v2 = v[0]*v[0] + v[1]*v[1] + v[2]*v[2]
// reciprocal of Lorenz factor
let bm1 = sqrt(1.0 - v2)


// Proper motion and parallax, giving BCRS coordinate direction
let pmt = ((tt1 - DJ00) + tt2) / DJY // time in julian years
let pco = pmpx(rc, dc, pr, pd, px, rv, pmt, pvb[0])
printSph(pco, "BCRS1      ")

// Light deflection by the Sun, giving BCRS natural direction
let pnat = ldsun(pco, eh, em)
printSph(pnat, "BCRS2      ")

// Aberration, giving GCRS proper direction
let ppr = ab(pnat, v, em, bm1)
printSph(ppr, "GCRS       ")

// Bias-precession-nutation, giving CIRS proper direction
let pi = rxp(bpn, ppr)
printSph(pi, "CIRS       ")

// CIRS RA,Dec
let (w, di) = c2s(pi)
let ri = anp(w)


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
print("Topocentric:, \(hot*DR2D), \(dot*DR2D)")
print("Topocentric:, \(aot*DR2D), \(90-zot*DR2D)")

// CIRS to observed
let (aob, zob, hob, dob, rob) = atio13(
		ri, di, utc1, utc2, dut1,
		elong, phi, hm, xp, yp,
		phpa, tc, rh, wl
)
print("Observed   :, \(aob*DR2D), \(90-zob*DR2D)")
