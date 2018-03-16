LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY test_register32 IS
END test_register32;

ARCHITECTURE test OF test_register32 IS
    SIGNAL we, c, ce: STD_LOGIC;
    SIGNAL input, output: word;
BEGIN
    clock: ENTITY work.clock(logic) PORT MAP (ce, c);
    reg: ENTITY work.register32(behavior) PORT MAP (input, we, c, output);

    PROCESS
        TYPE pattern_type IS RECORD
            we: STD_LOGIC;
            input, output: word;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=
            (
              ('0', x"ABACABAD", x"00000000"), --initialized to x00000000

              ('1', x"00000000", x"00000000"),
              ('0', x"01234567", x"00000000"),
              ('1', x"11111111", x"11111111"),
 
              ('0', x"89ABCDEF", x"11111111"),
              ('0', x"01010101", x"11111111"),
              ('0', x"ABABABAB", x"11111111"),
              ('0', x"C1C2C3C4", x"11111111"),

              ('1', x"11111111", x"11111111"),
              ('1', x"ABABABAB", x"ABABABAB"),
              ('1', x"C1C2C3C4", x"C1C2C3C4"),
              ('1', x"BEEFFEED", x"BEEFFEED")
            );

    BEGIN
        ce <= '1';
        FOR i IN patterns'range LOOP
            we <= patterns(i).we;
            input <= patterns(i).input;

            wait for 1 ms;

            assert output = patterns(i).output
                report "bad output" severity error;
        END LOOP;
        ce <= '0';

        assert false
            report "end of register32 test" severity note;

        wait;
    END PROCESS;
END test;


