LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY test_sign_extender IS
END test_sign_extender;

ARCHITECTURE test OF test_sign_extender IS
    SIGNAL input: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL s: STD_LOGIC;
    SIGNAL output: word;
BEGIN
    extender: ENTITY work.sign_extender(logic) PORT MAP (input, s, output);

    PROCESS
        TYPE pattern_type IS RECORD
            i: STD_LOGIC_VECTOR(15 downto 0);
            s: STD_LOGIC;
            o: word;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=

            ( (x"0000", '0', x"00000000"),
              (x"0000", '1', x"00000000"),

              (x"1234", '0', x"00001234"),
              (x"1234", '1', x"00001234"),

              (x"8000", '0', x"00008000"),
              (x"8000", '1', x"FFFF8000"),


              (x"FFFF", '0', x"0000FFFF"),
              (x"FFFF", '1', x"FFFFFFFF")
            );

    BEGIN
        FOR i IN patterns'range LOOP
            input <= patterns(i).i;
            s <= patterns(i).s;
            
            wait for 1 ms;

            assert output = patterns(i).o
                report "bad output" severity error;
        END LOOP;

        assert false
            report "end of extender test" severity note;

        wait;
    END PROCESS;
END test;

