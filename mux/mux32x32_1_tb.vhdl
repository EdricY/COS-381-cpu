LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY test_mux32x32_1 IS
END test_mux32x32_1;

ARCHITECTURE test OF test_mux32x32_1 IS
    SIGNAL input: word_array;
    SIGNAL sel: STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL output: word;
BEGIN
    mux: ENTITY work.Mux32x32_1(logic) PORT MAP (input, sel, output);
    PROCESS
        TYPE pattern_type IS RECORD
            i: word_array;
            s: STD_LOGIC_VECTOR(4 downto 0);
            o: word;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;
        
        CONSTANT input_array: word_array :=
            (x"FFFFFAB0", x"EEEEFAB0", x"DDDDFAB0", x"CCCCFAB0",
             x"BBBBFAB0", x"AAAAFAB0", x"9999FAB0", x"8888FAB0",
             x"7777FAB0", x"6666FAB0", x"5555FAB0", x"4444FAB0",
             x"3333FAB0", x"2222FAB0", x"1111FAB0", x"0000FAB0",
             x"FFFF8071", x"EEEE8071", x"DDDD8071", x"CCCC8071",
             x"BBBB8071", x"AAAA8071", x"99998071", x"88888071",
             x"77778071", x"66668071", x"55558071", x"44448071",
             x"33338071", x"22228071", x"11118071", x"00008071"
            );

        CONSTANT patterns: pattern_array :=

            ( (input_array, "00000", x"00008071"),
              (input_array, "00001", x"11118071"),
              (input_array, "00010", x"22228071"),
              (input_array, "00100", x"44448071"),
              (input_array, "01000", x"88888071"),
              (input_array, "01010", x"AAAA8071"),
              (input_array, "10000", x"0000FAB0"),
              (input_array, "11111", x"FFFFFAB0")
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
            report "end of 32x32_1 test" severity note;

        wait;
    END PROCESS;
END test;
