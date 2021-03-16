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
--! @file       riscv_opcodes_pkg.vhd
--! @brief      Package containing definitions of all RISC-V opcodes
--! @details    This package contains definitions of all RISC-V opcodes
--!             specified in base RV32I ISA, along with opcodes specified in M,
--!             A and F ISA extansions.
--! @author     Tomislav Milkovic (tomislav.milkovic95@gmail.com)
--! @copyright  Licensed under CERN-OHL-S v2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.riscv_types_pkg.opcode_t;

package riscv_opcodes_pkg is
    -- RV32I base ISA (with Zifencei and Zicsr extensions)
    constant OPCODE_LUI              : opcode_t := "0110111"; --! load upper immediate
    constant OPCODE_AUIPC            : opcode_t := "0010111"; --! add upper immediate and PC
    constant OPCODE_JAL              : opcode_t := "1101111"; --! jump
    constant OPCODE_JALR             : opcode_t := "1100111"; --! jump relative
    constant OPCODE_BRANCH           : opcode_t := "1100011"; --! branch (BEQ, BNE, BLT, BGE, BLTU, BGEU)
    constant OPCODE_LOAD             : opcode_t := "0000011"; --! load (LB, LH, LW, LBU, LHU)
    constant OPCODE_STORE            : opcode_t := "0100011"; --! store (SB, SH, SW)
    constant OPCODE_AL_OP            : opcode_t := "0110011"; --! arithmetical, logical and shift ops (ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND)
    constant OPCODE_ALI_OP           : opcode_t := "0010011"; --! immediate arithmetical, logical and shift ops (ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI)
    constant OPCODE_FENCE            : opcode_t := "0001111"; --! FENCE, FENCE.I (Zifencei extension)
    constant OPCODE_CSR_ECALL_EBREAK : opcode_t := "1110011"; --! ECALL, EBREAK, CSR ops (Zicsr extension - CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI)

    -- RV32M extension
    constant OPCODE_MUL_DIV_REM      : opcode_t := "0110011"; --! RV32M ops (MUL, MULH, MULHSU, MULHU, DIV, DIVU, REM, REMU)

    -- RV32A extension
    constant OPCODE_ATOMIC           : opcode_t := "0101111"; --! atomic ops (LR.W, SC.W, AMOSWAP.W, AMOADD.W, AMOXOR.W, AMOAND.W, AMOOR.W, AMOMIN.W, AMOMAX.W, AMOMINU.W, AMOMAXU.W)

    -- RV32F extension
    constant OPCODE_FLW              : opcode_t := "0000111"; --! load floating point word
    constant OPCODE_FSW              : opcode_t := "0100111"; --! store floating point word
    constant OPCODE_FMADD_S          : opcode_t := "1000011"; --! fused multiply - add
    constant OPCODE_FMSUB_S          : opcode_t := "1000111"; --! fused multiply - subtract
    constant OPCODE_FNMSUB_S         : opcode_t := "1001011"; --! negated fused multiply - subtract
    constant OPCODE_FNMADD_S         : opcode_t := "1001111"; --! negated fused multiply - add
    constant OPCODE_FADD_S           : opcode_t := "1010011"; --! all other regular floating point ops (FADD.S, FSUB.S, FMUL.S, FDIV.S, FSQRT.S, FSGNJ.S, FSGNJN.S, FSGNJX.S, FMIN.S, FMAX.S, FCVT.W.S, FCVT.WU.S, FMV.X.W, FEQ.S, FLT.S, FLE.S, FCLASS.S, FCVT.S.W, FCVT.S.WU, FMV.W.X)
end package riscv_opcodes_pkg;