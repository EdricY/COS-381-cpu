LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test_mux32_1 IS
END test_mux32_1;

ARCHITECTURE test OF test_mux32_1 IS
    SIGNAL input: STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL sel: STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL output: STD_LOGIC;
BEGIN
    m32: ENTITY work.mux32_1(logic) PORT MAP (input, sel, output);
    PROCESS
        TYPE pattern_type IS RECORD
            i: STD_LOGIC_VECTOR(31 downto 0);
            s: STD_LOGIC_VECTOR(4 downto 0);
            o: STD_LOGIC;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=

            ( (x"00000000", "00000", '0'),
              (x"00000001", "00000", '1'),
	          (x"00000002", "00001", '1'),
              (x"00000020", "00101", '1'),
              (x"00000100", "01000", '1'),
              (x"00002000", "01101", '1'),
              (x"00004000", "01110", '1'),
              (x"00010000", "10000", '1'),
              (x"00100000", "10100", '1'),
              (x"08000000", "11011", '1'),
              (x"10000000", "11100", '1'),
              (x"20000000", "11101", '1'),
              (x"80000000", "11111", '1'),
              (x"FFFF7FFF", "01111", '0'),
              (x"FFDFFFFF", "10101", '0'),
              (x"FFFFFFFF", "00000", '1')
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
            report "end of 32_1 test" severity note;

        wait;
    END PROCESS;
END test;


