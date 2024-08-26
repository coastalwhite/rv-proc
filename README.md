# RV-PROC

**Work In Progress**

A very basic RISC-V processor in Verilog meant to eventually be put on the
IceBreaker FPGA.

This only implements the base unprivileged ISA without `FENCE`, `ECALL` and `EBREAK`.

## Usage

```bash
iverilog test/tb.v -o tb -Wall
vvp tb
gtkwave test.vcd
```