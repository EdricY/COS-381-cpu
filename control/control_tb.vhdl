LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test_control IS
END test_control;

ARCHITECTURE test OF test_control IS 
    SIGNAL Operation: STD_LOGIC_VECTOR(31 DOWNTO 26);
    SIGNAL Func: STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL Branch, MemRead, MemWrite, RegWrite, SignExtend, ALUSrc1: STD_LOGIC;
    SIGNAL ALUSrc2, MemToReg, WriteRegDst, PCSrc, ALUOpType: STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
    control: ENTITY work.Control(Behavior) PORT MAP (Operation, Func, Branch, MemRead, MemWrite, RegWrite, SignExtend,
                                                 ALUSrc1, ALUSrc2, MemToReg, WriteRegDst, PCSrc, ALUOpType);
    PROCESS
        TYPE pattern_type IS RECORD
            Operation: STD_LOGIC_VECTOR(31 DOWNTO 26);
            Func: STD_LOGIC_VECTOR(5 DOWNTO 0);
            Branch, MemRead, MemWrite, RegWrite, SignExtend, ALUSrc1: STD_LOGIC;
            ALUSrc2, MemToReg, WriteRegDst, PCSrc, ALUOpType: STD_LOGIC_VECTOR(1 DOWNTO 0);
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=
            (
              ("000000", "001000", '0', '0', '0', '0', '0', '0', "10", "00", "00", "10", "10"),
              ("100011", "000000", '0', '1', '0', '1', '1', '0', "01", "01", "00", "00", "00"),
              ("001101", "000000", '0', '0', '0', '1', '0', '0', "01", "01", "00", "00", "11")
            );

    BEGIN
        FOR i IN patterns'range LOOP
            Operation <= patterns(i).Operation;
            Func <= patterns(i).Func;
            wait for 1 ms;
            assert PCSrc = patterns(i).PCSrc and ALUOpType = patterns(i).ALUOpType and MemRead = patterns(i).MemRead
                report "bad output" severity error;
        END LOOP;

        assert false
            report "end of control test" severity note;

        wait;
    END PROCESS;
END test;

--this was really just to make sure I know how processes work...
