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
--!             current program counter value (normal program flow) or by 
--!             result from EX pipeline stage (jump instructions).
--! @author     Tomislav Milkovic (tomislav.milkovic95@gmail.com)
--! @copyright  Licensed under CERN-OHL-S v2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_types_pkg.all;
use work.riscv_control_pkg.all;

--! Instruction fetch stage entity containing all generics and ports
entity IF_stage is
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
end entity IF_stage;


--! Instruction fetch stage RTL architecture
architecture rtl of IF_stage is

    signal pc_reg_en    : std_logic := '0';             --! PC register input enable
    signal pc_reg       : address_t := (others => '0'); --! Program counter register
    signal pc_in        : address_t := (others => '0'); --! Input to PC register
    signal pc_reg_add4  : address_t := (others => '0'); --! PC register incremented by 4

begin

    --! PC register update process with synchronous reset
    PC_reg_update: process(i_clk)
    begin
        if(rising_edge(i_clk)) then
            if(i_rst = RESET_ACTIVE) then
                pc_reg <= (others => '0');
            elsif(pc_reg_en = '1') then
                pc_reg <= pc_in;
            end if;
        end if;
    end process PC_reg_update;
    
    -- don't increment PC register if pipeline is stalled
    pc_reg_add4 <= address_t(unsigned(pc_reg) + 4) when i_ctrl.pipeline_stall = '0' else pc_reg;
    
    -- enable or disable writes to PC register based on IF stage control signals
    pc_reg_en <= not i_ctrl.mem_wait;
    
    -- PC register input multiplexor
    with i_ctrl.pc_in_mux select pc_in <=
        i_ex_stage_next_addr when PC_IN_MUX_EX_RESULT,  -- input to PC register is result from EX pipeline stage
        pc_reg_add4 when others;                        -- input to PC register is current PC register value + 4
        
    -- assign output signals
    o_address <= pc_reg;
    o_instruction <= i_instruction;
    o_pc <= pc_in; -- forward value that is currently being written to PC register

end architecture rtl;
