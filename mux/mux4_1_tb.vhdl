LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test_mux4_1 IS
END test_mux4_1;

ARCHITECTURE test OF test_mux4_1 IS
    SIGNAL input: STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL sel: STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL output: STD_LOGIC;

BEGIN
    m4: ENTITY work.mux4_1(logic) PORT MAP (input, sel, output);

    PROCESS
        TYPE pattern_type IS RECORD
            i: STD_LOGIC_VECTOR(3 downto 0);
            s: STD_LOGIC_VECTOR(1 downto 0);
            o: STD_LOGIC;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=

            ( ("0000", "00", '0'),
              ("0001", "00", '1'),
              ("0010", "01", '1'),
              ("0100", "10", '1'),
              ("1000", "11", '1'),
              ("0111", "11", '0'),
              ("1011", "10", '0'),
              ("1101", "01", '0'),
              ("1110", "00", '0'),
              ("1111", "11", '1')
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
            report "end of 4_1 test" severity note;

        wait;
    END PROCESS;
END test;


