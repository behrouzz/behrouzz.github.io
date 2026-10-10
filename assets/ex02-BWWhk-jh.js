const t=`# Catalog ICRS -> CIRS -> observed\r
\r
This is an example by [SOFA Astrometry Cookbook](http://www.iausofa.org/2023_1011_C/sofa/sofa_ast_c.pdf) (page 16) that can be used as a useful template. Of course, you don't need to follow all the steps in many cases.\r
\r
\`\`\`swift\r
import FAWS\r
\r
\r
// Date and Time\r
let (utc1, utc2) = dtf2d("UTC", 2013, 4, 2, 23, 15, 43.55)\r
let (tai1, tai2) = utctai(utc1, utc2)\r
let (tt1, tt2) = taitt(tai1, tai2)\r
\r
// Site longitude, latitude (radians), height (m)\r
let elong = af2a("-", 5, 41, 54.2)\r
let phi = af2a("-", 15, 57, 42.8)\r
let hm = 625.0\r
\r
let phpa = 952.0 // Ambient pressure (HPa)\r
let tc = 18.5    // Temperature (C)\r
let rh = 0.83    // Relative humidity (frac)\r
let wl = 0.55    // Effective color (microns)\r
\r
// Catalog data for the test star\r
let rc = tf2a(" ", 14, 34, 16.81183) // ra (radians)\r
let dc = af2a("-", 12, 31, 10.3965)  // dec (radians)\r
let pmra = -354.45 // mas/y\r
let pmdec = 595.35 // mas/y\r
let px = 0.16499  // as\r
let rv = 0.0     // km/s\r
\r
// Earth orientation parameters\r
let pmx = 50.995  // Polar motion (mas)\r
let pmy = 376.723 // Polar motion (mas)\r
let ut1_utc = 155.0675 // ms\r
// corrections to IAU 2000A CIP\r
var dx = +0.269 //mas\r
var dy = -0.274 //mas\r
\r
\r
// EOPs: polar motion in radians, UT1-UTC in seconds\r
let xp = pmx * 1e-3 * DAS2R\r
let yp = pmy * 1e-3 * DAS2R\r
let dut1 = 155.0675e-3\r
\r
// Corrections to IAU 2000A CIP (radians)\r
dx = 0.269e-3 * DAS2R\r
dy = -0.274e-3 * DAS2R\r
\r
// Annual proper motion: RA/Dec derivatives, epoch J2000.0\r
let pr = atan2(-354.45e-3 * DAS2R, cos(dc))\r
let pd = 595.35e-3 * DAS2R\r
\r
// CONVERSIONS\r
// -----------\r
var rca, dca, ri, di, eo, ra, da: Double\r
var aot, zot, hot, dot, rot, aob, zob, hob, dob, rob: Double\r
\r
// ICRS catalog to astrometric place\r
(rca, dca) = atcc13(rc, dc, pr, pd, px, rv, tt1, tt2)\r
\r
// ...then to CIRS (geocentric observer)\r
(ri, di, eo) = atci13 (rca, dca, 0.0, 0.0, 0.0, 0.0, tt1, tt2)\r
\r
\r
// ICRS catalog directly to CIRS (geocentric observer)\r
(ri, di, eo) = atci13(rc, dc, pr, pd, px, rv, tt1, tt2)\r
print("ICRS -> CIRS:        \\(ri * DR2D), \\(di * DR2D)")\r
\r
// Apparent place (geocentric apparent)\r
ra = anp(ri - eo)\r
da = di\r
\r
// CIRS to topocentric\r
(aot, zot, hot, dot, rot) = atio13(\r
								ri, di, \r
								utc1, utc2, dut1, \r
								elong, phi, hm, \r
								xp, yp, \r
								0.0, 0.0, 0.0, 0.0\r
								)\r
print("CIRS -> topocentric: \\(rot * DR2D), \\(dot * DR2D)")\r
\r
// CIRS to observed\r
(aob, zob, hob, dob, rob) = atio13(\r
								ri, di, \r
								utc1, utc2, dut1, \r
								elong, phi, hm, \r
								xp, yp, \r
								phpa, tc, rh, wl\r
								)\r
print("CIRS -> observed:    \\(rob * DR2D), \\(dob * DR2D)")\r
\r
// ICRS to observed\r
(aob, zob, hob, dob, rob, eo) = atco13(\r
								rc, dc, pr, pd, px, rv, \r
								utc1, utc2, dut1, \r
								elong, phi, hm, \r
								xp, yp, \r
								phpa, tc, rh, wl\r
								)\r
print("ICRS -> observed:    \\(rob * DR2D), \\(dob * DR2D)")\r
\`\`\`\r
\r
\r
**Output:**\r
\r
\`\`\`\r
ICRS -> CIRS:        218.58432107808034, -12.576772681754274\r
CIRS -> topocentric: 218.58440428643232, -12.576705890836976\r
CIRS -> observed:    218.57068712526686, -12.579067525264819\r
ICRS -> observed:    218.57068712760787, -12.579067526029883\r
\`\`\`\r
`;export{t as default};
