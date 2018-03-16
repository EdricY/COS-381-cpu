LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test_decoder1_2 IS
END test_decoder1_2;

ARCHITECTURE test OF test_decoder1_2 IS
    SIGNAL i, e, o0, o1: STD_LOGIC;
BEGIN
    d: ENTITY work.decoder1_2(logic) PORT MAP (i, e, o0, o1);

    PROCESS
        TYPE pattern_type IS RECORD
            i, e, o0, o1: STD_LOGIC;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=

            ( ('0', '0', '0', '0'),
              ('1', '0', '0', '0'),
              ('0', '1', '1', '0'),
              ('1', '1', '0', '1')
            );

    BEGIN
        FOR x IN patterns'range LOOP
            i <= patterns(x).i;
            e <= patterns(x).e;
            wait for 1 ms;

            assert o0 = patterns(x).o0 AND o1 = patterns(x).o1
                report "bad output" severity error;
        END LOOP;

        assert false
            report "end of 1_2 test" severity note;

        wait;
    END PROCESS;
END test;


