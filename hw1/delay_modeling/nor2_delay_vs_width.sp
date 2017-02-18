Simulating a NOR2 for optimal low-to-high transition

.lib '/home/ff/ee241/synopsys-32nm/hspice/saed32nm.lib' TT

* Inverter Subcircuit

.subckt inverter in out vdd gnd (pmos_width=121n, size=1)
    * MOSFET instantiation: x<name> <drain> <gate> <source> <body> <model> <parameter list>
    x1 out in gnd gnd n105 (w=100n*size l=32n)
    x2 out in vdd vdd p105 (w=pmos_width*size l=32n)
.ends

* NOR2 Subcircuit
.subckt nor2 in1 in2 out vdd gnd (nmos_width=100n, pmos_width=121n, size=1)
    x1 vstack in1 vdd vdd p105 (w=pmos_width*size l=32n)
    x2 out in2 vstack vstack p105 (w=pmos_width*size l=32n)
    x3 out in1 gnd gnd n105 (w=nmos_width*size l=32n)
    x4 out in2 gnd gnd n105 (w=nmos_width*size l=32n)
.ends

* Test Circuit
.param pmos_width_param=200n
vdd vdd gnd 1.05
vin vin gnd pwl(0 0 10p 0 20p 1.05)

x1 vin vnorin vdd gnd inverter (size=1)
xdut vnorin gnd vnorout vdd gnd nor2 (pmos_width=pmos_width_param, size=4)
x2 vnorout v2out vdd gnd inverter (size=16)
x3 v2out v3out vdd gnd inverter (size=64)

* Measurements

.measure tran delay_l_to_h trig v(vnorin) val=1.05/2 fall=1 targ v(vnorout) val=1.05/2 rise=1

* Analyses
.op
.tran 10f 200p START=0 SWEEP pmos_width_param 1100n 1300n 1n

.option post=2 nomod
.option accurate=1
.option numdgt=6
.option measdgt=6

.end
