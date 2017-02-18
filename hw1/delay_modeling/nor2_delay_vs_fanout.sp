Simulating a NOR2 for figuring out LE and intrinsic delay

.lib '/home/ff/ee241/synopsys-32nm/hspice/saed32nm.lib' TT

* Inverter Subcircuit

.subckt inverter in out vdd gnd (pmos_width=121n, size=1)
    * MOSFET instantiation: x<name> <drain> <gate> <source> <body> <model> <parameter list>
    x1 out in gnd gnd n105 (w=100n*size l=32n)
    x2 out in vdd vdd p105 (w=pmos_width*size l=32n)
.ends

* NOR2 Subcircuit
.subckt nor2 in1 in2 out vdd gnd (nmos_width=100n, pmos_width=1296n, size=1)
    x1 vstack in1 vdd vdd p105 (w=pmos_width*size l=32n)
    x2 out in2 vstack vstack p105 (w=pmos_width*size l=32n)
    x3 out in1 gnd gnd n105 (w=nmos_width*size l=32n)
    x4 out in2 gnd gnd n105 (w=nmos_width*size l=32n)
.ends

* Test Circuit
.param fanout=1
vdd vdd gnd 1.05
vin vin gnd pwl(0 0 10p 0 20p 1.05 200p 1.05 210p 0)

x1 vin vnorin vdd gnd inverter (size=1)
xdut vnorin gnd vnorout vdd gnd nor2 (size=4)
x2 vnorout v2out vdd gnd inverter (size=4*fanout)
x3 v2out v3out vdd gnd inverter (size=16*fanout)

* Measurements

.measure tran delay_l_to_h trig v(vnorin) val=1.05/2 fall=1 targ v(vnorout) val=1.05/2 rise=1
.measure tran delay_h_to_l trig v(vnorin) val=1.05/2 rise=1 targ v(vnorout) val=1.05/2 fall=1

* Analyses
.op
.tran 10f 600p START=0 SWEEP fanout 1 128 1

.option post=2 nomod
.option accurate=1
.option numdgt=6
.option measdgt=6

.end
