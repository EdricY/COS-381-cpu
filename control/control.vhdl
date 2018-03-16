LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Control IS
    PORT(Operation: IN STD_LOGIC_VECTOR(31 DOWNTO 26);
         Func: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
         Branch, MemRead, MemWrite, RegWrite, SignExtend,
         ALUSrc1: OUT STD_LOGIC;
         ALUSrc2, MemToReg, WriteRegDst, PCSrc,
         ALUOpType: OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END Control;

ARCHITECTURE Behavior OF Control IS 
BEGIN
    PROCESS
    BEGIN
    WAIT until Operation'EVENT or Func'EVENT;
    WAIT FOR 20 ps;
    if Operation = "000000" then --R-type
        ALUOpType <= "10";
        if Func = "001000" then --jr
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '0';
            SignExtend <=   '0';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "10"; --X
            MemToReg <=     "00"; --X
            WriteRegDst <=  "00"; --X
            PCSrc <=        "10";
        elsif Func = "100000" or Func = "100111" or Func = "101010" 
           or Func = "100010" or Func = "100001" or Func = "100110" 
        then --add, nor, slt, sub, addu, xor
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '1';
            SignExtend <=   '0';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "00";
            MemToReg <=     "00";
            WriteRegDst <=  "01";
            PCSrc <=        "00";
        elsif Func = "000000" or Func = "000010" then --sll, srl
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '1';
            SignExtend <=   '0';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "10";
            MemToReg <=     "00";
            WriteRegDst <=  "01";
            PCSrc <=        "00";
        end if;
    else 
        if Operation = "100011" then --lw
            Branch <=       '0';
            MemRead <=      '1';
            MemWrite <=     '0';
            RegWrite <=     '1';
            SignExtend <=   '1';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "01";
            MemToReg <=     "01";
            WriteRegDst <=  "00";
            PCSrc <=        "00";
            ALUOpType <=    "00";

        elsif Operation = "001000" or Operation = "001001" then --addi, addui
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '1';
            SignExtend <=   '1';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "01";
            MemToReg <=     "00";
            WriteRegDst <=  "00";
            PCSrc <=        "00";
            ALUOpType <=    "00";

        elsif Operation = "101011" then --sw
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '1';
            RegWrite <=     '0';
            SignExtend <=   '1';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "01";
            MemToReg <=     "00"; --X
            WriteRegDst <=  "00"; --X
            PCSrc <=        "00";
            ALUOpType <=    "00";

        elsif Operation = "000100" then --beq
            Branch <=       '1';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '0';
            SignExtend <=   '1';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "00";
            MemToReg <=     "00"; --X
            WriteRegDst <=  "00"; --X
            PCSrc <=        "00";
            ALUOpType <=    "01";

        elsif Operation = "001101" then --ori
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '1';
            SignExtend <=   '0';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "01";
            MemToReg <=     "00";
            WriteRegDst <=  "00";
            PCSrc <=        "00";
            ALUOpType <=    "11";

        elsif Operation = "000010" then --j
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '0';
            SignExtend <=   '0';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "00";--X
            MemToReg <=     "00";--X
            WriteRegDst <=  "00";--X
            PCSrc <=        "01";
            ALUOpType <=    "00";--X

        elsif Operation = "000011" then --jal
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '1';
            SignExtend <=   '0';
            ALUSrc1 <=      '1';--?
            ALUSrc2 <=      "11";--?
            MemToReg <=     "10";
            WriteRegDst <=  "10";
            PCSrc <=        "01";
            ALUOpType <=    "00";--X
        else --default
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '0';
            SignExtend <=   '0';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "00";
            MemToReg <=     "00";
            WriteRegDst <=  "00";
            PCSrc <=        "00";
            ALUOpType <=    "00";
        end if;
    end if;
    --wait;
    END PROCESS;
END Behavior;
ARCHITECTURE Pipelined OF Control IS --Change jal to store PC + 8 in $31
BEGIN
    PROCESS
    BEGIN
    WAIT until Operation'EVENT or Func'EVENT;
    WAIT FOR 20 ps;
    if Operation = "000000" then --R-type
        ALUOpType <= "10";
        if Func = "001000" then --jr
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '0';
            SignExtend <=   '0';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "10"; --X
            MemToReg <=     "00"; --X
            WriteRegDst <=  "00"; --X
            PCSrc <=        "10";
        elsif Func = "100000" or Func = "100111" or Func = "101010" 
           or Func = "100010" or Func = "100001" or Func = "100110" 
        then --add, nor, slt, sub, addu, xor
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '1';
            SignExtend <=   '0';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "00";
            MemToReg <=     "00";
            WriteRegDst <=  "01";
            PCSrc <=        "00";
        elsif Func = "000000" or Func = "000010" then --sll, srl
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '1';
            SignExtend <=   '0';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "10";
            MemToReg <=     "00";
            WriteRegDst <=  "01";
            PCSrc <=        "00";
        end if;
    else 
        if Operation = "100011" then --lw
            Branch <=       '0';
            MemRead <=      '1';
            MemWrite <=     '0';
            RegWrite <=     '1';
            SignExtend <=   '1';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "01";
            MemToReg <=     "01";
            WriteRegDst <=  "00";
            PCSrc <=        "00";
            ALUOpType <=    "00";

        elsif Operation = "001000" or Operation = "001001" then --addi, addui
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '1';
            SignExtend <=   '1';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "01";
            MemToReg <=     "00";
            WriteRegDst <=  "00";
            PCSrc <=        "00";
            ALUOpType <=    "00";

        elsif Operation = "101011" then --sw
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '1';
            RegWrite <=     '0';
            SignExtend <=   '1';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "01";
            MemToReg <=     "00"; --X
            WriteRegDst <=  "00"; --X
            PCSrc <=        "00";
            ALUOpType <=    "00";

        elsif Operation = "000100" then --beq
            Branch <=       '1';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '0';
            SignExtend <=   '1';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "00";
            MemToReg <=     "00"; --X
            WriteRegDst <=  "00"; --X
            PCSrc <=        "00";
            ALUOpType <=    "01";

        elsif Operation = "001101" then --ori
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '1';
            SignExtend <=   '0';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "01";
            MemToReg <=     "00";
            WriteRegDst <=  "00";
            PCSrc <=        "00";
            ALUOpType <=    "11";

        elsif Operation = "000010" then --j
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '0';
            SignExtend <=   '0';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "00";--X
            MemToReg <=     "00";--X
            WriteRegDst <=  "00";--X
            PCSrc <=        "01";
            ALUOpType <=    "00";--X

        elsif Operation = "000011" then --jal
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '1';
            SignExtend <=   '0';
            ALUSrc1 <=      '1'; -- +4
            ALUSrc2 <=      "11";-- PC+4
            MemToReg <=     "00";-- store from alu
            WriteRegDst <=  "10";
            PCSrc <=        "01";
            ALUOpType <=    "00";-- now we add
        else --default
            Branch <=       '0';
            MemRead <=      '0';
            MemWrite <=     '0';
            RegWrite <=     '0';
            SignExtend <=   '0';
            ALUSrc1 <=      '0';
            ALUSrc2 <=      "00";
            MemToReg <=     "00";
            WriteRegDst <=  "00";
            PCSrc <=        "00";
            ALUOpType <=    "00";
        end if;
    end if;
    --wait;
    END PROCESS;
END Pipelined;

