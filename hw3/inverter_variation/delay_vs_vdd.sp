Running Monte-Carlo simulation while sweeping VDD

.lib '/home/ff/ee241/synopsys-32nm/hspice/saed32nm.lib' TT
*  Library name: saed32nm_rvt
*  Cell name: INVX0_RVT
*  View name: schematic
.subckt invx0_rvt a vdd vss y
    xmp y a vdd vdd p105 m=1 w=520e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
    xmn y a vss vss n105 m=1 w=270e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
.ends 

* Parameters and supplies
.param VDD_val=1.05
vdd vdd gnd VDD_val
vin vin gnd pwl(0 0 10p 0 20p VDD_val)

* DUT instantiation and load capacitor
xdut vin vdd gnd vout invx0_rvt
c1 vout gnd 1f

* Measurements (input-rising to output-falling delay)
.measure tran inv_delay trig v(vin) val=VDD_val/2 rise=1 targ v(vout) val=VDD_val/2 fall=1

* Analyses
.op
.tran 1f 12n SWEEP MONTE=300

.option post=2 nomod
*.option accurate=1
*.option numdgt=6
*.option measdgt=6
*.option method=gear
*.option dcstep=1
*.option ingold=2
*.option measout=1

.end
