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
--! @file       WB_stage.vhd
--! @brief      CPU control unit module RTL implementation
--! @details    This module sets receives instruction from IF stage and sets
--!             control signals for all pipeline stages depending on the
--!             instruction.
--! @author     Tomislav Milkovic (tomislav.milkovic95@gmail.com)
--! @copyright  Licensed under CERN-OHL-S v2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.riscv_types_pkg.all;
use work.riscv_control_pkg.all;

--! CPU control unit entity containing all generics and ports
entity control_unit is
    port(
        -- inputs
        i_clk                   : in  std_logic;        --! Clock
        i_rst                   : in  std_logic;        --! Synchronous reset
        i_instruction           : in  word_t;           --! Instruction received from IF stage

        -- outputs
        o_if_stage_ctrl         : out IF_stage_ctrl_t;  --! IF stage control signals
        o_of_stage_ctrl         : out OF_stage_ctrl_t;  --! OF stage control signals
        o_ex_stage_ctrl         : out EX_stage_ctrl_t;  --! EX stage control signals
        o_mem_stage_ctrl        : out MEM_stage_ctrl_t; --! MEM stage control signals
        o_wb_stage_ctrl         : out WB_stage_ctrl_t   --! WB stage control signals
    );
end entity control_unit;


--! CPU control unit RTL architecture
architecture rtl of control_unit is

begin

end architecture rtl;
