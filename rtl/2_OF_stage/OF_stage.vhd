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
--! @file       OF_stage.vhd
--! @brief      Operand fetch stage module RTL implementation
--! @details    This stage instantiates the register set of 2^REG_ADDRESS_SIZE
--!             registers (REG_ADDRESS_SIZE is defined in riscv_types_pkg.vhd
--!             file). It also instantiates the logic necessary for extraction
--!             and sign extension of immediate value from the fetched 
--!             instruction.
--! @author     Tomislav Milkovic (tomislav.milkovic95@gmail.com)
--! @copyright  Licensed under CERN-OHL-S v2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.riscv_types_pkg.all;
use work.riscv_control_pkg.all;

use work.riscv_components_pkg.regset;
use work.riscv_components_pkg.immediate_extraction;

--! Operand fetch stage entity containing all generics and ports
entity OF_stage is
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
end entity OF_stage;


--! Operand fetch stage RTL architecture
architecture rtl of OF_stage is

    signal reg_en : std_logic;
    signal pc_reg : address_t := (others => '0');

begin

    --! Register set module
    regs: regset port map (
        i_clk       => i_clk,
        i_addr_a    => i_ctrl.rs1_addr,
        i_addr_b    => i_ctrl.rs2_addr,
        i_addr_c    => i_ctrl.rd_addr,
        i_we        => i_ctrl.rd_we,
        i_data_c    => i_rd_data,
        
        o_data_a    => o_rs1_data,
        o_data_b    => o_rs2_data
    );
    
    --! Immediate value extraction and sign extension module
    extend: immediate_extraction port map (
        i_data      => i_instruction,
        o_data      => o_immediate
    );
    
    --! Program counter buffering process
    pc_buffer: process (i_clk) is
    begin
        if(rising_edge(i_clk)) then
            if(i_rst = '1') then
                pc_reg <= (others => '0');
            elsif(reg_en = '1') then
                pc_reg <= i_pc;
            end if;
        end if;
    end process pc_buffer;

    reg_en <= not i_ctrl.mem_wait;

    --! Assign output signals
    o_pc <= pc_reg;

end architecture rtl;

