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

--! Package containing definitions of records with control signals for each pipeline stage
package riscv_control_pkg is

    --! Instruction fetch stage control signals record
    type IF_stage_ctrl_t is record
        pc_in_mux       : std_logic_vector(1 downto 0);     --! PC input multiplexor control signal
        pipeline_stall  : std_logic;                        --! Pipeline stall flag
    end record IF_stage_ctrl_t;
    
    constant PC_IN_MUX_ADD4 : std_logic_vector(1 downto 0) := "00";         --! PC input MUX PC+4 selector
    constant PC_IN_MUX_EX_RESULT : std_logic_vector(1 downto 0) := "01";    --! PC input MUX EX stage result selector
    
end package riscv_control_pkg;