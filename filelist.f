// Primary class-based verification build. Included source files are listed
// through +incdir+ paths and are intentionally not repeated below.
+incdir+rtl
+incdir+tb

// Interface and synthesizable/controller wrapper.
tb/ddr_intf.sv
rtl/ddr_sdram.v

// DUT adapter and the class-based top-level testbench.
tb/ddr_dut.sv
tb/ddr_top.sv