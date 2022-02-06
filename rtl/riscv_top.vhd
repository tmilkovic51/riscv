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
--! @file       riscv_top.vhd
--! @brief      Top file which instantiates and connects all components.
--! @details    This file instantiates and connects all pipeline stages
--!             together and to the control unit (IF_stage.vhd, OF_stage.vhd,
--!             EX_stage.vhd, MEM_stage.vhd, WB_stage.vhd and
--!             control_unit.vhd).
--! @author     Tomislav Milkovic (tomislav.milkovic95@gmail.com)
--! @copyright  Licensed under CERN-OHL-S v2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.riscv_types_pkg.all;
use work.riscv_control_pkg.all;
use work.riscv_components_pkg.IF_stage;
use work.riscv_components_pkg.OF_stage;
use work.riscv_components_pkg.EX_stage;
use work.riscv_components_pkg.MEM_stage;
use work.riscv_components_pkg.WB_stage;
use work.riscv_components_pkg.control_unit;

--! Top module entity containing all generics and ports
entity riscv_top is
    port(
        -- inputs
        i_clk                   : in  std_logic;        --! Clock
        i_rst                   : in  std_logic;        --! Synchronous reset
        i_instr_mem_word        : in  word_t;           --! Data word from instruction memory
        i_data_mem_word         : in  word_t;           --! Data word from data memory
        i_instr_mem_wait        : in  std_logic;        --! Instruction memory wait signal
        i_data_mem_wait         : in  std_logic;        --! Data memory wait signal
        
        -- outputs
        o_instr_mem_addr        : out address_t;        --! Program counter value (address in instruction memory)
        o_data_mem_addr         : out address_t;        --! Data memory address
        o_data_mem_word         : out word_t;           --! Word to be writen to data memory
        o_data_mem_rw           : out std_logic         --! Data memory read or write signal
    );
end entity riscv_top;


--! Top module structural architecture
architecture structural of riscv_top is

    signal if_stage_control         : IF_stage_ctrl_t;
    signal if_stage_pc              : address_t;
    signal if_stage_instruction     : word_t;

    signal of_stage_control         : OF_stage_ctrl_t;
    signal of_stage_rs1_data        : word_t;
    signal of_stage_rs2_data        : word_t;
    signal of_stage_immediate       : word_t;
    signal of_stage_pc              : address_t;

    signal ex_stage_control         : EX_stage_ctrl_t;
    signal ex_stage_result          : word_t;

    signal mem_stage_control        : MEM_stage_ctrl_t;
    signal mem_stage_result         : word_t;

    signal wb_stage_control         : WB_stage_ctrl_t;
    signal wb_stage_data            : word_t;

begin

    --! Instruction fetch pipeline stage instance
    IF_stage_inst: IF_stage port map (
        -- inputs
        i_clk                       => i_clk,
        i_rst                       => i_rst,
        i_ctrl                      => if_stage_control,
        i_instruction               => i_instr_mem_word,
        i_ex_stage_next_addr        => ex_stage_result,

        -- outputs
        o_address                   => o_instr_mem_addr,
        o_instruction               => if_stage_instruction,
        o_pc                        => if_stage_pc
    );

    --! Operand fetch pipeline stage instance
    OF_stage_inst: OF_stage port map (
        -- inputs
        i_clk                       => i_clk,
        i_rst                       => i_rst,
        i_ctrl                      => of_stage_control,
        i_instruction               => if_stage_instruction,
        i_pc                        => if_stage_pc,
        i_rd_data                   => wb_stage_data,

        -- outputs
        o_rs1_data                  => of_stage_rs1_data,
        o_rs2_data                  => of_stage_rs2_data,
        o_immediate                 => of_stage_immediate,
        o_pc                        => of_stage_pc
    );

    --! Execute pipeline stage instance
    EX_stage_inst: EX_stage port map (
        -- inputs
        i_clk                       => i_clk,
        i_rst                       => i_rst,
        i_ctrl                      => ex_stage_control,
        i_rs1                       => of_stage_rs1_data,
        i_rs2                       => of_stage_rs2_data,
        i_immediate                 => of_stage_immediate,
        i_pc                        => of_stage_pc,

        -- outputs
        o_result                    => ex_stage_result
    );

    --! Memory access pipeline stage instance
    MEM_stage_inst: MEM_stage port map (
        -- inputs
        i_clk                       => i_clk,
        i_rst                       => i_rst,
        i_ctrl                      => mem_stage_control,
        i_mem_addr                  => ex_stage_result, -- TODO: add different EX stage outputs for address and data
        i_mem_write_data            => ex_stage_result, -- TODO: add different EX stage outputs for address and data
        i_mem_read_data             => i_data_mem_word,

        -- outputs
        o_mem_addr                  => o_data_mem_addr,
        o_mem_rw                    => o_data_mem_rw,
        o_mem_write_data            => o_data_mem_word,
        o_mem_read_data             => mem_stage_result
    );

    --! Write-back pipeline stage instance
    WB_stage_inst: WB_stage port map (
        -- inputs
        i_clk                       => i_clk,
        i_rst                       => i_rst,
        i_ctrl                      => wb_stage_control,
        i_data                      => mem_stage_result,

        -- outputs
        o_data                      => wb_stage_data
    );

    --! CPU control unit instance
    control_unit_inst: control_unit port map (
        -- inputs
        i_clk                       => i_clk,
        i_rst                       => i_rst,
        i_instruction               => if_stage_instruction,

        -- outputs
        o_if_stage_ctrl             => if_stage_control,
        o_of_stage_ctrl             => of_stage_control,
        o_ex_stage_ctrl             => ex_stage_control,
        o_mem_stage_ctrl            => mem_stage_control,
        o_wb_stage_ctrl             => wb_stage_control
    );

end architecture structural;
