const t=`# Catalog ICRS to observed (detailed)\r
\r
In this example we will show step by step calculations to convert ICRS catalog coordinates of a star to its observed coordinates. We follow the steps shown by *Patrick Wallace* in this [PDF file](https://syrte.obspm.fr/iau/iauWGnfa/ExPW04.pdf).\r
\r
The observation site is located at 9◦.712156 E, 52◦.385639 N, 200m above sea level. The time of observation is UTC 2003/08/26 00:37:38.973810.\r
\r
The target of observation is a fictitious Tycho 2 star, epoch 2000:\r
- [ α, δ ] = 353◦.22987757, +52◦.27730247\r
- Proper motions: μα cos δ = +22.9mas/year, μδ = −2.1mas/year\r
- Parallax 23mas\r
- Radial velocity +25 km/s\r
\r
The Earth orientation parameters (from IERS):\r
- DUT1: −0.349535 s\r
- δX, δY corrections: +0.038, −0.118 (mas)\r
- polar motion xp, yp = 0.259371, 0.415573 (arcsec)\r
\r
Let's begin by assigning these data to variables.\r
\r
\`\`\`swift\r
import FAWS\r
import Foundation\r
\r
// Star data\r
let rc = 353.22987757 * DD2R\r
let dc = 52.27730247  * DD2R\r
let pr = atan2(22.9 * DMAS2R, cos(dc))\r
let pd = -2.1 * DMAS2R\r
let px = 23.0 * 0.001\r
let rv = 25.0\r
\r
// Time of observation (convert UTC to TT)\r
let (utc1, utc2) = dtf2d("UTC", 2003, 8, 26, 0, 37, 38.973810)\r
let (tai1, tai2) = utctai(utc1, utc2)\r
let (tt1, tt2) = taitt(tai1, tai2)\r
\r
// Earth Orientation Parameters\r
let dut1 = -0.349535\r
let xp = 0.259371 * DAS2R\r
let yp = 0.415573 * DAS2R\r
let dx = 0.038  * DMAS2R\r
let dy = -0.118 * DMAS2R\r
\`\`\`\r
\r
In the following steps, we want to print the results. Since the results are in cartesian and radians, let's create a very simple function to convert them to spherical and degrees and print them to the output as well as a text message.\r
\r
\`\`\`swift\r
func printSph(_ p: [Double], _ text: String) -> () {\r
    let (w, r) = c2s(p)\r
    let d = anp(w)\r
    print("\\(text): \\(r*DR2D), \\(d*DR2D)")\r
}\r
\`\`\`\r
\r
We can easily get the *Bias-Precession-Nutation (BPN)* matrix by calling \`pnm06a(tt1, tt2)\`. But, here we want more control over the calculations: we want to apply IERS corrections (\`dx\` and \`dy\`). So, after getting the intial *BPN*, we get the CIP coordinates from this matrix by calling \`bpn2xy\`. Then, we apply the corrections (adding \`dx\` and \`dy\` to \`x\` and \`y\`). Now that we have the exact coordinates of the CIP (\`x\` and \`y\`), we can get the CIO locator \`s\` by calling the function \`s06\`. By passing \`x\`, \`y\` and \`s\` to \`c2ixys\` we get more precise *BPN* matrix.\r
\r
\`\`\`swift\r
// Initial BPN matrix\r
let r = pnm06a(tt1, tt2)\r
var (x, y) = bpn2xy(r)\r
x += dx // Apply IERS corrections\r
y += dy // Apply IERS corrections\r
let s = s06(tt1, tt2, x, y)\r
\r
// More precise BPN matrix\r
let bpn = c2ixys(x, y, s)\r
\`\`\`\r
\r
Note that the *BPN* matrix is for rotating GCRS to....\r
So we need to convert the ICRS coordinates of the star into GCRS. For this reason, we need heliocentric and barycentric position-velocity vectors of the Earth. We can use the function \`epv00\` or get it from other resources (for example JPL). We use it to calculate some factors (\`em\`, \`eh\`, \`v\`, \`m1\`) as described in the code. We need these factors later.\r
\r
\`\`\`swift\r
// Earth heliocentric and barycentric position-velocity vectors\r
let (pvh, pvb) = epv00(tt1, tt2)\r
\r
// distance from Sun to observer (au) & Sun to observer (unit vector)\r
let (em, eh) = pn(pvh[0])\r
\r
// barycentric observer velocity (vector, c)\r
let v = sxp(AULT / DAYSEC, pvb[1])\r
let v2 = v[0]*v[0] + v[1]*v[1] + v[2]*v[2]\r
// reciprocal of Lorenz factor\r
let bm1 = sqrt(1.0 - v2)\r
\`\`\`\r
\r
Until here, we had nothing to do with the coordinates of the star. Now we start by applying proper motion and parallax to the catalog coordinates of the star, using pmpx. Note that this function take the time as julian years.\r
\r
\`\`\`swift\r
// Proper motion and parallax, giving BCRS coordinate direction\r
let pmt = ((tt1 - DJ00) + tt2) / DJY // time in julian years\r
let pco = pmpx(rc, dc, pr, pd, px, rv, pmt, pvb[0])\r
printSph(pco, "BCRS1      ")\r
\`\`\`\r
\r
We apply the light deflection by the Sun, using \`ldsun\`.\r
\r
\`\`\`swift\r
// Light deflection by the Sun, giving BCRS natural direction\r
let pnat = ldsun(pco, eh, em)\r
printSph(pnat, "BCRS2      ")\r
\`\`\`\r
\r
Applying the aberration, using ab, gives us the GCRS coordinates of the star.\r
\r
\`\`\`swift\r
// Aberration, giving GCRS proper direction\r
let ppr = ab(pnat, v, em, bm1)\r
printSph(ppr, "GCRS       ")\r
\`\`\`\r
\r
Now that we have the GCRS coordinates of the star, we can multiply the *BPN* matrix to it in order to get CIRS coordinates of the star.\r
\r
\`\`\`swift\r
// Bias-precession-nutation, giving CIRS proper direction\r
let pi = rxp(bpn, ppr)\r
printSph(pi, "CIRS       ")\r
\r
// CIRS RA,Dec\r
let (w, di) = c2s(pi)\r
let ri = anp(w)\r
\`\`\`\r
\r
We have now the CIRS coordinates of the star (\`ri\`, \`di\`). The remaining part can be achieved by calling a single function \`atio13\`, which converts CIRS to observed. If your provide the atmospheric condition of the obseving site (applying refraction) you will get the observed coordinates. Thses variables are ambient pressure (\`phpa\`), temperature (\`tc\`), relative humidity (\`rh\`) and wavelength (\`wl\`). If you don't provide them by passing zero, you will get the topocentric coordinates. We will try both.\r
\r
\`\`\`swift\r
let elong = 9.712156 * DD2R\r
let phi = 52.385639  * DD2R\r
let hm = 200.0\r
let phpa = 1000.0 //Ambient pressure (HPa)\r
let tc = 20.0     //Temperature (C)\r
let rh = 0.70     //Relative humidity (frac)\r
let wl = 0.55     //wavelength  (microns)\r
\r
// CIRS to topocentric\r
let (aot, zot, hot, dot, rot) = atio13(\r
    ri, di, utc1, utc2, dut1,\r
    elong, phi, hm, xp, yp,\r
    0.0, 0.0, 0.0, 0.0\r
)\r
print("Topocentric: \\(hot*DR2D), \\(dot*DR2D)")\r
print("Topocentric: \\(aot*DR2D), \\(90-zot*DR2D)")\r
\r
// CIRS to observed\r
let (aob, zob, hob, dob, rob) = atio13(\r
    ri, di, utc1, utc2, dut1,\r
    elong, phi, hm, xp, yp,\r
    phpa, tc, rh, wl\r
)\r
print("Observed   : \\(aob*DR2D), \\(90-zob*DR2D)")\r
\`\`\`\r
\r
The output:\r
\r
\`\`\`\r
BCRS1      : 52.27730584234127, 353.2299188909816\r
BCRS2      : 52.277305175083455, 353.22991848170153\r
GCRS       : 52.276952625332505, 353.23789320692833\r
CIRS       : 52.29554174097641, 353.23300208961683\r
Topocentric: -0.2950796293211075, 52.29549062787615\r
Topocentric: 116.44983887937016, 89.79843387472513\r
Observed   : 116.44983887937016, 89.79848799911075\r
\`\`\`\r
\r
The [Swift file](https://raw.githubusercontent.com/behrouzz/behrouzz.github.io/master/faws/icrs_obs_detailed.swift) of this example.\r
`;export{t as default};
