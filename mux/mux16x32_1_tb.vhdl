LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY test_mux16x32_1 IS
END test_mux16x32_1;

ARCHITECTURE test OF test_mux16x32_1 IS
    SIGNAL input: word_half_array;
    SIGNAL sel: STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL output: word;
BEGIN
    mux: ENTITY work.Mux16x32_1(logic) PORT MAP (input, sel, output);
    PROCESS
        TYPE pattern_type IS RECORD
            i: word_half_array;
            s: STD_LOGIC_VECTOR(3 downto 0);
            o: word;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;
        
        CONSTANT input_array: word_half_array :=
            (x"FFFFFAB0", x"EEEEFAB0", x"DDDDFAB0", x"CCCCFAB0",
             x"BBBBFAB0", x"AAAAFAB0", x"9999FAB0", x"8888FAB0",
             x"7777FAB0", x"6666FAB0", x"5555FAB0", x"4444FAB0",
             x"3333FAB0", x"2222FAB0", x"1111FAB0", x"0000FAB0"
            );

        CONSTANT patterns: pattern_array :=

            ( (input_array, "0000", x"0000FAB0"),
              (input_array, "0001", x"1111FAB0"),
              (input_array, "0010", x"2222FAB0"),
              (input_array, "0100", x"4444FAB0"),
              (input_array, "1000", x"8888FAB0"),
              (input_array, "1010", x"AAAAFAB0"),
              (input_array, "1110", x"EEEEFAB0"),
              (input_array, "1111", x"FFFFFAB0")
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
            report "end of 16x32_1 test" severity note;

        wait;
    END PROCESS;
END test;
