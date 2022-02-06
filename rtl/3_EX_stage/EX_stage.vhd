--------------------------------------------------------------------------------
-- Copyright Tomislav Milkovic 2021.
--
-- This source describes Open Hardware and is licensed under the CERN-OHL-S v2
--
-- You may redistribute and modify this source and make products
-- using it under the terms of the CERN-OHL-S v2 (https://cern.ch/cern-ohl).
-- This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY,
-- INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A
-- PARTICULAR PURPOSE. Please see the CERN-OHL-S v2 for applicable conditions.
-------------------------------------------------------------------------------
--! @file       EX_stage.vhd
--! @brief      Execution stage module RTL implementation
--! @details    This stage instantiates the arithmetic-logic unit, which
--!             consists of 32-bit full adder and barrel shifter unit. Based
--!             on EX stage control signals, operands and ALU operation is
--!             selected.
--! @author     Tomislav Milkovic (tomislav.milkovic95@gmail.com)
--! @copyright  Licensed under CERN-OHL-S v2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.riscv_types_pkg.all;
use work.riscv_control_pkg.all;
use work.riscv_components_pkg.all;

--! Execution stage entity containing all generics and ports
entity EX_stage is
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
        o_alu_result            : out word_t;           --! Result of ALU operation
        o_rs2                   : out word_t            --! Rs2 register forwarded from OF stage (needed for load and store instructions)
    );
end entity EX_stage;


--! Execution stage RTL architecture
architecture rtl of EX_stage is

    signal alu_operand1 : word_t;
    signal alu_operand2 : word_t;

    signal reg_en : std_logic;
    signal pc_reg : address_t := (others => '0');
    signal imm_reg  : word_t := (others => '0');
    signal rs1_reg  : word_t := (others => '0');
    signal rs2_reg  : word_t := (others => '0');

begin

    --! ALU operand 1 selection multiplexor
    with i_ctrl.alu_operand1_mux select
        alu_operand1 <=
            pc_reg when ALU_OPERAND1_MUX_PC,
            rs1_reg when others;

    --! ALU operand 2 selection multiplexor
    with i_ctrl.alu_operand2_mux select
        alu_operand2 <=
            imm_reg when ALU_OPERAND2_MUX_IMM,
            rs2_reg when others;

    --! Operands buffering process
    operand_buffer: process (i_clk) is
    begin
        if(rising_edge(i_clk)) then
            if(i_rst = '1') then
                pc_reg <= (others => '0');
                imm_reg <= (others => '0');
                rs1_reg <= (others => '0');
                rs2_reg <= (others => '0');
            elsif(reg_en = '1') then
                pc_reg <= i_pc;
                imm_reg <= i_immediate;
                rs1_reg <= i_rs1;
                rs2_reg <= i_rs2;
            end if;
        end if;
    end process operand_buffer;

    reg_en <= not i_ctrl.mem_wait;
    o_rs2 <= rs2_reg;

end architecture rtl;
