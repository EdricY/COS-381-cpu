LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test_dff IS
END test_dff;

ARCHITECTURE test OF test_dff IS
    SIGNAL D, WE, c, Q, Qprime, CE: STD_LOGIC;
BEGIN
    clock: ENTITY work.clock(logic) PORT MAP (CE, c);
    dff: ENTITY work.dff(Behavior) PORT MAP (D, WE, c, Q, Qprime);

    PROCESS
        TYPE pattern_type IS RECORD
            D, WE: STD_LOGIC;
            Q, Qprime: STD_LOGIC;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=
            (
              ('0', '1', '0', '1'),
              ('0', '0', '0', '1'),
              ('1', '0', '0', '1'),
              
              ('1', '1', '1', '0'),
              ('0', '0', '1', '0'),
              ('1', '0', '1', '0')
            );

    BEGIN
        CE <= '1';
        FOR i IN patterns'range LOOP
            D <= patterns(i).D;
            WE <= patterns(i).WE;

            wait for 1 ms;

            assert Q = patterns(i).Q and Qprime = patterns(i).Qprime
                report "bad output" severity error;
        END LOOP;
        CE <= '0';

        assert false
            report "end of dff test" severity note;

        wait;
    END PROCESS;
END test;


