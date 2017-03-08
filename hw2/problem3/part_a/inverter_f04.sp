Connecting a DUT inverter with f04 configuration

.lib '/home/ff/ee241/synopsys-32nm/hspice/saed32nm.lib' TT

* Inverter Subcircuit

.subckt inverter in out vdd gnd (pmos_width=200n, size=1)
    * MOSFET instantiation: x<name> <drain> <gate> <source> <body> <model> <parameter list>
    x1 out in gnd gnd n105 (w=100n*size l=32n)
    x2 out in vdd vdd p105 (w=pmos_width*size l=32n)
.ends

* Test Circuit

.param pmos_width_param = 100n
vdd vdd gnd 1.05
vin vin gnd pwl(0 0 10p 0 20p 1.05 100p 1.05 110p 0)

x1 vin v1out vdd gnd inverter (pmos_width=pmos_width_param, size=1)
xdut v1out v4out vdd gnd inverter (pmos_width=pmos_width_param, size=4)
x2 v4out v16out vdd gnd inverter (pmos_width=pmos_width_param, size=16)
x3 v16out v64out vdd gnd inverter (pmos_width=pmos_width_param, size=64)

* Measurements
* We want to measure the time at which v1out has fallen to 1.05V/2
* v4out has risen to 1.05/2, v1out has risen to 1.05/2, v4out has risen to 1.05/2
.measure tran delay_l_to_h trig v(v1out) val=1.05/2 fall=1 targ v(v4out) val=1.05/2 rise=1
.measure tran delay_h_to_l trig v(v1out) val=1.05/2 rise=1 targ v(v4out) val=1.05/2 fall=1

* Analyses
.op
.tran 1f 200p START=0 SWEEP pmos_width_param 100n 200n 1n

.option post=2 nomod
.option accurate=1
.option numdgt=6
.option measdgt=6
.option delmax=10f
.end
