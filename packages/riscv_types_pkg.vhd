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
--! @file       riscv_types_pkg.vhd
--! @brief      Package containing definitions of types used in project
--! @details    This package contains definitions of types used throughout the
--!             whole project (e.g. word and address size, instruction formats)
--! @author     Tomislav Milkovic (tomislav.milkovic95@gmail.com)
--! @copyright  Licensed under CERN-OHL-S v2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package riscv_types_pkg is
    
    -- Signal sizes and types
    constant WORD_SIZE : integer := 32;
    subtype word_t is std_logic_vector(WORD_SIZE - 1 downto 0);
    
    constant ADDRESS_SIZE : integer := 32;
    subtype address_t is std_logic_vector(ADDRESS_SIZE - 1 downto 0);

    constant REG_ADDRESS_SIZE : integer := 5;
    subtype reg_address_t is std_logic_vector(REG_ADDRESS_SIZE - 1 downto 0);
    type regset_type is array ((2**REG_ADDRESS_SIZE) - 1 downto 0) of word_t;

    constant OPCODE_SIZE : integer := 7;
    subtype opcode_t is std_logic_vector(OPCODE_SIZE - 1 downto 0);

    constant IMMEDIATE_SIZE : integer := 20;
    subtype immediate_t is std_logic_vector(IMMEDIATE_SIZE - 1 downto 0);

    constant STATUS_SIZE : integer := 2;
    subtype status_t is std_logic_vector(STATUS_SIZE - 1 downto 0);
    
    type instr_format_t is (U_TYPE, J_TYPE, R_TYPE, I_TYPE, I_SHIFT_TYPE, S_TYPE, B_TYPE);
    
    constant RESET_ACTIVE : std_logic := '1';
    constant RESET_INACTIVE : std_logic := '0';
    
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
    
    --! U-type instruction format
    type instr_u_type is record
        imm         : std_logic_vector(19 downto 0);    --! 20-bit immediate value
        rd          : std_logic_vector(4 downto 0);     --! destination register
        opcode      : opcode_t;                         --! instruction operation code
    end record instr_u_type;
    
    --! J-type instruction format
    type instr_j_type is record
        imm20       : std_logic_vector(0 downto 0);     --! bit 20 of the immediate value
        imm10to1    : std_logic_vector(9 downto 0);     --! bits 10 to 1 of the immediate value
        imm11       : std_logic_vector(0 downto 0);     --! bit 11 of the immediate
        imm19to12   : std_logic_vector(7 downto 0);     --! bits 19 to 12 of the immediate value
        rd          : std_logic_vector(4 downto 0);     --! destination register
        opcode      : opcode_t;                         --! instruction operation code
    end record instr_j_type;
    
    --! R-type instruction format
    type instr_r_type is record
        funct7      : std_logic_vector(6 downto 0);     --! funct7 part of the instruction
        rs2         : std_logic_vector(4 downto 0);     --! source register 2
        rs1         : std_logic_vector(4 downto 0);     --! source register 1
        funct3      : std_logic_vector(2 downto 0);     --! funct3 part of the instruction
        rd          : std_logic_vector(4 downto 0);     --! destination register
        opcode      : opcode_t;                         --! instruction operation code
    end record instr_r_type;
    
    --! I-type instruction format
    type instr_i_type is record
        imm         : std_logic_vector(11 downto 0);    --! 12-bit immediate value
        rs1         : std_logic_vector(4 downto 0);     --! source register 1
        funct3      : std_logic_vector(2 downto 0);     --! funct3 part of the instruction
        rd          : std_logic_vector(4 downto 0);     --! destination register
        opcode      : opcode_t;                         --! instruction operation code
    end record instr_i_type;
    
    --! I-type (shift) instruction format
    type instr_i_shift_type is record
        funct7      : std_logic_vector(6 downto 0);     --! funct7 part of the instruction
        shamt       : std_logic_vector(4 downto 0);     --! shift amount
        rs1         : std_logic_vector(4 downto 0);     --! source register 1
        funct3      : std_logic_vector(2 downto 0);     --! funct3 part of the instruction
        rd          : std_logic_vector(4 downto 0);     --! destination register
        opcode      : opcode_t;                         --! instruction operation code
    end record instr_i_shift_type;
    
    --! S-type instruction format
    type instr_s_type is record
        imm11to5    : std_logic_vector(6 downto 0);     --! bits 11 to 5 of the immediate value
        rs2         : std_logic_vector(4 downto 0);     --! source register 2
        rs1         : std_logic_vector(4 downto 0);     --! source register 1
        funct3      : std_logic_vector(2 downto 0);     --! funct3 part of the instruction
        imm4to0     : std_logic_vector(4 downto 0);     --! bits 4 to 0 of the immediate value
        opcode      : opcode_t;                         --! instruction operation code
    end record instr_s_type;
    
    --! B-type instruction format
    type instr_b_type is record
        imm12       : std_logic_vector(0 downto 0);     --! bit 12 of the immediate value
        imm10to5    : std_logic_vector(5 downto 0);     --! bits 10 to 5 of the immediate value
        rs2         : std_logic_vector(4 downto 0);     --! source register 2
        rs1         : std_logic_vector(4 downto 0);     --! source register 1
        funct3      : std_logic_vector(2 downto 0);     --! funct3 part of the instruction
        imm4to1     : std_logic_vector(3 downto 0);     --! bits 4 to 1 of the immediate value
        imm11       : std_logic_vector(0 downto 0);     --! bit 11 of the immediate value
        opcode      : opcode_t;                         --! instruction operation code
    end record instr_b_type;
    
end package riscv_types_pkg;