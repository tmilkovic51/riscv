# RISC-V core
A CPU core implementing RV32I ISA. The core consists of 5 pipeline stages:
- Instruction fetch stage
- Operand fetch stage
- Execute stage
- Memory access stage
- Write-back stage

The emphasis of this core is not on performance, but on portability accross different FPGA platforms, readability of the HDL code and documentation.

Name of the core is still TBD.

## Project initialization

### Xilinx tools
- Open the terminal and source the `settings64.bat`(on Windows) or `settings64.sh`(On Linux) script located in Vivado installation directory (e.g. in`C:\Xilinx\Vivado\2019.1\`directory on Windows)
- Change directory to the cloned git repo and run`vivado -source create_project.tcl`
- This will create a Vivado project and open it in Vivado GUI from which you can change the target board (the default one is ultra96) or make a custom block design with the CPU.
