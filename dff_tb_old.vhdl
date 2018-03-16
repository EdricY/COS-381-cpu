LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test_dff_old IS
END test_dff_old;

ARCHITECTURE test OF test_dff_old IS
    SIGNAL D, WE, clock, Q, Qprime: STD_LOGIC;
BEGIN
    dff: ENTITY work.dff(Behavior) PORT MAP (D, WE, clock, Q, Qprime);

    PROCESS
        TYPE pattern_type IS RECORD
            D, WE, clock: STD_LOGIC;
            Q, Qprime: STD_LOGIC;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=
            (  --positive edge ; write 0 ; Q=0
              ('0', '1', '1', '0', '1'),

               --negative edge ; nothing happens ; Q=0
              ('0', '1', '0', '0', '1'),
              ('1', '1', '0', '0', '1'),
              ('0', '0', '0', '0', '1'),
              ('1', '0', '0', '0', '1'),

               -- positive edge ; write 1 ; Q=1
              ('1', '1', '1', '1', '0'),

               -- negative edge ; nothing happens ; Q=1
              ('0', '1', '0', '1', '0'),
              ('1', '1', '0', '1', '0'),
              ('0', '0', '0', '1', '0'),
              ('1', '0', '0', '1', '0'),

               -- positive edge ; fail to write 0 ; Q=1
              ('0', '0', '1', '1', '0'),

               -- negative edge ; nothing happens ; Q=1
              ('0', '1', '0', '1', '0'),
              ('1', '1', '0', '1', '0'),
              ('0', '0', '0', '1', '0'),
              ('1', '0', '0', '1', '0')
            );

    BEGIN
        FOR i IN patterns'range LOOP
            D <= patterns(i).D;
            WE <= patterns(i).WE;
            clock <= patterns(i).clock;

            wait for 1 ms;

            assert Q = patterns(i).Q and Qprime = patterns(i).Qprime
                report "bad output" severity error;
        END LOOP;

        assert false
            report "end of dff test" severity note;

        wait;
    END PROCESS;
END test;


