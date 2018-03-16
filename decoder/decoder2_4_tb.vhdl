LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test_decoder2_4 IS
END test_decoder2_4;

ARCHITECTURE test OF test_decoder2_4 IS
    SIGNAL input: STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL e: STD_LOGIC;
    SIGNAL output: STD_LOGIC_VECTOR(3 downto 0);
BEGIN
    d: ENTITY work.decoder2_4(logic) PORT MAP (input, e, output);

    PROCESS
        TYPE pattern_type IS RECORD
            i: STD_LOGIC_VECTOR(1 downto 0);
            e: STD_LOGIC;
            o: STD_LOGIC_VECTOR(3 downto 0);
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=
            ( ("00", '0', "0000"),
              ("01", '0', "0000"),
              ("10", '0', "0000"),
              ("11", '0', "0000"),
              ("00", '1', "0001"),
              ("01", '1', "0010"),
              ("10", '1', "0100"),
              ("11", '1', "1000")
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
            report "end of 2_4 test" severity note;

        wait;
    END PROCESS;
END test;


