LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY test_mux4x5_1 IS
END test_mux4x5_1;

ARCHITECTURE test OF test_mux4x5_1 IS
    SIGNAL input: reg_addr_array4;
    SIGNAL sel: STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL output: reg_address;
BEGIN
    mux: ENTITY work.Mux4x5_1(logic) PORT MAP (input, sel, output);
    PROCESS
        TYPE pattern_type IS RECORD
            i: reg_addr_array4;
            s: STD_LOGIC_VECTOR(1 downto 0);
            o: reg_address;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;
        
        CONSTANT input_array: reg_addr_array4 :=
            ("01111", "00111", "00011", "00001"
            );

        CONSTANT patterns: pattern_array :=

            ( (input_array, "00", "00001"),
              (input_array, "01", "00011"),
              (input_array, "10", "00111"),
              (input_array, "11", "01111")
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
            report "end of 4x5_1 test" severity note;

        wait;
    END PROCESS;
END test;
