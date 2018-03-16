LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY test_mux2x32_1 IS
END test_mux2x32_1;

ARCHITECTURE test OF test_mux2x32_1 IS
    SIGNAL input: word_pair;
    SIGNAL sel: STD_LOGIC;
    SIGNAL output: word;
BEGIN
    mux: ENTITY work.Mux2x32_1(logic) PORT MAP (input, sel, output);
    PROCESS
        TYPE pattern_type IS RECORD
            i: word_pair;
            s: STD_LOGIC;
            o: word;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT input_array: word_pair :=
            (x"ABCDEF01", x"23456789");

        CONSTANT patterns: pattern_array :=

            (
              (input_array, '0', x"23456789"),
              (input_array, '1', x"ABCDEF01")
            );

    BEGIN

        FOR i IN patterns'range LOOP
            input <= patterns(i).i;
            sel <= patterns(i).s;

            wait for 1 ms;

            assert output = patterns(i).o
                report "bad output" severity error;
        END LOOP;

        assert false
            report "end of 2x32_1 test" severity note;

        wait;
    END PROCESS;
END test;
