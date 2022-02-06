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
--! @file       regset.vhd
--! @brief      Register set module RTL implementation
--! @details    This module describes a register set containing
--!             2^REG_ADDRESS_SIZE registers (REG_ADDRESS_SIZE is defined in
--!             riscv_types_pkg.vhd file). Register set has 3 ports:
--!                 - output port A
--!                 - output port B
--!                 - input port C
--!             Input port is synchronous, while output ports are asynchronous.
--!             When rgister X0 is selected to be written on port C, the write
--!             is ignored, so value of X0 always stays zero, as specified by
--!             RISC-V ISA specification.
--! @author     Tomislav Milkovic (tomislav.milkovic95@gmail.com)
--! @copyright  Licensed under CERN-OHL-S v2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.or_reduce;

library work;
use work.riscv_types_pkg.all;
use work.riscv_control_pkg.all;

--! Register set entity containing all generics and ports
entity regset is
    port(
        -- inputs
        i_clk                   : in  std_logic;        --! Clock
        i_rst                   : in  std_logic;        --! Synchronous reset
        i_addr_a                : in  reg_address_t;    --! Register address for output port A
        i_addr_b                : in  reg_address_t;    --! Register address for output port B
        i_addr_c                : in  reg_address_t;    --! Register address for input port C
        i_we                    : in  std_logic;        --! Write enable signal for input port C
        i_data_c                : in  word_t;           --! Data input into port C

        -- outputs
        o_data_a                : out word_t;           --! Data output from port A
        o_data_b                : out word_t            --! Data output from port B
    );
end entity regset;


--! Register set RTL architecture
architecture rtl of regset is

    signal registers        : regset_type   := (others => (others => '0')); --! Array of 2^REG_ADDRESS_SIZE registers
    signal addr_c_is_x0     : std_logic     := '0';                         --! Is X0 register addressed on port C

begin

    -- If no bits in port C address are set, the addressed register is X0 (the register with constant zero value)
    addr_c_is_x0 <= not or_reduce(i_addr_c);

    --! Data input process for port C
    data_input: process (i_clk)
    begin
        if (rising_edge(i_clk)) then
            -- Check if reset here is needed (synthesis tools may infer registers instead of distributed RAM)
            if(i_rst = '1') then
                registers <= (others => (others => '0'));
            -- Write to regset only if write enable is active and X0 is not addressed
            -- (that way the X0 will never be written to and its value will remain 0 forever)
            elsif((i_we = '1') and (addr_c_is_x0 = '0')) then
                registers(to_integer(unsigned(i_addr_c))) <= i_data_c;
            end if;
        end if;
    end process data_input;

    -- Data outputs - X0 is never written to, so it always outputs 0 (RISC-V ISA specification)
    o_data_a <= registers(to_integer(unsigned(i_addr_a)));
    o_data_b <= registers(to_integer(unsigned(i_addr_b)));

end architecture rtl;
