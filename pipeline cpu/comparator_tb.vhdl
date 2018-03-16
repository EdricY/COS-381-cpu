LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY test_comparator IS
END test_comparator;

ARCHITECTURE test OF test_comparator IS 
SIGNAL a, b: word;
SIGNAL eql: STD_LOGIC;
BEGIN
    comp: ENTITY work.comparator(logic) PORT MAP(a, b, eql);
    PROCESS
        TYPE pattern_type IS RECORD
            a, b: word;
            eql: STD_LOGIC;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;
        CONSTANT patterns: pattern_array :=
            ( (x"00000000", x"00000000", '1'),
              (x"00000000", x"00000001", '0'),
              (x"DEADBEEF", x"DEADBEEF", '1'),
              (x"DEADBEEF", x"BEEEEEEF", '0'),
              (x"ABABABAB", x"ABABABAB", '1')
            );
    BEGIN
        FOR i IN patterns'range LOOP
            a <= patterns(i).a;
            b <= patterns(i).b;
            
            wait for 1 ms;

            assert eql = patterns(i).eql
                report "bad output" severity error;

        END LOOP;

        assert false
            report "end of comparator test" severity note;

        wait;
    END PROCESS;
END test;
