LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY test_alu IS
END test_alu;


ARCHITECTURE test OF test_alu IS
    SIGNAL input1, input2: word;
    SIGNAL op: op_type;
    SIGNAL output: word;
    SIGNAL zfl, cfl, ofl, nfl: STD_LOGIC;
BEGIN
    alu: ENTITY work.alu(logic) PORT MAP (input1, input2, op, output, ofl, nfl, zfl, cfl);
    PROCESS
        TYPE pattern_type IS RECORD
            input1, input2: word;
            op: op_type;
            output: word;
            zfl, cfl, ofl, nfl: STD_LOGIC;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=
                -- a           b            op      out        z    c    o    n
                                         --add
            ( (x"00000000", x"00000000", "0000", x"00000000", '1', '0', '0', '0'),
              (x"11110000", x"00001111", "0000", x"11111111", '0', '0', '0', '0'),
              (x"FFFFFFFF", x"00000001", "0000", x"00000000", '1', '1', '0', '0'),
              (x"01234567", x"87654321", "0000", x"88888888", '0', '0', '0', '1'),
              (x"7FFFFFFF", x"00000001", "0000", x"80000000", '0', '0', '1', '1'),

                                         --uadd
              (x"00000000", x"00000000", "0001", x"00000000", '1', '0', '0', '0'),
              (x"11110000", x"00001111", "0001", x"11111111", '0', '0', '0', '0'),
              (x"FFFFFFFF", x"00000001", "0001", x"00000000", '1', '1', '1', '0'),
              (x"01234567", x"87654321", "0001", x"88888888", '0', '0', '0', '0'),
              (x"7FFFFFFF", x"00000001", "0001", x"80000000", '0', '0', '0', '0'),

                                         --lsh
              (x"00000000", x"00000000", "0010", x"00000000", '1', '0', '0', '0'),
              (x"F0000000", x"0000000F", "0010", x"00000000", '1', '0', '1', '0'),
              (x"FFFFFFFF", x"0000000F", "0010", x"FFFF8000", '0', '1', '1', '1'),
              (x"80000000", x"00000001", "0010", x"00000000", '1', '1', '1', '0'),
              (x"40000000", x"00000001", "0010", x"80000000", '0', '0', '0', '1'),

                                         --rsh
              (x"00000000", x"00000000", "0011", x"00000000", '1', '0', '0', '0'),
              (x"0000000F", x"00000001", "0011", x"00000007", '0', '1', '1', '0'),
              (x"FFFFFFFF", x"00000000", "0011", x"FFFFFFFF", '0', '0', '0', '1'),
              (x"80000000", x"FFFFFFFF", "0011", x"00000001", '0', '0', '0', '0'),
              (x"40000000", x"FFFFFFFF", "0011", x"00000000", '1', '1', '1', '0'),

                                         --sub
              (x"00000000", x"00000000", "0100", x"00000000", '1', '1', '0', '0'),
              (x"FFFFFFFF", x"FFFFFFFF", "0100", x"00000000", '1', '1', '0', '0'),
              (x"FFFFFFFF", x"00000000", "0100", x"FFFFFFFF", '0', '1', '0', '1'),
              (x"80000000", x"FFFFFFFF", "0100", x"80000001", '0', '0', '0', '1'),
              (x"80000000", x"00000001", "0100", x"7FFFFFFF", '0', '1', '1', '0'),

                                         --slt
              (x"00000000", x"00000000", "0101", x"00000000", '1', '0', '0', '0'),
              (x"FFFFFFFF", x"FFFFFFFF", "0101", x"00000000", '1', '0', '0', '0'),
              (x"FFFFFFFF", x"00000000", "0101", x"00000001", '0', '0', '0', '0'),
              (x"80000000", x"FFFFFFFF", "0101", x"00000001", '0', '0', '0', '0'),
              (x"80000000", x"00000001", "0101", x"00000001", '0', '0', '0', '0'),
              (x"00000001", x"80000000", "0101", x"00000000", '0', '0', '0', '0'),

                                         --xor
              (x"00001111", x"00111100", "1000", x"00110011", '0', '0', '0', '0'),
              (x"00000000", x"00000000", "1000", x"00000000", '1', '0', '0', '0'),
              (x"FFFFFFFF", x"01234567", "1000", x"FEDCBA98", '0', '0', '0', '1'),

                                         --nor
              (x"00001111", x"00111100", "1001", x"FFEEEEEE", '0', '0', '0', '1'),
              (x"00000000", x"80000000", "1001", x"7FFFFFFF", '0', '0', '0', '0'),
              (x"FFFFFFFF", x"FFFFFFFF", "1001", x"00000000", '1', '0', '0', '0'),

                                         --nand
              (x"0000FFFF", x"00FFFF00", "1010", x"FFFF00FF", '0', '0', '0', '1'),
              (x"FFFFFFFF", x"FFFFFFFF", "1010", x"00000000", '1', '0', '0', '0'),
              (x"80000000", x"87654321", "1010", x"7FFFFFFF", '0', '0', '0', '0'),

                                         --or
              (x"0000FFFF", x"00FFFF00", "1011", x"00FFFFFF", '0', '0', '0', '0'),
              (x"FFFFFFFF", x"FFFFFFFF", "1011", x"FFFFFFFF", '0', '0', '0', '1'),
              (x"80000000", x"87654321", "1011", x"87654321", '0', '0', '0', '1'),
              (x"00000000", x"00000000", "1011", x"00000000", '1', '0', '0', '0'),

                                         --comp
              (x"00000000", x"BEEEEEEF", "1100", x"FFFFFFFF", '0', '0', '0', '1'),
              (x"FFFFFFFF", x"BEEEEEEF", "1100", x"00000000", '1', '0', '0', '0'),
              (x"AAAA0123", x"BEEEEEEF", "1100", x"5555FEDC", '0', '0', '0', '0')

            );

    BEGIN
        FOR i IN patterns'range LOOP
            input1 <= patterns(i).input1;
            input2 <= patterns(i).input2;
            op <= patterns(i).op;
            
            wait for 1 ms;

            assert output = patterns(i).output
                report "bad output" severity error;
            assert zfl = patterns(i).zfl
                report "bad zfl" severity error;
            assert cfl = patterns(i).cfl
                report "bad cfl" severity error;
            assert ofl = patterns(i).ofl
                report "bad ofl" severity error;
            assert nfl = patterns(i).nfl
                report "bad nfl" severity error;
        END LOOP;

        assert false
            report "end of alu test" severity note;

        wait;
    END PROCESS;
END test;

