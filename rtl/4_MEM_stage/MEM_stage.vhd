--------------------------------------------------------------------------------
-- Copyright Tomislav Milkovic 2022.
--
-- This source describes Open Hardware and is licensed under the CERN-OHL-S v2
--
-- You may redistribute and modify this source and make products
-- using it under the terms of the CERN-OHL-S v2 (https://cern.ch/cern-ohl).
-- This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY,
-- INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A
-- PARTICULAR PURPOSE. Please see the CERN-OHL-S v2 for applicable conditions.
-------------------------------------------------------------------------------
--! @file       MEM_stage.vhd
--! @brief      Memory access stage module RTL implementation
--! @details    This stage accesses the data memory if load or store
--!             instruction is issued. It receives the memory address and, in
--!             case of store instruction, the store data from EX stage. In
--!             case of load instruction, it forwards the loaded data to the
--!             WB stage.
--! @author     Tomislav Milkovic (tomislav.milkovic95@gmail.com)
--! @copyright  Licensed under CERN-OHL-S v2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.riscv_types_pkg.all;
use work.riscv_control_pkg.all;

--! Memory access stage entity containing all generics and ports
entity MEM_stage is
    port(
        -- inputs
        i_clk                   : in  std_logic;        --! Clock
        i_rst                   : in  std_logic;        --! Synchronous reset
        i_ctrl                  : in  MEM_stage_ctrl_t; --! MEM stage control signals
        i_mem_addr              : in  address_t;        --! Address to be output to data memory
        i_mem_write_data        : in  word_t;           --! Data to write to memory
        i_mem_read_data         : in  word_t;           --! Data read from memory

        -- outputs
        o_mem_addr              : out address_t;        --! Address in data memory for which read/write operation will be issued
        o_mem_rw                : out std_logic;        --! Data memory read or write operation
        o_mem_write_data        : out word_t;           --! Data to write to memory
        o_mem_read_data         : out word_t            --! Data read from memory
    );
end entity MEM_stage;


--! Memory access stage RTL architecture
architecture rtl of MEM_stage is

begin

    o_mem_addr <= i_mem_addr;
    o_mem_rw <= i_ctrl.mem_rw;

end architecture rtl;
