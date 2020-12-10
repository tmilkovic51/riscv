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
use work.riscv_types_pkg.all;
use work.riscv_control_pkg.all;

--! Immediate extraction and sign extension entity containing all generics and ports
entity immediate_extraction is
    port(
        -- inputs
        i_data              : in  word_t;           --! Input word (instruction)
        
        -- outputs
        o_data              : out word_t;           --! Output (sign extended) word
    );
end entity immediate_extraction;

--! Immediate extraction and sign extension RTL architecture
architecture rtl of immediate_extraction is




begin



end architecture rtl;
