preamble_string = """Simulating VDD scaling and replica delay

.lib '/home/ff/ee241/synopsys-32nm/hspice/saed32nm.lib' TT

* Parameters and supplies
.param VDD_val=1.05
vdd vdd gnd VDD_val
vin vin gnd pwl(0 0 1n 0 1.1n VDD_val)

* Library standard cells that are used in this testbench

*  Library name: saed32nm_rvt
*  Cell name: INVX0_RVT
*  View name: schematic
.subckt invx0_rvt a vdd vss y
    xmp y a vdd vdd p105 m=1 w=520e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
    xmn y a vss vss n105 m=1 w=270e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
.ends

*  Library name: saed32nm_rvt
*  Cell name: INVX32_RVT
*  View name: schematic
.subckt invx32_rvt a vdd vss y
    xmp y a vdd vdd p105 m=32 w=800e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
    xmn y a vss vss n105 m=32 w=420e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
.ends 

*  Library name: saed32nm_rvt
*  Cell name: NAND2X0_RVT
*  View name: schematic
.subckt nand2x0_rvt a1 a2 vdd vss y
    xmp2 y a2 vdd vdd p105 m=1 w=300e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
    xmp1 y a1 vdd vdd p105 m=1 w=300e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
    xmn1 y a1 sa1 vss n105 m=1 w=320e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
    xmn2 sa1 a2 vss vss n105 m=1 w=320e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
.ends 

*  Library name: saed32nm_rvt
*  Cell name: NOR2X0_RVT
*  View name: schematic
.subckt nor2x0_rvt a1 a2 vdd vss y
    xmn2 sa1 a2 vss vss n105 m=1 w=210e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
    xmn1 sa1 a1 vss vss n105 m=1 w=210e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
    xmn4 y sa2 vss vss n105 m=1 w=420e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
    xmn3 sa2 sa1 vss vss n105 m=1 w=210e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
    xmp2 sa1 a2 net84 vdd p105 m=1 w=800e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
    xmp1 net84 a1 vdd vdd p105 m=1 w=800e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
    xmp4 y sa2 vdd vdd p105 m=1 w=800e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
    xmp3 sa2 sa1 vdd vdd p105 m=1 w=400e-9 l=30e-9 ad=10.5e-15 as=10.5e-15 pd=310e-9 ps=310e-9
.ends 
"""
finale_string = """
* Measurements 

.measure tran replica_delay trig v(vin) val=VDD_val/2 rise=1 targ v(vrepout40) val=VDD_val/2 rise=1
.measure tran inv_delay trig v(vin) val=VDD_val/2 rise=1 targ v(vcritinvout50) val=VDD_val/2 rise=1
.measure tran nand_delay trig v(vin) val=VDD_val/2 rise=1 targ v(vcritnandout33) val=VDD_val/2 cross=1
.measure tran nor_delay trig v(vin) val=VDD_val/2 rise=1 targ v(vcritnorout11) val=VDD_val/2 cross=1

* Analyses
.op
.tran 1f 12n SWEEP VDD_val 0.500 1.05 .050

.option post=2 nomod
*.option accurate=1
*.option numdgt=6
*.option measdgt=6
*.option method=gear
*.option dcstep=1
*.option ingold=2
*.option measout=1

.end
"""

spice_file = open("replica_delay_vs_vdd.sp", "w")
spice_file.write(preamble_string)

# Insert the DUT here

# Begin by constructing the replica path
spice_file.write("\n* Replica Path\n\n")
spice_file.write("xrepinv1 vin vdd gnd vrepout1 invx0_rvt\n")
for i in range(2, 40):
    spice_file.write("xrepinv%d vrepout%d vdd gnd vrepout%d invx0_rvt\n" % (i, i-1, i))
spice_file.write("xrepinv40 vrepout39 vdd gnd vrepout40 invx32_rvt\n")

# Next construct the critical paths made out of inverters
# We will assume that the critical path made out of FO4 inverters can be made 
# out of 50 FO1 inverters to keep area realistic.
spice_file.write("\n* Inverter Critical Path\n\n")
spice_file.write("xcritinv1 vin vdd gnd vcritinvout1 invx0_rvt\n")
for i in range(2, 51):
    spice_file.write("xcritinv%d vcritinvout%d vdd gnd vcritinvout%d invx0_rvt\n" % (i, i-1, i))

# Next construct the critical path made out of NAND2 gates
# We want this path to have a delay similar to the inverter chain delay
# Thus the number of stages is 43 minimally sized NAND2s
spice_file.write("\n* NAND2 Critical Path\n\n")
spice_file.write("xcritnand1 vin vdd vdd gnd vcritnandout1 nand2x0_rvt\n")
for i in range(2, 34):
    spice_file.write("xcritnand%d vcritnandout%d vdd vdd gnd vcritnandout%d nand2x0_rvt\n" % (i, i-1, i))

# Next construct the critical path made out of NOR2 gates
spice_file.write("\n* NOR2 Critical Path\n\n")
spice_file.write("xcritnor1 vin gnd vdd gnd vcritnorout1 nor2x0_rvt\n")
for i in range(2, 12):
    spice_file.write("xcritnor%d vcritnorout%d gnd vdd gnd vcritnorout%d nor2x0_rvt\n" % (i, i-1, i))

spice_file.write(finale_string)
spice_file.close()
