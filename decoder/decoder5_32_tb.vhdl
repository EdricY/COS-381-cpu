LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test_decoder5_32 IS
END test_decoder5_32;

ARCHITECTURE test OF test_decoder5_32 IS
    SIGNAL input: STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL e: STD_LOGIC;
    SIGNAL output: STD_LOGIC_VECTOR(31 downto 0);
BEGIN
    d: ENTITY work.decoder5_32(logic) PORT MAP (input, e, output);

    PROCESS
        TYPE pattern_type IS RECORD
            i: STD_LOGIC_VECTOR(4 downto 0);
            e: STD_LOGIC;
            o: STD_LOGIC_VECTOR(31 downto 0);
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=
            ( ("00000", '0', x"00000000"),
              ("10101", '0', x"00000000"),
              ("10000", '0', x"00000000"),
              ("01000", '0', x"00000000"),
              ("00100", '0', x"00000000"),
              ("00010", '0', x"00000000"),
              ("00001", '0', x"00000000"),

              ("00000", '1', x"00000001"),
              ("00001", '1', x"00000002"),
              ("00010", '1', x"00000004"),
              ("00011", '1', x"00000008"),
              ("00100", '1', x"00000010"),
              ("01001", '1', x"00000200"),
              ("01110", '1', x"00004000"),
              ("10011", '1', x"00080000"),
              ("10100", '1', x"00100000"),
              ("11001", '1', x"02000000"),
              ("11110", '1', x"40000000"),
              ("11111", '1', x"80000000")
            );

    BEGIN
        FOR x IN patterns'range LOOP
            input <= patterns(x).i;
            e <= patterns(x).e;
            wait for 1 ms;

            assert output = patterns(x).o
                report "bad output" severity error;
        END LOOP;

        assert false
            report "end of 5_32 test" severity note;

        wait;
    END PROCESS;
END test;


