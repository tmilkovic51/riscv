--------------------------------------------------------------------------------
-- Copyright Tomislav Milkovic 2020.
--
-- This source describes Open Hardware and is licensed under the CERN-OHL-S v2
--
-- You may redistribute and modify this source and make products
-- using it under the terms of the CERN-OHL-S v2 (https://cern.ch/cern-ohl).
-- This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY,
-- INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A
-- PARTICULAR PURPOSE. Please see the CERN-OHL-S v2 for applicable conditions.
-------------------------------------------------------------------------------
--! @file       riscv_components_pkg.vhd
--! @brief      Package containing declarations of all components in project
--! @details    This package contains declaration of all components used in
--!             the project (e.g. pipeline stages and other modules), so
--!             instantiations in source files are tidier (no need to declare
--!             the component in the source file if it is already declared in
--!             this package.
--! @author     Tomislav Milkovic (tomislav.milkovic95@gmail.com)
--! @copyright  Licensed under CERN-OHL-S v2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.riscv_types_pkg.all;
use work.riscv_control_pkg.all;

package riscv_components_pkg is

    component regset is
        port (
            -- inputs
            i_clk                   : in  std_logic;        --! Clock
            i_rst                   : in std_logic;         --! Synchronous reset
            i_addr_a                : in  reg_address_t;    --! Register address for output port A
            i_addr_b                : in  reg_address_t;    --! Register address for output port B
            i_addr_c                : in  reg_address_t;    --! Register address for input port C
            i_we                    : in  std_logic;        --! Write enable signal for input port C
            i_data_c                : in  word_t;           --! Data input into port C

            -- outputs
            o_data_a                : out word_t;           --! Data output from port A
            o_data_b                : out word_t            --! Data output from port B
        );
    end component regset;

    component immediate_extraction is
        port (
            -- inputs
            i_data                  : in  word_t;           --! Input word (instruction)
            i_instr_format          : in  instr_format_t;   --! Instruction format control signal
            
            -- outputs
            o_data                  : out word_t            --! Output (sign extended) word
        );
    end component immediate_extraction;

    component IF_stage is
        port(
            -- inputs
            i_clk                   : in  std_logic;        --! Clock
            i_rst                   : in  std_logic;        --! Synchronous reset
            i_ctrl                  : in  IF_stage_ctrl_t;  --! IF stage control signals
            i_instruction           : in  word_t;           --! Instruction fetched from memory
            i_ex_stage_next_addr    : in  word_t;           --! Next PC address calculated in EX pipeline stage

            -- outputs
            o_address               : out address_t;        --! Address of the instruction to be fetched
            o_instruction           : out word_t;           --! Instruction forwarded to the next pipeline stage
            o_pc                    : out address_t         --! Program counter value forwarded to the next pipeline stage
        );
    end component IF_stage;

    component OF_stage is
        port(
            -- inputs
            i_clk                   : in  std_logic;        --! Clock
            i_rst                   : in  std_logic;        --! Synchronous reset
            i_ctrl                  : in  OF_stage_ctrl_t;  --! OF stage control signals
            i_instruction           : in  word_t;           --! Instruction forwarded from the previous pipeline stage
            i_pc                    : in  address_t;        --! Program counter value forwarded from the previous pipeline stage
            i_rd_data               : in  word_t;           --! Input data to be written to destination register

            -- outputs
            o_rs1_data              : out word_t;           --! Output data from source register 1
            o_rs2_data              : out word_t;           --! Output data from source register 2
            o_immediate             : out word_t;           --! Sign extended immediate value extracted from instruction
            o_pc                    : out address_t         --! Program counter value buffered and forwarded to the next pipeline stage
        );
    end component OF_stage;

    component EX_stage is
        port(
            -- inputs
            i_clk                   : in  std_logic;        --! Clock
            i_rst                   : in  std_logic;        --! Synchronous reset
            i_ctrl                  : in  EX_stage_ctrl_t;  --! EX stage control signals
            i_rs1                   : in  word_t;           --! Source register 1 value
            i_rs2                   : in  word_t;           --! Source register 2 value
            i_immediate             : in  word_t;           --! Sign extended immediate value from instruction
            i_pc                    : in  address_t;        --! Program counter value forwarded from the previous pipeline stage

            -- outputs
            o_result                : out word_t            --! Result of ALU operation
        );
    end component EX_stage;

end package riscv_components_pkg;