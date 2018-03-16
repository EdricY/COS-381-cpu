LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test_mux2_1 IS
END test_mux2_1;

ARCHITECTURE test OF test_mux2_1 IS
    SIGNAL testI1, testI2, testSel, testO : STD_LOGIC;
BEGIN
    m2: ENTITY work.mux2_1(logic) PORT MAP (testI1, testI2, testSel, testO);

    PROCESS
        TYPE pattern_type IS RECORD
            a, b, c: STD_LOGIC;
            o: STD_LOGIC;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=

            ( ('0', '0', '0', '0'),
              ('0', '0', '1', '0'),
              ('0', '1', '0', '0'),
              ('0', '1', '1', '1'),
              ('1', '0', '0', '1'),
              ('1', '0', '1', '0'),
              ('1', '1', '0', '1'),
              ('1', '1', '1', '1')
            );

    BEGIN
        FOR i IN patterns'range LOOP
            testI1 <= patterns(i).a;
            testI2 <= patterns(i).b;
            testSel <= patterns(i).c;

            wait for 1 ms;

            assert testO = patterns(i).o
                report "bad output" severity error;
        END LOOP;

        assert false
            report "end of 2_1 test" severity note;

        wait;
    END PROCESS;
END test;


