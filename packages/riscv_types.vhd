library ieee;
use ieee.std_logic_1164.all;

package riscv_types is
    
    -- Signal sizes and types
    constant WORD_SIZE : integer := 32;
    subtype word_t is std_logic_vector(WORD_SIZE - 1 downto 0);
	
	constant ADDRESS_SIZE : integer := 32;
	subtype address_t is std_logic_vector(ADDRESS_SIZE - 1 downto 0);

    constant REG_ADDRESS_SIZE : integer := 5;
    subtype reg_address_t is std_logic_vector(REG_ADDRESS_SIZE - 1 downto 0);

    constant OPCODE_SIZE : integer := 7;
    subtype opcode_t is std_logic_vector(OPCODE_SIZE - 1 downto 0);

    constant IMMEDIATE_SIZE : integer := 17;
    subtype immediate_t is std_logic_vector(IMMEDIATE_SIZE - 1 downto 0);

    constant STATUS_SIZE : integer := 2;
    subtype status_t is std_logic_vector(STATUS_SIZE - 1 downto 0);
    
    -- Status register bit indices
    constant Z : natural := 0;
    constant S : natural := 1;
    
    constant CONDITION_SIZE : integer := 3;
    subtype condition_t is std_logic_vector(CONDITION_SIZE - 1 downto 0);
    
    -- Condition constants
    constant AL :condition_t := "000"; -- always
    constant NV :condition_t := "001"; -- never
    constant ZR :condition_t := "010"; -- zero = 1
    constant NZ :condition_t := "011"; -- zero = 0
    constant PL :condition_t := "100"; -- plus (sign = 0)
    constant MI :condition_t := "101"; -- always
    
end package riscv_types;