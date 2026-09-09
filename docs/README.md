# DDR SDRAM Controller

Verilog and SystemVerilog design and verification project for a DDR SDRAM
memory controller. The project accompanies the thesis *Design and Verification
of DDR SDRAM Memory Controller Using SystemVerilog for Higher Coverage*.

## Repository layout

| Directory | Contents |
| --- | --- |
| `rtl/` | Synthesizable controller, clocking blocks, timing/control logic, and controller parameters. |
| `tb/` | SystemVerilog interface, transaction classes, generator, driver, monitor, scoreboard, coverage, DUT adapter, memory model, and testbench tops. |
| `docs/` | This README, thesis/report PDFs, and preserved simulator output/artifacts. |

The build controls remain at the repository root:

- `filelist.f` is the primary Questa/ModelSim compilation list.
- `Makefile` provides `compile`, `run`, and `clean` targets.

## Hierarchy and interdependencies

The primary simulation top is `top` in `tb/ddr_top.sv`:

```text
top (tb/ddr_top.sv)
|- ddr_intf (rtl/ddr_intf.sv)
|- dut (tb/ddr_dut.sv)
|  `- ddr_sdram (rtl/ddr_sdram.v)
|     |- pll1 (rtl/pll1.v)
|     |- altclklock (rtl/altclklock.v)
|     |- ddr_control_interface (rtl/ddr_controle_interface.v)
|     |- ddr_command (rtl/ddr_commands.v)
|     `- ddr_data_path (rtl/ddr_data_path.v)
`- tb (tb/ddr_tb.sv)
   |- configurations (tb/configurations.sv)
   |- ddr_gen (tb/ddr_gen.sv)
   |- ddr_drv (tb/ddr_drv.sv)
   |- ddr_monitor (tb/ddr_monitor.sv)
   |- ddr_score (tb/ddr_score.sv)
   |- coverage (tb/coverage_ddr.sv)
   `- ddr_base (tb/ddr_base.sv)
```

`rtl/ddr_sdram.v` textually includes `rtl/params.v`, `rtl/pll1.v`,
`rtl/altclklock.v`, `rtl/ddr_controle_interface.v`, `rtl/ddr_commands.v`,
and `rtl/ddr_data_path.v`. Likewise, `tb/ddr_top.sv` includes the class-based
testbench sources through `tb/ddr_tb.sv`. The include directories in
`filelist.f` are therefore required, and these included files must not also be
compiled as independent file-list entries.

There is also a legacy, standalone controller/memory-model testbench:

```text
ddr_sdram_tb (tb/ddr_sdram_tb.v)
|- ddr_sdram (rtl/ddr_sdram.v)
`- eight mt46v4m16 memory-model instances (tb/mt46v4m16.v)
```

It is intentionally separate from the primary `filelist.f`: the source uses
legacy Verilog syntax that conflicts with SystemVerilog keywords. Compile it
in Verilog mode when that reference flow is needed, for example:

```text
vlog +incdir+rtl +incdir+tb tb/ddr_sdram_tb.v
```

## Build and run

With Questa/ModelSim and GNU make available on the Bash `PATH`:

```text
make compile
make run
```

The Makefile uses POSIX commands (`mkdir`, `rm`, and standard shell quoting),
so it is intended for Linux, macOS, WSL, or another Bash-compatible
environment. The default top is `top`, the default bounded simulation duration
is `100 us`, and the run writes a recursive VCD waveform to `ddr.vcd`.
Override these with:

```text
make TOP=top SIM_TIME="1 ms" VCD=waves/ddr.vcd run
```

The Makefile creates a nested VCD directory automatically. The generated VCD
is removed by the cleanup target with `make clean`.

## Source notes

The RTL and verification sources retain their original interfaces and
behavior. Comments near module/class boundaries describe each block's role and
its position in the hierarchy. Existing reports and simulator output are
retained under `docs/` for traceability. Preserve the original attributions
and licensing conditions for externally sourced RTL or memory model code.
