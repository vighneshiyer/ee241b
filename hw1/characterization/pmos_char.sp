Sweep of V_GS with constant V_DS for N-MOSFET
.lib '/home/ff/ee241/synopsys-32nm/hspice/saed32nm.lib' TT
vds vds gnd 1.05
vgs vgs gnd 1.05 
x1 vds vgs gnd gnd p105 (w=1u l=32n)

.op
.dc vgs -1.05 0 10m vds -1.05 0 10m

.option post=2 nomod
.end
