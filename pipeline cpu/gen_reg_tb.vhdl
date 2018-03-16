LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY test_gen_reg IS
END test_gen_reg;

ARCHITECTURE test OF test_gen_reg IS
    SIGNAL we, c, ce, we2: STD_LOGIC;
    SIGNAL input1, output1: word;
    SIGNAL input2, output2: STD_LOGIC_VECTOR(63 downto 0);
BEGIN
    clock: ENTITY work.clock(logic) PORT MAP (ce, c);
    reg32: ENTITY work.gen_reg(behavior) GENERIC MAP(32) PORT MAP (input1, we, c, output1);
    reg72: ENTITY work.gen_reg(behavior) GENERIC MAP(64) PORT MAP (input2, we2, c, output2);

    PROCESS
        TYPE pattern_type1 IS RECORD
            we: STD_LOGIC;
            input, output: word;
        END RECORD;

        TYPE pattern_array1 IS ARRAY (NATURAL RANGE <>) OF pattern_type1;

        CONSTANT patterns1: pattern_array1 :=
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

        TYPE pattern_type2 IS RECORD
            we: STD_LOGIC;
            input, output: STD_LOGIC_VECTOR(63 downto 0);
        END RECORD;

        TYPE pattern_array2 IS ARRAY (NATURAL RANGE <>) OF pattern_type2;

        CONSTANT patterns2: pattern_array2 :=
            (
              ('0', x"ABACABADABACABAD", x"0000000000000000"), --initialized to x00000000

              ('1', x"0000000000000000", x"0000000000000000"),
              ('0', x"0123456701234567", x"0000000000000000"),
              ('1', x"1111111111111111", x"1111111111111111"),
 
              ('0', x"89ABCDEF89ABCDEF", x"1111111111111111"),
              ('0', x"0101010101010101", x"1111111111111111"),
              ('0', x"ABABABABABABABAB", x"1111111111111111"),
              ('0', x"C1C2C3C4C1C2C3C4", x"1111111111111111"),

              ('1', x"1111111111111111", x"1111111111111111"),
              ('1', x"ABABABABABABABAB", x"ABABABABABABABAB"),
              ('1', x"C1C2C3C4C1C2C3C4", x"C1C2C3C4C1C2C3C4"),
              ('1', x"BEEFFEEDBEEFFEED", x"BEEFFEEDBEEFFEED")
            );

    BEGIN
        ce <= '1';
        FOR i IN patterns1'range LOOP
            we <= patterns1(i).we;
            input1 <= patterns1(i).input;

            wait for 1 us;

            assert output1 = patterns1(i).output
                report "bad output" severity note;


        END LOOP;
        FOR i IN patterns2'range LOOP
            we2 <= patterns2(i).we;
            input2 <= patterns2(i).input;

            wait for 1 us;

            assert output2 = patterns2(i).output
                report "bad output" severity note;

        END LOOP;
        ce <= '0';

        assert false
            report "end of gen_reg test" severity note;

        wait;
    END PROCESS;
END test;


