Connecting a DUT inverter with f04 configuration

.lib '/home/ff/ee241/synopsys-32nm/hspice/saed32nm.lib' TT

* Inverter Subcircuit

.subckt inverter in out vdd gnd (pmos_width=200n)
    * MOSFET instantiation: x<name> <drain> <gate> <source> <body> <model> <parameter list>
    x1 out in gnd gnd n105 (w=100n l=32n)
    x2 out in vdd vdd p105 (w=pmos_width l=32n)
.ends

* Test Circuit

vdd vdd gnd 1.05
vin vin gnd pwl(0 0 10p 0 15p 1.05 30p 1.05 35p 0)
x1 vin vout vdd gnd inverter

* Analyses

.op
.tran 1f 50p START=0

.option post=2 nomod
.end
