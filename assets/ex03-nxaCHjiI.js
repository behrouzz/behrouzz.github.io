const r=`# Catalog ICRS to CIRS\r
\r
In this example, we want to find the CIRS coordinates of a star called *Gliese 555*. The Hipparcos identifier of this star is 71253 and it's SIMBAD *main_id* is "BD-11 3759". It's basic catalog data from [SIMBAD](https://simbad.cds.unistra.fr/simbad/sim-id?Ident=BD-11+3759) is:\r
\r
\`\`\`\r
ra             218.57004859310788\r
dec           -12.519559582093887\r
pmra                     -355.138\r
pmdec                      593.04\r
plx_value                159.9225\r
rvz_radvel                  -1.28\r
\`\`\`\r
\r
We need to convert some units befor using FAWS functions. Some useful constants for unit conversions are:\r
\r
\`\`\`\r
DR2D: Radians to degrees\r
DD2R: Degrees to radians\r
DAS2R: Arcseconds to radians\r
DMAS2R: Milliarcseconds to radians\r
\`\`\`\r
\r
The UTC date and time is 10th Feb 2024 at 22:32:37. The Earth Orientation Parameters have been obtained from IERS website.\r
\r
We can convert ICRS to CIRS directly with \`atci13\` or first getting the star-independent context using \`apci13\` and then calling \`atciq\`. Both of them are shown here.\r
\r
\`\`\`swift\r
import FAWS\r
\r
// Star data\r
let rc = 218.57004859310788 * DD2R\r
let dc = -12.519559582093887 * DD2R\r
let pr = -355.138 * DMAS2R\r
let pd = 593.04 * DMAS2R\r
let px = 159.9225 * 0.001\r
let rv = -1.28\r
\r
// Time of observation (convert UTC to TT)\r
let (utc1, utc2) = dtf2d("UTC", 2024, 2, 10, 22, 32, 37.0)\r
let (tai1, tai2) = utctai(utc1, utc2)\r
let (tt1, tt2) = taitt(tai1, tai2)\r
\r
// Earth Orientation Parameters\r
let dut1 = 0.00261476\r
let xp = 0.0473476 * DAS2R\r
let yp = 0.2368623 * DAS2R\r
\r
\r
// with atci13\r
var (ri, di, _) = atci13(rc, dc, pr, pd, px, rv, tt1, tt2)\r
print("\\(ri*DR2D), \\(di*DR2D)")\r
\r
// with atciq\r
let (astrom, _) = apci13(tt1, tt2)\r
(ri, di) = atciq(rc, dc, pr, pd, px, rv, astrom)\r
print("\\(ri*DR2D), \\(di*DR2D)")\r
\`\`\`\r
\r
\r
The output (in degrees):\r
\r
\`\`\`\r
218.586903349345, -12.622083449085888\r
218.586903349345, -12.622083449085888\r
\`\`\`\r
`;export{r as default};
