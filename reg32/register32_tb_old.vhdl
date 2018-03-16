LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY test_register32_old IS
END test_register32_old;

ARCHITECTURE test OF test_register32_old IS
    SIGNAL we, clock: STD_LOGIC;
    SIGNAL input, output: word;
BEGIN
    reg: ENTITY work.register32(behavior) PORT MAP (input, we, clock, output);

    PROCESS
        TYPE pattern_type IS RECORD
            clock, we: STD_LOGIC;
            input, output: word;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=
            (  --positive edge ; write 00000000
              ('1', '1', x"00000000", x"00000000"),

               --negative edge ; nothing happens
              ('0', '1', x"01234567", x"00000000"),

               -- positive edge ; write 1s ; Q=1
              ('1', '1', x"11111111", x"11111111"),

               -- negative edge ; nothing happens ; Q=1
              ('0', '1', x"89ABCDEF", x"11111111"),

               -- write disabled
              ('1', '0', x"01010101", x"11111111"),
              ('0', '0', x"ABABABAB", x"11111111"),
              ('1', '0', x"C1C2C3C4", x"11111111"),
              ('0', '0', x"BEEFFEED", x"11111111")
            );

    BEGIN
        FOR i IN patterns'range LOOP
            clock <= patterns(i).clock;
            we <= patterns(i).we;
            input <= patterns(i).input;

            wait for 1 ms;

            assert output = patterns(i).output
                report "bad output" severity error;
        END LOOP;

        assert false
            report "end of register32 test" severity note;

        wait;
    END PROCESS;
END test;


