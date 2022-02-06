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
--! @file       riscv_control_pkg.vhd
--! @brief      Package containing definitions of control signals
--! @details    This package contains records with control signals for each
--!             pipeline stage, along with constatns for easier undersanding of
--!             control signals values.
--! @author     Tomislav Milkovic (tomislav.milkovic95@gmail.com)
--! @copyright  Licensed under CERN-OHL-S v2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.riscv_types_pkg.all;

--! Package containing definitions of records with control signals for each pipeline stage
package riscv_control_pkg is

    --! Instruction fetch stage control signals record
    type IF_stage_ctrl_t is record
        pc_in_mux       : std_logic_vector(1 downto 0);     --! PC input multiplexor control signal
        pipeline_stall  : std_logic;                        --! Pipeline stall flag
        mem_wait        : std_logic;                        --! Memory wait flag
    end record IF_stage_ctrl_t;

    -- Instruction fetch stage related constants
    constant PC_IN_MUX_ADD4 : std_logic_vector(1 downto 0) := "00";         --! PC input MUX PC+4 selector
    constant PC_IN_MUX_EX_RESULT : std_logic_vector(1 downto 0) := "01";    --! PC input MUX EX stage result selector

    --! Operand fetch stage control signals record
    type OF_stage_ctrl_t is record
        rs1_addr        : reg_address_t;        --! Source register 1 address
        rs2_addr        : reg_address_t;        --! Source register 2 address
        rd_addr         : reg_address_t;        --! Destination register address
        rd_we           : std_logic;            --! Destination register write enable
        instr_format    : instr_format_t;       --! Instruction format
        pipeline_stall  : std_logic;            --! Pipeline stall flag
        mem_wait        : std_logic;            --! Memory wait flag
    end record OF_stage_ctrl_t;

    -- Execution stage related constants
    constant ALU_OPERAND1_MUX_RS1 : std_logic := '0';           --! ALU operand 1 is source register 1 selector value
    constant ALU_OPERAND1_MUX_PC  : std_logic := '1';           --! ALU operand 1 is PC register selector value
    constant ALU_OPERAND2_MUX_RS2 : std_logic := '0';           --! ALU operand 2 is source register 2 selector value
    constant ALU_OPERAND2_MUX_IMM : std_logic := '1';           --! ALU operand 2 is immediate selector value

    --! Execution stage control signals record
    type EX_stage_ctrl_t is record
        alu_operand1_mux    : std_logic;        --! ALU operand 1 input multiplexor control signal
        alu_operand2_mux    : std_logic;        --! ALU operand 2 input multiplexor control signal
        alu_operation       : alu_op_t;         --! ALU operation select multiplexor control signal
        alu_add_sub_mux     : std_logic;        --! ALU addition/subtraction select multiplexor control signal
        alu_arith_log_mux   : std_logic;        --! Shifter arithmetic/logic shift select multiplexor control signal
        pipeline_stall      : std_logic;        --! Pipeline stall flag
        mem_wait            : std_logic;        --! Memory wait flag
    end record EX_stage_ctrl_t;

     -- Memory access stage related constants
    constant MEM_READ   : std_logic := '0';      --! Data memory read signal value
    constant MEM_WRITE  : std_logic := '1';      --! Data memory write signal value

    --! Memory access stage control signals record
    type MEM_stage_ctrl_t is record
        mem_rw              : std_logic;        --! Data memory read or write signal
    end record MEM_stage_ctrl_t;

    --! Write-back stage control signals record
    type WB_stage_ctrl_t is record
        dummy              : std_logic;         --! No control signals for WB stage
    end record WB_stage_ctrl_t;

end package riscv_control_pkg;