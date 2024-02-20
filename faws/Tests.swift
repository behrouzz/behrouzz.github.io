import Foundation
import FAWS

let verbose = false

let faws = Faws()

// Validate an integer result
func viv(_ ival: Int, _ ivalok: Int, _ fn: String, _ test: String) {
    // Given:
    //    ival   : value computed by function under test
    //    ivalok : correct value
    //    fn     : name of function under test
    //    test   : name of individual test
    
    if ival != ivalok {
        print("\(fn) failed: \(test) want \(ivalok) got \(ival)")
    } else if verbose {
        print("\(fn) passed: \(test) want \(ivalok) got \(ival)")
    }
}

// Validate a Double result
func vvd(_ val: Double, _ valok: Double, _ dval: Double, _ fn: String, _ test: String) {
    // Given:
    //    val   : value computed by function under test
    //    valok : expected value
    //    dval  : maximum allowable error
    //    fn    : name of function under test
    //    test   : name of individual test
    
    var a, f: Double   // absolute and fractional error
    a = val - valok
    if (a != 0.0 && fabs(a) > fabs(dval)) {
        f = fabs(valok / a)
        print("\(fn) failed: \(test) want \(valok) got \(val) : \(f)")
    } else if verbose {
        print("\(fn) passed: \(test) want \(valok) got \(val)")
    }
}


func t_a2af() {
    let (_, idmsf) = faws.a2af(4, 2.345)
    //viv(s, '+', "a2af", "s")
    viv(idmsf[0],  134, "a2af", "0")
    viv(idmsf[1],   21, "a2af", "1")
    viv(idmsf[2],   30, "a2af", "2")
    viv(idmsf[3], 9706, "a2af", "3")
}

func t_a2tf() {
    let (_, ihmsf) = faws.a2tf(4, -3.01234)
    //viv((int)s, '-', "a2tf", "s")
    viv(ihmsf[0],   11, "a2tf", "0")
    viv(ihmsf[1],   30, "a2tf", "1")
    viv(ihmsf[2],   22, "a2tf", "2")
    viv(ihmsf[3], 6484, "a2tf", "3")
}

func t_ab() {
    let pnat = [-0.76321968546737951, -0.60869453983060384, -0.21676408580639883]
    let v = [2.1044018893653786e-5, -8.9108923304429319e-5, -3.8633714797716569e-5]
    let s = 0.99980921395708788
    let bm1 = 0.99999999506209258
    let ppr = faws.ab(pnat, v, s, bm1)
    vvd(ppr[0], -0.7631631094219556269, 1e-12, "ab", "1")
    vvd(ppr[1], -0.6087553082505590832, 1e-12, "ab", "2")
    vvd(ppr[2], -0.2167926269368471279, 1e-12, "ab", "3")
}

func t_ae2hd() {
    let a = 5.5
    let e = 1.1
    let p = 0.7
    let (h, d) = faws.ae2hd(a, e, p)
    vvd(h, 0.5933291115507309663, 1e-14, "ae2hd", "h")
    vvd(d, 0.9613934761647817620, 1e-14, "ae2hd", "d")
}

func t_af2a() {
    let a = faws.af2a("-", 45, 13, 27.2)
    vvd(a, -0.7893115794313644842, 1e-12, "af2a", "a")
}

func t_anp() {
    vvd(faws.anp(-0.1), 6.183185307179586477, 1e-12, "anp", "")
}

func t_anpm() {
    vvd(faws.anpm(-4.0), 2.283185307179586477, 1e-12, "anpm", "")
}

func t_apcg() {
    var ebpv = faws.zpv()
    var ehp = faws.zp()
    let date1 = 2456165.5
    let date2 = 0.401182685
    ebpv[0][0] =  0.901310875
    ebpv[0][1] = -0.417402664
    ebpv[0][2] = -0.180982288
    ebpv[1][0] =  0.00742727954
    ebpv[1][1] =  0.0140507459
    ebpv[1][2] =  0.00609045792
    ehp[0] =  0.903358544
    ehp[1] = -0.415395237
    ehp[2] = -0.180084014
    let astrom = faws.apcg(date1, date2, ebpv, ehp)
    vvd(astrom.pmt, 12.65133794027378508, 1e-11, "apcg", "pmt")
    vvd(astrom.eb[0], 0.901310875, 1e-12, "apcg", "eb(1)")
    vvd(astrom.eb[1], -0.417402664, 1e-12, "apcg", "eb(2)")
    vvd(astrom.eb[2], -0.180982288, 1e-12, "apcg", "eb(3)")
    vvd(astrom.eh[0], 0.8940025429324143045, 1e-12, "apcg", "eh(1)")
    vvd(astrom.eh[1], -0.4110930268679817955, 1e-12, "apcg", "eh(2)")
    vvd(astrom.eh[2], -0.1782189004872870264, 1e-12, "apcg", "eh(3)")
    vvd(astrom.em, 1.010465295811013146, 1e-12, "apcg", "em")
    vvd(astrom.v[0], 0.4289638913597693554e-4, 1e-16, "apcg", "v(1)")
    vvd(astrom.v[1], 0.8115034051581320575e-4, 1e-16, "apcg", "v(2)")
    vvd(astrom.v[2], 0.3517555136380563427e-4, 1e-16, "apcg", "v(3)")
    vvd(astrom.bm1, 0.9999999951686012981, 1e-12, "apcg", "bm1")
    vvd(astrom.bpn[0][0], 1.0, 0.0, "apcg", "bpn(1,1)")
    vvd(astrom.bpn[1][0], 0.0, 0.0, "apcg", "bpn(2,1)")
    vvd(astrom.bpn[2][0], 0.0, 0.0, "apcg", "bpn(3,1)")
    vvd(astrom.bpn[0][1], 0.0, 0.0, "apcg", "bpn(1,2)")
    vvd(astrom.bpn[1][1], 1.0, 0.0, "apcg", "bpn(2,2)")
    vvd(astrom.bpn[2][1], 0.0, 0.0, "apcg", "bpn(3,2)")
    vvd(astrom.bpn[0][2], 0.0, 0.0, "apcg", "bpn(1,3)")
    vvd(astrom.bpn[1][2], 0.0, 0.0, "apcg", "bpn(2,3)")
    vvd(astrom.bpn[2][2], 1.0, 0.0, "apcg", "bpn(3,3)")
}

func t_apcg13() {
    let date1 = 2456165.5
    let date2 = 0.401182685
    let astrom = faws.apcg13(date1, date2)
    vvd(astrom.pmt, 12.65133794027378508, 1e-11, "apcg13", "pmt")
    vvd(astrom.eb[0], 0.9013108747340644755, 1e-12, "apcg13", "eb(1)")
    vvd(astrom.eb[1], -0.4174026640406119957, 1e-12, "apcg13", "eb(2)")
    vvd(astrom.eb[2], -0.1809822877867817771, 1e-12, "apcg13", "eb(3)")
    vvd(astrom.eh[0], 0.8940025429255499549, 1e-12, "apcg13", "eh(1)")
    vvd(astrom.eh[1], -0.4110930268331896318, 1e-12, "apcg13", "eh(2)")
    vvd(astrom.eh[2], -0.1782189006019749850, 1e-12, "apcg13", "eh(3)")
    vvd(astrom.em, 1.010465295964664178, 1e-12, "apcg13", "em")
    vvd(astrom.v[0], 0.4289638912941341125e-4, 1e-16, "apcg13", "v(1)")
    vvd(astrom.v[1], 0.8115034032405042132e-4, 1e-16, "apcg13", "v(2)")
    vvd(astrom.v[2], 0.3517555135536470279e-4, 1e-16, "apcg13", "v(3)")
    vvd(astrom.bm1, 0.9999999951686013142, 1e-12, "apcg13", "bm1")
    vvd(astrom.bpn[0][0], 1.0, 0.0, "apcg13", "bpn(1,1)")
    vvd(astrom.bpn[1][0], 0.0, 0.0, "apcg13", "bpn(2,1)")
    vvd(astrom.bpn[2][0], 0.0, 0.0, "apcg13", "bpn(3,1)")
    vvd(astrom.bpn[0][1], 0.0, 0.0, "apcg13", "bpn(1,2)")
    vvd(astrom.bpn[1][1], 1.0, 0.0, "apcg13", "bpn(2,2)")
    vvd(astrom.bpn[2][1], 0.0, 0.0, "apcg13", "bpn(3,2)")
    vvd(astrom.bpn[0][2], 0.0, 0.0, "apcg13", "bpn(1,3)")
    vvd(astrom.bpn[1][2], 0.0, 0.0, "apcg13", "bpn(2,3)")
    vvd(astrom.bpn[2][2], 1.0, 0.0, "apcg13", "bpn(3,3)")
}

func t_apci() {
    var ebpv = faws.zpv()
    var ehp = faws.zp()
    let date1 = 2456165.5
    let date2 = 0.401182685
    ebpv[0][0] =  0.901310875
    ebpv[0][1] = -0.417402664
    ebpv[0][2] = -0.180982288
    ebpv[1][0] =  0.00742727954
    ebpv[1][1] =  0.0140507459
    ebpv[1][2] =  0.00609045792
    ehp[0] =  0.903358544
    ehp[1] = -0.415395237
    ehp[2] = -0.180084014
    let x =  0.0013122272
    let y = -2.92808623e-5
    let s =  3.05749468e-8
    let astrom = faws.apci(date1, date2, ebpv, ehp, x, y, s)
    vvd(astrom.pmt, 12.65133794027378508, 1e-11, "apci", "pmt")
    vvd(astrom.eb[0], 0.901310875, 1e-12, "apci", "eb(1)")
    vvd(astrom.eb[1], -0.417402664, 1e-12, "apci", "eb(2)")
    vvd(astrom.eb[2], -0.180982288, 1e-12, "apci", "eb(3)")
    vvd(astrom.eh[0], 0.8940025429324143045, 1e-12, "apci", "eh(1)")
    vvd(astrom.eh[1], -0.4110930268679817955, 1e-12, "apci", "eh(2)")
    vvd(astrom.eh[2], -0.1782189004872870264, 1e-12, "apci", "eh(3)")
    vvd(astrom.em, 1.010465295811013146, 1e-12, "apci", "em")
    vvd(astrom.v[0], 0.4289638913597693554e-4, 1e-16, "apci", "v(1)")
    vvd(astrom.v[1], 0.8115034051581320575e-4, 1e-16, "apci", "v(2)")
    vvd(astrom.v[2], 0.3517555136380563427e-4, 1e-16, "apci", "v(3)")
    vvd(astrom.bm1, 0.9999999951686012981, 1e-12, "apci", "bm1")
    vvd(astrom.bpn[0][0], 0.9999991390295159156, 1e-12, "apci", "bpn(1,1)")
    vvd(astrom.bpn[1][0], 0.4978650072505016932e-7, 1e-12, "apci", "bpn(2,1)")
    vvd(astrom.bpn[2][0], 0.1312227200000000000e-2, 1e-12, "apci", "bpn(3,1)")
    vvd(astrom.bpn[0][1], -0.1136336653771609630e-7, 1e-12, "apci", "bpn(1,2)")
    vvd(astrom.bpn[1][1], 0.9999999995713154868, 1e-12, "apci", "bpn(2,2)")
    vvd(astrom.bpn[2][1], -0.2928086230000000000e-4, 1e-12, "apci", "bpn(3,2)")
    vvd(astrom.bpn[0][2], -0.1312227200895260194e-2, 1e-12, "apci", "bpn(1,3)")
    vvd(astrom.bpn[1][2], 0.2928082217872315680e-4, 1e-12, "apci", "bpn(2,3)")
    vvd(astrom.bpn[2][2], 0.9999991386008323373, 1e-12, "apci", "bpn(3,3)")
}

func t_apci13() {
    let date1 = 2456165.5
    let date2 = 0.401182685
    let (astrom, eo) = faws.apci13(date1, date2)
    vvd(astrom.pmt, 12.65133794027378508, 1e-11, "apci13", "pmt")
    vvd(astrom.eb[0], 0.9013108747340644755, 1e-12, "apci13", "eb(1)")
    vvd(astrom.eb[1], -0.4174026640406119957, 1e-12, "apci13", "eb(2)")
    vvd(astrom.eb[2], -0.1809822877867817771, 1e-12, "apci13", "eb(3)")
    vvd(astrom.eh[0], 0.8940025429255499549, 1e-12, "apci13", "eh(1)")
    vvd(astrom.eh[1], -0.4110930268331896318, 1e-12, "apci13", "eh(2)")
    vvd(astrom.eh[2], -0.1782189006019749850, 1e-12, "apci13", "eh(3)")
    vvd(astrom.em, 1.010465295964664178, 1e-12, "apci13", "em")
    vvd(astrom.v[0], 0.4289638912941341125e-4, 1e-16, "apci13", "v(1)")
    vvd(astrom.v[1], 0.8115034032405042132e-4, 1e-16, "apci13", "v(2)")
    vvd(astrom.v[2], 0.3517555135536470279e-4, 1e-16, "apci13", "v(3)")
    vvd(astrom.bm1, 0.9999999951686013142, 1e-12, "apci13", "bm1")
    vvd(astrom.bpn[0][0], 0.9999992060376761710, 1e-12, "apci13", "bpn(1,1)")
    vvd(astrom.bpn[1][0], 0.4124244860106037157e-7, 1e-12, "apci13", "bpn(2,1)")
    vvd(astrom.bpn[2][0], 0.1260128571051709670e-2, 1e-12, "apci13", "bpn(3,1)")
    vvd(astrom.bpn[0][1], -0.1282291987222130690e-7, 1e-12, "apci13", "bpn(1,2)")
    vvd(astrom.bpn[1][1], 0.9999999997456835325, 1e-12, "apci13", "bpn(2,2)")
    vvd(astrom.bpn[2][1], -0.2255288829420524935e-4, 1e-12, "apci13", "bpn(3,2)")
    vvd(astrom.bpn[0][2], -0.1260128571661374559e-2, 1e-12, "apci13", "bpn(1,3)")
    vvd(astrom.bpn[1][2], 0.2255285422953395494e-4, 1e-12, "apci13", "bpn(2,3)")
    vvd(astrom.bpn[2][2], 0.9999992057833604343, 1e-12, "apci13", "bpn(3,3)")
    vvd(eo, -0.2900618712657375647e-2, 1e-12, "apci13", "eo")
}

func t_apco() {
    var ebpv = faws.zpv()
    var ehp = faws.zp()
    let date1 = 2456384.5
    let date2 = 0.970031644
    ebpv[0][0] = -0.974170438
    ebpv[0][1] = -0.211520082
    ebpv[0][2] = -0.0917583024
    ebpv[1][0] = 0.00364365824
    ebpv[1][1] = -0.0154287319
    ebpv[1][2] = -0.00668922024
    ehp[0] = -0.973458265
    ehp[1] = -0.209215307
    ehp[2] = -0.0906996477
    let x = 0.0013122272
    let y = -2.92808623e-5
    let s = 3.05749468e-8
    let theta = 3.14540971
    let elong = -0.527800806
    let phi = -1.2345856
    let hm = 2738.0
    let xp = 2.47230737e-7
    let yp = 1.82640464e-6
    let sp = -3.01974337e-11
    let refa = 0.000201418779
    let refb = -2.36140831e-7
    let astrom = faws.apco(date1, date2, ebpv, ehp, x, y, s, theta, elong, phi, hm, xp, yp, sp, refa, refb)
    vvd(astrom.pmt, 13.25248468622587269, 1e-11, "apco", "pmt")
    vvd(astrom.eb[0], -0.9741827110630322720, 1e-12, "apco", "eb(1)")
    vvd(astrom.eb[1], -0.2115130190135344832, 1e-12, "apco", "eb(2)")
    vvd(astrom.eb[2], -0.09179840186949532298, 1e-12, "apco", "eb(3)")
    vvd(astrom.eh[0], -0.9736425571689739035, 1e-12, "apco", "eh(1)")
    vvd(astrom.eh[1], -0.2092452125849330936, 1e-12, "apco", "eh(2)")
    vvd(astrom.eh[2], -0.09075578152243272599, 1e-12, "apco", "eh(3)")
    vvd(astrom.em, 0.9998233241709957653, 1e-12, "apco", "em")
    vvd(astrom.v[0], 0.2078704992916728762e-4, 1e-16, "apco", "v(1)")
    vvd(astrom.v[1], -0.8955360107151952319e-4, 1e-16, "apco", "v(2)")
    vvd(astrom.v[2], -0.3863338994288951082e-4, 1e-16, "apco", "v(3)")
    vvd(astrom.bm1, 0.9999999950277561236, 1e-12, "apco", "bm1")
    vvd(astrom.bpn[0][0], 0.9999991390295159156, 1e-12, "apco", "bpn(1,1)")
    vvd(astrom.bpn[1][0], 0.4978650072505016932e-7, 1e-12, "apco", "bpn(2,1)")
    vvd(astrom.bpn[2][0], 0.1312227200000000000e-2, 1e-12, "apco", "bpn(3,1)")
    vvd(astrom.bpn[0][1], -0.1136336653771609630e-7, 1e-12, "apco", "bpn(1,2)")
    vvd(astrom.bpn[1][1], 0.9999999995713154868, 1e-12, "apco", "bpn(2,2)")
    vvd(astrom.bpn[2][1], -0.2928086230000000000e-4, 1e-12, "apco", "bpn(3,2)")
    vvd(astrom.bpn[0][2], -0.1312227200895260194e-2, 1e-12, "apco", "bpn(1,3)")
    vvd(astrom.bpn[1][2], 0.2928082217872315680e-4, 1e-12, "apco", "bpn(2,3)")
    vvd(astrom.bpn[2][2], 0.9999991386008323373, 1e-12, "apco", "bpn(3,3)")
    vvd(astrom.along, -0.5278008060295995734, 1e-12, "apco", "along")
    vvd(astrom.xpl, 0.1133427418130752958e-5, 1e-17, "apco", "xpl")
    vvd(astrom.ypl, 0.1453347595780646207e-5, 1e-17, "apco", "ypl")
    vvd(astrom.sphi, -0.9440115679003211329, 1e-12, "apco", "sphi")
    vvd(astrom.cphi, 0.3299123514971474711, 1e-12, "apco", "cphi")
    vvd(astrom.diurab, 0, 0, "apco", "diurab")
    vvd(astrom.eral, 2.617608903970400427, 1e-12, "apco", "eral")
    vvd(astrom.refa, 0.2014187790000000000e-3, 1e-15, "apco", "refa")
    vvd(astrom.refb, -0.2361408310000000000e-6, 1e-18, "apco", "refb")
}

func t_apco13() {
    let utc1 = 2456384.5
    let utc2 = 0.969254051
    let dut1 = 0.1550675
    let elong = -0.527800806
    let phi = -1.2345856
    let hm = 2738.0
    let xp = 2.47230737e-7
    let yp = 1.82640464e-6
    let phpa = 731.0
    let tc = 12.8
    let rh = 0.59
    let wl = 0.55
    let (astrom, eo) = faws.apco13(utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
    vvd(astrom.pmt, 13.25248468622475727, 1e-11, "apco13", "pmt")
    vvd(astrom.eb[0], -0.9741827107320875162, 1e-12, "apco13", "eb(1)")
    vvd(astrom.eb[1], -0.2115130190489716682, 1e-12, "apco13", "eb(2)")
    vvd(astrom.eb[2], -0.09179840189496755339, 1e-12, "apco13", "eb(3)")
    vvd(astrom.eh[0], -0.9736425572586935247, 1e-12, "apco13", "eh(1)")
    vvd(astrom.eh[1], -0.2092452121603336166, 1e-12, "apco13", "eh(2)")
    vvd(astrom.eh[2], -0.09075578153885665295, 1e-12, "apco13", "eh(3)")
    vvd(astrom.em, 0.9998233240913898141, 1e-12, "apco13", "em")
    vvd(astrom.v[0], 0.2078704994520489246e-4, 1e-16, "apco13", "v(1)")
    vvd(astrom.v[1], -0.8955360133238868938e-4, 1e-16, "apco13", "v(2)")
    vvd(astrom.v[2], -0.3863338993055887398e-4, 1e-16, "apco13", "v(3)")
    vvd(astrom.bm1, 0.9999999950277561004, 1e-12, "apco13", "bm1")
    vvd(astrom.bpn[0][0], 0.9999991390295147999, 1e-12, "apco13", "bpn(1,1)")
    vvd(astrom.bpn[1][0], 0.4978650075315529277e-7, 1e-12, "apco13", "bpn(2,1)")
    vvd(astrom.bpn[2][0], 0.001312227200850293372, 1e-12, "apco13", "bpn(3,1)")
    vvd(astrom.bpn[0][1], -0.1136336652812486604e-7, 1e-12, "apco13", "bpn(1,2)")
    vvd(astrom.bpn[1][1], 0.9999999995713154865, 1e-12, "apco13", "bpn(2,2)")
    vvd(astrom.bpn[2][1], -0.2928086230975367296e-4, 1e-12, "apco13", "bpn(3,2)")
    vvd(astrom.bpn[0][2], -0.001312227201745553566, 1e-12, "apco13", "bpn(1,3)")
    vvd(astrom.bpn[1][2], 0.2928082218847679162e-4, 1e-12, "apco13", "bpn(2,3)")
    vvd(astrom.bpn[2][2], 0.9999991386008312212, 1e-12, "apco13", "bpn(3,3)")
    vvd(astrom.along, -0.5278008060295995733, 1e-12, "apco13", "along")
    vvd(astrom.xpl, 0.1133427418130752958e-5, 1e-17, "apco13", "xpl")
    vvd(astrom.ypl, 0.1453347595780646207e-5, 1e-17, "apco13", "ypl")
    vvd(astrom.sphi, -0.9440115679003211329, 1e-12, "apco13", "sphi")
    vvd(astrom.cphi, 0.3299123514971474711, 1e-12, "apco13", "cphi")
    vvd(astrom.diurab, 0, 0, "apco13", "diurab")
    vvd(astrom.eral, 2.617608909189664000, 1e-12, "apco13", "eral")
    vvd(astrom.refa, 0.2014187785940396921e-3, 1e-15, "apco13", "refa")
    vvd(astrom.refb, -0.2361408314943696227e-6, 1e-18, "apco13", "refb")
    vvd(eo, -0.003020548354802412839, 1e-14, "apco13", "eo")
}

func t_apcs() {
    var pv = faws.zpv()
    var ebpv = faws.zpv()
    var ehp = faws.zp()
    let date1 = 2456384.5
    let date2 = 0.970031644
    pv[0][0] = -1836024.09
    pv[0][1] = 1056607.72
    pv[0][2] = -5998795.26
    pv[1][0] = -77.0361767
    pv[1][1] = -133.310856
    pv[1][2] = 0.0971855934
    ebpv[0][0] = -0.974170438
    ebpv[0][1] = -0.211520082
    ebpv[0][2] = -0.0917583024
    ebpv[1][0] = 0.00364365824
    ebpv[1][1] = -0.0154287319
    ebpv[1][2] = -0.00668922024
    ehp[0] = -0.973458265
    ehp[1] = -0.209215307
    ehp[2] = -0.0906996477
    let astrom = faws.apcs(date1, date2, pv, ebpv, ehp)
    vvd(astrom.pmt, 13.25248468622587269, 1e-11, "apcs", "pmt")
    vvd(astrom.eb[0], -0.9741827110629881886, 1e-12, "apcs", "eb(1)")
    vvd(astrom.eb[1], -0.2115130190136415986, 1e-12, "apcs", "eb(2)")
    vvd(astrom.eb[2], -0.09179840186954412099, 1e-12, "apcs", "eb(3)")
    vvd(astrom.eh[0], -0.9736425571689454706, 1e-12, "apcs", "eh(1)")
    vvd(astrom.eh[1], -0.2092452125850435930, 1e-12, "apcs", "eh(2)")
    vvd(astrom.eh[2], -0.09075578152248299218, 1e-12, "apcs", "eh(3)")
    vvd(astrom.em, 0.9998233241709796859, 1e-12, "apcs", "em")
    vvd(astrom.v[0], 0.2078704993282685510e-4, 1e-16, "apcs", "v(1)")
    vvd(astrom.v[1], -0.8955360106989405683e-4, 1e-16, "apcs", "v(2)")
    vvd(astrom.v[2], -0.3863338994289409097e-4, 1e-16, "apcs", "v(3)")
    vvd(astrom.bm1, 0.9999999950277561237, 1e-12, "apcs", "bm1")
    vvd(astrom.bpn[0][0], 1, 0, "apcs", "bpn(1,1)")
    vvd(astrom.bpn[1][0], 0, 0, "apcs", "bpn(2,1)")
    vvd(astrom.bpn[2][0], 0, 0, "apcs", "bpn(3,1)")
    vvd(astrom.bpn[0][1], 0, 0, "apcs", "bpn(1,2)")
    vvd(astrom.bpn[1][1], 1, 0, "apcs", "bpn(2,2)")
    vvd(astrom.bpn[2][1], 0, 0, "apcs", "bpn(3,2)")
    vvd(astrom.bpn[0][2], 0, 0, "apcs", "bpn(1,3)")
    vvd(astrom.bpn[1][2], 0, 0, "apcs", "bpn(2,3)")
    vvd(astrom.bpn[2][2], 1, 0, "apcs", "bpn(3,3)")
}

func t_apcs13() {
    var pv = faws.zpv()
    let date1 = 2456165.5
    let date2 = 0.401182685
    pv[0][0] = -6241497.16
    pv[0][1] = 401346.896
    pv[0][2] = -1251136.04
    pv[1][0] = -29.264597
    pv[1][1] = -455.021831
    pv[1][2] = 0.0266151194
    let astrom = faws.apcs13(date1, date2, pv)
    vvd(astrom.pmt, 12.65133794027378508, 1e-11, "apcs13", "pmt")
    vvd(astrom.eb[0], 0.9012691529025250644, 1e-12, "apcs13", "eb(1)")
    vvd(astrom.eb[1], -0.4173999812023194317, 1e-12, "apcs13", "eb(2)")
    vvd(astrom.eb[2], -0.1809906511146429670, 1e-12, "apcs13", "eb(3)")
    vvd(astrom.eh[0], 0.8939939101760130792, 1e-12, "apcs13", "eh(1)")
    vvd(astrom.eh[1], -0.4111053891734021478, 1e-12, "apcs13", "eh(2)")
    vvd(astrom.eh[2], -0.1782336880636997374, 1e-12, "apcs13", "eh(3)")
    vvd(astrom.em, 1.010428384373491095, 1e-12, "apcs13", "em")
    vvd(astrom.v[0], 0.4279877294121697570e-4, 1e-16, "apcs13", "v(1)")
    vvd(astrom.v[1], 0.7963255087052120678e-4, 1e-16, "apcs13", "v(2)")
    vvd(astrom.v[2], 0.3517564013384691531e-4, 1e-16, "apcs13", "v(3)")
    vvd(astrom.bm1, 0.9999999952947980978, 1e-12, "apcs13", "bm1")
    vvd(astrom.bpn[0][0], 1, 0, "apcs13", "bpn(1,1)")
    vvd(astrom.bpn[1][0], 0, 0, "apcs13", "bpn(2,1)")
    vvd(astrom.bpn[2][0], 0, 0, "apcs13", "bpn(3,1)")
    vvd(astrom.bpn[0][1], 0, 0, "apcs13", "bpn(1,2)")
    vvd(astrom.bpn[1][1], 1, 0, "apcs13", "bpn(2,2)")
    vvd(astrom.bpn[2][1], 0, 0, "apcs13", "bpn(3,2)")
    vvd(astrom.bpn[0][2], 0, 0, "apcs13", "bpn(1,3)")
    vvd(astrom.bpn[1][2], 0, 0, "apcs13", "bpn(2,3)")
    vvd(astrom.bpn[2][2], 1, 0, "apcs13", "bpn(3,3)")
}

func t_aper() {
    var astrom = ASTROM()
    astrom.along = 1.234
    let theta = 5.678
    astrom = faws.aper(theta, astrom)
    vvd(astrom.eral, 6.912000000000000000, 1e-12, "aper", "pmt")
}

func t_aper13() {
    var astrom = ASTROM()
    astrom.along = 1.234
    let ut11 = 2456165.5
    let ut12 = 0.401182685
    astrom = faws.aper13(ut11, ut12, astrom)
    vvd(astrom.eral, 3.316236661789694933, 1e-12, "aper13", "pmt")
}

func t_apio() {
    let sp = -3.01974337e-11
    let theta = 3.14540971
    let elong = -0.527800806
    let phi = -1.2345856
    let hm = 2738.0
    let xp = 2.47230737e-7
    let yp = 1.82640464e-6
    let refa = 0.000201418779
    let refb = -2.36140831e-7
    let astrom = faws.apio(sp, theta, elong, phi, hm, xp, yp, refa, refb)
    vvd(astrom.along, -0.5278008060295995734, 1e-12, "apio", "along")
    vvd(astrom.xpl, 0.1133427418130752958e-5, 1e-17, "apio", "xpl")
    vvd(astrom.ypl, 0.1453347595780646207e-5, 1e-17, "apio", "ypl")
    vvd(astrom.sphi, -0.9440115679003211329, 1e-12, "apio", "sphi")
    vvd(astrom.cphi, 0.3299123514971474711, 1e-12, "apio", "cphi")
    vvd(astrom.diurab, 0.5135843661699913529e-6, 1e-12, "apio", "diurab")
    vvd(astrom.eral, 2.617608903970400427, 1e-12, "apio", "eral")
    vvd(astrom.refa, 0.2014187790000000000e-3, 1e-15, "apio", "refa")
    vvd(astrom.refb, -0.2361408310000000000e-6, 1e-18, "apio", "refb")
}

func t_apio13() {
    let utc1 = 2456384.5
    let utc2 = 0.969254051
    let dut1 = 0.1550675
    let elong = -0.527800806
    let phi = -1.2345856
    let hm = 2738.0
    let xp = 2.47230737e-7
    let yp = 1.82640464e-6
    let phpa = 731.0
    let tc = 12.8
    let rh = 0.59
    let wl = 0.55
    let astrom = faws.apio13(utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
    vvd(astrom.along, -0.5278008060295995733, 1e-12, "apio13", "along")
    vvd(astrom.xpl, 0.1133427418130752958e-5, 1e-17, "apio13", "xpl")
    vvd(astrom.ypl, 0.1453347595780646207e-5, 1e-17, "apio13", "ypl")
    vvd(astrom.sphi, -0.9440115679003211329, 1e-12, "apio13", "sphi")
    vvd(astrom.cphi, 0.3299123514971474711, 1e-12, "apio13", "cphi")
    vvd(astrom.diurab, 0.5135843661699913529e-6, 1e-12, "apio13", "diurab")
    vvd(astrom.eral, 2.617608909189664000, 1e-12, "apio13", "eral")
    vvd(astrom.refa, 0.2014187785940396921e-3, 1e-15, "apio13", "refa")
    vvd(astrom.refb, -0.2361408314943696227e-6, 1e-18, "apio13", "refb")
}

func t_atcc13() {
    let rc = 2.71
    let dc = 0.174
    let pr = 1e-5
    let pd = 5e-6
    let px = 0.1
    let rv = 55.0
    let date1 = 2456165.5
    let date2 = 0.401182685
    let (ra, da) = faws.atcc13(rc, dc, pr, pd, px, rv, date1, date2)
    vvd(ra,  2.710126504531372384, 1e-12, "atcc13", "ra")
    vvd(da, 0.1740632537628350152, 1e-12, "atcc13", "da")
}

func t_atccq() {
    let date1 = 2456165.5
    let date2 = 0.401182685
    let (astrom, _) = faws.apci13(date1, date2)
    let rc = 2.71
    let dc = 0.174
    let pr = 1e-5
    let pd = 5e-6
    let px = 0.1
    let rv = 55.0
    let (ra, da) = faws.atccq(rc, dc, pr, pd, px, rv, astrom)
    vvd(ra, 2.710126504531372384, 1e-12, "atccq", "ra")
    vvd(da, 0.1740632537628350152, 1e-12, "atccq", "da")
}

func t_atci13() {
    let rc = 2.71
    let dc = 0.174
    let pr = 1e-5
    let pd = 5e-6
    let px = 0.1
    let rv = 55.0
    let date1 = 2456165.5
    let date2 = 0.401182685
    let (ri, di, eo) = faws.atci13(rc, dc, pr, pd, px, rv, date1, date2)
    vvd(ri, 2.710121572968696744, 1e-12, "atci13", "ri")
    vvd(di, 0.1729371367219539137, 1e-12, "atci13", "di")
    vvd(eo, -0.002900618712657375647, 1e-14, "atci13", "eo")
}

func t_atciq() {
    let date1 = 2456165.5
    let date2 = 0.401182685
    let (astrom, _) = faws.apci13(date1, date2)
    let rc = 2.71
    let dc = 0.174
    let pr = 1e-5
    let pd = 5e-6
    let px = 0.1
    let rv = 55.0
    let (ri, di) = faws.atciq(rc, dc, pr, pd, px, rv, astrom)
    vvd(ri, 2.710121572968696744, 1e-12, "atciq", "ri")
    vvd(di, 0.1729371367219539137, 1e-12, "atciq", "di")
}

func t_atciqn() {
    let date1 = 2456165.5
    let date2 = 0.401182685
    let (astrom, _) = faws.apci13(date1, date2)
    let rc = 2.71
    let dc = 0.174
    let pr = 1e-5
    let pd = 5e-6
    let px = 0.1
    let rv = 55.0
    
    let b0_bm = 0.00028574
    let b0_dl = 3e-10
    let b0_pv = [[-7.81014427, -5.60956681, -1.98079819], [0.0030723249, -0.00406995477, -0.00181335842]]
    var b0 = LDBODY()
    b0.bm = b0_bm
    b0.dl = b0_dl
    b0.pv = b0_pv
    
    let b1_bm = 0.00095435
    let b1_dl = 3e-9
    let b1_pv = [[0.738098796, 4.63658692, 1.9693136], [-0.00755816922, 0.00126913722, 0.000727999001]]
    var b1 = LDBODY()
    b1.bm = b1_bm
    b1.dl = b1_dl
    b1.pv = b1_pv
    
    let b2_bm = 1.0
    let b2_dl = 6e-6
    let b2_pv = [[-0.000712174377, -0.00230478303, -0.00105865966], [6.29235213e-6, -3.30888387e-7, -2.96486623e-7]]
    var b2 = LDBODY()
    b2.bm = b2_bm
    b2.dl = b2_dl
    b2.pv = b2_pv
    
    let b = [b0, b1, b2]
    
    let (ri, di) = faws.atciqn(rc, dc, pr, pd, px, rv, astrom, b)
    vvd(ri, 2.710122008104983335, 1e-12, "atciqn", "ri")
    vvd(di, 0.1729371916492767821, 1e-12, "atciqn", "di")
}

func t_atciqz() {
    let date1 = 2456165.5
    let date2 = 0.401182685
    let (astrom, _) = faws.apci13(date1, date2)
    let rc = 2.71
    let dc = 0.174
    let (ri, di) = faws.atciqz(rc, dc, astrom)
    vvd(ri, 2.709994899247256984, 1e-12, "atciqz", "ri")
    vvd(di, 0.1728740720984931891, 1e-12, "atciqz", "di")
}

func t_atco13() {
    let rc = 2.71
    let dc = 0.174
    let pr = 1e-5
    let pd = 5e-6
    let px = 0.1
    let rv = 55.0
    let utc1 = 2456384.5
    let utc2 = 0.969254051
    let dut1 = 0.1550675
    let elong = -0.527800806
    let phi = -1.2345856
    let hm = 2738.0
    let xp = 2.47230737e-7
    let yp = 1.82640464e-6
    let phpa = 731.0
    let tc = 12.8
    let rh = 0.59
    let wl = 0.55
    let (aob, zob, hob, dob, rob, eo) = faws.atco13(rc, dc, pr, pd, px, rv, utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
    vvd(aob, 0.9251774485485515207e-1, 1e-12, "atco13", "aob")
    vvd(zob, 1.407661405256499357, 1e-12, "atco13", "zob")
    vvd(hob, -0.9265154431529724692e-1, 1e-12, "atco13", "hob")
    vvd(dob, 0.1716626560072526200, 1e-12, "atco13", "dob")
    vvd(rob, 2.710260453504961012, 1e-12, "atco13", "rob")
    vvd(eo, -0.003020548354802412839, 1e-14, "atco13", "eo")
}

func t_atic13() {
    let ri = 2.710121572969038991
    let di = 0.1729371367218230438
    let date1 = 2456165.5
    let date2 = 0.401182685
    let (rc, dc, eo) = faws.atic13(ri, di, date1, date2)
    vvd(rc, 2.710126504531716819, 1e-12, "atic13", "rc")
    vvd(dc, 0.1740632537627034482, 1e-12, "atic13", "dc")
    vvd(eo, -0.002900618712657375647, 1e-14, "atic13", "eo")
}

func t_aticq() {
    let date1 = 2456165.5
    let date2 = 0.401182685
    let (astrom, _) = faws.apci13(date1, date2)
    let ri = 2.710121572969038991
    let di = 0.1729371367218230438
    let (rc, dc) = faws.aticq(ri, di, astrom)
    vvd(rc, 2.710126504531716819, 1e-12, "aticq", "rc")
    vvd(dc, 0.1740632537627034482, 1e-12, "aticq", "dc")
}

func t_aticqn() {
    let date1 = 2456165.5
    let date2 = 0.401182685
    let (astrom, _) = faws.apci13(date1, date2)
    let ri = 2.709994899247599271
    let di = 0.1728740720983623469
    
    let b0_bm = 0.00028574
    let b0_dl = 3e-10
    let b0_pv = [[-7.81014427, -5.60956681, -1.98079819], [0.0030723249, -0.00406995477, -0.00181335842]]
    var b0 = LDBODY()
    b0.bm = b0_bm
    b0.dl = b0_dl
    b0.pv = b0_pv
    let b1_bm = 0.00095435
    let b1_dl = 3e-9
    let b1_pv = [[0.738098796, 4.63658692, 1.9693136], [-0.00755816922, 0.00126913722, 0.000727999001]]
    var b1 = LDBODY()
    b1.bm = b1_bm
    b1.dl = b1_dl
    b1.pv = b1_pv
    let b2_bm = 1.0
    let b2_dl = 6e-6
    let b2_pv = [[-0.000712174377, -0.00230478303, -0.00105865966], [6.29235213e-6, -3.30888387e-7, -2.96486623e-7]]
    var b2 = LDBODY()
    b2.bm = b2_bm
    b2.dl = b2_dl
    b2.pv = b2_pv
    let b = [b0, b1, b2]
    
    let (rc, dc) = faws.aticqn(ri, di, astrom, b)
    vvd(rc, 2.709999575033027333, 1e-12, "atciqn", "rc")
    vvd(dc, 0.1739999656316469990, 1e-12, "atciqn", "dc")
}

func t_atio13() {
    let ri = 2.710121572969038991
    let di = 0.1729371367218230438
    let utc1 = 2456384.5
    let utc2 = 0.969254051
    let dut1 = 0.1550675
    let elong = -0.527800806
    let phi = -1.2345856
    let hm = 2738.0
    let xp = 2.47230737e-7
    let yp = 1.82640464e-6
    let phpa = 731.0
    let tc = 12.8
    let rh = 0.59
    let wl = 0.55
    let (aob, zob, hob, dob, rob) = faws.atio13(ri, di, utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
    vvd(aob, 0.9233952224895122499e-1, 1e-12, "atio13", "aob")
    vvd(zob, 1.407758704513549991, 1e-12, "atio13", "zob")
    vvd(hob, -0.9247619879881698140e-1, 1e-12, "atio13", "hob")
    vvd(dob, 0.1717653435756234676, 1e-12, "atio13", "dob")
    vvd(rob, 2.710085107988480746, 1e-12, "atio13", "rob")
}

func t_atioq() {
    let utc1 = 2456384.5
    let utc2 = 0.969254051
    let dut1 = 0.1550675
    let elong = -0.527800806
    let phi = -1.2345856
    let hm = 2738.0
    let xp = 2.47230737e-7
    let yp = 1.82640464e-6
    let phpa = 731.0
    let tc = 12.8
    let rh = 0.59
    let wl = 0.55
    let astrom = faws.apio13(utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
    let ri = 2.710121572969038991
    let di = 0.1729371367218230438
    let (aob, zob, hob, dob, rob) = faws.atioq(ri, di, astrom)
    vvd(aob, 0.9233952224895122499e-1, 1e-12, "atioq", "aob")
    vvd(zob, 1.407758704513549991, 1e-12, "atioq", "zob")
    vvd(hob, -0.9247619879881698140e-1, 1e-12, "atioq", "hob")
    vvd(dob, 0.1717653435756234676, 1e-12, "atioq", "dob")
    vvd(rob, 2.710085107988480746, 1e-12, "atioq", "rob")
}

func t_atoc13() {
    var ob1, ob2, rc, dc: Double
    let utc1 = 2456384.5
    let utc2 = 0.969254051
    let dut1 = 0.1550675
    let elong = -0.527800806
    let phi = -1.2345856
    let hm = 2738.0
    let xp = 2.47230737e-7
    let yp = 1.82640464e-6
    let phpa = 731.0
    let tc = 12.8
    let rh = 0.59
    let wl = 0.55
    ob1 = 2.710085107986886201
    ob2 = 0.1717653435758265198
    (rc, dc) = faws.atoc13("R", ob1, ob2, utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
    vvd(rc, 2.709956744659136129, 1e-12, "atoc13", "R/rc")
    vvd(dc, 0.1741696500898471362, 1e-12, "atoc13", "R/dc")
    ob1 = -0.09247619879782006106
    ob2 = 0.1717653435758265198
    (rc, dc) = faws.atoc13("H", ob1, ob2, utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
    vvd(rc, 2.709956744659734086, 1e-12, "atoc13", "H/rc")
    vvd(dc, 0.1741696500898471362, 1e-12, "atoc13", "H/dc")
    ob1 = 0.09233952224794989993
    ob2 = 1.407758704513722461
    (rc, dc) = faws.atoc13("A", ob1, ob2, utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
    vvd(rc, 2.709956744659734086, 1e-12, "atoc13", "A/rc")
    vvd(dc, 0.1741696500898471366, 1e-12, "atoc13", "A/dc")
}

func t_atoi13() {
    var ob1, ob2, ri, di: Double
    let utc1 = 2456384.5
    let utc2 = 0.969254051
    let dut1 = 0.1550675
    let elong = -0.527800806
    let phi = -1.2345856
    let hm = 2738.0
    let xp = 2.47230737e-7
    let yp = 1.82640464e-6
    let phpa = 731.0
    let tc = 12.8
    let rh = 0.59
    let wl = 0.55
    ob1 = 2.710085107986886201
    ob2 = 0.1717653435758265198
    (ri, di) = faws.atoi13("R", ob1, ob2, utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
    vvd(ri, 2.710121574447540810, 1e-12, "atoi13", "R/ri")
    vvd(di, 0.1729371839116608778, 1e-12, "atoi13", "R/di")
    ob1 = -0.09247619879782006106
    ob2 = 0.1717653435758265198
    (ri, di) = faws.atoi13("H", ob1, ob2, utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
    vvd(ri, 2.710121574448138676, 1e-12, "atoi13", "H/ri")
    vvd(di, 0.1729371839116608778, 1e-12, "atoi13", "H/di")
    ob1 = 0.09233952224794989993
    ob2 = 1.407758704513722461
    (ri, di) = faws.atoi13("A", ob1, ob2, utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
    vvd(ri, 2.710121574448138676, 1e-12, "atoi13", "A/ri")
    vvd(di, 0.1729371839116608781, 1e-12, "atoi13", "A/di")
}

func t_atoiq() {
    var ob1, ob2, ri, di: Double
    let utc1 = 2456384.5
    let utc2 = 0.969254051
    let dut1 = 0.1550675
    let elong = -0.527800806
    let phi = -1.2345856
    let hm = 2738.0
    let xp = 2.47230737e-7
    let yp = 1.82640464e-6
    let phpa = 731.0
    let tc = 12.8
    let rh = 0.59
    let wl = 0.55
    let astrom = faws.apio13(utc1, utc2, dut1, elong, phi, hm, xp, yp, phpa, tc, rh, wl)
    ob1 = 2.710085107986886201
    ob2 = 0.1717653435758265198
    (ri, di) = faws.atoiq("R", ob1, ob2, astrom)
    vvd(ri, 2.710121574447540810, 1e-12, "atoiq", "R/ri")
    vvd(di, 0.17293718391166087785, 1e-12, "atoiq", "R/di")
    ob1 = -0.09247619879782006106
    ob2 = 0.1717653435758265198
    (ri, di) = faws.atoiq("H", ob1, ob2, astrom)
    vvd(ri, 2.710121574448138676, 1e-12, "atoiq", "H/ri")
    vvd(di, 0.1729371839116608778, 1e-12, "atoiq", "H/di")
    ob1 = 0.09233952224794989993
    ob2 = 1.407758704513722461
    (ri, di) = faws.atoiq("A", ob1, ob2, astrom)
    vvd(ri, 2.710121574448138676, 1e-12, "atoiq", "A/ri")
    vvd(di, 0.1729371839116608781, 1e-12, "atoiq", "A/di")
}

func t_bi00() {
    let (dpsibi, depsbi, dra) = faws.bi00()
    vvd(dpsibi, -0.2025309152835086613e-6, 1e-12, "bi00", "dpsibi")
    vvd(depsbi, -0.3306041454222147847e-7, 1e-12, "bi00", "depsbi")
    vvd(dra, -0.7078279744199225506e-7, 1e-12, "bi00", "dra")
}

func t_bp00() {
    let (rb, rp, rbp) = faws.bp00(2400000.5, 50123.9999)
    vvd(rb[0][0], 0.9999999999999942498, 1e-12, "bp00", "rb11")
    vvd(rb[0][1], -0.7078279744199196626e-7, 1e-16, "bp00", "rb12")
    vvd(rb[0][2], 0.8056217146976134152e-7, 1e-16, "bp00", "rb13")
    vvd(rb[1][0], 0.7078279477857337206e-7, 1e-16, "bp00", "rb21")
    vvd(rb[1][1], 0.9999999999999969484, 1e-12, "bp00", "rb22")
    vvd(rb[1][2], 0.3306041454222136517e-7, 1e-16, "bp00", "rb23")
    vvd(rb[2][0], -0.8056217380986972157e-7, 1e-16, "bp00", "rb31")
    vvd(rb[2][1], -0.3306040883980552500e-7, 1e-16, "bp00", "rb32")
    vvd(rb[2][2], 0.9999999999999962084, 1e-12, "bp00", "rb33")
    vvd(rp[0][0], 0.9999995504864048241, 1e-12, "bp00", "rp11")
    vvd(rp[0][1], 0.8696113836207084411e-3, 1e-14, "bp00", "rp12")
    vvd(rp[0][2], 0.3778928813389333402e-3, 1e-14, "bp00", "rp13")
    vvd(rp[1][0], -0.8696113818227265968e-3, 1e-14, "bp00", "rp21")
    vvd(rp[1][1], 0.9999996218879365258, 1e-12, "bp00", "rp22")
    vvd(rp[1][2], -0.1690679263009242066e-6, 1e-14, "bp00", "rp23")
    vvd(rp[2][0], -0.3778928854764695214e-3, 1e-14, "bp00", "rp31")
    vvd(rp[2][1], -0.1595521004195286491e-6, 1e-14, "bp00", "rp32")
    vvd(rp[2][2], 0.9999999285984682756, 1e-12, "bp00", "rp33")
    vvd(rbp[0][0], 0.9999995505175087260, 1e-12, "bp00", "rbp11")
    vvd(rbp[0][1], 0.8695405883617884705e-3, 1e-14, "bp00", "rbp12")
    vvd(rbp[0][2], 0.3779734722239007105e-3, 1e-14, "bp00", "rbp13")
    vvd(rbp[1][0], -0.8695405990410863719e-3, 1e-14, "bp00", "rbp21")
    vvd(rbp[1][1], 0.9999996219494925900, 1e-12, "bp00", "rbp22")
    vvd(rbp[1][2], -0.1360775820404982209e-6, 1e-14, "bp00", "rbp23")
    vvd(rbp[2][0], -0.3779734476558184991e-3, 1e-14, "bp00", "rbp31")
    vvd(rbp[2][1], -0.1925857585832024058e-6, 1e-14, "bp00", "rbp32")
    vvd(rbp[2][2], 0.9999999285680153377, 1e-12, "bp00", "rbp33")
}

func t_bp06() {
    let (rb, rp, rbp) = faws.bp06(2400000.5, 50123.9999)
    vvd(rb[0][0], 0.9999999999999942497, 1e-12, "bp06", "rb11")
    vvd(rb[0][1], -0.7078368960971557145e-7, 1e-14, "bp06", "rb12")
    vvd(rb[0][2], 0.8056213977613185606e-7, 1e-14, "bp06", "rb13")
    vvd(rb[1][0], 0.7078368694637674333e-7, 1e-14, "bp06", "rb21")
    vvd(rb[1][1], 0.9999999999999969484, 1e-12, "bp06", "rb22")
    vvd(rb[1][2], 0.3305943742989134124e-7, 1e-14, "bp06", "rb23")
    vvd(rb[2][0], -0.8056214211620056792e-7, 1e-14, "bp06", "rb31")
    vvd(rb[2][1], -0.3305943172740586950e-7, 1e-14, "bp06", "rb32")
    vvd(rb[2][2], 0.9999999999999962084, 1e-12, "bp06", "rb33")
    vvd(rp[0][0], 0.9999995504864960278, 1e-12, "bp06", "rp11")
    vvd(rp[0][1], 0.8696112578855404832e-3, 1e-14, "bp06", "rp12")
    vvd(rp[0][2], 0.3778929293341390127e-3, 1e-14, "bp06", "rp13")
    vvd(rp[1][0], -0.8696112560510186244e-3, 1e-14, "bp06", "rp21")
    vvd(rp[1][1], 0.9999996218880458820, 1e-12, "bp06", "rp22")
    vvd(rp[1][2], -0.1691646168941896285e-6, 1e-14, "bp06", "rp23")
    vvd(rp[2][0], -0.3778929335557603418e-3, 1e-14, "bp06", "rp31")
    vvd(rp[2][1], -0.1594554040786495076e-6, 1e-14, "bp06", "rp32")
    vvd(rp[2][2], 0.9999999285984501222, 1e-12, "bp06", "rp33")
    vvd(rbp[0][0], 0.9999995505176007047, 1e-12, "bp06", "rbp11")
    vvd(rbp[0][1], 0.8695404617348208406e-3, 1e-14, "bp06", "rbp12")
    vvd(rbp[0][2], 0.3779735201865589104e-3, 1e-14, "bp06", "rbp13")
    vvd(rbp[1][0], -0.8695404723772031414e-3, 1e-14, "bp06", "rbp21")
    vvd(rbp[1][1], 0.9999996219496027161, 1e-12, "bp06", "rbp22")
    vvd(rbp[1][2], -0.1361752497080270143e-6, 1e-14, "bp06", "rbp23")
    vvd(rbp[2][0], -0.3779734957034089490e-3, 1e-14, "bp06", "rbp31")
    vvd(rbp[2][1], -0.1924880847894457113e-6, 1e-14, "bp06", "rbp32")
    vvd(rbp[2][2], 0.9999999285679971958, 1e-12, "bp06", "rbp33")
}

func t_bpn2xy() {
    var rbpn = faws.zr()
    rbpn[0][0] =  9.999962358680738e-1
    rbpn[0][1] = -2.516417057665452e-3
    rbpn[0][2] = -1.093569785342370e-3
    rbpn[1][0] =  2.516462370370876e-3
    rbpn[1][1] =  9.999968329010883e-1
    rbpn[1][2] =  4.006159587358310e-5
    rbpn[2][0] =  1.093465510215479e-3
    rbpn[2][1] = -4.281337229063151e-5
    rbpn[2][2] =  9.999994012499173e-1
    let (x, y) = faws.bpn2xy(rbpn)
    vvd(x,  1.093465510215479e-3, 1e-12, "bpn2xy", "x")
    vvd(y, -4.281337229063151e-5, 1e-12, "bpn2xy", "y")
}

func t_c2i00a() {
    let rc2i = faws.c2i00a(2400000.5, 53736.0)
    vvd(rc2i[0][0], 0.9999998323037165557, 1e-12, "c2i00a", "11")
    vvd(rc2i[0][1], 0.5581526348992140183e-9, 1e-12, "c2i00a", "12")
    vvd(rc2i[0][2], -0.5791308477073443415e-3, 1e-12, "c2i00a", "13")
    vvd(rc2i[1][0], -0.2384266227870752452e-7, 1e-12, "c2i00a", "21")
    vvd(rc2i[1][1], 0.9999999991917405258, 1e-12, "c2i00a", "22")
    vvd(rc2i[1][2], -0.4020594955028209745e-4, 1e-12, "c2i00a", "23")
    vvd(rc2i[2][0], 0.5791308472168152904e-3, 1e-12, "c2i00a", "31")
    vvd(rc2i[2][1], 0.4020595661591500259e-4, 1e-12, "c2i00a", "32")
    vvd(rc2i[2][2], 0.9999998314954572304, 1e-12, "c2i00a", "33")
}

func t_c2i00b() {
    let rc2i = faws.c2i00b(2400000.5, 53736.0)
    vvd(rc2i[0][0], 0.9999998323040954356, 1e-12, "c2i00b", "11")
    vvd(rc2i[0][1], 0.5581526349131823372e-9, 1e-12, "c2i00b", "12")
    vvd(rc2i[0][2], -0.5791301934855394005e-3, 1e-12, "c2i00b", "13")
    vvd(rc2i[1][0], -0.2384239285499175543e-7, 1e-12, "c2i00b", "21")
    vvd(rc2i[1][1], 0.9999999991917574043, 1e-12, "c2i00b", "22")
    vvd(rc2i[1][2], -0.4020552974819030066e-4, 1e-12, "c2i00b", "23")
    vvd(rc2i[2][0], 0.5791301929950208873e-3, 1e-12, "c2i00b", "31")
    vvd(rc2i[2][1], 0.4020553681373720832e-4, 1e-12, "c2i00b", "32")
    vvd(rc2i[2][2], 0.9999998314958529887, 1e-12, "c2i00b", "33")
}

func t_c2i06a() {
    let rc2i = faws.c2i06a(2400000.5, 53736.0)
    vvd(rc2i[0][0], 0.9999998323037159379, 1e-12, "c2i06a", "11")
    vvd(rc2i[0][1], 0.5581121329587613787e-9, 1e-12, "c2i06a", "12")
    vvd(rc2i[0][2], -0.5791308487740529749e-3, 1e-12, "c2i06a", "13")
    vvd(rc2i[1][0], -0.2384253169452306581e-7, 1e-12, "c2i06a", "21")
    vvd(rc2i[1][1], 0.9999999991917467827, 1e-12, "c2i06a", "22")
    vvd(rc2i[1][2], -0.4020579392895682558e-4, 1e-12, "c2i06a", "23")
    vvd(rc2i[2][0], 0.5791308482835292617e-3, 1e-12, "c2i06a", "31")
    vvd(rc2i[2][1], 0.4020580099454020310e-4, 1e-12, "c2i06a", "32")
    vvd(rc2i[2][2], 0.9999998314954628695, 1e-12, "c2i06a", "33")
}

func t_c2ibpn() {
    var rbpn = faws.zr()
    rbpn[0][0] =  9.999962358680738e-1
    rbpn[0][1] = -2.516417057665452e-3
    rbpn[0][2] = -1.093569785342370e-3
    rbpn[1][0] =  2.516462370370876e-3
    rbpn[1][1] =  9.999968329010883e-1
    rbpn[1][2] =  4.006159587358310e-5
    rbpn[2][0] =  1.093465510215479e-3
    rbpn[2][1] = -4.281337229063151e-5
    rbpn[2][2] =  9.999994012499173e-1
    let rc2i = faws.c2ibpn(2400000.5, 50123.9999, rbpn)
    vvd(rc2i[0][0], 0.9999994021664089977, 1e-12, "c2ibpn", "11")
    vvd(rc2i[0][1], -0.3869195948017503664e-8, 1e-12, "c2ibpn", "12")
    vvd(rc2i[0][2], -0.1093465511383285076e-2, 1e-12, "c2ibpn", "13")
    vvd(rc2i[1][0], 0.5068413965715446111e-7, 1e-12, "c2ibpn", "21")
    vvd(rc2i[1][1], 0.9999999990835075686, 1e-12, "c2ibpn", "22")
    vvd(rc2i[1][2], 0.4281334246452708915e-4, 1e-12, "c2ibpn", "23")
    vvd(rc2i[2][0], 0.1093465510215479000e-2, 1e-12, "c2ibpn", "31")
    vvd(rc2i[2][1], -0.4281337229063151000e-4, 1e-12, "c2ibpn", "32")
    vvd(rc2i[2][2], 0.9999994012499173103, 1e-12, "c2ibpn", "33")
}

func t_c2ixy() {
    let x = 0.5791308486706011000e-3
    let y = 0.4020579816732961219e-4
    let rc2i = faws.c2ixy(2400000.5, 53736, x, y)
    vvd(rc2i[0][0], 0.9999998323037157138, 1e-12, "c2ixy", "11")
    vvd(rc2i[0][1], 0.5581526349032241205e-9, 1e-12, "c2ixy", "12")
    vvd(rc2i[0][2], -0.5791308491611263745e-3, 1e-12, "c2ixy", "13")
    vvd(rc2i[1][0], -0.2384257057469842953e-7, 1e-12, "c2ixy", "21")
    vvd(rc2i[1][1], 0.9999999991917468964, 1e-12, "c2ixy", "22")
    vvd(rc2i[1][2], -0.4020579110172324363e-4, 1e-12, "c2ixy", "23")
    vvd(rc2i[2][0], 0.5791308486706011000e-3, 1e-12, "c2ixy", "31")
    vvd(rc2i[2][1], 0.4020579816732961219e-4, 1e-12, "c2ixy", "32")
    vvd(rc2i[2][2], 0.9999998314954627590, 1e-12, "c2ixy", "33")
}

func t_c2ixys() {
    let x =  0.5791308486706011000e-3
    let y =  0.4020579816732961219e-4
    let s = -0.1220040848472271978e-7
    let rc2i = faws.c2ixys(x, y, s)
    vvd(rc2i[0][0], 0.9999998323037157138, 1e-12, "c2ixys", "11")
    vvd(rc2i[0][1], 0.5581984869168499149e-9, 1e-12, "c2ixys", "12")
    vvd(rc2i[0][2], -0.5791308491611282180e-3, 1e-12, "c2ixys", "13")
    vvd(rc2i[1][0], -0.2384261642670440317e-7, 1e-12, "c2ixys", "21")
    vvd(rc2i[1][1], 0.9999999991917468964, 1e-12, "c2ixys", "22")
    vvd(rc2i[1][2], -0.4020579110169668931e-4, 1e-12, "c2ixys", "23")
    vvd(rc2i[2][0], 0.5791308486706011000e-3, 1e-12, "c2ixys", "31")
    vvd(rc2i[2][1], 0.4020579816732961219e-4, 1e-12, "c2ixys", "32")
    vvd(rc2i[2][2], 0.9999998314954627590, 1e-12, "c2ixys", "33")
}

func t_c2s() {
    let p = [100.0, -50.0, 25.0]
    let (theta, phi) = faws.c2s(p)
    vvd(theta, -0.4636476090008061162, 1e-14, "c2s", "theta")
    vvd(phi, 0.2199879773954594463, 1e-14, "c2s", "phi")
}

func t_c2t00a() {
    let tta = 2400000.5
    let uta = 2400000.5
    let ttb = 53736.0
    let utb = 53736.0
    let xp = 2.55060238e-7
    let yp = 1.860359247e-6
    let rc2t = faws.c2t00a(tta, ttb, uta, utb, xp, yp)
    vvd(rc2t[0][0], -0.1810332128307182668, 1e-12, "c2t00a", "11")
    vvd(rc2t[0][1], 0.9834769806938457836, 1e-12, "c2t00a", "12")
    vvd(rc2t[0][2], 0.6555535638688341725e-4, 1e-12, "c2t00a", "13")
    vvd(rc2t[1][0], -0.9834768134135984552, 1e-12, "c2t00a", "21")
    vvd(rc2t[1][1], -0.1810332203649520727, 1e-12, "c2t00a", "22")
    vvd(rc2t[1][2], 0.5749801116141056317e-3, 1e-12, "c2t00a", "23")
    vvd(rc2t[2][0], 0.5773474014081406921e-3, 1e-12, "c2t00a", "31")
    vvd(rc2t[2][1], 0.3961832391770163647e-4, 1e-12, "c2t00a", "32")
    vvd(rc2t[2][2], 0.9999998325501692289, 1e-12, "c2t00a", "33")
}

func t_c2t00b() {
    let tta = 2400000.5
    let uta = 2400000.5
    let ttb = 53736.0
    let utb = 53736.0
    let xp = 2.55060238e-7
    let yp = 1.860359247e-6
    let rc2t = faws.c2t00b(tta, ttb, uta, utb, xp, yp)
    vvd(rc2t[0][0], -0.1810332128439678965, 1e-12, "c2t00b", "11")
    vvd(rc2t[0][1], 0.9834769806913872359, 1e-12, "c2t00b", "12")
    vvd(rc2t[0][2], 0.6555565082458415611e-4, 1e-12, "c2t00b", "13")
    vvd(rc2t[1][0], -0.9834768134115435923, 1e-12, "c2t00b", "21")
    vvd(rc2t[1][1], -0.1810332203784001946, 1e-12, "c2t00b", "22")
    vvd(rc2t[1][2], 0.5749793922030017230e-3, 1e-12, "c2t00b", "23")
    vvd(rc2t[2][0], 0.5773467471863534901e-3, 1e-12, "c2t00b", "31")
    vvd(rc2t[2][1], 0.3961790411549945020e-4, 1e-12, "c2t00b", "32")
    vvd(rc2t[2][2], 0.9999998325505635738, 1e-12, "c2t00b", "33")
}

func t_c2t06a() {
    let tta = 2400000.5
    let uta = 2400000.5
    let ttb = 53736.0
    let utb = 53736.0
    let xp = 2.55060238e-7
    let yp = 1.860359247e-6
    let rc2t = faws.c2t06a(tta, ttb, uta, utb, xp, yp)
    vvd(rc2t[0][0], -0.1810332128305897282, 1e-12, "c2t06a", "11")
    vvd(rc2t[0][1], 0.9834769806938592296, 1e-12, "c2t06a", "12")
    vvd(rc2t[0][2], 0.6555550962998436505e-4, 1e-12, "c2t06a", "13")
    vvd(rc2t[1][0], -0.9834768134136214897, 1e-12, "c2t06a", "21")
    vvd(rc2t[1][1], -0.1810332203649130832, 1e-12, "c2t06a", "22")
    vvd(rc2t[1][2], 0.5749800844905594110e-3, 1e-12, "c2t06a", "23")
    vvd(rc2t[2][0], 0.5773474024748545878e-3, 1e-12, "c2t06a", "31")
    vvd(rc2t[2][1], 0.3961816829632690581e-4, 1e-12, "c2t06a", "32")
    vvd(rc2t[2][2], 0.9999998325501747785, 1e-12, "c2t06a", "33")
}

func t_c2tcio() {
    var rc2i = faws.zr()
    var rpom = faws.zr()
    rc2i[0][0] =  0.9999998323037164738
    rc2i[0][1] =  0.5581526271714303683e-9
    rc2i[0][2] = -0.5791308477073443903e-3
    rc2i[1][0] = -0.2384266227524722273e-7
    rc2i[1][1] =  0.9999999991917404296
    rc2i[1][2] = -0.4020594955030704125e-4
    rc2i[2][0] =  0.5791308472168153320e-3
    rc2i[2][1] =  0.4020595661593994396e-4
    rc2i[2][2] =  0.9999998314954572365
    let era = 1.75283325530307
    rpom[0][0] =  0.9999999999999674705
    rpom[0][1] = -0.1367174580728847031e-10
    rpom[0][2] =  0.2550602379999972723e-6
    rpom[1][0] =  0.1414624947957029721e-10
    rpom[1][1] =  0.9999999999982694954
    rpom[1][2] = -0.1860359246998866338e-5
    rpom[2][0] = -0.2550602379741215275e-6
    rpom[2][1] =  0.1860359247002413923e-5
    rpom[2][2] =  0.9999999999982369658
    let rc2t = faws.c2tcio(rc2i, era, rpom)
    vvd(rc2t[0][0], -0.1810332128307110439, 1e-12, "c2tcio", "11")
    vvd(rc2t[0][1], 0.9834769806938470149, 1e-12, "c2tcio", "12")
    vvd(rc2t[0][2], 0.6555535638685466874e-4, 1e-12, "c2tcio", "13")
    vvd(rc2t[1][0], -0.9834768134135996657, 1e-12, "c2tcio", "21")
    vvd(rc2t[1][1], -0.1810332203649448367, 1e-12, "c2tcio", "22")
    vvd(rc2t[1][2], 0.5749801116141106528e-3, 1e-12, "c2tcio", "23")
    vvd(rc2t[2][0], 0.5773474014081407076e-3, 1e-12, "c2tcio", "31")
    vvd(rc2t[2][1], 0.3961832391772658944e-4, 1e-12, "c2tcio", "32")
    vvd(rc2t[2][2], 0.9999998325501691969, 1e-12, "c2tcio", "33")
}

func t_c2teqx() {
    var rbpn = faws.zr()
    var rpom = faws.zr()
    rbpn[0][0] =  0.9999989440476103608
    rbpn[0][1] = -0.1332881761240011518e-2
    rbpn[0][2] = -0.5790767434730085097e-3
    rbpn[1][0] =  0.1332858254308954453e-2
    rbpn[1][1] =  0.9999991109044505944
    rbpn[1][2] = -0.4097782710401555759e-4
    rbpn[2][0] =  0.5791308472168153320e-3
    rbpn[2][1] =  0.4020595661593994396e-4
    rbpn[2][2] =  0.9999998314954572365
    let gst = 1.754166138040730516
    rpom[0][0] =  0.9999999999999674705
    rpom[0][1] = -0.1367174580728847031e-10
    rpom[0][2] =  0.2550602379999972723e-6
    rpom[1][0] =  0.1414624947957029721e-10
    rpom[1][1] =  0.9999999999982694954
    rpom[1][2] = -0.1860359246998866338e-5
    rpom[2][0] = -0.2550602379741215275e-6
    rpom[2][1] =  0.1860359247002413923e-5
    rpom[2][2] =  0.9999999999982369658
    let rc2t = faws.c2teqx(rbpn, gst, rpom)
    vvd(rc2t[0][0], -0.1810332128528685730, 1e-12, "c2teqx", "11")
    vvd(rc2t[0][1], 0.9834769806897685071, 1e-12, "c2teqx", "12")
    vvd(rc2t[0][2], 0.6555535639982634449e-4, 1e-12, "c2teqx", "13")
    vvd(rc2t[1][0], -0.9834768134095211257, 1e-12, "c2teqx", "21")
    vvd(rc2t[1][1], -0.1810332203871023800, 1e-12, "c2teqx", "22")
    vvd(rc2t[1][2], 0.5749801116126438962e-3, 1e-12, "c2teqx", "23")
    vvd(rc2t[2][0], 0.5773474014081539467e-3, 1e-12, "c2teqx", "31")
    vvd(rc2t[2][1], 0.3961832391768640871e-4, 1e-12, "c2teqx", "32")
    vvd(rc2t[2][2], 0.9999998325501691969, 1e-12, "c2teqx", "33")
}

func t_c2tpe() {
    let tta = 2400000.5
    let uta = 2400000.5
    let ttb = 53736.0
    let utb = 53736.0
    let deps =  0.4090789763356509900
    let dpsi = -0.9630909107115582393e-5
    let xp = 2.55060238e-7
    let yp = 1.860359247e-6
    let rc2t = faws.c2tpe(tta, ttb, uta, utb, dpsi, deps, xp, yp)
    vvd(rc2t[0][0], -0.1813677995763029394, 1e-12, "c2tpe", "11")
    vvd(rc2t[0][1], 0.9023482206891683275, 1e-12, "c2tpe", "12")
    vvd(rc2t[0][2], -0.3909902938641085751, 1e-12, "c2tpe", "13")
    vvd(rc2t[1][0], -0.9834147641476804807, 1e-12, "c2tpe", "21")
    vvd(rc2t[1][1], -0.1659883635434995121, 1e-12, "c2tpe", "22")
    vvd(rc2t[1][2], 0.7309763898042819705e-1, 1e-12, "c2tpe", "23")
    vvd(rc2t[2][0], 0.1059685430673215247e-2, 1e-12, "c2tpe", "31")
    vvd(rc2t[2][1], 0.3977631855605078674, 1e-12, "c2tpe", "32")
    vvd(rc2t[2][2], 0.9174875068792735362, 1e-12, "c2tpe", "33")
}

func t_c2txy() {
    let tta = 2400000.5
    let uta = 2400000.5
    let ttb = 53736.0
    let utb = 53736.0
    let x = 0.5791308486706011000e-3
    let y = 0.4020579816732961219e-4
    let xp = 2.55060238e-7
    let yp = 1.860359247e-6
    let rc2t = faws.c2txy(tta, ttb, uta, utb, x, y, xp, yp)
    vvd(rc2t[0][0], -0.1810332128306279253, 1e-12, "c2txy", "11")
    vvd(rc2t[0][1], 0.9834769806938520084, 1e-12, "c2txy", "12")
    vvd(rc2t[0][2], 0.6555551248057665829e-4, 1e-12, "c2txy", "13")
    vvd(rc2t[1][0], -0.9834768134136142314, 1e-12, "c2txy", "21")
    vvd(rc2t[1][1], -0.1810332203649529312, 1e-12, "c2txy", "22")
    vvd(rc2t[1][2], 0.5749800843594139912e-3, 1e-12, "c2txy", "23")
    vvd(rc2t[2][0], 0.5773474028619264494e-3, 1e-12, "c2txy", "31")
    vvd(rc2t[2][1], 0.3961816546911624260e-4, 1e-12, "c2txy", "32")
    vvd(rc2t[2][2], 0.9999998325501746670, 1e-12, "c2txy", "33")
}

func t_cal2jd() {
    let (djm0, djm) = faws.cal2jd(2003, 06, 01)
    vvd(djm0, 2400000.5, 0.0, "cal2jd", "djm0")
    vvd(djm,    52791.0, 0.0, "cal2jd", "djm")
}

func t_cp() {
    let p = [0.3, 1.2, -2.5]
    let c = faws.cp(p)
    vvd(c[0],  0.3, 0.0, "cp", "1")
    vvd(c[1],  1.2, 0.0, "cp", "2")
    vvd(c[2], -2.5, 0.0, "cp", "3")
}

func t_cpv() {
    var pv = faws.zpv()
    pv[0][0] =  0.3
    pv[0][1] =  1.2
    pv[0][2] = -2.5
    pv[1][0] = -0.5
    pv[1][1] =  3.1
    pv[1][2] =  0.9
    let c = faws.cpv(pv)
    vvd(c[0][0],  0.3, 0.0, "cpv", "p1")
    vvd(c[0][1],  1.2, 0.0, "cpv", "p2")
    vvd(c[0][2], -2.5, 0.0, "cpv", "p3")
    vvd(c[1][0], -0.5, 0.0, "cpv", "v1")
    vvd(c[1][1],  3.1, 0.0, "cpv", "v2")
    vvd(c[1][2],  0.9, 0.0, "cpv", "v3")
}

func t_cr() {
    var r = faws.zr()
    r[0][0] = 2.0
    r[0][1] = 3.0
    r[0][2] = 2.0
    r[1][0] = 3.0
    r[1][1] = 2.0
    r[1][2] = 3.0
    r[2][0] = 3.0
    r[2][1] = 4.0
    r[2][2] = 5.0
    let c = faws.cr(r)
    vvd(c[0][0], 2.0, 0.0, "cr", "11")
    vvd(c[0][1], 3.0, 0.0, "cr", "12")
    vvd(c[0][2], 2.0, 0.0, "cr", "13")
    vvd(c[1][0], 3.0, 0.0, "cr", "21")
    vvd(c[1][1], 2.0, 0.0, "cr", "22")
    vvd(c[1][2], 3.0, 0.0, "cr", "23")
    vvd(c[2][0], 3.0, 0.0, "cr", "31")
    vvd(c[2][1], 4.0, 0.0, "cr", "32")
    vvd(c[2][2], 5.0, 0.0, "cr", "33")
}

func t_d2dtf() {
    let (iy, im, id, ihmsf) = faws.d2dtf("UTC", 5, 2400000.5, 49533.99999)
    viv(iy, 1994, "d2dtf", "y")
    viv(im, 6, "d2dtf", "mo")
    viv(id, 30, "d2dtf", "d")
    viv(ihmsf[0], 23, "d2dtf", "h")
    viv(ihmsf[1], 59, "d2dtf", "m")
    viv(ihmsf[2], 60, "d2dtf", "s")
    viv(ihmsf[3], 13599, "d2dtf", "f")
}

func t_d2tf() {
    let (s, ihmsf) = faws.d2tf(4, -0.987654321)
    if s != "-" { print("d2tf failed") }
    //viv((int)s, '-', "d2tf", "s")
    viv(ihmsf[0], 23, "d2tf", "0")
    viv(ihmsf[1], 42, "d2tf", "1")
    viv(ihmsf[2], 13, "d2tf", "2")
    viv(ihmsf[3], 3333, "d2tf", "3")
}

func t_dat() {
    var deltat: Double
    deltat = faws.dat(2003, 6, 1, 0.0)
    vvd(deltat, 32.0, 0.0, "dat", "d1")
    deltat = faws.dat(2008, 1, 17, 0.0)
    vvd(deltat, 33.0, 0.0, "dat", "d2")
    deltat = faws.dat(2017, 9, 1, 0.0)
    vvd(deltat, 37.0, 0.0, "dat", "d3")
}

func t_dtdb() {
    let dtdb = faws.dtdb(2448939.5, 0.123, 0.76543, 5.0123, 5525.242, 3190.0)
    vvd(dtdb, -0.1280368005936998991e-2, 1e-15, "dtdb", "")
}

func t_dtf2d() {
    let (u1, u2) = faws.dtf2d("UTC", 1994, 6, 30, 23, 59, 60.13599)
    vvd(u1+u2, 2449534.49999, 1e-6, "dtf2d", "u")
}

func t_eceq06() {
    let date1 = 2456165.5
    let date2 = 0.401182685
    let dl = 5.1
    let db = -0.9
    let (dr, dd) = faws.eceq06(date1, date2, dl, db)
    vvd(dr, 5.533459733613627767, 1e-14, "eceq06", "dr")
    vvd(dd, -1.246542932554480576, 1e-14, "eceq06", "dd")
}

func t_ecm06() {
    let date1 = 2456165.5
    let date2 = 0.401182685
    let rm = faws.ecm06(date1, date2)
    vvd(rm[0][0], 0.9999952427708701137, 1e-14, "ecm06", "rm11")
    vvd(rm[0][1], -0.2829062057663042347e-2, 1e-14, "ecm06", "rm12")
    vvd(rm[0][2], -0.1229163741100017629e-2, 1e-14, "ecm06", "rm13")
    vvd(rm[1][0], 0.3084546876908653562e-2, 1e-14, "ecm06", "rm21")
    vvd(rm[1][1], 0.9174891871550392514, 1e-14, "ecm06", "rm22")
    vvd(rm[1][2], 0.3977487611849338124, 1e-14, "ecm06", "rm23")
    vvd(rm[2][0], 0.2488512951527405928e-5, 1e-14, "ecm06", "rm31")
    vvd(rm[2][1], -0.3977506604161195467, 1e-14, "ecm06", "rm32")
    vvd(rm[2][2], 0.9174935488232863071, 1e-14, "ecm06", "rm33")
}

func t_ee00() {
    let epsa =  0.4090789763356509900
    let dpsi = -0.9630909107115582393e-5
    let ee = faws.ee00(2400000.5, 53736.0, epsa, dpsi)
    vvd(ee, -0.8834193235367965479e-5, 1e-18, "ee00", "")
}

func t_ee00a() {
    let ee = faws.ee00a(2400000.5, 53736.0)
    vvd(ee, -0.8834192459222588227e-5, 1e-18, "ee00a", "")
}

func t_ee00b() {
    let ee = faws.ee00b(2400000.5, 53736.0)
    vvd(ee, -0.8835700060003032831e-5, 1e-18, "ee00b", "")
}

func t_ee06a() {
    let ee = faws.ee06a(2400000.5, 53736.0)
    vvd(ee, -0.8834195072043790156e-5, 1e-15, "ee06a", "")
}

func t_eect00() {
    let eect = faws.eect00(2400000.5, 53736.0)
    vvd(eect, 0.2046085004885125264e-8, 1e-20, "eect00", "")
}

func t_eform() {
    var a, f: Double
    (a, f) = faws.eform(faws.WGS84)
    vvd(a, 6378137.0, 1e-10, "eform", "a1")
    vvd(f, 0.3352810664747480720e-2, 1e-18, "eform", "f1")
    (a, f) = faws.eform(faws.GRS80)
    vvd(a, 6378137.0, 1e-10, "eform", "a2")
    vvd(f, 0.3352810681182318935e-2, 1e-18, "eform", "f2")
    (a, f) = faws.eform(faws.WGS72)
    vvd(a, 6378135.0, 1e-10, "eform", "a3")
    vvd(f, 0.3352779454167504862e-2, 1e-18, "eform", "f3")
}

func t_eo06a() {
    let eo = faws.eo06a(2400000.5, 53736.0)
    vvd(eo, -0.1332882371941833644e-2, 1e-15, "eo06a", "")
}

func t_eors() {
    var rnpb = faws.zr()
    rnpb[0][0] =  0.9999989440476103608
    rnpb[0][1] = -0.1332881761240011518e-2
    rnpb[0][2] = -0.5790767434730085097e-3
    rnpb[1][0] =  0.1332858254308954453e-2
    rnpb[1][1] =  0.9999991109044505944
    rnpb[1][2] = -0.4097782710401555759e-4
    rnpb[2][0] =  0.5791308472168153320e-3
    rnpb[2][1] =  0.4020595661593994396e-4
    rnpb[2][2] =  0.9999998314954572365
    let s = -0.1220040848472271978e-7
    let eo = faws.eors(rnpb, s)
    vvd(eo, -0.1332882715130744606e-2, 1e-14, "eors", "")
}

func t_epb() {
    let epb = faws.epb(2415019.8135, 30103.18648)
    vvd(epb, 1982.418424159278580, 1e-12, "epb", "")
}

func t_epb2jd() {
    let epb = 1957.3
    let (djm0, djm) = faws.epb2jd(epb)
    vvd(djm0, 2400000.5, 1e-9, "epb2jd", "djm0")
    vvd(djm, 35948.1915101513, 1e-9, "epb2jd", "mjd")
}

func t_epj() {
    let epj = faws.epj(2451545, -7392.5)
    vvd(epj, 1979.760438056125941, 1e-12, "epj", "")
}

func t_epj2jd() {
    let epj = 1996.8
    let (djm0, djm) = faws.epj2jd(epj)
    vvd(djm0, 2400000.5, 1e-9, "epj2jd", "djm0")
    vvd(djm,    50375.7, 1e-9, "epj2jd", "mjd")
}

func t_epv00() {
    let (pvh, pvb) = faws.epv00(2400000.5, 53411.52501161)
    vvd(pvh[0][0], -0.7757238809297706813, 1e-14, "epv00", "ph(x)")
    vvd(pvh[0][1], 0.5598052241363340596, 1e-14, "epv00", "ph(y)")
    vvd(pvh[0][2], 0.2426998466481686993, 1e-14, "epv00", "ph(z)")
    vvd(pvh[1][0], -0.1091891824147313846e-1, 1e-15, "epv00", "vh(x)")
    vvd(pvh[1][1], -0.1247187268440845008e-1, 1e-15, "epv00", "vh(y)")
    vvd(pvh[1][2], -0.5407569418065039061e-2, 1e-15, "epv00", "vh(z)")
    vvd(pvb[0][0], -0.7714104440491111971, 1e-14, "epv00", "pb(x)")
    vvd(pvb[0][1], 0.5598412061824171323, 1e-14, "epv00", "pb(y)")
    vvd(pvb[0][2], 0.2425996277722452400, 1e-14, "epv00", "pb(z)")
    vvd(pvb[1][0], -0.1091874268116823295e-1, 1e-15, "epv00", "vb(x)")
    vvd(pvb[1][1], -0.1246525461732861538e-1, 1e-15, "epv00", "vb(y)")
    vvd(pvb[1][2], -0.5404773180966231279e-2, 1e-15, "epv00", "vb(z)")
}

func t_eqec06() {
    let date1 = 1234.5
    let date2 = 2440000.5
    let dr = 1.234
    let dd = 0.987
    let (dl, db) = faws.eqec06(date1, date2, dr, dd)
    vvd(dl, 1.342509918994654619, 1e-14, "eqec06", "dl")
    vvd(db, 0.5926215259704608132, 1e-14, "eqec06", "db")
}

func t_eqeq94() {
    let eqeq = faws.eqeq94(2400000.5, 41234.0)
    vvd(eqeq, 0.5357758254609256894e-4, 1e-17, "eqeq94", "")
}

func t_era00() {
    let era00 = faws.era00(2400000.5, 54388.0)
    vvd(era00, 0.4022837240028158102, 1e-12, "era00", "")
}

func t_fad03() {
    vvd(faws.fad03(0.80), 1.946709205396925672, 1e-12, "fad03", "")
}

func t_fae03() {
    vvd(faws.fae03(0.80), 1.744713738913081846, 1e-12, "fae03", "")
}

func t_faf03() {
    vvd(faws.faf03(0.80), 0.2597711366745499518, 1e-12, "faf03", "")
}

func t_faju03() {
    vvd(faws.faju03(0.80), 5.275711665202481138, 1e-12, "faju03", "")
}

func t_fal03() {
    vvd(faws.fal03(0.80), 5.132369751108684150, 1e-12, "fal03", "")
}

func t_falp03() {
    vvd(faws.falp03(0.80), 6.226797973505507345, 1e-12, "falp03", "")
}

func t_fama03() {
    vvd(faws.fama03(0.80), 3.275506840277781492, 1e-12, "fama03", "")
}

func t_fame03() {
    vvd(faws.fame03(0.80), 5.417338184297289661, 1e-12, "fame03", "")
}

func t_fane03() {
    vvd(faws.fane03(0.80), 2.079343830860413523, 1e-12, "fane03", "")
}

func t_faom03() {
    vvd(faws.faom03(0.80), -5.973618440951302183, 1e-12, "faom03", "")
}

func t_fapa03() {
    vvd(faws.fapa03(0.80), 0.1950884762240000000e-1, 1e-12, "fapa03", "")
}

func t_fasa03() {
    vvd(faws.fasa03(0.80), 5.371574539440827046, 1e-12, "fasa03", "")
}

func t_faur03() {
    vvd(faws.faur03(0.80), 5.180636450180413523, 1e-12, "faur03", "")
}

func t_fave03() {
    vvd(faws.fave03(0.80), 3.424900460533758000, 1e-12, "fave03", "")
}

func t_fk425() {
    let r1950 = 0.07626899753879587532
    let d1950 = -1.137405378399605780
    let dr1950 = 0.1973749217849087460e-4
    let dd1950 = 0.5659714913272723189e-5
    let p1950 = 0.134
    let v1950 = 8.7
    let (r2000, d2000, dr2000, dd2000, p2000, v2000) = faws.fk425(r1950, d1950, dr1950, dd1950, p1950, v1950)
    vvd(r2000, 0.08757989933556446040, 1e-14, "fk425", "r2000")
    vvd(d2000, -1.132279113042091895, 1e-12, "fk425", "d2000")
    vvd(dr2000, 0.1953670614474396139e-4, 1e-17, "fk425", "dr2000")
    vvd(dd2000, 0.5637686678659640164e-5, 1e-18, "fk425", "dd2000")
    vvd(p2000, 0.1339919950582767871, 1e-13, "fk425", "p2000")
    vvd(v2000, 8.736999669183529069, 1e-12, "fk425", "v2000")
}

func t_fk45z() {
    let r1950 = 0.01602284975382960982
    let d1950 = -0.1164347929099906024
    let bepoch = 1954.677617625256806
    let (r2000, d2000) = faws.fk45z(r1950, d1950, bepoch)
    vvd(r2000, 0.02719295911606862303, 1e-15, "fk45z", "r2000")
    vvd(d2000, -0.1115766001565926892, 1e-13, "fk45z", "d2000")
}

func t_fk524() {
    let r2000 = 0.8723503576487275595
    let d2000 = -0.7517076365138887672
    let dr2000 = 0.2019447755430472323e-4
    let dd2000 = 0.3541563940505160433e-5
    let p2000 = 0.1559
    let v2000 = 86.87
    let (r1950, d1950, dr1950, dd1950, p1950, v1950) = faws.fk524(r2000, d2000, dr2000, dd2000, p2000, v2000)
    vvd(r1950, 0.8636359659799603487, 1e-13, "fk524", "r1950")
    vvd(d1950, -0.7550281733160843059, 1e-13, "fk524", "d1950")
    vvd(dr1950, 0.2023628192747172486e-4, 1e-17, "fk524", "dr1950")
    vvd(dd1950, 0.3624459754935334718e-5, 1e-18, "fk524", "dd1950")
    vvd(p1950, 0.1560079963299390241, 1e-13, "fk524", "p1950")
    vvd(v1950, 86.79606353469163751, 1e-11, "fk524", "v1950")
}

func t_fk52h() {
    let r5  =  1.76779433
    let d5  = -0.2917517103
    let dr5 = -1.91851572e-7
    let dd5 = -5.8468475e-6
    let px5 =  0.379210
    let rv5 = -7.6
    let (rh, dh, drh, ddh, pxh, rvh) = faws.fk52h(r5, d5, dr5, dd5, px5, rv5)
    vvd(rh, 1.767794226299947632, 1e-14, "fk52h", "ra")
    vvd(dh,  -0.2917516070530391757, 1e-14, "fk52h", "dec")
    vvd(drh, -0.1961874125605721270e-6,1e-19, "fk52h", "dr5")
    vvd(ddh, -0.58459905176693911e-5, 1e-19, "fk52h", "dd5")
    vvd(pxh,  0.37921, 1e-14, "fk52h", "px")
    vvd(rvh, -7.6000000940000254, 1e-11, "fk52h", "rv")
}

func t_fk54z() {
    let r2000 = 0.02719026625066316119
    let d2000 = -0.1115815170738754813
    let bepoch = 1954.677308160316374
    let (r1950, d1950, dr1950, dd1950) = faws.fk54z(r2000, d2000, bepoch)
    vvd(r1950, 0.01602015588390065476, 1e-14, "fk54z", "r1950")
    vvd(d1950, -0.1164397101110765346, 1e-13, "fk54z", "d1950")
    vvd(dr1950, -0.1175712648471090704e-7, 1e-20, "fk54z", "dr1950")
    vvd(dd1950, 0.2108109051316431056e-7, 1e-20, "fk54z", "dd1950")
}

func t_fk5hip() {
    let (r5h, s5h) = faws.fk5hip()
    vvd(r5h[0][0], 0.9999999999999928638, 1e-14, "fk5hip", "11")
    vvd(r5h[0][1], 0.1110223351022919694e-6, 1e-17, "fk5hip", "12")
    vvd(r5h[0][2], 0.4411803962536558154e-7, 1e-17, "fk5hip", "13")
    vvd(r5h[1][0], -0.1110223308458746430e-6, 1e-17, "fk5hip", "21")
    vvd(r5h[1][1], 0.9999999999999891830, 1e-14, "fk5hip", "22")
    vvd(r5h[1][2], -0.9647792498984142358e-7, 1e-17, "fk5hip", "23")
    vvd(r5h[2][0], -0.4411805033656962252e-7, 1e-17, "fk5hip", "31")
    vvd(r5h[2][1], 0.9647792009175314354e-7, 1e-17, "fk5hip", "32")
    vvd(r5h[2][2], 0.9999999999999943728, 1e-14, "fk5hip", "33")
    vvd(s5h[0], -0.1454441043328607981e-8, 1e-17, "fk5hip", "s1")
    vvd(s5h[1], 0.2908882086657215962e-8, 1e-17, "fk5hip", "s2")
    vvd(s5h[2], 0.3393695767766751955e-8, 1e-17, "fk5hip", "s3")
}

func t_fk5hz() {
    let r5 =  1.76779433
    let d5 = -0.2917517103
    let (rh, dh) = faws.fk5hz(r5, d5, 2400000.5, 54479.0)
    vvd(rh,  1.767794191464423978, 1e-12, "fk5hz", "ra")
    vvd(dh, -0.2917516001679884419, 1e-12, "fk5hz", "dec")
}

func t_fw2m() {
    let gamb = -0.2243387670997992368e-5
    let phib =  0.4091014602391312982
    let psi  = -0.9501954178013015092e-3
    let eps  =  0.4091014316587367472
    let r = faws.fw2m(gamb, phib, psi, eps)
    vvd(r[0][0], 0.9999995505176007047, 1e-12, "fw2m", "11")
    vvd(r[0][1], 0.8695404617348192957e-3, 1e-12, "fw2m", "12")
    vvd(r[0][2], 0.3779735201865582571e-3, 1e-12, "fw2m", "13")
    vvd(r[1][0], -0.8695404723772016038e-3, 1e-12, "fw2m", "21")
    vvd(r[1][1], 0.9999996219496027161, 1e-12, "fw2m", "22")
    vvd(r[1][2], -0.1361752496887100026e-6, 1e-12, "fw2m", "23")
    vvd(r[2][0], -0.3779734957034082790e-3, 1e-12, "fw2m", "31")
    vvd(r[2][1], -0.1924880848087615651e-6, 1e-12, "fw2m", "32")
    vvd(r[2][2], 0.9999999285679971958, 1e-12, "fw2m", "33")
}

func t_fw2xy() {
    let gamb = -0.2243387670997992368e-5
    let phib =  0.4091014602391312982
    let psi  = -0.9501954178013015092e-3
    let eps  =  0.4091014316587367472
    let (x, y) = faws.fw2xy(gamb, phib, psi, eps)
    vvd(x, -0.3779734957034082790e-3, 1e-14, "fw2xy", "x")
    vvd(y, -0.1924880848087615651e-6, 1e-14, "fw2xy", "y")
}

func t_g2icrs() {
    let dl =  5.5850536063818546461558105
    let db = -0.7853981633974483096156608
    let (dr, dd) = faws.g2icrs(dl, db)
    vvd(dr,  5.9338074302227188048671, 1e-14, "g2icrs", "R")
    vvd(dd, -1.1784870613579944551541, 1e-14, "g2icrs", "D")
}

func t_gc2gd() {
    let xyz = [2e6, 3e6, 5.244e6]
    var e, p, h: Double
    (e, p, h) = faws.gc2gd(faws.WGS84, xyz)
    vvd(e, 0.9827937232473290680, 1e-14, "gc2gd", "e1")
    vvd(p, 0.97160184819075459, 1e-14, "gc2gd", "p1")
    vvd(h, 331.4172461426059892, 1e-8, "gc2gd", "h1")
    (e, p, h) = faws.gc2gd(faws.GRS80, xyz)
    vvd(e, 0.9827937232473290680, 1e-14, "gc2gd", "e2")
    vvd(p, 0.97160184820607853, 1e-14, "gc2gd", "p2")
    vvd(h, 331.41731754844348, 1e-8, "gc2gd", "h2")
    (e, p, h) = faws.gc2gd(faws.WGS72, xyz)
    vvd(e, 0.9827937232473290680, 1e-14, "gc2gd", "e3")
    vvd(p, 0.9716018181101511937, 1e-14, "gc2gd", "p3")
    vvd(h, 333.2770726130318123, 1e-8, "gc2gd", "h3")
}

func t_gc2gde() {
    let a = 6378136.0
    let f = 0.0033528
    let xyz = [2e6, 3e6, 5.244e6]
    let (e, p, h) = faws.gc2gde(a, f, xyz)
    vvd(e, 0.9827937232473290680, 1e-14, "gc2gde", "e")
    vvd(p, 0.9716018377570411532, 1e-14, "gc2gde", "p")
    vvd(h, 332.36862495764397, 1e-8, "gc2gde", "h")
}

func t_gd2gc() {
    let e = 3.1
    let p = -0.5
    let h = 2500.0
    var xyz = faws.zp()
    xyz = faws.gd2gc(faws.WGS84, e, p, h)
    vvd(xyz[0], -5599000.5577049947, 1e-7, "gd2gc", "1/1")
    vvd(xyz[1], 233011.67223479203, 1e-7, "gd2gc", "2/1")
    vvd(xyz[2], -3040909.4706983363, 1e-7, "gd2gc", "3/1")
    xyz = faws.gd2gc(faws.GRS80, e, p, h)
    vvd(xyz[0], -5599000.5577260984, 1e-7, "gd2gc", "1/2")
    vvd(xyz[1], 233011.6722356702949, 1e-7, "gd2gc", "2/2")
    vvd(xyz[2], -3040909.4706095476, 1e-7, "gd2gc", "3/2")
    xyz = faws.gd2gc(faws.WGS72, e, p, h)
    vvd(xyz[0], -5598998.7626301490, 1e-7, "gd2gc", "1/3")
    vvd(xyz[1], 233011.5975297822211, 1e-7, "gd2gc", "2/3")
    vvd(xyz[2], -3040908.6861467111, 1e-7, "gd2gc", "3/3")
}

func t_gd2gce() {
    let (a, f, e, p, h) = (6378136.0, 0.0033528, 3.1, -0.5, 2500.0)
    let xyz = faws.gd2gce(a, f, e, p, h)
    vvd(xyz[0], -5598999.6665116328, 1e-7, "gd2gce", "1")
    vvd(xyz[1], 233011.6351463057189, 1e-7, "gd2gce", "2")
    vvd(xyz[2], -3040909.0517314132, 1e-7, "gd2gce", "3")
}

func t_gmst00() {
    let theta = faws.gmst00(2400000.5, 53736.0, 2400000.5, 53736.0)
    vvd(theta, 1.754174972210740592, 1e-12, "gmst00", "")
}

func t_gmst06() {
    let theta = faws.gmst06(2400000.5, 53736.0, 2400000.5, 53736.0)
    vvd(theta, 1.754174971870091203, 1e-12, "gmst06", "")
}

func t_gmst82() {
    let theta = faws.gmst82(2400000.5, 53736.0)
    vvd(theta, 1.754174981860675096, 1e-12, "iauGmst82", "")
}

func t_gst00a() {
    let theta = faws.gst00a(2400000.5, 53736.0, 2400000.5, 53736.0)
    vvd(theta, 1.754166138018281369, 1e-12, "gst00a", "")
}

func t_gst00b() {
    let theta = faws.gst00b(2400000.5, 53736.0)
    vvd(theta, 1.754166136510680589, 1e-12, "gst00b", "")
}

func t_gst06() {
    var rnpb = faws.zr()
    rnpb[0][0] =  0.9999989440476103608
    rnpb[0][1] = -0.1332881761240011518e-2
    rnpb[0][2] = -0.5790767434730085097e-3
    rnpb[1][0] =  0.1332858254308954453e-2
    rnpb[1][1] =  0.9999991109044505944
    rnpb[1][2] = -0.4097782710401555759e-4
    rnpb[2][0] =  0.5791308472168153320e-3
    rnpb[2][1] =  0.4020595661593994396e-4
    rnpb[2][2] =  0.9999998314954572365
    let theta = faws.gst06(2400000.5, 53736.0, 2400000.5, 53736.0, rnpb)
    vvd(theta, 1.754166138018167568, 1e-12, "gst06", "")
}

func t_gst06a() {
    let theta = faws.gst06a(2400000.5, 53736.0, 2400000.5, 53736.0)
    vvd(theta, 1.754166137675019159, 1e-12, "gst06a", "")
}

func t_gst94() {
    let theta = faws.gst94(2400000.5, 53736.0)
    vvd(theta, 1.754166136020645203, 1e-12, "gst94", "")
}

func t_icrs2g() {
    let dr =  5.9338074302227188048671087
    let dd = -1.1784870613579944551540570
    let (dl, db) = faws.icrs2g(dr, dd)
    vvd(dl,  5.5850536063818546461558, 1e-14, "icrs2g", "L")
    vvd(db, -0.7853981633974483096157, 1e-14, "icrs2g", "B")
}

func t_h2fk5() {
    let rh  =  1.767794352
    let dh  = -0.2917512594
    let drh = -2.76413026e-6
    let ddh = -5.92994449e-6
    let pxh =  0.379210
    let rvh = -7.6
    let (r5, d5, dr5, dd5, px5, rv5) = faws.h2fk5(rh, dh, drh, ddh, pxh, rvh)
    vvd(r5, 1.767794455700065506, 1e-13, "h2fk5", "ra")
    vvd(d5, -0.2917513626469638890, 1e-13, "h2fk5", "dec")
    vvd(dr5, -0.27597945024511204e-5, 1e-18, "h2fk5", "dr5")
    vvd(dd5, -0.59308014093262838e-5, 1e-18, "h2fk5", "dd5")
    vvd(px5, 0.37921, 1e-13, "h2fk5", "px")
    vvd(rv5, -7.6000001309071126, 1e-11, "h2fk5", "rv")
}

func t_hd2ae() {
    let h = 1.1
    let d = 1.2
    let p = 0.3
    let (a, e) = faws.hd2ae(h, d, p)
    vvd(a, 5.916889243730066194, 1e-13, "hd2ae", "a")
    vvd(e, 0.4472186304990486228, 1e-14, "hd2ae", "e")
}

func t_hd2pa() {
    let h = 1.1
    let d = 1.2
    let p = 0.3
    let q = faws.hd2pa(h, d, p)
    vvd(q, 1.906227428001995580, 1e-13, "hd2pa", "q")
}

func t_hfk5z() {
    let rh =  1.767794352
    let dh = -0.2917512594
    let (r5, d5, dr5, dd5) = faws.hfk5z(rh, dh, 2400000.5, 54479.0)
    vvd(r5, 1.767794490535581026, 1e-13, "iauHfk5z", "ra")
    vvd(d5, -0.2917513695320114258, 1e-14, "iauHfk5z", "dec")
    vvd(dr5, 0.4335890983539243029e-8, 1e-22, "iauHfk5z", "dr5")
    vvd(dd5, -0.8569648841237745902e-9, 1e-23, "iauHfk5z", "dd5")
}

func t_ir() {
    var r = faws.zr()
    r[0][0] = 2.0
    r[0][1] = 3.0
    r[0][2] = 2.0
    r[1][0] = 3.0
    r[1][1] = 2.0
    r[1][2] = 3.0
    r[2][0] = 3.0
    r[2][1] = 4.0
    r[2][2] = 5.0
    r = faws.ir()
    vvd(r[0][0], 1.0, 0.0, "ir", "11")
    vvd(r[0][1], 0.0, 0.0, "ir", "12")
    vvd(r[0][2], 0.0, 0.0, "ir", "13")
    vvd(r[1][0], 0.0, 0.0, "ir", "21")
    vvd(r[1][1], 1.0, 0.0, "ir", "22")
    vvd(r[1][2], 0.0, 0.0, "ir", "23")
    vvd(r[2][0], 0.0, 0.0, "ir", "31")
    vvd(r[2][1], 0.0, 0.0, "ir", "32")
    vvd(r[2][2], 1.0, 0.0, "ir", "33")
}

func t_jd2cal() {
    let dj1 = 2400000.5
    let dj2 = 50123.9999
    let (iy, im, id, fd) = faws.jd2cal(dj1, dj2)
    viv(iy, 1996, "jd2cal", "y")
    viv(im, 2, "jd2cal", "m")
    viv(id, 10, "jd2cal", "d")
    vvd(fd, 0.9999, 1e-7, "jd2cal", "fd")
}

func t_jdcalf() {
    let dj1 = 2400000.5
    let dj2 = 50123.9999
    let iydmf = faws.jdcalf(4, dj1, dj2)
    viv(iydmf[0], 1996, "jdcalf", "y")
    viv(iydmf[1], 2, "jdcalf", "m")
    viv(iydmf[2], 10, "jdcalf", "d")
    viv(iydmf[3], 9999, "jdcalf", "f")
}

func t_ld() {
    let bm = 0.00028574
    let p = [-0.763276255, -0.608633767, -0.216735543]
    let q = [-0.763276255, -0.608633767, -0.216735543]
    let e = [0.76700421, 0.605629598, 0.211937094]
    let em = 8.91276983
    let dlim = 3e-10
    let p1 = faws.ld(bm, p, q, e, em, dlim)
    vvd(p1[0], -0.7632762548968159627, 1e-12, "ld", "1")
    vvd(p1[1], -0.6086337670823762701, 1e-12, "ld", "2")
    vvd(p1[2], -0.2167355431320546947, 1e-12, "ld", "3")
}

func t_ldn() {
    let b0_bm = 0.00028574
    let b0_dl = 3e-10
    let b0_pv = [[-7.81014427, -5.60956681, -1.98079819], [0.0030723249, -0.00406995477, -0.00181335842]]
    var b0 = LDBODY()
    b0.bm = b0_bm
    b0.dl = b0_dl
    b0.pv = b0_pv
    let b1_bm = 0.00095435
    let b1_dl = 3e-9
    let b1_pv = [[0.738098796, 4.63658692, 1.9693136], [-0.00755816922, 0.00126913722, 0.000727999001]]
    var b1 = LDBODY()
    b1.bm = b1_bm
    b1.dl = b1_dl
    b1.pv = b1_pv
    let b2_bm = 1.0
    let b2_dl = 6e-6
    let b2_pv = [[-0.000712174377, -0.00230478303, -0.00105865966], [6.29235213e-6, -3.30888387e-7, -2.96486623e-7]]
    var b2 = LDBODY()
    b2.bm = b2_bm
    b2.dl = b2_dl
    b2.pv = b2_pv
    let b = [b0, b1, b2]
    let ob = [-0.974170437, -0.2115201, -0.0917583114]
    let sc = [-0.763276255, -0.608633767, -0.216735543]
    let sn = faws.ldn(3, b, ob, sc)
    vvd(sn[0], -0.7632762579693333866, 1e-12, "ldn", "1")
    vvd(sn[1], -0.6086337636093002660, 1e-12, "ldn", "2")
    vvd(sn[2], -0.2167355420646328159, 1e-12, "ldn", "3")
}

func t_ldsun() {
    let p = [-0.763276255, -0.608633767, -0.216735543]
    let e = [-0.973644023, -0.20925523, -0.0907169552]
    let em = 0.999809214
    let p1 = faws.ldsun(p, e, em)
    vvd(p1[0], -0.7632762580731413169, 1e-12, "ldsun", "1")
    vvd(p1[1], -0.6086337635262647900, 1e-12, "ldsun", "2")
    vvd(p1[2], -0.2167355419322321302, 1e-12, "ldsun", "3")
}

func t_lteceq() {
    let epj = 2500.0
    let dl = 1.5
    let db = 0.6
    let (dr, dd) = faws.lteceq(epj, dl, db)
    vvd(dr, 1.275156021861921167, 1e-14, "lteceq", "dr")
    vvd(dd, 0.9966573543519204791, 1e-14, "lteceq", "dd")
}

func t_ltecm() {
    let epj = -3000.0
    let rm = faws.ltecm(epj)
    vvd(rm[0][0], 0.3564105644859788825, 1e-14, "ltecm", "rm11")
    vvd(rm[0][1], 0.8530575738617682284, 1e-14, "ltecm", "rm12")
    vvd(rm[0][2], 0.3811355207795060435, 1e-14, "ltecm", "rm13")
    vvd(rm[1][0], -0.9343283469640709942, 1e-14, "ltecm", "rm21")
    vvd(rm[1][1], 0.3247830597681745976, 1e-14, "ltecm", "rm22")
    vvd(rm[1][2], 0.1467872751535940865, 1e-14, "ltecm", "rm23")
    vvd(rm[2][0], 0.1431636191201167793e-2, 1e-14, "ltecm", "rm31")
    vvd(rm[2][1], -0.4084222566960599342, 1e-14, "ltecm", "rm32")
    vvd(rm[2][2], 0.9127919865189030899, 1e-14, "ltecm", "rm33")
}

func t_lteqec() {
    let epj = -1500.0
    let dr = 1.234
    let dd = 0.987
    let (dl, db) = faws.lteqec(epj, dr, dd)
    vvd(dl, 0.5039483649047114859, 1e-14, "lteqec", "dl")
    vvd(db, 0.5848534459726224882, 1e-14, "lteqec", "db")
}

func t_ltp() {
    let epj = 1666.666
    let rp = faws.ltp(epj)
    vvd(rp[0][0], 0.9967044141159213819, 1e-14, "ltp", "rp11")
    vvd(rp[0][1], 0.7437801893193210840e-1, 1e-14, "ltp", "rp12")
    vvd(rp[0][2], 0.3237624409345603401e-1, 1e-14, "ltp", "rp13")
    vvd(rp[1][0], -0.7437802731819618167e-1, 1e-14, "ltp", "rp21")
    vvd(rp[1][1], 0.9972293894454533070, 1e-14, "ltp", "rp22")
    vvd(rp[1][2], -0.1205768842723593346e-2, 1e-14, "ltp", "rp23")
    vvd(rp[2][0], -0.3237622482766575399e-1, 1e-14, "ltp", "rp31")
    vvd(rp[2][1], -0.1206286039697609008e-2, 1e-14, "ltp", "rp32")
    vvd(rp[2][2], 0.9994750246704010914, 1e-14, "ltp", "rp33")
}

func t_ltpb() {
    let epj = 1666.666
    let rpb = faws.ltpb(epj)
    vvd(rpb[0][0], 0.9967044167723271851, 1e-14, "ltpb", "rpb11")
    vvd(rpb[0][1], 0.7437794731203340345e-1, 1e-14, "ltpb", "rpb12")
    vvd(rpb[0][2], 0.3237632684841625547e-1, 1e-14, "ltpb", "rpb13")
    vvd(rpb[1][0], -0.7437795663437177152e-1, 1e-14, "ltpb", "rpb21")
    vvd(rpb[1][1], 0.9972293947500013666, 1e-14, "ltpb", "rpb22")
    vvd(rpb[1][2], -0.1205741865911243235e-2, 1e-14, "ltpb", "rpb23")
    vvd(rpb[2][0], -0.3237630543224664992e-1, 1e-14, "ltpb", "rpb31")
    vvd(rpb[2][1], -0.1206316791076485295e-2, 1e-14, "ltpb", "rpb32")
    vvd(rpb[2][2], 0.9994750220222438819, 1e-14, "ltpb", "rpb33")
}

func t_ltpecl() {
    let epj = -1500.0
    let vec = faws.ltpecl(epj)
    vvd(vec[0], 0.4768625676477096525e-3, 1e-14, "ltpecl", "vec1")
    vvd(vec[1], -0.4052259533091875112, 1e-14, "ltpecl", "vec2")
    vvd(vec[2], 0.9142164401096448012, 1e-14, "ltpecl", "vec3")
}

func t_ltpequ() {
    let epj = -2500.0
    let veq = faws.ltpequ(epj)
    vvd(veq[0], -0.3586652560237326659, 1e-14, "ltpequ", "veq1")
    vvd(veq[1], -0.1996978910771128475, 1e-14, "ltpequ", "veq2")
    vvd(veq[2], 0.9118552442250819624, 1e-14, "ltpequ", "veq3")
}

func t_moon98() {
    let pv = faws.moon98(2400000.5, 43999.9)
    vvd(pv[0][0], -0.2601295959971044180e-2, 1e-11, "moon98", "x 4")
    vvd(pv[0][1], 0.6139750944302742189e-3, 1e-11, "moon98", "y 4")
    vvd(pv[0][2], 0.2640794528229828909e-3, 1e-11, "moon98", "z 4")
    vvd(pv[1][0], -0.1244321506649895021e-3, 1e-11, "moon98", "xd 4")
    vvd(pv[1][1], -0.5219076942678119398e-3, 1e-11, "moon98", "yd 4")
    vvd(pv[1][2], -0.1716132214378462047e-3, 1e-11, "moon98", "zd 4")
}

func t_num00a() {
    let rmatn = faws.num00a(2400000.5, 53736.0)
    vvd(rmatn[0][0], 0.9999999999536227949, 1e-12, "num00a", "11")
    vvd(rmatn[0][1], 0.8836238544090873336e-5, 1e-12, "num00a", "12")
    vvd(rmatn[0][2], 0.3830835237722400669e-5, 1e-12, "num00a", "13")
    vvd(rmatn[1][0], -0.8836082880798569274e-5, 1e-12, "num00a", "21")
    vvd(rmatn[1][1], 0.9999999991354655028, 1e-12, "num00a", "22")
    vvd(rmatn[1][2], -0.4063240865362499850e-4, 1e-12, "num00a", "23")
    vvd(rmatn[2][0], -0.3831194272065995866e-5, 1e-12, "num00a", "31")
    vvd(rmatn[2][1], 0.4063237480216291775e-4, 1e-12, "num00a", "32")
    vvd(rmatn[2][2], 0.9999999991671660338, 1e-12, "num00a", "33")
}

func t_num00b() {
    let rmatn = faws.num00b(2400000.5, 53736)
    vvd(rmatn[0][0], 0.9999999999536069682, 1e-12, "num00b", "11")
    vvd(rmatn[0][1], 0.8837746144871248011e-5, 1e-12, "num00b", "12")
    vvd(rmatn[0][2], 0.3831488838252202945e-5, 1e-12, "num00b", "13")
    vvd(rmatn[1][0], -0.8837590456632304720e-5, 1e-12, "num00b", "21")
    vvd(rmatn[1][1], 0.9999999991354692733, 1e-12, "num00b", "22")
    vvd(rmatn[1][2], -0.4063198798559591654e-4, 1e-12, "num00b", "23")
    vvd(rmatn[2][0], -0.3831847930134941271e-5, 1e-12, "num00b", "31")
    vvd(rmatn[2][1], 0.4063195412258168380e-4, 1e-12, "num00b", "32")
    vvd(rmatn[2][2], 0.9999999991671806225, 1e-12, "num00b", "33")
}

func t_num06a() {
    let rmatn = faws.num06a(2400000.5, 53736)
    vvd(rmatn[0][0], 0.9999999999536227668, 1e-12, "num06a", "11")
    vvd(rmatn[0][1], 0.8836241998111535233e-5, 1e-12, "num06a", "12")
    vvd(rmatn[0][2], 0.3830834608415287707e-5, 1e-12, "num06a", "13")
    vvd(rmatn[1][0], -0.8836086334870740138e-5, 1e-12, "num06a", "21")
    vvd(rmatn[1][1], 0.9999999991354657474, 1e-12, "num06a", "22")
    vvd(rmatn[1][2], -0.4063240188248455065e-4, 1e-12, "num06a", "23")
    vvd(rmatn[2][0], -0.3831193642839398128e-5, 1e-12, "num06a", "31")
    vvd(rmatn[2][1], 0.4063236803101479770e-4, 1e-12, "num06a", "32")
    vvd(rmatn[2][2], 0.9999999991671663114, 1e-12, "num06a", "33")
}

func t_numat() {
    let epsa =  0.4090789763356509900
    let dpsi = -0.9630909107115582393e-5
    let deps =  0.4063239174001678826e-4
    let rmatn = faws.numat(epsa, dpsi, deps)
    vvd(rmatn[0][0], 0.9999999999536227949, 1e-12, "numat", "11")
    vvd(rmatn[0][1], 0.8836239320236250577e-5, 1e-12, "numat", "12")
    vvd(rmatn[0][2], 0.3830833447458251908e-5, 1e-12, "numat", "13")
    vvd(rmatn[1][0], -0.8836083657016688588e-5, 1e-12, "numat", "21")
    vvd(rmatn[1][1], 0.9999999991354654959, 1e-12, "numat", "22")
    vvd(rmatn[1][2], -0.4063240865361857698e-4, 1e-12, "numat", "23")
    vvd(rmatn[2][0], -0.3831192481833385226e-5, 1e-12, "numat", "31")
    vvd(rmatn[2][1], 0.4063237480216934159e-4, 1e-12, "numat", "32")
    vvd(rmatn[2][2], 0.9999999991671660407, 1e-12, "numat", "33")
}

func t_nut00a() {
    let (dpsi, deps) = faws.nut00a(2400000.5, 53736.0)
    vvd(dpsi, -0.9630909107115518431e-5, 1e-13, "nut00a", "dpsi")
    vvd(deps,  0.4063239174001678710e-4, 1e-13, "nut00a", "deps")
}

func t_nut00b() {
    let (dpsi, deps) = faws.nut00b(2400000.5, 53736.0)
    vvd(dpsi, -0.9632552291148362783e-5, 1e-13, "nut00b", "dpsi")
    vvd(deps,  0.4063197106621159367e-4, 1e-13, "nut00b", "deps")
}

func t_nut06a() {
    let (dpsi, deps) = faws.nut06a(2400000.5, 53736.0)
    vvd(dpsi, -0.9630912025820308797e-5, 1e-13, "nut06a", "dpsi")
    vvd(deps,  0.4063238496887249798e-4, 1e-13, "nut06a", "deps")
}

func t_nut80() {
    let (dpsi, deps) = faws.nut80(2400000.5, 53736.0)
    vvd(dpsi, -0.9643658353226563966e-5, 1e-13, "nut80", "dpsi")
    vvd(deps,  0.4060051006879713322e-4, 1e-13, "nut80", "deps")
}

func t_nutm80() {
    let rmatn = faws.nutm80(2400000.5, 53736.0)
    vvd(rmatn[0][0], 0.9999999999534999268, 1e-12, "nutm80", "11")
    vvd(rmatn[0][1], 0.8847935789636432161e-5, 1e-12, "nutm80", "12")
    vvd(rmatn[0][2], 0.3835906502164019142e-5, 1e-12, "nutm80", "13")
    vvd(rmatn[1][0], -0.8847780042583435924e-5, 1e-12, "nutm80", "21")
    vvd(rmatn[1][1], 0.9999999991366569963, 1e-12, "nutm80", "22")
    vvd(rmatn[1][2], -0.4060052702727130809e-4, 1e-12, "nutm80", "23")
    vvd(rmatn[2][0], -0.3836265729708478796e-5, 1e-12, "nutm80", "31")
    vvd(rmatn[2][1], 0.4060049308612638555e-4, 1e-12, "nutm80", "32")
    vvd(rmatn[2][2], 0.9999999991684415129, 1e-12, "nutm80", "33")
}

func t_obl06() {
    vvd(faws.obl06(2400000.5, 54388.0), 0.4090749229387258204, 1e-14, "obl06", "")
}

func t_obl80() {
    let eps0 = faws.obl80(2400000.5, 54388.0)
    vvd(eps0, 0.4090751347643816218, 1e-14, "obl80", "")
}

func t_p06e() {
    let (eps0, psia, oma, bpa, bqa, pia, bpia, epsa, chia, za, zetaa, thetaa, pa, gam, phi, psi) = faws.p06e(2400000.5, 52541.0)
    vvd(eps0, 0.4090926006005828715, 1e-14, "p06e", "eps0")
    vvd(psia, 0.6664369630191613431e-3, 1e-14, "p06e", "psia")
    vvd(oma , 0.4090925973783255982, 1e-14, "p06e", "oma")
    vvd(bpa, 0.5561149371265209445e-6, 1e-14, "p06e", "bpa")
    vvd(bqa, -0.6191517193290621270e-5, 1e-14, "p06e", "bqa")
    vvd(pia, 0.6216441751884382923e-5, 1e-14, "p06e", "pia")
    vvd(bpia, 3.052014180023779882, 1e-14, "p06e", "bpia")
    vvd(epsa, 0.4090864054922431688, 1e-14, "p06e", "epsa")
    vvd(chia, 0.1387703379530915364e-5, 1e-14, "p06e", "chia")
    vvd(za, 0.2921789846651790546e-3, 1e-14, "p06e", "za")
    vvd(zetaa, 0.3178773290332009310e-3, 1e-14, "p06e", "zetaa")
    vvd(thetaa, 0.2650932701657497181e-3, 1e-14, "p06e", "thetaa")
    vvd(pa, 0.6651637681381016288e-3, 1e-14, "p06e", "pa")
    vvd(gam, 0.1398077115963754987e-5, 1e-14, "p06e", "gam")
    vvd(phi, 0.4090864090837462602, 1e-14, "p06e", "phi")
    vvd(psi, 0.6664464807480920325e-3, 1e-14, "p06e", "psi")
}

func t_p2pv() {
    let p = [0.25, 1.2, 3.0]
    let pv = faws.p2pv(p)
    vvd(pv[0][0], 0.25, 0.0, "p2pv", "p1")
    vvd(pv[0][1], 1.2,  0.0, "p2pv", "p2")
    vvd(pv[0][2], 3.0,  0.0, "p2pv", "p3")
    vvd(pv[1][0], 0.0,  0.0, "p2pv", "v1")
    vvd(pv[1][1], 0.0,  0.0, "p2pv", "v2")
    vvd(pv[1][2], 0.0,  0.0, "p2pv", "v3")
}

func t_p2s() {
    let p = [100.0, -50.0, 25.0]
    let (theta, phi, r) = faws.p2s(p)
    vvd(theta, -0.4636476090008061162, 1e-12, "p2s", "theta")
    vvd(phi, 0.2199879773954594463, 1e-12, "p2s", "phi")
    vvd(r, 114.5643923738960002, 1e-9, "p2s", "r")
}

func t_pap() {
    let a = [1.0, 0.1, 0.2]
    let b = [-3.0, 1e-3, 0.2]
    let theta = faws.pap(a, b)
    vvd(theta, 0.3671514267841113674, 1e-12, "pap", "")
}

func t_pas() {
    let al = 1.0
    let ap = 0.1
    let bl = 0.2
    let bp = -1.0
    let theta = faws.pas(al, ap, bl, bp)
    vvd(theta, -2.724544922932270424, 1e-12, "pas", "")
}

func t_pb06() {
    let (bzeta, bz, btheta) = faws.pb06(2400000.5, 50123.9999)
    vvd(bzeta, -0.5092634016326478238e-3, 1e-12, "pb06", "bzeta")
    vvd(bz, -0.3602772060566044413e-3, 1e-12, "pb06", "bz")
    vvd(btheta, -0.3779735537167811177e-3, 1e-12, "pb06", "btheta")
}

func t_pdp() {
    let a = [2.0, 2.0, 3.0]
    let b = [1.0, 3.0, 4.0]
    let adb = faws.pdp(a, b)
    vvd(adb, 20, 1e-12, "pdp", "")
}

func t_pfw06() {
    let (gamb, phib, psib, epsa) = faws.pfw06(2400000.5, 50123.9999)
    vvd(gamb, -0.2243387670997995690e-5, 1e-16, "pfw06", "gamb")
    vvd(phib,  0.4091014602391312808, 1e-12, "pfw06", "phib")
    vvd(psib, -0.9501954178013031895e-3, 1e-14, "pfw06", "psib")
    vvd(epsa,  0.4091014316587367491, 1e-12, "pfw06", "epsa")
}

func t_plan94() {
    var pv = faws.zpv()
    pv = faws.plan94(2400000.5, -320000.0, 3)
    vvd(pv[0][0], 0.9308038666832975759, 1e-11, "plan94", "x 3")
    vvd(pv[0][1], 0.3258319040261346000, 1e-11, "plan94", "y 3")
    vvd(pv[0][2], 0.1422794544481140560, 1e-11, "plan94", "z 3")
    vvd(pv[1][0], -0.6429458958255170006e-2, 1e-11, "plan94", "xd 3")
    vvd(pv[1][1], 0.1468570657704237764e-1, 1e-11, "plan94", "yd 3")
    vvd(pv[1][2], 0.6406996426270981189e-2, 1e-11, "plan94", "zd 3")
    pv = faws.plan94(2400000.5, 43999.9, 1)
    vvd(pv[0][0], 0.2945293959257430832, 1e-11, "plan94", "x 4")
    vvd(pv[0][1], -0.2452204176601049596, 1e-11, "plan94", "y 4")
    vvd(pv[0][2], -0.1615427700571978153, 1e-11, "plan94", "z 4")
    vvd(pv[1][0], 0.1413867871404614441e-1, 1e-11, "plan94", "xd 4")
    vvd(pv[1][1], 0.1946548301104706582e-1, 1e-11, "plan94", "yd 4")
    vvd(pv[1][2], 0.8929809783898904786e-2, 1e-11, "plan94", "zd 4")
}

func t_pmat00() {
    let rbp = faws.pmat00(2400000.5, 50123.9999)
    vvd(rbp[0][0], 0.9999995505175087260, 1e-12, "pmat00", "11")
    vvd(rbp[0][1], 0.8695405883617884705e-3, 1e-14, "pmat00", "12")
    vvd(rbp[0][2], 0.3779734722239007105e-3, 1e-14, "pmat00", "13")
    vvd(rbp[1][0], -0.8695405990410863719e-3, 1e-14, "pmat00", "21")
    vvd(rbp[1][1], 0.9999996219494925900, 1e-12, "pmat00", "22")
    vvd(rbp[1][2], -0.1360775820404982209e-6, 1e-14, "pmat00", "23")
    vvd(rbp[2][0], -0.3779734476558184991e-3, 1e-14, "pmat00", "31")
    vvd(rbp[2][1], -0.1925857585832024058e-6, 1e-14, "pmat00", "32")
    vvd(rbp[2][2], 0.9999999285680153377, 1e-12, "pmat00", "33")
}

func t_pmat06() {
    let rbp = faws.pmat06(2400000.5, 50123.9999)
    vvd(rbp[0][0], 0.9999995505176007047, 1e-12, "pmat06", "11")
    vvd(rbp[0][1], 0.8695404617348208406e-3, 1e-14, "pmat06", "12")
    vvd(rbp[0][2], 0.3779735201865589104e-3, 1e-14, "pmat06", "13")
    vvd(rbp[1][0], -0.8695404723772031414e-3, 1e-14, "pmat06", "21")
    vvd(rbp[1][1], 0.9999996219496027161, 1e-12, "pmat06", "22")
    vvd(rbp[1][2], -0.1361752497080270143e-6, 1e-14, "pmat06", "23")
    vvd(rbp[2][0], -0.3779734957034089490e-3, 1e-14, "pmat06", "31")
    vvd(rbp[2][1], -0.1924880847894457113e-6, 1e-14, "pmat06", "32")
    vvd(rbp[2][2], 0.9999999285679971958, 1e-12, "pmat06", "33")
}

func t_pmat76() {
    let rmatp = faws.pmat76(2400000.5, 50123.9999)
    vvd(rmatp[0][0], 0.9999995504328350733, 1e-12, "pmat76", "11")
    vvd(rmatp[0][1], 0.8696632209480960785e-3, 1e-14, "pmat76", "12")
    vvd(rmatp[0][2], 0.3779153474959888345e-3, 1e-14, "pmat76", "13")
    vvd(rmatp[1][0], -0.8696632209485112192e-3, 1e-14, "pmat76", "21")
    vvd(rmatp[1][1], 0.9999996218428560614, 1e-12, "pmat76", "22")
    vvd(rmatp[1][2], -0.1643284776111886407e-6, 1e-14, "pmat76", "23")
    vvd(rmatp[2][0], -0.3779153474950335077e-3, 1e-14, "pmat76", "31")
    vvd(rmatp[2][1], -0.1643306746147366896e-6, 1e-14, "pmat76", "32")
    vvd(rmatp[2][2], 0.9999999285899790119, 1e-12, "pmat76", "33")
}

func t_pm() {
    let p = [0.3, 1.2, -2.5]
    let r = faws.pm(p)
    vvd(r, 2.789265136196270604, 1e-12, "pm", "")
}

func t_pmp() {
    let a = [2.0, 2.0, 3.0]
    let b = [1.0, 3.0, 4.0]
    let amb = faws.pmp(a, b)
    vvd(amb[0],  1.0, 1e-12, "pmp", "0")
    vvd(amb[1], -1.0, 1e-12, "pmp", "1")
    vvd(amb[2], -1.0, 1e-12, "pmp", "2")
}

func t_pmpx() {
    let rc = 1.234
    let dc = 0.789
    let pr = 1e-5
    let pd = -2e-5
    let px = 1e-2
    let rv = 10.0
    let pmt = 8.75
    let pob = [0.9, 0.4, 0.1]
    let pco = faws.pmpx(rc, dc, pr, pd, px, rv, pmt, pob)
    vvd(pco[0], 0.2328137623960308438, 1e-12, "pmpx", "1")
    vvd(pco[1], 0.6651097085397855328, 1e-12, "pmpx", "2")
    vvd(pco[2], 0.7095257765896359837, 1e-12, "pmpx", "3")
}

func t_pmsafe() {
    let ra1 = 1.234
    let dec1 = 0.789
    let pmr1 = 1e-5
    let pmd1 = -2e-5
    let px1 = 1e-2
    let rv1 = 10.0
    let ep1a = 2400000.5
    let ep1b = 48348.5625
    let ep2a = 2400000.5
    let ep2b = 51544.5
    let (ra2, dec2, pmr2, pmd2, px2, rv2) = faws.pmsafe(ra1, dec1, pmr1, pmd1, px1, rv1, ep1a, ep1b, ep2a, ep2b)
    vvd(ra2, 1.234087484501017061, 1e-12, "pmsafe", "ra2")
    vvd(dec2, 0.7888249982450468567, 1e-12, "pmsafe", "dec2")
    vvd(pmr2, 0.9996457663586073988e-5, 1e-12, "pmsafe", "pmr2")
    vvd(pmd2, -0.2000040085106754565e-4, 1e-16, "pmsafe", "pmd2")
    vvd(px2, 0.9999997295356830666e-2, 1e-12, "pmsafe", "px2")
    vvd(rv2, 10.38468380293920069, 1e-10, "pmsafe", "rv2")
}

func t_pn() {
    let p = [0.3, 1.2, -2.5]
    let (r, u) = faws.pn(p)
    vvd(r, 2.789265136196270604, 1e-12, "pn", "r")
    vvd(u[0], 0.1075552109073112058, 1e-12, "pn", "u1")
    vvd(u[1], 0.4302208436292448232, 1e-12, "pn", "u2")
    vvd(u[2], -0.8962934242275933816, 1e-12, "pn", "u3")
}

func t_pn00() {
    let dpsi = -0.9632552291149335877e-5
    let deps =  0.4063197106621141414e-4
    let (epsa, rb, rp, rbp, rn, rbpn) = faws.pn00(2400000.5, 53736.0, dpsi, deps)
    vvd(epsa, 0.4090791789404229916, 1e-12, "pn00", "epsa")
    vvd(rb[0][0], 0.9999999999999942498, 1e-12, "pn00", "rb11")
    vvd(rb[0][1], -0.7078279744199196626e-7, 1e-18, "pn00", "rb12")
    vvd(rb[0][2], 0.8056217146976134152e-7, 1e-18, "pn00", "rb13")
    vvd(rb[1][0], 0.7078279477857337206e-7, 1e-18, "pn00", "rb21")
    vvd(rb[1][1], 0.9999999999999969484, 1e-12, "pn00", "rb22")
    vvd(rb[1][2], 0.3306041454222136517e-7, 1e-18, "pn00", "rb23")
    vvd(rb[2][0], -0.8056217380986972157e-7, 1e-18, "pn00", "rb31")
    vvd(rb[2][1], -0.3306040883980552500e-7, 1e-18, "pn00", "rb32")
    vvd(rb[2][2], 0.9999999999999962084, 1e-12, "pn00", "rb33")
    vvd(rp[0][0], 0.9999989300532289018, 1e-12, "pn00", "rp11")
    vvd(rp[0][1], -0.1341647226791824349e-2, 1e-14, "pn00", "rp12")
    vvd(rp[0][2], -0.5829880927190296547e-3, 1e-14, "pn00", "rp13")
    vvd(rp[1][0], 0.1341647231069759008e-2, 1e-14, "pn00", "rp21")
    vvd(rp[1][1], 0.9999990999908750433, 1e-12, "pn00", "rp22")
    vvd(rp[1][2], -0.3837444441583715468e-6, 1e-14, "pn00", "rp23")
    vvd(rp[2][0], 0.5829880828740957684e-3, 1e-14, "pn00", "rp31")
    vvd(rp[2][1], -0.3984203267708834759e-6, 1e-14, "pn00", "rp32")
    vvd(rp[2][2], 0.9999998300623538046, 1e-12, "pn00", "rp33")
    vvd(rbp[0][0], 0.9999989300052243993, 1e-12, "pn00", "rbp11")
    vvd(rbp[0][1], -0.1341717990239703727e-2, 1e-14, "pn00", "rbp12")
    vvd(rbp[0][2], -0.5829075749891684053e-3, 1e-14, "pn00", "rbp13")
    vvd(rbp[1][0], 0.1341718013831739992e-2, 1e-14, "pn00", "rbp21")
    vvd(rbp[1][1], 0.9999990998959191343, 1e-12, "pn00", "rbp22")
    vvd(rbp[1][2], -0.3505759733565421170e-6, 1e-14, "pn00", "rbp23")
    vvd(rbp[2][0], 0.5829075206857717883e-3, 1e-14, "pn00", "rbp31")
    vvd(rbp[2][1], -0.4315219955198608970e-6, 1e-14, "pn00", "rbp32")
    vvd(rbp[2][2], 0.9999998301093036269, 1e-12, "pn00", "rbp33")
    vvd(rn[0][0], 0.9999999999536069682, 1e-12, "pn00", "rn11")
    vvd(rn[0][1], 0.8837746144872140812e-5, 1e-16, "pn00", "rn12")
    vvd(rn[0][2], 0.3831488838252590008e-5, 1e-16, "pn00", "rn13")
    vvd(rn[1][0], -0.8837590456633197506e-5, 1e-16, "pn00", "rn21")
    vvd(rn[1][1], 0.9999999991354692733, 1e-12, "pn00", "rn22")
    vvd(rn[1][2], -0.4063198798559573702e-4, 1e-16, "pn00", "rn23")
    vvd(rn[2][0], -0.3831847930135328368e-5, 1e-16, "pn00", "rn31")
    vvd(rn[2][1], 0.4063195412258150427e-4, 1e-16, "pn00", "rn32")
    vvd(rn[2][2], 0.9999999991671806225, 1e-12, "pn00", "rn33")
    vvd(rbpn[0][0], 0.9999989440499982806, 1e-12, "pn00", "rbpn11")
    vvd(rbpn[0][1], -0.1332880253640848301e-2, 1e-14, "pn00", "rbpn12")
    vvd(rbpn[0][2], -0.5790760898731087295e-3, 1e-14, "pn00", "rbpn13")
    vvd(rbpn[1][0], 0.1332856746979948745e-2, 1e-14, "pn00", "rbpn21")
    vvd(rbpn[1][1], 0.9999991109064768883, 1e-12, "pn00", "rbpn22")
    vvd(rbpn[1][2], -0.4097740555723063806e-4, 1e-14, "pn00", "rbpn23")
    vvd(rbpn[2][0], 0.5791301929950205000e-3, 1e-14, "pn00", "rbpn31")
    vvd(rbpn[2][1], 0.4020553681373702931e-4, 1e-14, "pn00", "rbpn32")
    vvd(rbpn[2][2], 0.9999998314958529887, 1e-12, "pn00", "rbpn33")
}

func t_pn00a() {
    let (dpsi, deps, epsa, rb, rp, rbp, rn, rbpn) = faws.pn00a(2400000.5, 53736.0)
    vvd(dpsi, -0.9630909107115518431e-5, 1e-12, "pn00a", "dpsi")
    vvd(deps,  0.4063239174001678710e-4, 1e-12, "pn00a", "deps")
    vvd(epsa,  0.4090791789404229916, 1e-12, "pn00a", "epsa")
    vvd(rb[0][0], 0.9999999999999942498, 1e-12, "pn00a", "rb11")
    vvd(rb[0][1], -0.7078279744199196626e-7, 1e-16, "pn00a", "rb12")
    vvd(rb[0][2], 0.8056217146976134152e-7, 1e-16, "pn00a", "rb13")
    vvd(rb[1][0], 0.7078279477857337206e-7, 1e-16, "pn00a", "rb21")
    vvd(rb[1][1], 0.9999999999999969484, 1e-12, "pn00a", "rb22")
    vvd(rb[1][2], 0.3306041454222136517e-7, 1e-16, "pn00a", "rb23")
    vvd(rb[2][0], -0.8056217380986972157e-7, 1e-16, "pn00a", "rb31")
    vvd(rb[2][1], -0.3306040883980552500e-7, 1e-16, "pn00a", "rb32")
    vvd(rb[2][2], 0.9999999999999962084, 1e-12, "pn00a", "rb33")
    vvd(rp[0][0], 0.9999989300532289018, 1e-12, "pn00a", "rp11")
    vvd(rp[0][1], -0.1341647226791824349e-2, 1e-14, "pn00a", "rp12")
    vvd(rp[0][2], -0.5829880927190296547e-3, 1e-14, "pn00a", "rp13")
    vvd(rp[1][0], 0.1341647231069759008e-2, 1e-14, "pn00a", "rp21")
    vvd(rp[1][1], 0.9999990999908750433, 1e-12, "pn00a", "rp22")
    vvd(rp[1][2], -0.3837444441583715468e-6, 1e-14, "pn00a", "rp23")
    vvd(rp[2][0], 0.5829880828740957684e-3, 1e-14, "pn00a", "rp31")
    vvd(rp[2][1], -0.3984203267708834759e-6, 1e-14, "pn00a", "rp32")
    vvd(rp[2][2], 0.9999998300623538046, 1e-12, "pn00a", "rp33")
    vvd(rbp[0][0], 0.9999989300052243993, 1e-12, "pn00a", "rbp11")
    vvd(rbp[0][1], -0.1341717990239703727e-2, 1e-14, "pn00a", "rbp12")
    vvd(rbp[0][2], -0.5829075749891684053e-3, 1e-14, "pn00a", "rbp13")
    vvd(rbp[1][0], 0.1341718013831739992e-2, 1e-14, "pn00a", "rbp21")
    vvd(rbp[1][1], 0.9999990998959191343, 1e-12, "pn00a", "rbp22")
    vvd(rbp[1][2], -0.3505759733565421170e-6, 1e-14, "pn00a", "rbp23")
    vvd(rbp[2][0], 0.5829075206857717883e-3, 1e-14, "pn00a", "rbp31")
    vvd(rbp[2][1], -0.4315219955198608970e-6, 1e-14, "pn00a", "rbp32")
    vvd(rbp[2][2], 0.9999998301093036269, 1e-12, "pn00a", "rbp33")
    vvd(rn[0][0], 0.9999999999536227949, 1e-12, "pn00a", "rn11")
    vvd(rn[0][1], 0.8836238544090873336e-5, 1e-14, "pn00a", "rn12")
    vvd(rn[0][2], 0.3830835237722400669e-5, 1e-14, "pn00a", "rn13")
    vvd(rn[1][0], -0.8836082880798569274e-5, 1e-14, "pn00a", "rn21")
    vvd(rn[1][1], 0.9999999991354655028, 1e-12, "pn00a", "rn22")
    vvd(rn[1][2], -0.4063240865362499850e-4, 1e-14, "pn00a", "rn23")
    vvd(rn[2][0], -0.3831194272065995866e-5, 1e-14, "pn00a", "rn31")
    vvd(rn[2][1], 0.4063237480216291775e-4, 1e-14, "pn00a", "rn32")
    vvd(rn[2][2], 0.9999999991671660338, 1e-12, "pn00a", "rn33")
    vvd(rbpn[0][0], 0.9999989440476103435, 1e-12, "pn00a", "rbpn11")
    vvd(rbpn[0][1], -0.1332881761240011763e-2, 1e-14, "pn00a", "rbpn12")
    vvd(rbpn[0][2], -0.5790767434730085751e-3, 1e-14, "pn00a", "rbpn13")
    vvd(rbpn[1][0], 0.1332858254308954658e-2, 1e-14, "pn00a", "rbpn21")
    vvd(rbpn[1][1], 0.9999991109044505577, 1e-12, "pn00a", "rbpn22")
    vvd(rbpn[1][2], -0.4097782710396580452e-4, 1e-14, "pn00a", "rbpn23")
    vvd(rbpn[2][0], 0.5791308472168152904e-3, 1e-14, "pn00a", "rbpn31")
    vvd(rbpn[2][1], 0.4020595661591500259e-4, 1e-14, "pn00a", "rbpn32")
    vvd(rbpn[2][2], 0.9999998314954572304, 1e-12, "pn00a", "rbpn33")
}

func t_pn00b() {
    let (dpsi, deps, epsa, rb, rp, rbp, rn, rbpn) = faws.pn00b(2400000.5, 53736.0)
    vvd(dpsi, -0.9632552291148362783e-5, 1e-12, "pn00b", "dpsi")
    vvd(deps,  0.4063197106621159367e-4, 1e-12, "pn00b", "deps")
    vvd(epsa,  0.4090791789404229916, 1e-12, "pn00b", "epsa")
    vvd(rb[0][0], 0.9999999999999942498, 1e-12, "pn00b", "rb11")
    vvd(rb[0][1], -0.7078279744199196626e-7, 1e-16, "pn00b", "rb12")
    vvd(rb[0][2], 0.8056217146976134152e-7, 1e-16, "pn00b", "rb13")
    vvd(rb[1][0], 0.7078279477857337206e-7, 1e-16, "pn00b", "rb21")
    vvd(rb[1][1], 0.9999999999999969484, 1e-12, "pn00b", "rb22")
    vvd(rb[1][2], 0.3306041454222136517e-7, 1e-16, "pn00b", "rb23")
    vvd(rb[2][0], -0.8056217380986972157e-7, 1e-16, "pn00b", "rb31")
    vvd(rb[2][1], -0.3306040883980552500e-7, 1e-16, "pn00b", "rb32")
    vvd(rb[2][2], 0.9999999999999962084, 1e-12, "pn00b", "rb33")
    vvd(rp[0][0], 0.9999989300532289018, 1e-12, "pn00b", "rp11")
    vvd(rp[0][1], -0.1341647226791824349e-2, 1e-14, "pn00b", "rp12")
    vvd(rp[0][2], -0.5829880927190296547e-3, 1e-14, "pn00b", "rp13")
    vvd(rp[1][0], 0.1341647231069759008e-2, 1e-14, "pn00b", "rp21")
    vvd(rp[1][1], 0.9999990999908750433, 1e-12, "pn00b", "rp22")
    vvd(rp[1][2], -0.3837444441583715468e-6, 1e-14, "pn00b", "rp23")
    vvd(rp[2][0], 0.5829880828740957684e-3, 1e-14, "pn00b", "rp31")
    vvd(rp[2][1], -0.3984203267708834759e-6, 1e-14, "pn00b", "rp32")
    vvd(rp[2][2], 0.9999998300623538046, 1e-12, "pn00b", "rp33")
    vvd(rbp[0][0], 0.9999989300052243993, 1e-12, "pn00b", "rbp11")
    vvd(rbp[0][1], -0.1341717990239703727e-2, 1e-14, "pn00b", "rbp12")
    vvd(rbp[0][2], -0.5829075749891684053e-3, 1e-14, "pn00b", "rbp13")
    vvd(rbp[1][0], 0.1341718013831739992e-2, 1e-14, "pn00b", "rbp21")
    vvd(rbp[1][1], 0.9999990998959191343, 1e-12, "pn00b", "rbp22")
    vvd(rbp[1][2], -0.3505759733565421170e-6, 1e-14, "pn00b", "rbp23")
    vvd(rbp[2][0], 0.5829075206857717883e-3, 1e-14, "pn00b", "rbp31")
    vvd(rbp[2][1], -0.4315219955198608970e-6, 1e-14, "pn00b", "rbp32")
    vvd(rbp[2][2], 0.9999998301093036269, 1e-12, "pn00b", "rbp33")
    vvd(rn[0][0], 0.9999999999536069682, 1e-12, "pn00b", "rn11")
    vvd(rn[0][1], 0.8837746144871248011e-5, 1e-14, "pn00b", "rn12")
    vvd(rn[0][2], 0.3831488838252202945e-5, 1e-14, "pn00b", "rn13")
    vvd(rn[1][0], -0.8837590456632304720e-5, 1e-14, "pn00b", "rn21")
    vvd(rn[1][1], 0.9999999991354692733, 1e-12, "pn00b", "rn22")
    vvd(rn[1][2], -0.4063198798559591654e-4, 1e-14, "pn00b", "rn23")
    vvd(rn[2][0], -0.3831847930134941271e-5, 1e-14, "pn00b", "rn31")
    vvd(rn[2][1], 0.4063195412258168380e-4, 1e-14, "pn00b", "rn32")
    vvd(rn[2][2], 0.9999999991671806225, 1e-12, "pn00b", "rn33")
    vvd(rbpn[0][0], 0.9999989440499982806, 1e-12, "pn00b", "rbpn11")
    vvd(rbpn[0][1], -0.1332880253640849194e-2, 1e-14, "pn00b", "rbpn12")
    vvd(rbpn[0][2], -0.5790760898731091166e-3, 1e-14, "pn00b", "rbpn13")
    vvd(rbpn[1][0], 0.1332856746979949638e-2, 1e-14, "pn00b", "rbpn21")
    vvd(rbpn[1][1], 0.9999991109064768883, 1e-12, "pn00b", "rbpn22")
    vvd(rbpn[1][2], -0.4097740555723081811e-4, 1e-14, "pn00b", "rbpn23")
    vvd(rbpn[2][0], 0.5791301929950208873e-3, 1e-14, "pn00b", "rbpn31")
    vvd(rbpn[2][1], 0.4020553681373720832e-4, 1e-14, "pn00b", "rbpn32")
    vvd(rbpn[2][2], 0.9999998314958529887, 1e-12, "pn00b", "rbpn33")
}

func t_pn06a() {
    let (dpsi, deps, epsa, rb, rp, rbp, rn, rbpn) = faws.pn06a(2400000.5, 53736.0)
    vvd(dpsi, -0.9630912025820308797e-5, 1e-12, "pn06a", "dpsi")
    vvd(deps,  0.4063238496887249798e-4, 1e-12, "pn06a", "deps")
    vvd(epsa,  0.4090789763356509926, 1e-12, "pn06a", "epsa")
    vvd(rb[0][0], 0.9999999999999942497, 1e-12, "pn06a", "rb11")
    vvd(rb[0][1], -0.7078368960971557145e-7, 1e-14, "pn06a", "rb12")
    vvd(rb[0][2], 0.8056213977613185606e-7, 1e-14, "pn06a", "rb13")
    vvd(rb[1][0], 0.7078368694637674333e-7, 1e-14, "pn06a", "rb21")
    vvd(rb[1][1], 0.9999999999999969484, 1e-12, "pn06a", "rb22")
    vvd(rb[1][2], 0.3305943742989134124e-7, 1e-14, "pn06a", "rb23")
    vvd(rb[2][0], -0.8056214211620056792e-7, 1e-14, "pn06a", "rb31")
    vvd(rb[2][1], -0.3305943172740586950e-7, 1e-14, "pn06a", "rb32")
    vvd(rb[2][2], 0.9999999999999962084, 1e-12, "pn06a", "rb33")
    vvd(rp[0][0], 0.9999989300536854831, 1e-12, "pn06a", "rp11")
    vvd(rp[0][1], -0.1341646886204443795e-2, 1e-14, "pn06a", "rp12")
    vvd(rp[0][2], -0.5829880933488627759e-3, 1e-14, "pn06a", "rp13")
    vvd(rp[1][0], 0.1341646890569782183e-2, 1e-14, "pn06a", "rp21")
    vvd(rp[1][1], 0.9999990999913319321, 1e-12, "pn06a", "rp22")
    vvd(rp[1][2], -0.3835944216374477457e-6, 1e-14, "pn06a", "rp23")
    vvd(rp[2][0], 0.5829880833027867368e-3, 1e-14, "pn06a", "rp31")
    vvd(rp[2][1], -0.3985701514686976112e-6, 1e-14, "pn06a", "rp32")
    vvd(rp[2][2], 0.9999998300623534950, 1e-12, "pn06a", "rp33")
    vvd(rbp[0][0], 0.9999989300056797893, 1e-12, "pn06a", "rbp11")
    vvd(rbp[0][1], -0.1341717650545059598e-2, 1e-14, "pn06a", "rbp12")
    vvd(rbp[0][2], -0.5829075756493728856e-3, 1e-14, "pn06a", "rbp13")
    vvd(rbp[1][0], 0.1341717674223918101e-2, 1e-14, "pn06a", "rbp21")
    vvd(rbp[1][1], 0.9999990998963748448, 1e-12, "pn06a", "rbp22")
    vvd(rbp[1][2], -0.3504269280170069029e-6, 1e-14, "pn06a", "rbp23")
    vvd(rbp[2][0], 0.5829075211461454599e-3, 1e-14, "pn06a", "rbp31")
    vvd(rbp[2][1], -0.4316708436255949093e-6, 1e-14, "pn06a", "rbp32")
    vvd(rbp[2][2], 0.9999998301093032943, 1e-12, "pn06a", "rbp33")
    vvd(rn[0][0], 0.9999999999536227668, 1e-12, "pn06a", "rn11")
    vvd(rn[0][1], 0.8836241998111535233e-5, 1e-14, "pn06a", "rn12")
    vvd(rn[0][2], 0.3830834608415287707e-5, 1e-14, "pn06a", "rn13")
    vvd(rn[1][0], -0.8836086334870740138e-5, 1e-14, "pn06a", "rn21")
    vvd(rn[1][1], 0.9999999991354657474, 1e-12, "pn06a", "rn22")
    vvd(rn[1][2], -0.4063240188248455065e-4, 1e-14, "pn06a", "rn23")
    vvd(rn[2][0], -0.3831193642839398128e-5, 1e-14, "pn06a", "rn31")
    vvd(rn[2][1], 0.4063236803101479770e-4, 1e-14, "pn06a", "rn32")
    vvd(rn[2][2], 0.9999999991671663114, 1e-12, "pn06a", "rn33")
    vvd(rbpn[0][0], 0.9999989440480669738, 1e-12, "pn06a", "rbpn11")
    vvd(rbpn[0][1], -0.1332881418091915973e-2, 1e-14, "pn06a", "rbpn12")
    vvd(rbpn[0][2], -0.5790767447612042565e-3, 1e-14, "pn06a", "rbpn13")
    vvd(rbpn[1][0], 0.1332857911250989133e-2, 1e-14, "pn06a", "rbpn21")
    vvd(rbpn[1][1], 0.9999991109049141908, 1e-12, "pn06a", "rbpn22")
    vvd(rbpn[1][2], -0.4097767128546784878e-4, 1e-14, "pn06a", "rbpn23")
    vvd(rbpn[2][0], 0.5791308482835292617e-3, 1e-14, "pn06a", "rbpn31")
    vvd(rbpn[2][1], 0.4020580099454020310e-4, 1e-14, "pn06a", "rbpn32")
    vvd(rbpn[2][2], 0.9999998314954628695, 1e-12, "pn06a", "rbpn33")
}

func t_pn06() {
    let dpsi = -0.9632552291149335877e-5
    let deps =  0.4063197106621141414e-4
    let (epsa, rb, rp, rbp, rn, rbpn) = faws.pn06(2400000.5, 53736.0, dpsi, deps)
    vvd(epsa, 0.4090789763356509926, 1e-12, "pn06", "epsa")
    vvd(rb[0][0], 0.9999999999999942497, 1e-12, "pn06", "rb11")
    vvd(rb[0][1], -0.7078368960971557145e-7, 1e-14, "pn06", "rb12")
    vvd(rb[0][2], 0.8056213977613185606e-7, 1e-14, "pn06", "rb13")
    vvd(rb[1][0], 0.7078368694637674333e-7, 1e-14, "pn06", "rb21")
    vvd(rb[1][1], 0.9999999999999969484, 1e-12, "pn06", "rb22")
    vvd(rb[1][2], 0.3305943742989134124e-7, 1e-14, "pn06", "rb23")
    vvd(rb[2][0], -0.8056214211620056792e-7, 1e-14, "pn06", "rb31")
    vvd(rb[2][1], -0.3305943172740586950e-7, 1e-14, "pn06", "rb32")
    vvd(rb[2][2], 0.9999999999999962084, 1e-12, "pn06", "rb33")
    vvd(rp[0][0], 0.9999989300536854831, 1e-12, "pn06", "rp11")
    vvd(rp[0][1], -0.1341646886204443795e-2, 1e-14, "pn06", "rp12")
    vvd(rp[0][2], -0.5829880933488627759e-3, 1e-14, "pn06", "rp13")
    vvd(rp[1][0], 0.1341646890569782183e-2, 1e-14, "pn06", "rp21")
    vvd(rp[1][1], 0.9999990999913319321, 1e-12, "pn06", "rp22")
    vvd(rp[1][2], -0.3835944216374477457e-6, 1e-14, "pn06", "rp23")
    vvd(rp[2][0], 0.5829880833027867368e-3, 1e-14, "pn06", "rp31")
    vvd(rp[2][1], -0.3985701514686976112e-6, 1e-14, "pn06", "rp32")
    vvd(rp[2][2], 0.9999998300623534950, 1e-12, "pn06", "rp33")
    vvd(rbp[0][0], 0.9999989300056797893, 1e-12, "pn06", "rbp11")
    vvd(rbp[0][1], -0.1341717650545059598e-2, 1e-14, "pn06", "rbp12")
    vvd(rbp[0][2], -0.5829075756493728856e-3, 1e-14, "pn06", "rbp13")
    vvd(rbp[1][0], 0.1341717674223918101e-2, 1e-14, "pn06", "rbp21")
    vvd(rbp[1][1], 0.9999990998963748448, 1e-12, "pn06", "rbp22")
    vvd(rbp[1][2], -0.3504269280170069029e-6, 1e-14, "pn06", "rbp23")
    vvd(rbp[2][0], 0.5829075211461454599e-3, 1e-14, "pn06", "rbp31")
    vvd(rbp[2][1], -0.4316708436255949093e-6, 1e-14, "pn06", "rbp32")
    vvd(rbp[2][2], 0.9999998301093032943, 1e-12, "pn06", "rbp33")
    vvd(rn[0][0], 0.9999999999536069682, 1e-12, "pn06", "rn11")
    vvd(rn[0][1], 0.8837746921149881914e-5, 1e-14, "pn06", "rn12")
    vvd(rn[0][2], 0.3831487047682968703e-5, 1e-14, "pn06", "rn13")
    vvd(rn[1][0], -0.8837591232983692340e-5, 1e-14, "pn06", "rn21")
    vvd(rn[1][1], 0.9999999991354692664, 1e-12, "pn06", "rn22")
    vvd(rn[1][2], -0.4063198798558931215e-4, 1e-14, "pn06", "rn23")
    vvd(rn[2][0], -0.3831846139597250235e-5, 1e-14, "pn06", "rn31")
    vvd(rn[2][1], 0.4063195412258792914e-4, 1e-14, "pn06", "rn32")
    vvd(rn[2][2], 0.9999999991671806293, 1e-12, "pn06", "rn33")
    vvd(rbpn[0][0], 0.9999989440504506688, 1e-12, "pn06", "rbpn11")
    vvd(rbpn[0][1], -0.1332879913170492655e-2, 1e-14, "pn06", "rbpn12")
    vvd(rbpn[0][2], -0.5790760923225655753e-3, 1e-14, "pn06", "rbpn13")
    vvd(rbpn[1][0], 0.1332856406595754748e-2, 1e-14, "pn06", "rbpn21")
    vvd(rbpn[1][1], 0.9999991109069366795, 1e-12, "pn06", "rbpn22")
    vvd(rbpn[1][2], -0.4097725651142641812e-4, 1e-14, "pn06", "rbpn23")
    vvd(rbpn[2][0], 0.5791301952321296716e-3, 1e-14, "pn06", "rbpn31")
    vvd(rbpn[2][1], 0.4020538796195230577e-4, 1e-14, "pn06", "rbpn32")
    vvd(rbpn[2][2], 0.9999998314958576778, 1e-12, "pn06", "rbpn33")
}

func t_pnm00a() {
    let rbpn = faws.pnm00a(2400000.5, 50123.9999)
    vvd(rbpn[0][0], 0.9999995832793134257, 1e-12, "pnm00a", "11")
    vvd(rbpn[0][1], 0.8372384254137809439e-3, 1e-14, "pnm00a", "12")
    vvd(rbpn[0][2], 0.3639684306407150645e-3, 1e-14, "pnm00a", "13")
    vvd(rbpn[1][0], -0.8372535226570394543e-3, 1e-14, "pnm00a", "21")
    vvd(rbpn[1][1], 0.9999996486491582471, 1e-12, "pnm00a", "22")
    vvd(rbpn[1][2], 0.4132915262664072381e-4, 1e-14, "pnm00a", "23")
    vvd(rbpn[2][0], -0.3639337004054317729e-3, 1e-14, "pnm00a", "31")
    vvd(rbpn[2][1], -0.4163386925461775873e-4, 1e-14, "pnm00a", "32")
    vvd(rbpn[2][2], 0.9999999329094390695, 1e-12, "pnm00a", "33")
}

func t_pnm00b() {
    let rbpn = faws.pnm00b(2400000.5, 50123.9999)
    vvd(rbpn[0][0], 0.9999995832776208280, 1e-12, "pnm00b", "11")
    vvd(rbpn[0][1], 0.8372401264429654837e-3, 1e-14, "pnm00b", "12")
    vvd(rbpn[0][2], 0.3639691681450271771e-3, 1e-14, "pnm00b", "13")
    vvd(rbpn[1][0], -0.8372552234147137424e-3, 1e-14, "pnm00b", "21")
    vvd(rbpn[1][1], 0.9999996486477686123, 1e-12, "pnm00b", "22")
    vvd(rbpn[1][2], 0.4132832190946052890e-4, 1e-14, "pnm00b", "23")
    vvd(rbpn[2][0], -0.3639344385341866407e-3, 1e-14, "pnm00b", "31")
    vvd(rbpn[2][1], -0.4163303977421522785e-4, 1e-14, "pnm00b", "32")
    vvd(rbpn[2][2], 0.9999999329092049734, 1e-12, "pnm00b", "33")
}

func t_pnm06a() {
    let rbpn = faws.pnm06a(2400000.5, 50123.9999)
    vvd(rbpn[0][0], 0.9999995832794205484, 1e-12, "pnm06a", "11")
    vvd(rbpn[0][1], 0.8372382772630962111e-3, 1e-14, "pnm06a", "12")
    vvd(rbpn[0][2], 0.3639684771140623099e-3, 1e-14, "pnm06a", "13")
    vvd(rbpn[1][0], -0.8372533744743683605e-3, 1e-14, "pnm06a", "21")
    vvd(rbpn[1][1], 0.9999996486492861646, 1e-12, "pnm06a", "22")
    vvd(rbpn[1][2], 0.4132905944611019498e-4, 1e-14, "pnm06a", "23")
    vvd(rbpn[2][0], -0.3639337469629464969e-3, 1e-14, "pnm06a", "31")
    vvd(rbpn[2][1], -0.4163377605910663999e-4, 1e-14, "pnm06a", "32")
    vvd(rbpn[2][2], 0.9999999329094260057, 1e-12, "pnm06a", "33")
}

func t_pnm80() {
    let rmatpn = faws.pnm80(2400000.5, 50123.9999)
    vvd(rmatpn[0][0], 0.9999995831934611169, 1e-12, "pnm80", "11")
    vvd(rmatpn[0][1], 0.8373654045728124011e-3, 1e-14, "pnm80", "12")
    vvd(rmatpn[0][2], 0.3639121916933106191e-3, 1e-14, "pnm80", "13")
    vvd(rmatpn[1][0], -0.8373804896118301316e-3, 1e-14, "pnm80", "21")
    vvd(rmatpn[1][1], 0.9999996485439674092, 1e-12, "pnm80", "22")
    vvd(rmatpn[1][2], 0.4130202510421549752e-4, 1e-14, "pnm80", "23")
    vvd(rmatpn[2][0], -0.3638774789072144473e-3, 1e-14, "pnm80", "31")
    vvd(rmatpn[2][1], -0.4160674085851722359e-4, 1e-14, "pnm80", "32")
    vvd(rmatpn[2][2], 0.9999999329310274805, 1e-12, "pnm80", "33")
}

func t_pom00() {
    let xp =  2.55060238e-7
    let yp =  1.860359247e-6
    let sp = -0.1367174580728891460e-10
    let rpom = faws.pom00(xp, yp, sp)
    vvd(rpom[0][0], 0.9999999999999674721, 1e-12, "pom00", "11")
    vvd(rpom[0][1], -0.1367174580728846989e-10, 1e-16, "pom00", "12")
    vvd(rpom[0][2], 0.2550602379999972345e-6, 1e-16, "pom00", "13")
    vvd(rpom[1][0], 0.1414624947957029801e-10, 1e-16, "pom00", "21")
    vvd(rpom[1][1], 0.9999999999982695317, 1e-12, "pom00", "22")
    vvd(rpom[1][2], -0.1860359246998866389e-5, 1e-16, "pom00", "23")
    vvd(rpom[2][0], -0.2550602379741215021e-6, 1e-16, "pom00", "31")
    vvd(rpom[2][1], 0.1860359247002414021e-5, 1e-16, "pom00", "32")
    vvd(rpom[2][2], 0.9999999999982370039, 1e-12, "pom00", "33")
}

func t_ppp() {
    let a = [2.0, 2.0, 3.0]
    let b = [1.0, 3.0, 4.0]
    let apb = faws.ppp(a, b)
    vvd(apb[0], 3.0, 1e-12, "ppp", "0")
    vvd(apb[1], 5.0, 1e-12, "ppp", "1")
    vvd(apb[2], 7.0, 1e-12, "ppp", "2")
}

func t_ppsp() {
    let a = [2.0, 2.0, 3.0]
    let b = [1.0, 3.0, 4.0]
    let s = 5.0
    let apsb = faws.ppsp(a, s, b)
    vvd(apsb[0], 7.0, 1e-12, "ppsp", "0")
    vvd(apsb[1], 17.0, 1e-12, "ppsp", "1")
    vvd(apsb[2], 23.0, 1e-12, "ppsp", "2")
}

func t_pr00() {
    let (dpsipr, depspr) = faws.pr00(2400000.5, 53736)
    vvd(dpsipr, -0.8716465172668347629e-7, 1e-22, "pr00", "dpsipr")
    vvd(depspr, -0.7342018386722813087e-8, 1e-22, "pr00", "depspr")
}

func t_prec76() {
    let ep01 = 2400000.5
    let ep02 = 33282.0
    let ep11 = 2400000.5
    let ep12 = 51544.0
    let (zeta, z, theta) = faws.prec76(ep01, ep02, ep11, ep12)
    vvd(zeta, 0.5588961642000161243e-2, 1e-12, "prec76", "zeta")
    vvd(z, 0.5589922365870680624e-2, 1e-12, "prec76", "z")
    vvd(theta, 0.4858945471687296760e-2, 1e-12, "prec76", "theta")
}

func t_pv2p() {
    var pv = faws.zpv()
    pv[0][0] =  0.3
    pv[0][1] =  1.2
    pv[0][2] = -2.5
    pv[1][0] = -0.5
    pv[1][1] =  3.1
    pv[1][2] =  0.9
    let p = faws.pv2p(pv)
    vvd(p[0],  0.3, 0.0, "pv2p", "1")
    vvd(p[1],  1.2, 0.0, "pv2p", "2")
    vvd(p[2], -2.5, 0.0, "pv2p", "3")
}

func t_pv2s() {
    var pv = faws.zpv()
    pv[0][0] = -0.4514964673880165
    pv[0][1] =  0.03093394277342585
    pv[0][2] =  0.05594668105108779
    pv[1][0] =  1.292270850663260e-5
    pv[1][1] =  2.652814182060692e-6
    pv[1][2] =  2.568431853930293e-6
    let (theta, phi, r, td, pd, rd) = faws.pv2s(pv)
    vvd(theta, 3.073185307179586515, 1e-12, "pv2s", "theta")
    vvd(phi, 0.1229999999999999992, 1e-12, "pv2s", "phi")
    vvd(r, 0.4559999999999999757, 1e-12, "pv2s", "r")
    vvd(td, -0.7800000000000000364e-5, 1e-16, "pv2s", "td")
    vvd(pd, 0.9010000000000001639e-5, 1e-16, "pv2s", "pd")
    vvd(rd, -0.1229999999999999832e-4, 1e-16, "pv2s", "rd")
}

func t_pvdpv() {
    var a = faws.zpv()
    var b = faws.zpv()
    a[0][0] = 2.0
    a[0][1] = 2.0
    a[0][2] = 3.0
    a[1][0] = 6.0
    a[1][1] = 0.0
    a[1][2] = 4.0
    b[0][0] = 1.0
    b[0][1] = 3.0
    b[0][2] = 4.0
    b[1][0] = 0.0
    b[1][1] = 2.0
    b[1][2] = 8.0
    let adb = faws.pvdpv(a, b)
    vvd(adb[0], 20.0, 1e-12, "pvdpv", "1")
    vvd(adb[1], 50.0, 1e-12, "pvdpv", "2")
}

func t_pvm() {
    var pv = faws.zpv()
    pv[0][0] =  0.3
    pv[0][1] =  1.2
    pv[0][2] = -2.5
    pv[1][0] =  0.45
    pv[1][1] = -0.25
    pv[1][2] =  1.1
    let (r, s) = faws.pvm(pv)
    vvd(r, 2.789265136196270604, 1e-12, "pvm", "r")
    vvd(s, 1.214495780149111922, 1e-12, "pvm", "s")
}

func t_pvmpv() {
    var a = faws.zpv()
    var b = faws.zpv()
    a[0][0] = 2.0
    a[0][1] = 2.0
    a[0][2] = 3.0
    a[1][0] = 5.0
    a[1][1] = 6.0
    a[1][2] = 3.0
    b[0][0] = 1.0
    b[0][1] = 3.0
    b[0][2] = 4.0
    b[1][0] = 3.0
    b[1][1] = 2.0
    b[1][2] = 1.0
    let amb = faws.pvmpv(a, b)
    vvd(amb[0][0],  1.0, 1e-12, "pvmpv", "11")
    vvd(amb[0][1], -1.0, 1e-12, "pvmpv", "21")
    vvd(amb[0][2], -1.0, 1e-12, "pvmpv", "31")
    vvd(amb[1][0],  2.0, 1e-12, "pvmpv", "12")
    vvd(amb[1][1],  4.0, 1e-12, "pvmpv", "22")
    vvd(amb[1][2],  2.0, 1e-12, "pvmpv", "32")
}

func t_pvppv() {
    var a = faws.zpv()
    var b = faws.zpv()
    a[0][0] = 2.0
    a[0][1] = 2.0
    a[0][2] = 3.0
    a[1][0] = 5.0
    a[1][1] = 6.0
    a[1][2] = 3.0
    b[0][0] = 1.0
    b[0][1] = 3.0
    b[0][2] = 4.0
    b[1][0] = 3.0
    b[1][1] = 2.0
    b[1][2] = 1.0
    let apb = faws.pvppv(a, b)
    vvd(apb[0][0], 3.0, 1e-12, "pvppv", "p1")
    vvd(apb[0][1], 5.0, 1e-12, "pvppv", "p2")
    vvd(apb[0][2], 7.0, 1e-12, "pvppv", "p3")
    vvd(apb[1][0], 8.0, 1e-12, "pvppv", "v1")
    vvd(apb[1][1], 8.0, 1e-12, "pvppv", "v2")
    vvd(apb[1][2], 4.0, 1e-12, "pvppv", "v3")
}

func t_pvstar() {
    var pv = faws.zpv()
    pv[0][0] =  126668.5912743160601
    pv[0][1] =  2136.792716839935195
    pv[0][2] = -245251.2339876830091
    pv[1][0] = -0.4051854035740712739e-2
    pv[1][1] = -0.6253919754866173866e-2
    pv[1][2] =  0.1189353719774107189e-1
    let (ra, dec, pmr, pmd, px, rv) = faws.pvstar(pv)
    vvd(ra, 0.1686756e-1, 1e-12, "pvstar", "ra")
    vvd(dec, -1.093989828, 1e-12, "pvstar", "dec")
    vvd(pmr, -0.1783235160000472788e-4, 1e-16, "pvstar", "pmr")
    vvd(pmd, 0.2336024047000619347e-5, 1e-16, "pvstar", "pmd")
    vvd(px, 0.74723, 1e-12, "pvstar", "px")
    vvd(rv, -21.60000010107306010, 1e-11, "pvstar", "rv")
}

func t_pvtob() {
    let elong = 2.0
    let phi = 0.5
    let hm = 3000.0
    let xp = 1e-6
    let yp = -0.5e-6
    let sp = 1e-8
    let theta = 5.0
    let pv = faws.pvtob(elong, phi, hm, xp, yp, sp, theta)
    vvd(pv[0][0], 4225081.367071159207, 1e-5, "pvtob", "p(1)")
    vvd(pv[0][1], 3681943.215856198144, 1e-5, "pvtob", "p(2)")
    vvd(pv[0][2], 3041149.399241260785, 1e-5, "pvtob", "p(3)")
    vvd(pv[1][0], -268.4915389365998787, 1e-9, "pvtob", "v(1)")
    vvd(pv[1][1], 308.0977983288903123, 1e-9, "pvtob", "v(2)")
    vvd(pv[1][2], 0, 0, "pvtob", "v(3)")
}

func t_pvu() {
    var pv = faws.zpv()
    pv[0][0] =  126668.5912743160734
    pv[0][1] =  2136.792716839935565
    pv[0][2] = -245251.2339876830229
    pv[1][0] = -0.4051854035740713039e-2
    pv[1][1] = -0.6253919754866175788e-2
    pv[1][2] =  0.1189353719774107615e-1
    let upv = faws.pvu(2920.0, pv)
    vvd(upv[0][0], 126656.7598605317105, 1e-6, "pvu", "p1")
    vvd(upv[0][1], 2118.531271155726332, 1e-8, "pvu", "p2")
    vvd(upv[0][2], -245216.5048590656190, 1e-6, "pvu", "p3")
    vvd(upv[1][0], -0.4051854035740713039e-2, 1e-12, "pvu", "v1")
    vvd(upv[1][1], -0.6253919754866175788e-2, 1e-12, "pvu", "v2")
    vvd(upv[1][2], 0.1189353719774107615e-1, 1e-12, "pvu", "v3")
}

func t_pvup() {
    var pv = faws.zpv()
    pv[0][0] =  126668.5912743160734
    pv[0][1] =  2136.792716839935565
    pv[0][2] = -245251.2339876830229
    pv[1][0] = -0.4051854035740713039e-2
    pv[1][1] = -0.6253919754866175788e-2
    pv[1][2] =  0.1189353719774107615e-1
    let p = faws.pvup(2920.0, pv)
    vvd(p[0],  126656.7598605317105,   1e-6, "pvup", "1")
    vvd(p[1],    2118.531271155726332, 1e-8, "pvup", "2")
    vvd(p[2], -245216.5048590656190,   1e-6, "pvup", "3")
}

func t_pvxpv() {
    var a = faws.zpv()
    var b = faws.zpv()
    a[0][0] = 2.0
    a[0][1] = 2.0
    a[0][2] = 3.0
    a[1][0] = 6.0
    a[1][1] = 0.0
    a[1][2] = 4.0
    b[0][0] = 1.0
    b[0][1] = 3.0
    b[0][2] = 4.0
    b[1][0] = 0.0
    b[1][1] = 2.0
    b[1][2] = 8.0
    let axb = faws.pvxpv(a, b)
    vvd(axb[0][0],  -1.0, 1e-12, "pvxpv", "p1")
    vvd(axb[0][1],  -5.0, 1e-12, "pvxpv", "p2")
    vvd(axb[0][2],   4.0, 1e-12, "pvxpv", "p3")
    vvd(axb[1][0],  -2.0, 1e-12, "pvxpv", "v1")
    vvd(axb[1][1], -36.0, 1e-12, "pvxpv", "v2")
    vvd(axb[1][2],  22.0, 1e-12, "pvxpv", "v3")
}

func t_pxp() {
    let a = [2.0, 2.0, 3.0]
    let b = [1.0, 3.0, 4.0]
    let axb = faws.pxp(a, b)
    vvd(axb[0], -1.0, 1e-12, "pxp", "1")
    vvd(axb[1], -5.0, 1e-12, "pxp", "2")
    vvd(axb[2],  4.0, 1e-12, "pxp", "3")
}

func t_refco() {
    let phpa = 800.0
    let tc = 10.0
    let rh = 0.9
    let wl = 0.4
    let (refa, refb) = faws.refco(phpa, tc, rh, wl)
    vvd(refa, 0.2264949956241415009e-3, 1e-15, "refco", "refa")
    vvd(refb, -0.2598658261729343970e-6, 1e-18, "refco", "refb")
}

func t_rm2v() {
    var r = faws.zr()
    r[0][0] =  0.00
    r[0][1] = -0.80
    r[0][2] = -0.60
    r[1][0] =  0.80
    r[1][1] = -0.36
    r[1][2] =  0.48
    r[2][0] =  0.60
    r[2][1] =  0.48
    r[2][2] = -0.64
    let w = faws.rm2v(r)
    vvd(w[0],  0.0,                  1e-12, "rm2v", "1")
    vvd(w[1],  1.413716694115406957, 1e-12, "rm2v", "2")
    vvd(w[2], -1.884955592153875943, 1e-12, "rm2v", "3")
}

func t_rv2m() {
    let w = [0.0, 1.41371669, -1.88495559]
    let r = faws.rv2m(w)
    vvd(r[0][0], -0.7071067782221119905, 1e-14, "rv2m", "11")
    vvd(r[0][1], -0.5656854276809129651, 1e-14, "rv2m", "12")
    vvd(r[0][2], -0.4242640700104211225, 1e-14, "rv2m", "13")
    vvd(r[1][0],  0.5656854276809129651, 1e-14, "rv2m", "21")
    vvd(r[1][1], -0.0925483394532274246, 1e-14, "rv2m", "22")
    vvd(r[1][2], -0.8194112531408833269, 1e-14, "rv2m", "23")
    vvd(r[2][0],  0.4242640700104211225, 1e-14, "rv2m", "31")
    vvd(r[2][1], -0.8194112531408833269, 1e-14, "rv2m", "32")
    vvd(r[2][2],  0.3854415612311154341, 1e-14, "rv2m", "33")
}

func t_rx() {
    var r = faws.zr()
    let phi = 0.3456789
    r[0][0] = 2.0
    r[0][1] = 3.0
    r[0][2] = 2.0
    r[1][0] = 3.0
    r[1][1] = 2.0
    r[1][2] = 3.0
    r[2][0] = 3.0
    r[2][1] = 4.0
    r[2][2] = 5.0
    r = faws.rx(phi, r)
    vvd(r[0][0], 2.0, 0.0, "rx", "11")
    vvd(r[0][1], 3.0, 0.0, "rx", "12")
    vvd(r[0][2], 2.0, 0.0, "rx", "13")
    vvd(r[1][0], 3.839043388235612460, 1e-12, "rx", "21")
    vvd(r[1][1], 3.237033249594111899, 1e-12, "rx", "22")
    vvd(r[1][2], 4.516714379005982719, 1e-12, "rx", "23")
    vvd(r[2][0], 1.806030415924501684, 1e-12, "rx", "31")
    vvd(r[2][1], 3.085711545336372503, 1e-12, "rx", "32")
    vvd(r[2][2], 3.687721683977873065, 1e-12, "rx", "33")
}

func t_rxp() {
    var r = faws.zr()
    r[0][0] = 2.0
    r[0][1] = 3.0
    r[0][2] = 2.0
    r[1][0] = 3.0
    r[1][1] = 2.0
    r[1][2] = 3.0
    r[2][0] = 3.0
    r[2][1] = 4.0
    r[2][2] = 5.0
    let p = [0.2, 1.5, 0.1]
    let rp = faws.rxp(r, p)
    vvd(rp[0], 5.1, 1e-12, "rxp", "1")
    vvd(rp[1], 3.9, 1e-12, "rxp", "2")
    vvd(rp[2], 7.1, 1e-12, "rxp", "3")
}

func t_rxpv() {
    var r = faws.zr()
    var pv = faws.zpv()
    r[0][0] = 2.0
    r[0][1] = 3.0
    r[0][2] = 2.0
    r[1][0] = 3.0
    r[1][1] = 2.0
    r[1][2] = 3.0
    r[2][0] = 3.0
    r[2][1] = 4.0
    r[2][2] = 5.0
    pv[0][0] = 0.2
    pv[0][1] = 1.5
    pv[0][2] = 0.1
    pv[1][0] = 1.5
    pv[1][1] = 0.2
    pv[1][2] = 0.1
    let rpv = faws.rxpv(r, pv)
    vvd(rpv[0][0], 5.1, 1e-12, "rxpv", "11")
    vvd(rpv[1][0], 3.8, 1e-12, "rxpv", "12")
    vvd(rpv[0][1], 3.9, 1e-12, "rxpv", "21")
    vvd(rpv[1][1], 5.2, 1e-12, "rxpv", "22")
    vvd(rpv[0][2], 7.1, 1e-12, "rxpv", "31")
    vvd(rpv[1][2], 5.8, 1e-12, "rxpv", "32")
}

func t_rxr() {
    var a = faws.zr()
    var b = faws.zr()
    a[0][0] = 2.0
    a[0][1] = 3.0
    a[0][2] = 2.0
    a[1][0] = 3.0
    a[1][1] = 2.0
    a[1][2] = 3.0
    a[2][0] = 3.0
    a[2][1] = 4.0
    a[2][2] = 5.0
    b[0][0] = 1.0
    b[0][1] = 2.0
    b[0][2] = 2.0
    b[1][0] = 4.0
    b[1][1] = 1.0
    b[1][2] = 1.0
    b[2][0] = 3.0
    b[2][1] = 0.0
    b[2][2] = 1.0
    let atb = faws.rxr(a, b)
    vvd(atb[0][0], 20.0, 1e-12, "rxr", "11")
    vvd(atb[0][1],  7.0, 1e-12, "rxr", "12")
    vvd(atb[0][2],  9.0, 1e-12, "rxr", "13")
    vvd(atb[1][0], 20.0, 1e-12, "rxr", "21")
    vvd(atb[1][1],  8.0, 1e-12, "rxr", "22")
    vvd(atb[1][2], 11.0, 1e-12, "rxr", "23")
    vvd(atb[2][0], 34.0, 1e-12, "rxr", "31")
    vvd(atb[2][1], 10.0, 1e-12, "rxr", "32")
    vvd(atb[2][2], 15.0, 1e-12, "rxr", "33")
}

func t_ry() {
    var r = faws.zr()
    let theta = 0.3456789
    r[0][0] = 2.0
    r[0][1] = 3.0
    r[0][2] = 2.0
    r[1][0] = 3.0
    r[1][1] = 2.0
    r[1][2] = 3.0
    r[2][0] = 3.0
    r[2][1] = 4.0
    r[2][2] = 5.0
    r = faws.ry(theta, r)
    vvd(r[0][0], 0.8651847818978159930, 1e-12, "ry", "11")
    vvd(r[0][1], 1.467194920539316554, 1e-12, "ry", "12")
    vvd(r[0][2], 0.1875137911274457342, 1e-12, "ry", "13")
    vvd(r[1][0], 3, 1e-12, "ry", "21")
    vvd(r[1][1], 2, 1e-12, "ry", "22")
    vvd(r[1][2], 3, 1e-12, "ry", "23")
    vvd(r[2][0], 3.500207892850427330, 1e-12, "ry", "31")
    vvd(r[2][1], 4.779889022262298150, 1e-12, "ry", "32")
    vvd(r[2][2], 5.381899160903798712, 1e-12, "ry", "33")
}

func t_rz() {
    var r = faws.zr()
    let psi = 0.3456789
    r[0][0] = 2.0
    r[0][1] = 3.0
    r[0][2] = 2.0
    r[1][0] = 3.0
    r[1][1] = 2.0
    r[1][2] = 3.0
    r[2][0] = 3.0
    r[2][1] = 4.0
    r[2][2] = 5.0
    r = faws.rz(psi, r)
    vvd(r[0][0], 2.898197754208926769, 1e-12, "rz", "11")
    vvd(r[0][1], 3.500207892850427330, 1e-12, "rz", "12")
    vvd(r[0][2], 2.898197754208926769, 1e-12, "rz", "13")
    vvd(r[1][0], 2.144865911309686813, 1e-12, "rz", "21")
    vvd(r[1][1], 0.865184781897815993, 1e-12, "rz", "22")
    vvd(r[1][2], 2.144865911309686813, 1e-12, "rz", "23")
    vvd(r[2][0], 3.0, 1e-12, "rz", "31")
    vvd(r[2][1], 4.0, 1e-12, "rz", "32")
    vvd(r[2][2], 5.0, 1e-12, "rz", "33")
}

func t_s00a() {
    let s = faws.s00a(2400000.5, 52541.0)
    vvd(s, -0.1340684448919163584e-7, 1e-18, "s00a", "")
}

func t_s00b() {
    let s = faws.s00b(2400000.5, 52541.0)
    vvd(s, -0.1340695782951026584e-7, 1e-18, "s00b", "")
}

func t_s00() {
    let x = 0.5791308486706011000e-3
    let y = 0.4020579816732961219e-4
    let s = faws.s00(2400000.5, 53736.0, x, y)
    vvd(s, -0.1220036263270905693e-7, 1e-18, "s00", "")
}

func t_s06a() {
    let s = faws.s06a(2400000.5, 52541.0)
    vvd(s, -0.1340680437291812383e-7, 1e-18, "s06a", "")
}

func t_s06() {
    let x = 0.5791308486706011000e-3
    let y = 0.4020579816732961219e-4
    let s = faws.s06(2400000.5, 53736.0, x, y)
    vvd(s, -0.1220032213076463117e-7, 1e-18, "s06", "")
}

func t_s2c() {
    let c = faws.s2c(3.0123, -0.999)
    vvd(c[0], -0.5366267667260523906, 1e-12, "s2c", "1")
    vvd(c[1],  0.0697711109765145365, 1e-12, "s2c", "2")
    vvd(c[2], -0.8409302618566214041, 1e-12, "s2c", "3")
}

func t_s2p() {
    let p = faws.s2p(-3.21, 0.123, 0.456)
    vvd(p[0], -0.4514964673880165228, 1e-12, "s2p", "x")
    vvd(p[1],  0.0309339427734258688, 1e-12, "s2p", "y")
    vvd(p[2],  0.0559466810510877933, 1e-12, "s2p", "z")
}

func t_s2pv() {
    let pv = faws.s2pv(-3.21, 0.123, 0.456, -7.8e-6, 9.01e-6, -1.23e-5)
    vvd(pv[0][0], -0.4514964673880165228, 1e-12, "s2pv", "x")
    vvd(pv[0][1],  0.0309339427734258688, 1e-12, "s2pv", "y")
    vvd(pv[0][2],  0.0559466810510877933, 1e-12, "s2pv", "z")
    vvd(pv[1][0],  0.1292270850663260170e-4, 1e-16, "s2pv", "vx")
    vvd(pv[1][1],  0.2652814182060691422e-5, 1e-16, "s2pv", "vy")
    vvd(pv[1][2],  0.2568431853930292259e-5, 1e-16, "s2pv", "vz")
}

func t_s2xpv() {
    var pv = faws.zpv()
    let s1 = 2.0
    let s2 = 3.0
    pv[0][0] =  0.3
    pv[0][1] =  1.2
    pv[0][2] = -2.5
    pv[1][0] =  0.5
    pv[1][1] =  2.3
    pv[1][2] = -0.4
    let spv = faws.s2xpv(s1, s2, pv)
    vvd(spv[0][0],  0.6, 1e-12, "s2xpv", "p1")
    vvd(spv[0][1],  2.4, 1e-12, "s2xpv", "p2")
    vvd(spv[0][2], -5.0, 1e-12, "s2xpv", "p3")
    vvd(spv[1][0],  1.5, 1e-12, "s2xpv", "v1")
    vvd(spv[1][1],  6.9, 1e-12, "s2xpv", "v2")
    vvd(spv[1][2], -1.2, 1e-12, "s2xpv", "v3")
}

func t_sepp() {
    let a = [1.0, 0.1, 0.2]
    let b = [-3.0, 1e-3, 0.2]
    let s = faws.sepp(a, b)
    vvd(s, 2.860391919024660768, 1e-12, "sepp", "")
}

func t_seps() {
    let al =  1.0
    let ap =  0.1
    let bl =  0.2
    let bp = -3.0
    let s = faws.seps(al, ap, bl, bp)
    vvd(s, 2.346722016996998842, 1e-14, "seps", "")
}

func t_sp00() {
    vvd(faws.sp00(2400000.5, 52541.0), -0.6216698469981019309e-11, 1e-12, "sp00", "")
}

func t_starpm() {
    let ra1 =   0.01686756
    let dec1 = -1.093989828
    let pmr1 = -1.78323516e-5
    let pmd1 =  2.336024047e-6
    let px1 =   0.74723
    let rv1 = -21.6
    let (ra2, dec2, pmr2, pmd2, px2, rv2) = faws.starpm(ra1, dec1, pmr1, pmd1, px1, rv1, 2400000.5, 50083.0, 2400000.5, 53736.0)
    vvd(ra2, 0.01668919069414256149, 1e-13, "starpm", "ra")
    vvd(dec2, -1.093966454217127897, 1e-13, "starpm", "dec")
    vvd(pmr2, -0.1783662682153176524e-4, 1e-17, "starpm", "pmr")
    vvd(pmd2, 0.2338092915983989595e-5, 1e-17, "starpm", "pmd")
    vvd(px2, 0.7473533835317719243, 1e-13, "starpm", "px")
    vvd(rv2, -21.59905170476417175, 1e-11, "starpm", "rv")
}

func t_starpv() {
    let ra =   0.01686756
    let dec = -1.093989828
    let pmr = -1.78323516e-5
    let pmd =  2.336024047e-6
    let px =   0.74723
    let rv = -21.6
    let pv = faws.starpv(ra, dec, pmr, pmd, px, rv)
    vvd(pv[0][0], 126668.5912743160601, 1e-10, "starpv", "11")
    vvd(pv[0][1], 2136.792716839935195, 1e-12, "starpv", "12")
    vvd(pv[0][2], -245251.2339876830091, 1e-10, "starpv", "13")
    vvd(pv[1][0], -0.4051854008955659551e-2, 1e-13, "starpv", "21")
    vvd(pv[1][1], -0.6253919754414777970e-2, 1e-15, "starpv", "22")
    vvd(pv[1][2], 0.1189353714588109341e-1, 1e-13, "starpv", "23")
}

func t_sxp() {
    let s = 2.0
    let p = [0.3, 1.2, -2.5]
    let sp = faws.sxp(s, p)
    vvd(sp[0],  0.6, 0.0, "sxp", "1")
    vvd(sp[1],  2.4, 0.0, "sxp", "2")
    vvd(sp[2], -5.0, 0.0, "sxp", "3")
}

func t_sxpv() {
    var pv = faws.zpv()
    let s = 2.0
    pv[0][0] =  0.3
    pv[0][1] =  1.2
    pv[0][2] = -2.5
    pv[1][0] =  0.5
    pv[1][1] =  3.2
    pv[1][2] = -0.7
    let spv = faws.sxpv(s, pv)
    vvd(spv[0][0],  0.6, 0.0, "sxpv", "p1")
    vvd(spv[0][1],  2.4, 0.0, "sxpv", "p2")
    vvd(spv[0][2], -5.0, 0.0, "sxpv", "p3")
    vvd(spv[1][0],  1.0, 0.0, "sxpv", "v1")
    vvd(spv[1][1],  6.4, 0.0, "sxpv", "v2")
    vvd(spv[1][2], -1.4, 0.0, "sxpv", "v3")
}

func t_taitt() {
    let (t1, t2) = faws.taitt(2453750.5, 0.892482639)
    vvd(t1, 2453750.5, 1e-6, "taitt", "t1")
    vvd(t2, 0.892855139, 1e-12, "taitt", "t2")
}

func t_taiut1() {
    let(u1, u2) = faws.taiut1(2453750.5, 0.892482639, -32.6659)
    vvd(u1, 2453750.5, 1e-6, "taiut1", "u1")
    vvd(u2, 0.8921045614537037037, 1e-12, "taiut1", "u2")
}

func t_taiutc() {
    let (u1, u2) = faws.taiutc(2453750.5, 0.892482639)
    vvd(u1, 2453750.5, 1e-6, "taiutc", "u1")
    vvd(u2, 0.8921006945555555556, 1e-12, "taiutc", "u2")
}

func t_tcbtdb() {
    let (b1, b2) = faws.tcbtdb(2453750.5, 0.893019599)
    vvd(b1, 2453750.5, 1e-6, "tcbtdb", "b1")
    vvd(b2, 0.8928551362746343397, 1e-12, "tcbtdb", "b2")
}

func t_tcgtt() {
    let (t1, t2) = faws.tcgtt(2453750.5, 0.892862531)
    vvd(t1, 2453750.5, 1e-6, "tcgtt", "t1")
    vvd(t2, 0.8928551387488816828, 1e-12, "tcgtt", "t2")
}

func t_tdbtcb() {
    let (b1, b2) = faws.tdbtcb(2453750.5, 0.892855137)
    vvd( b1, 2453750.5, 1e-6, "tdbtcb", "b1")
    vvd( b2, 0.8930195997253656716, 1e-12, "tdbtcb", "b2")
}

func t_tdbtt() {
    let (t1, t2) = faws.tdbtt(2453750.5, 0.892855137, -0.000201)
    vvd(t1, 2453750.5, 1e-6, "tdbtt", "t1")
    vvd(t2, 0.8928551393263888889, 1e-12, "tdbtt", "t2")
}

func t_tf2a() {
    let a = faws.tf2a("+", 4, 58, 20.2)
    vvd(a, 1.301739278189537429, 1e-12, "tf2a", "a")
}

func t_tf2d() {
    let d = faws.tf2d(" ", 23, 55, 10.9)
    vvd(d, 0.9966539351851851852, 1e-12, "tf2d", "d")
}

func t_tpors() {
    let xi = -0.03
    let eta = 0.07
    let ra = 1.3
    let dec = 1.5
    let (az1, bz1, az2, bz2, n) = faws.tpors(xi, eta, ra, dec)
    vvd(az1, 1.736621577783208748, 1e-13, "tpors", "az1")
    vvd(bz1, 1.436736561844090323, 1e-13, "tpors", "bz1")
    vvd(az2, 4.004971075806584490, 1e-13, "tpors", "az2")
    vvd(bz2, 1.565084088476417917, 1e-13, "tpors", "bz2")
    viv(n, 2, "tpors", "n")
}

func t_tporv() {
    let xi = -0.03
    let eta = 0.07
    let ra = 1.3
    let dec = 1.5
    let v = faws.s2c(ra, dec)
    let (vz1, vz2, n) = faws.tporv(xi, eta, v)
    vvd(vz1[0], -0.02206252822366888610, 1e-15, "tporv", "x1")
    vvd(vz1[1], 0.1318251060359645016, 1e-14, "tporv", "y1")
    vvd(vz1[2], 0.9910274397144543895, 1e-14, "tporv", "z1")
    vvd(vz2[0], -0.003712211763801968173, 1e-16, "tporv", "x2")
    vvd(vz2[1], -0.004341519956299836813, 1e-16, "tporv", "y2")
    vvd(vz2[2], 0.9999836852110587012, 1e-14, "tporv", "z2")
    viv(n, 2, "tporv", "n")
}

func t_tpsts() {
    let xi = -0.03
    let eta = 0.07
    let raz = 2.3
    let decz = 1.5
    let (ra, dec) = faws.tpsts(xi, eta, raz, decz)
    vvd(ra, 0.7596127167359629775, 1e-14, "tpsts", "ra")
    vvd(dec, 1.540864645109263028, 1e-13, "tpsts", "dec")
}

func t_tpstv() {
    let xi = -0.03
    let eta = 0.07
    let raz = 2.3
    let decz = 1.5
    let vz = faws.s2c(raz, decz)
    let v = faws.tpstv(xi, eta, vz)
    vvd(v[0], 0.02170030454907376677, 1e-15, "tpstv", "x")
    vvd(v[1], 0.02060909590535367447, 1e-15, "tpstv", "y")
    vvd(v[2], 0.9995520806583523804, 1e-14, "tpstv", "z")
}

func t_tpxes() {
    let ra = 1.3
    let dec = 1.55
    let raz = 2.3
    let decz = 1.5
    let (xi, eta, status) = faws.tpxes(ra, dec, raz, decz)
    vvd(xi, -0.01753200983236980595, 1e-15, "tpxes", "xi")
    vvd(eta, 0.05962940005778712891, 1e-15, "tpxes", "eta")
    viv(status, 0, "tpxes", "status")
}

func t_tpxev() {
    let ra = 1.3
    let dec = 1.55
    let raz = 2.3
    let decz = 1.5
    let v = faws.s2c(ra, dec)
    let vz = faws.s2c(raz, decz)
    let (xi, eta, status) = faws.tpxev(v, vz)
    vvd(xi, -0.01753200983236980595, 1e-15, "tpxev", "xi")
    vvd(eta, 0.05962940005778712891, 1e-15, "tpxev", "eta")
    viv(status, 0, "tpxev", "status")
}

func t_tr() {
    var r = faws.zr()
    r[0][0] = 2.0
    r[0][1] = 3.0
    r[0][2] = 2.0
    r[1][0] = 3.0
    r[1][1] = 2.0
    r[1][2] = 3.0
    r[2][0] = 3.0
    r[2][1] = 4.0
    r[2][2] = 5.0
    let rt = faws.tr(r)
    vvd(rt[0][0], 2.0, 0.0, "tr", "11")
    vvd(rt[0][1], 3.0, 0.0, "tr", "12")
    vvd(rt[0][2], 3.0, 0.0, "tr", "13")
    vvd(rt[1][0], 3.0, 0.0, "tr", "21")
    vvd(rt[1][1], 2.0, 0.0, "tr", "22")
    vvd(rt[1][2], 4.0, 0.0, "tr", "23")
    vvd(rt[2][0], 2.0, 0.0, "tr", "31")
    vvd(rt[2][1], 3.0, 0.0, "tr", "32")
    vvd(rt[2][2], 5.0, 0.0, "tr", "33")
}

func t_trxp() {
    var r = faws.zr()
    r[0][0] = 2.0
    r[0][1] = 3.0
    r[0][2] = 2.0
    r[1][0] = 3.0
    r[1][1] = 2.0
    r[1][2] = 3.0
    r[2][0] = 3.0
    r[2][1] = 4.0
    r[2][2] = 5.0
    let p = [0.2, 1.5, 0.1]
    let trp = faws.trxp(r, p)
    vvd(trp[0], 5.2, 1e-12, "trxp", "1")
    vvd(trp[1], 4.0, 1e-12, "trxp", "2")
    vvd(trp[2], 5.4, 1e-12, "trxp", "3")
}

func t_trxpv() {
    var r = faws.zr()
    var pv = faws.zpv()
    r[0][0] = 2.0
    r[0][1] = 3.0
    r[0][2] = 2.0
    r[1][0] = 3.0
    r[1][1] = 2.0
    r[1][2] = 3.0
    r[2][0] = 3.0
    r[2][1] = 4.0
    r[2][2] = 5.0
    pv[0][0] = 0.2
    pv[0][1] = 1.5
    pv[0][2] = 0.1
    pv[1][0] = 1.5
    pv[1][1] = 0.2
    pv[1][2] = 0.1
    let trpv = faws.trxpv(r, pv)
    vvd(trpv[0][0], 5.2, 1e-12, "trxpv", "p1")
    vvd(trpv[0][1], 4.0, 1e-12, "trxpv", "p1")
    vvd(trpv[0][2], 5.4, 1e-12, "trxpv", "p1")
    vvd(trpv[1][0], 3.9, 1e-12, "trxpv", "v1")
    vvd(trpv[1][1], 5.3, 1e-12, "trxpv", "v2")
    vvd(trpv[1][2], 4.1, 1e-12, "trxpv", "v3")
}

func t_tttai() {
    let (a1, a2) = faws.tttai(2453750.5, 0.892482639)
    vvd(a1, 2453750.5, 1e-6, "tttai", "a1")
    vvd(a2, 0.892110139, 1e-12, "tttai", "a2")
}

func t_tttcg() {
    let (g1, g2) = faws.tttcg(2453750.5, 0.892482639)
    vvd( g1, 2453750.5, 1e-6, "tttcg", "g1")
    vvd( g2, 0.8924900312508587113, 1e-12, "tttcg", "g2")
}

func t_tttdb() {
    let (b1, b2) = faws.tttdb(2453750.5, 0.892855139, -0.000201)
    vvd(b1, 2453750.5, 1e-6, "tttdb", "b1")
    vvd(b2, 0.8928551366736111111, 1e-12, "tttdb", "b2")
}

func t_ttut1() {
    let (u1, u2) = faws.ttut1(2453750.5, 0.892855139, 64.8499)
    vvd(u1, 2453750.5, 1e-6, "ttut1", "u1")
    vvd(u2, 0.8921045614537037037, 1e-12, "ttut1", "u2")
}

func t_ut1tai() {
    let (a1, a2) = faws.ut1tai(2453750.5, 0.892104561, -32.6659)
    vvd(a1, 2453750.5, 1e-6, "ut1tai", "a1")
    vvd(a2, 0.8924826385462962963, 1e-12, "ut1tai", "a2")
}

func t_ut1tt() {
    let (t1, t2) = faws.ut1tt(2453750.5, 0.892104561, 64.8499)
    vvd(t1, 2453750.5, 1e-6, "ut1tt", "t1")
    vvd(t2, 0.8928551385462962963, 1e-12, "ut1tt", "t2")
}

func t_ut1utc() {
    let (u1, u2) = faws.ut1utc(2453750.5, 0.892104561, 0.3341)
    vvd(u1, 2453750.5, 1e-6, "ut1utc", "u1")
    vvd(u2, 0.8921006941018518519, 1e-12, "ut1utc", "u2")
}

func t_utctai() {
    let (u1, u2) = faws.utctai(2453750.5, 0.892100694)
    vvd(u1, 2453750.5, 1e-6, "utctai", "u1")
    vvd(u2, 0.8924826384444444444, 1e-12, "utctai", "u2")
}

func t_utcut1() {
    let (u1, u2) = faws.utcut1(2453750.5, 0.892100694, 0.3341)
    vvd(u1, 2453750.5, 1e-6, "utcut1", "u1")
    vvd(u2, 0.8921045608981481481, 1e-12, "utcut1", "u2")
}

func t_xy06() {
    let (x, y) = faws.xy06(2400000.5, 53736.0)
    vvd(x, 0.5791308486706010975e-3, 1e-15, "xy06", "x")
    vvd(y, 0.4020579816732958141e-4, 1e-16, "xy06", "y")
}

func t_xys00a() {
    let (x, y, s) = faws.xys00a(2400000.5, 53736.0)
    vvd(x,  0.5791308472168152904e-3, 1e-14, "xys00a", "x")
    vvd(y,  0.4020595661591500259e-4, 1e-15, "xys00a", "y")
    vvd(s, -0.1220040848471549623e-7, 1e-18, "xys00a", "s")
}

func t_xys00b() {
    let (x, y, s) = faws.xys00b(2400000.5, 53736.0)
    vvd(x,  0.5791301929950208873e-3, 1e-14, "xys00b", "x")
    vvd(y,  0.4020553681373720832e-4, 1e-15, "xys00b", "y")
    vvd(s, -0.1220027377285083189e-7, 1e-18, "xys00b", "s")
}

func t_xys06a() {
    let (x, y, s) = faws.xys06a(2400000.5, 53736.0)
    vvd(x,  0.5791308482835292617e-3, 1e-14, "xys06a", "x")
    vvd(y,  0.4020580099454020310e-4, 1e-15, "xys06a", "y")
    vvd(s, -0.1220032294164579896e-7, 1e-18, "xys06a", "s")
}

func t_zp() {
    var p = [0.3, 1.2, -2.5]
    p = faws.zp()
    vvd(p[0], 0.0, 0.0, "zp", "1")
    vvd(p[1], 0.0, 0.0, "zp", "2")
    vvd(p[2], 0.0, 0.0, "zp", "3")
}

func t_zpv() {
    var pv = [[0.3, 1.2, -2.5], [-0.5, 3.1, 0.9]]
    pv = faws.zpv()
    vvd(pv[0][0], 0.0, 0.0, "zpv", "p1")
    vvd(pv[0][1], 0.0, 0.0, "zpv", "p2")
    vvd(pv[0][2], 0.0, 0.0, "zpv", "p3")
    vvd(pv[1][0], 0.0, 0.0, "zpv", "v1")
    vvd(pv[1][1], 0.0, 0.0, "zpv", "v2")
    vvd(pv[1][2], 0.0, 0.0, "zpv", "v3")
}

func t_zr() {
    var r = [[2.0, 3.0, 3.0], [3.0, 2.0, 4.0], [2.0, 3.0, 5.0]]
    r = faws.zr()
    vvd(r[0][0], 0.0, 0.0, "zr", "00")
    vvd(r[1][0], 0.0, 0.0, "zr", "01")
    vvd(r[2][0], 0.0, 0.0, "zr", "02")
    vvd(r[0][1], 0.0, 0.0, "zr", "10")
    vvd(r[1][1], 0.0, 0.0, "zr", "11")
    vvd(r[2][1], 0.0, 0.0, "zr", "12")
    vvd(r[0][2], 0.0, 0.0, "zr", "20")
    vvd(r[1][2], 0.0, 0.0, "zr", "21")
    vvd(r[2][2], 0.0, 0.0, "zr", "22")
}


func t_Basics() {
    print("Validating Basics...")
    t_fad03()
    t_fae03()
    t_faf03()
    t_faju03()
    t_fal03()
    t_falp03()
    t_fama03()
    t_fame03()
    t_fane03()
    t_faom03()
    t_fapa03()
    t_fasa03()
    t_faur03()
    t_fave03()
    print("Basics validated.")
}

func t_Matrix() {
    print("Validating Matrix...")
    t_a2af()
    t_a2tf()
    t_af2a()
    t_anp()
    t_anpm()
    t_c2s()
    t_cp()
    t_cpv()
    t_cr()
    t_d2tf()
    t_ir()
    t_p2pv()
    t_p2s()
    t_pap()
    t_pas()
    t_pdp()
    t_pm()
    t_pmp()
    t_pn()
    t_ppp()
    t_ppsp()
    t_pv2p()
    t_pv2s()
    t_pvdpv()
    t_pvm()
    t_pvmpv()
    t_pvppv()
    t_pvu()
    t_pvup()
    t_pvxpv()
    t_pxp()
    t_rm2v()
    t_rv2m()
    t_rx()
    t_rxp()
    t_rxpv()
    t_rxr()
    t_ry()
    t_rz()
    t_s2c()
    t_s2p()
    t_s2pv()
    t_s2xpv()
    t_sepp()
    t_seps()
    t_sxp()
    t_sxpv()
    t_tf2a()
    t_tf2d()
    t_tr()
    t_trxp()
    t_trxpv()
    t_zp()
    t_zpv()
    t_zr()
    print("Matrix validated.")
}

func t_CalTime() {
    print("Validating CalTime...")
    t_cal2jd()
    t_d2dtf()
    t_dat()
    t_dtdb()
    t_dtf2d()
    t_epb()
    t_epb2jd()
    t_epj()
    t_epj2jd()
    t_jd2cal()
    t_jdcalf()
    t_taitt()
    t_taiut1()
    t_taiutc()
    t_tcbtdb()
    t_tcgtt()
    t_tdbtcb()
    t_tdbtt()
    t_tttai()
    t_tttcg()
    t_tttdb()
    t_ttut1()
    t_ut1tai()
    t_ut1tt()
    t_ut1utc()
    t_utctai()
    t_utcut1()
    print("CalTime validated.")
}

func t_PrecNutPol() {
    print("Validating PrecNutPol...")
    t_bi00()
    t_bp00()
    t_bp06()
    t_bpn2xy()
    t_c2i00a()
    t_c2i00b()
    t_c2i06a()
    t_c2ibpn()
    t_c2ixy()
    t_c2ixys()
    t_c2t00a()
    t_c2t00b()
    t_c2t06a()
    //t_c2tall()
    t_c2tcio()
    t_c2teqx()
    t_c2tpe()
    t_c2txy()
    t_ee00()
    t_ee00a()
    t_ee00b()
    t_ee06a()
    t_eect00()
    t_eo06a()
    t_eors()
    t_eqeq94()
    t_era00()
    t_fw2m()
    t_fw2xy()
    t_gmst00()
    t_gmst06()
    t_gmst82()
    t_gst00a()
    t_gst00b()
    t_gst06()
    t_gst06a()
    t_gst94()
    t_ltp()
    t_ltpb()
    t_ltpecl()
    t_ltpequ()
    t_num00a()
    t_num00b()
    t_num06a()
    t_numat()
    t_nut00a()
    t_nut00b()
    t_nut06a()
    t_nut80()
    t_nutm80()
    t_obl06()
    t_obl80()
    t_p06e()
    t_pb06()
    t_pfw06()
    t_pmat00()
    t_pmat06()
    t_pmat76()
    t_pn00()
    t_pn00a()
    t_pn00b()
    t_pn06()
    t_pn06a()
    t_pnm00a()
    t_pnm00b()
    t_pnm06a()
    t_pnm80()
    t_pom00()
    t_pr00()
    t_prec76()
    t_s00()
    t_s00a()
    t_s00b()
    t_s06()
    t_s06a()
    t_sp00()
    t_xy06()
    t_xys00a()
    t_xys00b()
    t_xys06a()
    print("PrecNutPol validated.")
}

func t_GeoGnoEclGalHor() {
    print("Validating GeoGnoEclGalHor...")
    t_ae2hd()
    t_eceq06()
    t_ecm06()
    t_eform()
    t_eqec06()
    t_g2icrs()
    t_gc2gd()
    t_gc2gde()
    t_gd2gc()
    t_gd2gce()
    t_hd2ae()
    t_hd2pa()
    t_icrs2g()
    t_lteceq()
    t_ltecm()
    t_lteqec()
    t_tpors()
    t_tporv()
    t_tpsts()
    t_tpstv()
    t_tpxes()
    t_tpxev()
    print("GeoGnoEclGalHor validated.")
}

func t_Ephemerides() {
    print("Validating Ephemerides...")
    t_epv00()
    t_moon98()
    t_plan94()
    print("Ephemerides validated.")
}

func t_Astrometry() {
    print("Validating Astrometry...")
    t_ab()
    t_apcg()
    t_apcg13()
    t_apci()
    t_apci13()
    t_apco()
    t_apco13()
    t_apcs()
    t_apcs13()
    t_aper()
    t_aper13()
    t_apio()
    t_apio13()
    t_atcc13()
    t_atccq()
    t_atci13()
    t_atciq()
    t_atciqn()
    t_atciqz()
    t_atco13()
    t_atic13()
    t_aticq()
    t_aticqn()
    t_atio13()
    t_atioq()
    t_atoc13()
    t_atoi13()
    t_atoiq()
    t_ld()
    t_ldn()
    t_ldsun()
    t_pmpx()
    t_pmsafe()
    t_pvstar()
    t_pvtob()
    t_refco()
    t_starpm()
    t_starpv()
    print("Astrometry validated.")
}


func t_CatalogConv() {
    print("Validating CatalogConv...")
    t_fk425()
    t_fk45z()
    t_fk524()
    t_fk52h()
    t_fk54z()
    t_fk5hip()
    t_fk5hz()
    t_h2fk5()
    t_hfk5z()
    print("CatalogConv validated.")
}



func validate_all_functions() {
    t_Basics()
    print("-----------------------------------")
    t_Matrix()
    print("-----------------------------------")
    t_CalTime()
    print("-----------------------------------")
    t_PrecNutPol()
    print("-----------------------------------")
    t_GeoGnoEclGalHor()
    print("-----------------------------------")
    t_Ephemerides()
    print("-----------------------------------")
    t_Astrometry()
    print("-----------------------------------")
    t_CatalogConv()
}
