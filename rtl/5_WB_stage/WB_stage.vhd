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
--! @brief      Write-back stage module RTL implementation
--! @details    This stage receives the data from MEM stage and forwards it to
--!             the register set to be written to the destination register (Rd)
--!             in case instruction result needs to be stored.
--! @author     Tomislav Milkovic (tomislav.milkovic95@gmail.com)
--! @copyright  Licensed under CERN-OHL-S v2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.riscv_types_pkg.all;
use work.riscv_control_pkg.all;
use work.riscv_components_pkg.all;

--! Write-back stage entity containing all generics and ports
entity WB_stage is
    port(
        -- inputs
        i_clk                   : in  std_logic;        --! Clock
        i_rst                   : in  std_logic;        --! Synchronous reset
        i_ctrl                  : in  WB_stage_ctrl_t;  --! WB stage control signals
        i_data                  : in  word_t;           --! Data from MEM stage to be forwarded to the register set

        -- outputs
        o_data                  : out word_t            --! Data to be written to the destination register
    );
end entity WB_stage;


--! Write-back stage RTL architecture
architecture rtl of WB_stage is

begin

    o_data <= i_data;

end architecture rtl;
