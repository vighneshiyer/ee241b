Simulating a NAND3's transitions and sweeping its fanout

.lib '/home/ff/ee241/synopsys-32nm/hspice/saed32nm.lib' TT

* Inverter Subcircuit

.subckt inverter in out vdd gnd (pmos_width=121n, size=1)
    * MOSFET instantiation: x<name> <drain> <gate> <source> <body> <model> <parameter list>
    x1 out in gnd gnd n105 (w=100n*size l=32n)
    x2 out in vdd vdd p105 (w=pmos_width*size l=32n)
.ends

* NAND3 Subcircuit
.subckt nand3 in1 in2 in3 out vdd gnd (nmos_width=672n, pmos_width=121n, size=1)
    x1 out in1 vdd vdd p105 (w=pmos_width*size l=32n)
    x2 out in2 vdd vdd p105 (w=pmos_width*size l=32n)
    x3 out in3 vdd vdd p105 (w=pmos_width*size l=32n)
    x4 out in1 vstack1 vstack1 n105 (w=nmos_width*size l=32n)
    x5 vstack1 in2 vstack2 vstack2 n105 (w=nmos_width*size l=32n)
    x6 vstack2 in3 gnd gnd n105 (w=nmos_width*size l=32n)
.ends

* Test Circuit
.param fanout=1
vdd vdd gnd 1.05
vin vin gnd pwl(0 1.05 10p 1.05 20p 0 500p 0 510p 1.05)

x1 vin vnandin vdd gnd inverter (size=1)
xdut vdd vdd vnandin vnandout vdd gnd nand3 (size=4)
x2 vnandout v2out vdd gnd inverter (size=4*fanout)
x3 v2out v3out vdd gnd inverter (size=16*fanout)

* Measurements
* We want to measure the high-to-low transition of the NAND2 gate to measure
* the strength of the pull-down network. We want it to pull low as fast as an inverter.

.measure tran delay_h_to_l trig v(vnandin) val=1.05/2 rise=1 targ v(vnandout) val=1.05/2 fall=1
.measure tran delay_l_to_h trig v(vnandin) val=1.05/2 fall=1 targ v(vnandout) val=1.05/2 rise=1

* Analyses
.op
.tran 100f 1.2n START=0 SWEEP fanout 1 128 1

.option post=2 nomod
.option accurate=1
.option numdgt=6
.option measdgt=6

.end
