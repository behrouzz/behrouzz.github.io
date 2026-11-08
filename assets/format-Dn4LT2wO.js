import{j as n}from"./index-CS6ORQJm.js";const j={idle:{label:"Not submitted",cls:"idle"},done:{label:"Done",cls:"done"},stale:{label:"Inputs changed — submit again",cls:"stale"},locked:{label:"Waiting for previous steps",cls:"idle"}};function T({id:a,n:e,title:t,intro:r,status:o,children:l}){const h=j[o];return n.jsxs("section",{className:`card step-${o}`,id:a,children:[n.jsxs("header",{className:"card-head",children:[n.jsx("span",{className:"badge",children:e}),n.jsx("h2",{children:t}),n.jsx("span",{className:`chip ${h.cls}`,children:h.label})]}),r&&n.jsx("p",{className:"intro",children:r}),l]})}function _({children:a}){return n.jsx("div",{className:"actions",children:a})}function O({loading:a,children:e,...t}){return n.jsxs("button",{className:"btn",...t,disabled:t.disabled||a,children:[a&&n.jsx("span",{className:"spinner","aria-hidden":!0}),e]})}function F({error:a}){return a?n.jsx("div",{className:"error",role:"alert",children:a}):null}function B({rows:a}){return n.jsx("div",{className:"vars","aria-live":"polite",children:a.map(e=>n.jsxs("div",{className:"var",children:[n.jsx("code",{className:"vname",children:e.name}),n.jsx("span",{className:"eq",children:"="}),n.jsx("code",{className:"vval",children:e.value}),n.jsx("span",{className:"vunit",children:e.unit}),n.jsx("span",{className:"vnote",children:e.note&&n.jsx("span",{children:e.note})})]},e.name))})}function U({children:a}){return n.jsx("code",{className:"fn",children:a})}function q({name:a,m:e,note:t}){return n.jsxs("div",{className:"mat",children:[n.jsxs("div",{className:"mat-head",children:[n.jsx("code",{className:"vname",children:a}),t&&n.jsx("span",{className:"vnote",children:n.jsx("span",{children:t})})]}),n.jsx("div",{className:"mat-body",children:e.flat().map((r,o)=>n.jsx("code",{children:r.toPrecision(12)},o))})]})}const g=Math.PI/180,N=180/Math.PI,R=Math.PI/648e3,S=R/1e3,D={angleRA:{sofa:"rad",list:[{id:"deg",label:"degrees",to:a=>a*g,how:"value × DD2R"},{id:"rad",label:"radians",to:a=>a,how:"already in radians"},{id:"h",label:"hours",to:a=>a*15*g,how:"value × 15 × DD2R"}]},angle:{sofa:"rad",list:[{id:"deg",label:"degrees",to:a=>a*g,how:"value × DD2R"},{id:"rad",label:"radians",to:a=>a,how:"already in radians"}]},parallax:{sofa:"arcsec",list:[{id:"mas",label:"mas",to:a=>a*.001,how:"value × 0.001"},{id:"arcsec",label:"arcsec",to:a=>a,how:"already in arcsec"}]},pm:{sofa:"rad/yr",list:[{id:"mas/yr",label:"mas/yr",to:a=>a*S,how:"value × DMAS2R"},{id:"arcsec/yr",label:"arcsec/yr",to:a=>a*R,how:"value × DAS2R"},{id:"rad/yr",label:"rad/yr",to:a=>a,how:"already in rad/yr"}]},rv:{sofa:"km/s",list:[{id:"km/s",label:"km/s",to:a=>a,how:"already in km/s"},{id:"m/s",label:"m/s",to:a=>a/1e3,how:"value ÷ 1000"}]},height:{sofa:"m",list:[{id:"m",label:"metres",to:a=>a,how:"already in metres"},{id:"km",label:"km",to:a=>a*1e3,how:"value × 1000"},{id:"ft",label:"feet",to:a=>a*.3048,how:"value × 0.3048"}]},pressure:{sofa:"hPa",list:[{id:"hPa",label:"hPa (mbar)",to:a=>a,how:"already in hPa"},{id:"kPa",label:"kPa",to:a=>a*10,how:"value × 10"},{id:"Pa",label:"Pa",to:a=>a/100,how:"value ÷ 100"},{id:"mmHg",label:"mmHg",to:a=>a*1.333224,how:"value × 1.333224"},{id:"atm",label:"atm",to:a=>a*1013.25,how:"value × 1013.25"}]},temperature:{sofa:"°C",list:[{id:"C",label:"°C",to:a=>a,how:"already in °C"},{id:"K",label:"K",to:a=>a-273.15,how:"value − 273.15"},{id:"F",label:"°F",to:a=>(a-32)*5/9,how:"(value − 32) × 5/9"}]},humidity:{sofa:"fraction",list:[{id:"frac",label:"fraction (0–1)",to:a=>a,how:"already a fraction"},{id:"pct",label:"%",to:a=>a/100,how:"value ÷ 100"}]},dut1:{sofa:"s",list:[{id:"s",label:"s",to:a=>a,how:"already in seconds"},{id:"ms",label:"ms",to:a=>a/1e3,how:"value ÷ 1000"}]},eopAngle:{sofa:"rad",list:[{id:"arcsec",label:"arcsec",to:a=>a*R,how:"value × DAS2R"},{id:"mas",label:"mas",to:a=>a*S,how:"value × DMAS2R"},{id:"rad",label:"radians",to:a=>a,how:"already in radians"}]},wavelength:{sofa:"µm",list:[{id:"um",label:"µm",to:a=>a,how:"already in µm"},{id:"nm",label:"nm",to:a=>a/1e3,how:"value ÷ 1000"}]}};function H(a,e){const t=D[a].list.find(l=>l.id===e.unit),r=e.value.trim(),o=r===""?NaN:Number(r);return{num:Number.isFinite(o)?t.to(o):NaN,how:t.how,sofaUnit:D[a].sofa}}function L({label:a,kind:e,field:t,onChange:r,hint:o,plainUnit:l}){const h=D[e].list,u=t.value.trim()!==""&&!Number.isFinite(Number(t.value));return n.jsxs("label",{className:"field",children:[n.jsx("span",{className:"flabel",children:a}),n.jsxs("span",{className:`fcontrol ${u?"bad":""}`,children:[n.jsx("input",{type:"text",inputMode:"decimal",value:t.value,onChange:d=>r({...t,value:d.target.value}),spellCheck:!1}),l?n.jsx("span",{className:"funit",children:l}):n.jsx("select",{value:t.unit,onChange:d=>r({...t,unit:d.target.value}),"aria-label":`${a} unit`,children:h.map(d=>n.jsx("option",{value:d.id,children:d.label},d.id))})]}),o&&n.jsx("span",{className:"fhint",children:o})]})}const C={angleRA:{deg:"{v} * DD2R",rad:"{v}",h:"{v} * 15 * DD2R"},angle:{deg:"{v} * DD2R",rad:"{v}"},parallax:{mas:"{v} * 0.001",arcsec:"{v}"},pm:{"mas/yr":"{v} * DMAS2R","arcsec/yr":"{v} * DAS2R","rad/yr":"{v}"},rv:{"km/s":"{v}","m/s":"{v} / 1000"},height:{m:"{v}",km:"{v} * 1000",ft:"{v} * 0.3048"},pressure:{hPa:"{v}",kPa:"{v} * 10",Pa:"{v} / 100",mmHg:"{v} * 1.333224",atm:"{v} * 1013.25"},temperature:{C:"{v}",K:"{v} - 273.15",F:"({v} - 32) * 5 / 9"},humidity:{frac:"{v}",pct:"{v} / 100"},wavelength:{um:"{v}",nm:"{v} / 1000"},dut1:{s:"{v}",ms:"{v} / 1000"},eopAngle:{arcsec:"{v} * DAS2R",mas:"{v} * DMAS2R",rad:"{v}"}},P=a=>String(Number(a)),I=a=>Number.isInteger(a)?a.toFixed(1):String(a);function i(a,e,t=P(e.value)){return C[a][e.unit].replace("{v}",t)}const k={angleRA:{deg:"degrees",rad:"radians",h:"hours"},angle:{deg:"degrees",rad:"radians"},parallax:{mas:"mas",arcsec:"arcsec"},pm:{"mas/yr":"mas/yr","arcsec/yr":"arcsec/yr","rad/yr":"rad/yr"},rv:{"km/s":"km/s","m/s":"m/s"},height:{m:"m",km:"km",ft:"ft"},pressure:{hPa:"hPa",kPa:"kPa",Pa:"Pa",mmHg:"mmHg",atm:"atm"},temperature:{C:"°C",K:"K",F:"°F"},humidity:{frac:"fraction",pct:"%"},wavelength:{um:"µm",nm:"nm"},dut1:{s:"s",ms:"ms"},eopAngle:{arcsec:"arcsec",mas:"mas",rad:"rad"}},c=(a,e)=>`input in ${k[a][e.unit]}`,s=(a,e,t)=>`${a} = ${e}${t?`  # ${t}`:""}`,y=(a,e)=>`"""${a}

${e}

Generated by "SOFA by Example". Requires:  pip install pyerfa
"""
import math

import numpy as np
import erfa
from erfa import DD2R, DR2D, DAS2R, DMAS2R
`,x=(a,e=!0)=>`# Time of observation (UTC) -> two-part Julian Date
utc1, utc2 = erfa.dtf2d("UTC", ${a.iy}, ${a.im}, ${a.id}, ${a.ihr}, ${a.imn}, ${I(a.sec)})
${e?`tai1, tai2 = erfa.utctai(utc1, utc2)
tt1, tt2 = erfa.taitt(tai1, tai2)
`:""}`,w=a=>`# Earth Orientation Parameters (IERS Bulletin ${a.bulletin??"B"}, interpolated to the date above)
dut1 = ${a.dut1}  # UT1-UTC (s)
xp = ${a.pxArc} * DAS2R  # polar motion x (arcsec -> rad)
yp = ${a.pyArc} * DAS2R  # polar motion y (arcsec -> rad)
`,$=(a,e=!0)=>`# Observation site
${s("elong",i("angle",a.lon),`longitude, east positive (rad); ${c("angle",a.lon)}`)}
${s("phi",i("angle",a.lat),`geodetic latitude (rad); ${c("angle",a.lat)}`)}
${s("hm",i("height",a.h),`height above the ellipsoid (m); ${c("height",a.h)}`)}
${e?`
# Atmospheric conditions (for refraction)
${s("phpa",i("pressure",a.p),`pressure (hPa); ${c("pressure",a.p)}`)}
${s("tc",i("temperature",a.t),`temperature (deg C); ${c("temperature",a.t)}`)}
${s("rh",i("humidity",a.rh),`relative humidity (0-1); ${c("humidity",a.rh)}`)}
${s("wl",i("wavelength",a.wl),`wavelength (micrometres); ${c("wavelength",a.wl)}`)}
`:""}`,A=(a,{atan2:e=!1}={})=>{const t=i("pm",a.pmra);let r;return e?r=s("pr",`math.atan2(${t}, math.cos(dc))`,"dRA/dt, from mu_alpha*cos(delta)"):a.divCos?r=s("pr",`(${t}) / math.cos(dc)`,"dRA/dt, from mu_alpha*cos(delta) (rad/yr)"):r=s("pr",t,`RA proper motion (rad/yr); ${c("pm",a.pmra)}`),`# Star data (ICRS, epoch J2000.0)
${s("rc",i("angleRA",a.ra),`right ascension (rad); ${c("angleRA",a.ra)}`)}
${s("dc",i("angle",a.dec),`declination (rad); ${c("angle",a.dec)}`)}
${r}
${s("pd",i("pm",a.pmdec),`Dec proper motion (rad/yr); ${c("pm",a.pmdec)}`)}
${s("px",i("parallax",a.plx),`parallax (arcsec); ${c("parallax",a.plx)}`)}
${s("rv",i("rv",a.rv),`radial velocity (km/s); ${c("rv",a.rv)}`)}
`};function J({star:a,time:e,eop:t,site:r}){return`${y("Catalog ICRS to observed place","One call to atco13 does the whole conversion.")}
${A(a)}
${x(e)}
${w(t)}
${$(r)}
# ICRS -> observed place
aob, zob, hob, dob, rob, eo = erfa.atco13(
    rc, dc, pr, pd, px, rv,
    utc1, utc2, dut1,
    elong, phi, hm,
    xp, yp,
    phpa, tc, rh, wl,
)

print(f"Azimuth                 : {aob * DR2D}")
print(f"Zenith distance         : {zob * DR2D}")
print(f"Hour angle              : {hob * DR2D}")
print(f"Declination             : {dob * DR2D}")
print(f"Right ascension         : {rob * DR2D}")
print(f"Equation of the origins : {eo * DR2D}")
`}function K({star:a,time:e,eop:t,site:r}){return`${y("Catalog ICRS to observed place, step by step","Each correction (proper motion, light deflection, aberration, precession-nutation, refraction) is applied separately.")}
${A(a,{atan2:!0})}
${x(e)}
# Earth Orientation Parameters
${s("dut1",i("dut1",t.dut1),`UT1-UTC (s); ${c("dut1",t.dut1)}`)}
${s("xp",i("eopAngle",t.xp),`polar motion x (rad); ${c("eopAngle",t.xp)}`)}
${s("yp",i("eopAngle",t.yp),`polar motion y (rad); ${c("eopAngle",t.yp)}`)}
${s("dx",i("eopAngle",t.dx),`CIP correction dX (rad); ${c("eopAngle",t.dx)}`)}
${s("dy",i("eopAngle",t.dy),`CIP correction dY (rad); ${c("eopAngle",t.dy)}`)}

${$(r)}

def print_sph(p, text):
    """Print a direction vector as right ascension and declination in degrees."""
    theta, phi_ = erfa.c2s(p)
    print(f"{text}: RA {erfa.anp(theta) * DR2D:.10f}, Dec {phi_ * DR2D:.10f}")


# 5. Bias-precession-nutation matrix, with the IERS corrections applied to the CIP
r = erfa.pnm06a(tt1, tt2)
x, y = erfa.bpn2xy(r)
x += dx
y += dy
s = erfa.s06(tt1, tt2, x, y)
bpn = erfa.c2ixys(x, y, s)

# 6. Earth position and velocity
pvh, pvb = erfa.epv00(tt1, tt2)
em, eh = erfa.pn(pvh["p"])  # Sun-observer distance (au) and unit vector
v = erfa.sxp(erfa.AULT / erfa.DAYSEC, pvb["v"])  # barycentric velocity in units of c
v2 = float(np.dot(v, v))
bm1 = math.sqrt(1.0 - v2)  # reciprocal of the Lorentz factor

# 7. Proper motion and parallax -> BCRS direction
pmt = ((tt1 - erfa.DJ00) + tt2) / erfa.DJY  # Julian years since J2000.0
pco = erfa.pmpx(rc, dc, pr, pd, px, rv, pmt, pvb["p"])
print_sph(pco, "BCRS (proper motion, parallax)")

# 8. Light deflection by the Sun
pnat = erfa.ldsun(pco, eh, em)
print_sph(pnat, "BCRS (light deflection)     ")

# 9. Aberration -> GCRS
ppr = erfa.ab(pnat, v, em, bm1)
print_sph(ppr, "GCRS (aberration)            ")

# 10. GCRS -> CIRS
p_cirs = erfa.rxp(bpn, ppr)
print_sph(p_cirs, "CIRS                         ")
theta, di = erfa.c2s(p_cirs)
ri = erfa.anp(theta)

# 11. CIRS -> topocentric (no atmosphere) and observed (with refraction)
aot, zot, hot, dot, rot = erfa.atio13(ri, di, utc1, utc2, dut1, elong, phi, hm, xp, yp, 0.0, 0.0, 0.0, 0.0)
aob, zob, hob, dob, rob = erfa.atio13(ri, di, utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)

print(f"Topocentric: azimuth {aot * DR2D}, altitude {90 - zot * DR2D}")
print(f"Observed   : azimuth {aob * DR2D}, altitude {90 - zob * DR2D}")
`}function G({rows:a,units:e,divCos:t,time:r,eop:o,site:l}){const h=m=>JSON.stringify(m),u=a.map(m=>`    (${h(m.name)}, ${m.ra}, ${m.dec}, ${m.pmra}, ${m.pmdec}, ${m.plx}, ${m.rv}),`).join(`
`),d=m=>({unit:e[m]}),v=i("pm",d("pmra"),"pmra");return`${y("Many stars at once","Prepare the star-independent parameters once (apco13), then transform every star with atciq and atioq.")}
# Stars, as exported from SIMBAD (the units are those you selected on the web page)
stars = [
    # name, ra, dec, pmra, pmdec, parallax, radial velocity
${u}
]
names = [s[0] for s in stars]
ra, dec, pmra, pmdec, plx, rv_raw = (np.array([s[i] for s in stars], dtype=float) for i in range(1, 7))

# Star data in SOFA units: one array entry per star
${s("rc",i("angleRA",d("ra"),"ra"),`right ascension (rad); ${c("angleRA",d("ra"))}`)}
${s("dc",i("angle",d("dec"),"dec"),`declination (rad); ${c("angle",d("dec"))}`)}
${t?s("pr",`(${v}) / np.cos(dc)`,"dRA/dt from mu_alpha*cos(delta) (rad/yr)"):s("pr",v,`RA proper motion (rad/yr); ${c("pm",d("pmra"))}`)}
${s("pd",i("pm",d("pmdec"),"pmdec"),`Dec proper motion (rad/yr); ${c("pm",d("pmdec"))}`)}
${s("px",i("parallax",d("plx"),"plx"),`parallax (arcsec); ${c("parallax",d("plx"))}`)}
${s("rv",i("rv",d("rv"),"rv_raw"),`radial velocity (km/s); ${c("rv",d("rv"))}`)}

${x(r,!1)}
${w(o)}
${$(l)}
# Everything that does not depend on the star, computed ONCE
astrom, eo = erfa.apco13(utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)

# ICRS -> CIRS, then CIRS -> observed, for all the stars in one call each
ri, di = erfa.atciq(rc, dc, pr, pd, px, rv, astrom)
aob, zob, hob, dob, rob = erfa.atioq(ri, di, astrom)

print(f"{'star':<10} {'azimuth':>10} {'altitude':>10}")
for name, az, zd in zip(names, aob, zob):
    print(f"{name:<10} {az * DR2D % 360:10.4f} {90 - zd * DR2D:10.4f}")
`}function Y({obs:a,time:e,eop:t,site:r}){const o=a.type==="A",l=a.type==="A"?["angle","angle"]:["angleRA","angle"],h={A:["azimuth","altitude above the horizon"],H:["hour angle","declination"],R:["observed right ascension","observed declination"]}[a.type],u=o?`${s("alt",i("angle",a.c2),`${h[1]} (rad); ${c("angle",a.c2)}`)}
ob2 = math.pi / 2 - alt  # atoc13 wants the zenith distance`:s("ob2",i("angle",a.c2),`${h[1]} (rad); ${c("angle",a.c2)}`),d={A:["aob","zob"],H:["hob","dob"],R:["rob","dob"]}[a.type],v={A:["azimuth","zenith distance"],H:["hour angle","declination"],R:["right ascension","declination"]}[a.type];return`${y("Observed to ICRS","Run the forward conversion backwards with atoc13 (and atoi13), then check the result with a round trip through atco13.")}
# Observed position: type "A" = azimuth/zenith distance, "H" = hour angle/declination, "R" = RA/Dec
obs_type = "${a.type}"
${s("ob1",i(l[0],a.c1),`${h[0]} (rad); ${c(l[0],a.c1)}`)}
${u}

${x(e,!1)}
${w(t)}
${$(r)}
# Observed place -> ICRS (astrometric: no proper motion or parallax)
rc, dc = erfa.atoc13(obs_type, ob1, ob2, utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
print(f"ICRS right ascension: {rc % (2 * math.pi) * DR2D}")
print(f"ICRS declination    : {dc * DR2D}")

# Observed place -> CIRS (the intermediate frame)
ri, di = erfa.atoi13(obs_type, ob1, ob2, utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
print(f"CIRS right ascension: {ri % (2 * math.pi) * DR2D}")
print(f"CIRS declination    : {di * DR2D}")

# Round trip: go forward again (no proper motion, parallax or radial velocity)
aob, zob, hob, dob, rob, eo = erfa.atco13(rc, dc, 0.0, 0.0, 0.0, 0.0, utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
print("Round trip differences (arcsec):")
print(f"  ${v[0]}: {math.remainder(${d[0]} - ob1, 2 * math.pi) * DR2D * 3600:.6f}")
print(f"  ${v[1]}: {(${d[1]} - ob2) * DR2D * 3600:.6f}")
`}function z(a,e){const t=URL.createObjectURL(new Blob([e],{type:"text/x-python;charset=utf-8"})),r=document.createElement("a");r.href=t,r.download=a,document.body.appendChild(r),r.click(),r.remove(),setTimeout(()=>URL.revokeObjectURL(t),1e3)}function V({ready:a,filename:e,build:t}){const r=a?t():"";return n.jsxs("section",{className:`card ${a?"step-done":"step-locked"}`,id:"python",children:[n.jsxs("header",{className:"card-head",children:[n.jsx("span",{className:"badge","aria-hidden":!0,children:"↓"}),n.jsx("h2",{children:"Download this example as Python"}),n.jsx("span",{className:`chip ${a?"done":"idle"}`,children:a?"Ready":"Submit all steps first"})]}),n.jsxs("p",{className:"intro",children:["A standalone script that does the same calculation with your inputs, using the"," ",n.jsx("a",{href:"https://pyerfa.readthedocs.io",target:"_blank",rel:"noreferrer",children:"pyerfa"})," library (",n.jsx("code",{children:"pip install pyerfa"}),"). Run it with ",n.jsxs("code",{children:["python ",e]}),". The Earth orientation values are those fetched from the IERS above, written into the script."]}),n.jsxs("div",{className:"actions",children:[n.jsxs("button",{className:"btn",type:"button",disabled:!a,onClick:()=>z(e,r),children:["Download ",e]}),!a&&n.jsx("span",{className:"warn",children:"Submit every step of the example to enable the download."})]}),a&&n.jsxs("details",{className:"args",children:[n.jsx("summary",{children:"Preview the script"}),n.jsx("pre",{className:"code",children:r})]})]})}const E="https://astroapirepo.vercel.app";async function f(a,e){let t;try{t=await fetch(`${E}${a}`,{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify(e)})}catch{throw new Error("Could not reach the SOFA API. Check your connection and try again.")}const r=await t.json().catch(()=>null);if(!t.ok){const o=r==null?void 0:r.detail,l=Array.isArray(o)?o.map(h=>h.msg).join("; "):o||t.statusText;throw new Error(`API error ${t.status}: ${l}`)}return r}const Q=(a,e,t,r,o,l,h)=>f("/time/dtf2d",{scale:a,iy:e,im:t,id:r,ihr:o,imn:l,sec:h}).then(u=>u.result),W=(a,e)=>f("/time/utctai",{utc1:a,utc2:e}).then(t=>t.result),X=(a,e)=>f("/time/taitt",{tai1:a,tai2:e}).then(t=>t.result),Z=(a,e=1)=>f("/eop/get_eop",{t:a,kind:e}),aa=a=>f("/astrometry/atco13",a).then(e=>e.result),p=(a,e)=>f(a,e).then(t=>t.result),ea=(a,e)=>p("/earth/pnm06a",{date1:a,date2:e}),ta=a=>p("/earth/bpn2xy",{rbpn:a}),ra=(a,e,t,r)=>p("/earth/s06",{date1:a,date2:e,x:t,y:r}),na=(a,e,t)=>p("/earth/c2ixys",{x:a,y:e,s:t}),oa=(a,e)=>p("/astrometry/epv00",{date1:a,date2:e}),sa=a=>p("/matrix/pn",{p:a}),ia=(a,e)=>p("/matrix/sxp",{s:a,p:e}),ca=(a,e)=>p("/matrix/rxp",{r:a,p:e}),la=a=>p("/matrix/c2s",{p:a}),da=a=>p("/matrix/anp",{a}),pa=a=>p("/astrometry/pmpx",a),ha=(a,e,t)=>p("/astrometry/ldsun",{p:a,e,em:t}),ma=(a,e,t,r)=>p("/astrometry/ab",{pnat:a,v:e,s:t,bm1:r}),ua=a=>p("/astrometry/atio13",a),fa=a=>p("/astrometry/apco13",a),va=a=>p("/astrometry/atciq",a),ba=a=>p("/astrometry/atioq",a),ya=a=>p("/astrometry/atoc13",a),xa=a=>p("/astrometry/atoi13",a);function $a(a,e=15){if(!Number.isFinite(a))return"—";if(a===0)return"0";const t=Math.abs(a);return t<1e-4||t>=1e9?a.toExponential(e-6):String(Number(a.toPrecision(e)))}const b=(a,e=2)=>String(a).padStart(e,"0");function ga(a){const e=a<0?"−":"+";let t=Math.abs(a),r=Math.floor(t),o=Math.floor((t-r)*60),l=((t-r)*60-o)*60;return l>=59.995&&(l=0,o+=1),o>=60&&(o=0,r+=1),`${e}${b(r)}° ${b(o)}′ ${l.toFixed(2).padStart(5,"0")}″`}function Ra(a){const e=a<0?"−":"";let t=Math.abs(a),r=Math.floor(t),o=Math.floor((t-r)*60),l=((t-r)*60-o)*60;return l>=59.995&&(l=0,o+=1),o>=60&&(o=0,r+=1),`${e}${b(r)}ʰ ${b(o)}ᵐ ${l.toFixed(2).padStart(5,"0")}ˢ`}const Da=a=>a*N,wa=a=>(a%360+360)%360;function Sa(a){const e=/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})(?::(\d{2}(?:\.\d+)?))?$/.exec(a||"");return e?{iy:+e[1],im:+e[2],id:+e[3],ihr:+e[4],imn:+e[5],sec:e[6]?+e[6]:0}:null}export{_ as A,O as B,la as C,N as D,F as E,U as F,da as G,ua as H,D as I,G as J,fa as K,va as L,q as M,ba as N,Y as O,V as P,ya as Q,xa as R,T as S,L as U,B as V,ga as a,X as b,H as c,Q as d,R as e,$a as f,Z as g,aa as h,J as i,K as j,ea as k,ta as l,na as m,oa as n,sa as o,Sa as p,ia as q,Da as r,ra as s,Ra as t,W as u,pa as v,wa as w,ha as x,ma as y,ca as z};
