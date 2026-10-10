const n=`# Catalog ICRS to observed\r
\r
In this example, we want to find the observed coordinates of a star called *Gliese 555*. The Hipparcos identifier of this star is 71253 and it's SIMBAD *main_id* is "BD-11 3759". It's basic catalog data from [SIMBAD](https://simbad.cds.unistra.fr/simbad/sim-id?Ident=BD-11+3759) is:\r
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
We have choosen the observation site in Strasbourg, France and the UTC date and time is 10th Feb 2024 at 22:32:37. The Earth Orientation Parameters have been obtained from IERS website.\r
\r
\r
\`\`\`swift\r
import FAWS\r
\r
let faws = Faws()\r
\r
// Star data\r
let rc = 218.57004859310788 * faws.DD2R\r
let dc = -12.519559582093887 * faws.DD2R\r
let pr = -355.138 * faws.DMAS2R\r
let pd = 593.04 * faws.DMAS2R\r
let px = 159.9225 * 0.001\r
let rv = -1.28\r
\r
// Time of observation\r
let (utc1, utc2) = faws.dtf2d("UTC", 2024, 2, 10, 22, 32, 37.0)\r
//let (tai1, tai2) = faws.utctai(utc1, utc2)\r
//let (tt1, tt2) = faws.taitt(tai1, tai2)\r
\r
// Earth Orientation Parameters\r
let dut1 = 0.00261476\r
let xp = 0.0473476 * faws.DAS2R\r
let yp = 0.2368623 * faws.DAS2R\r
\r
// Observation site (coordinates and conditions)\r
let elong = 7.744083817548831 * faws.DD2R //longitude (radians)\r
let phi = 48.58313582900411 * faws.DD2R   //latitude (radians)\r
let hm = 140.0                       //height (m)\r
let phpa = 987.0 //Ambient pressure (HPa)\r
let tc = 15.0    //Temperature (C)\r
let rh = 0.92    //Relative humidity (frac)\r
let wl = 0.55    //Effective color (microns)\r
\r
let (aob, zob, hob, dob, rob, eo) = faws.atco13(\r
        rc, dc, pr, pd, px, rv,\r
        utc1, utc2, dut1,\r
        elong, phi, hm,\r
        xp, yp,\r
        phpa, tc, rh, wl\r
        )\r
        \r
    \r
print("Azimuth                 : \\(aob * faws.DR2D)")\r
print("Zenith Distance         : \\(zob * faws.DR2D)")\r
print("Hour Angle              : \\(hob * faws.DR2D)")\r
print("Declination             : \\(dob * faws.DR2D)")\r
print("Right Ascension         : \\(rob * faws.DR2D)")\r
print("equation of the origins : \\(eo  * faws.DR2D)")\r
\`\`\`\r
\r
\r
The output (all in degrees):\r
\r
\`\`\`\r
Azimuth                 : 96.59548514831307\r
Zenith Distance         : 100.89938985767792\r
Hour Angle              : -92.37778736685267\r
Declination             : -12.498270592129632\r
Right Ascension         : 218.47147240846533\r
equation of the origins : -0.3079588055596707\r
\`\`\`\r
`;export{n as default};
