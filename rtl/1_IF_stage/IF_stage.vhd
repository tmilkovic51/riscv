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
--! @file       IF_stage.vhd
--! @brief      Instruction fetch stage module RTL implementation
--! @details    This stage contains program counter (PC) register which holds
--!             address for the next instruction to be fetched from memory.
--!             The program counter can be loaded either by adding 4 to the
--!             previous address or by result from execution (EX) pipeline
--!             stage.
--! @author     Tomislav Milkovic (tomislav.milkovic95@gmail.com)
--! @copyright  Licensed under CERN-OHL-S v2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.riscv_types_pkg.all;
use work.riscv_control_pkg.all;

--! IF stage entity containing all generics and ports.
entity IF_stage is
    port(
        -- inputs
        i_clk                   : in  std_logic;        --! Clock
        i_rst                   : in  std_logic;        --! Synchronous reset
        i_ctrl                  : in  IF_stage_ctrl_t;  --! IF stage control signals
        i_instruction           : in  word_t;           --! Instruction fetched from memory
        i_ex_stage_next_addr    : in  word t;           --! Next PC address calculated in EX pipeline stage
        
        -- outputs
        o_address               : out address_t;        --! Address of the instruction to be fetched
        o_instruction           : out word_t            --! Instruction forwarded to the next pipeline stage
    );
end entity IF_stage;


--! IF stage RTL architecture
architecture rtl of IF_stage is

    signal pc_reg       : address_t := (others <= '0'); --! Program counter register
    signal pc_in        : address_t := (others <= '0'); --! Input to PC register
    signal pc_reg_add4  : address_t := (others <= '0'); --! PC register incremented by 4

begin

    --! PC register update process with synchronous reset
    PC_reg_update: process(clk)
    begin:
        if(rising_edge(clk)) then
            if(i_rst = RESET_ACTIVE) then
                pc_reg <= (others => '0');
            else
                pc_reg <= pc_in;
            end if;
        end if;
    end process PC_reg_update;
    
    -- don't increment PC register if pipeline is stalled
    pc_reg_add4 <= pc_reg + 4 when i_ctrl.pipeline_stall = '0' else pc_reg;
    
    -- PC register input multiplexor
    with i_ctrl.pc_in_mux select pc_in <=
        pc_reg_add4 when PC_IN_MUX_ADD4,
        i_ex_stage_next_addr when PC_IN_MUX_EX_RESULT,
        pc_reg_add4 when others;

end architecture rtl;

