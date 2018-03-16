LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test_mux16_1 IS
END test_mux16_1;

ARCHITECTURE test OF test_mux16_1 IS
    SIGNAL input: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL sel: STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL output: STD_LOGIC;
BEGIN
    m16: ENTITY work.mux16_1(logic) PORT MAP (input, sel, output);
    PROCESS
        TYPE pattern_type IS RECORD
            i: STD_LOGIC_VECTOR(15 downto 0);
            s: STD_LOGIC_VECTOR(3 downto 0);
            o: STD_LOGIC;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=

            ( (x"0000", "0000", '0'),
              (x"0001", "0000", '1'),
	          (x"0002", "0001", '1'),
              (x"0020", "0101", '1'),
              (x"0100", "1000", '1'),
              (x"2000", "1101", '1'),
              (x"4000", "1110", '1'),
              (x"8000", "1111", '1'),
              (x"7FFF", "1111", '0'),
              (x"FFDF", "0101", '0'),
              (x"FFFF", "0000", '1')
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
            report "end of 16_1 test" severity note;

        wait;
    END PROCESS;
END test;


