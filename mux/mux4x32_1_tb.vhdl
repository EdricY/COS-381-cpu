LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY test_mux4x32_1 IS
END test_mux4x32_1;

ARCHITECTURE test OF test_mux4x32_1 IS
    SIGNAL input: word_array4;
    SIGNAL sel: STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL output: word;
BEGIN
    mux: ENTITY work.Mux4x32_1(logic) PORT MAP (input, sel, output);
    PROCESS
        TYPE pattern_type IS RECORD
            i: word_array4;
            s: STD_LOGIC_VECTOR(1 downto 0);
            o: word;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;
        
        CONSTANT input_array: word_array4 :=
            (x"FFFFFAB0", x"EEEEFAB0", x"DDDDFAB0", x"CCCCFAB0"
            );

        CONSTANT patterns: pattern_array :=

            ( (input_array, "00", x"CCCCFAB0"),
              (input_array, "01", x"DDDDFAB0"),
              (input_array, "10", x"EEEEFAB0"),
              (input_array, "11", x"FFFFFAB0")
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
            report "end of 4x32_1 test" severity note;

        wait;
    END PROCESS;
END test;
