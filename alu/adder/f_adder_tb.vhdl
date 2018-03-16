LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test_f_adder IS
END test_f_adder;

ARCHITECTURE test OF test_f_adder IS
    SIGNAL a, b, cin, s, cout : STD_LOGIC;
BEGIN
    fa: ENTITY work.f_adder(logic) PORT MAP (a, b, cin, cout, s);
    
    PROCESS
        TYPE pattern_type IS RECORD
            a, b, cin, cout, s: STD_LOGIC;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=

            ( ('0', '0', '0', '0', '0'),
              ('0', '0', '1', '0', '1'),
              ('0', '1', '0', '0', '1'),
              ('0', '1', '1', '1', '0'),
              ('1', '0', '0', '0', '1'),
              ('1', '0', '1', '1', '0'),
              ('1', '1', '0', '1', '0'),
              ('1', '1', '1', '1', '1')
            );
    BEGIN
        FOR i IN patterns'range LOOP
            a <= patterns(i).a;
            b <= patterns(i).b;
            cin <= patterns(i).cin;

            wait for 1 ms;

            assert s = patterns(i).s AND cout = patterns(i).cout
                report "bad output" severity error;
        END LOOP;

        assert false
            report "end of f_adder test" severity note;

        wait;
    END PROCESS;
END test;

