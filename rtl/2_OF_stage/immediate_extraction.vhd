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
--! @file       immediate_extraction.vhd
--! @brief      Immediate extraction and sign extension module RTL implementation
--! @details    This module extracts the immediate value for all instruction 
--! ¨           formats and sign extends it, if necessary.
--! @author     Tomislav Milkovic (tomislav.milkovic95@gmail.com)
--! @copyright  Licensed under CERN-OHL-S v2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_types_pkg.all;
use work.riscv_control_pkg.all;

--! Immediate extraction and sign extension entity containing all generics and ports
entity immediate_extraction is
    port(
        -- inputs
        i_data              : in  word_t;           --! Input word (instruction)
        i_instr_format      : in  instr_format_t;   --! Instruction format control signal
        
        -- outputs
        o_data              : out word_t            --! Output (sign extended) word
    );
end entity immediate_extraction;


--! Immediate extraction and sign extension RTL architecture
architecture rtl of immediate_extraction is

begin

    --! Combinational process for immediate extraction and sign extension
    imm_extract: process(i_data, i_instr_format) is
    begin
        case i_instr_format is
            when U_TYPE =>
                o_data <=
                    (31 downto 12 => i_data(31 downto 12),
                    others => '0');
            when J_TYPE =>
                o_data <=
                    (20 => i_data(31),
                    19 downto 12 => i_data(19 downto 12),
                    11 => i_data(20),
                    10 downto 1 => i_data(30 downto 21),
                    0 => '0',
                    others => i_data(31));
            when I_TYPE =>
                o_data <=
                    (11 downto 0 => i_data(31 downto 20),
                    others => i_data(31));
            when I_SHIFT_TYPE =>
                o_data <=
                    (4 downto 0 => i_data(24 downto 20),
                    others => '0');
            when S_TYPE =>
                o_data <=
                    (11 downto 5 => i_data(31 downto 25),
                    4 downto 0 => i_data(11 downto 7),
                    others => i_data(31));
            when B_TYPE =>
                o_data <=
                    (12 => i_data(31),
                    11 => i_data(7),
                    10 downto 5 => i_data(30 downto 25),
                    4 downto 1 => i_data(11 downto 8),
                    0 => '0',
                    others => i_data(31));
            when others =>
                -- Instruction format does not have an immediate value
                 o_data <= 
                    (19 downto 0 => i_data(31 downto 12),
                    others => i_data(31));
        end case;
    end process imm_extract;

end architecture rtl;
