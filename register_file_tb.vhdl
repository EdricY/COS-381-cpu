LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.p.all;

ENTITY test_register_file IS
END test_register_file;

ARCHITECTURE test OF test_register_file IS
    SIGNAL reg1, reg2, writeReg: reg_address;
    SIGNAL WE: STD_LOGIC;
    SIGNAL c, CE: STD_LOGIC;
    SIGNAL writeData, read1Data, read2Data: word;
BEGIN
    clock: ENTITY work.clock(logic) PORT MAP (CE, c);
    reg_file: ENTITY work.RegFile(behavior) PORT MAP (reg1, reg2, writeReg, WE, c, writeData, read1Data, read2Data);
    PROCESS
        TYPE pattern_type IS RECORD
            r1, r2, wreg: reg_address;
            we: STD_LOGIC;
            wdata, r1data, r2data: word;
        END RECORD;
        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT input_array: word_array :=
            (
             x"FFFF4912", x"EEEE4912", x"DDDD4912", x"CCCC4912",
             x"BBBB4912", x"AAAA4912", x"99994912", x"88884912",
             x"77774912", x"66664912", x"55554912", x"44444912",
             x"33334912", x"22224912", x"11114912", x"00004912",
             x"FFFFBAA7", x"EEEEBAA7", x"DDDDBAA7", x"CCCCBAA7",
             x"BBBBBAA7", x"AAAABAA7", x"9999BAA7", x"8888BAA7",
             x"7777BAA7", x"6666BAA7", x"5555BAA7", x"4444BAA7",
             x"3333BAA7", x"2222BAA7", x"1111BAA7", x"0000BAA7"
            );

        CONSTANT patterns: pattern_array :=
            ( 
              ("00000", "00001", "00000", '1', x"BEEEEEF0", x"00000000", x"1111BAA7"), -- can't write to reg0

              ("00010", "00011", "00010", '0', x"BEEEEEF1", x"2222BAA7", x"3333BAA7"), -- read w/ write disabled
              ("11111", "11110", "11111", '0', x"BEEEEEF2", x"FFFF4912", x"EEEE4912"),
              ("01010", "10101", "01010", '0', x"BEEEEEF3", x"AAAABAA7", x"55554912"),

              ("01010", "00001", "00001", '1', x"BEEEEEF4", x"AAAABAA7", x"BEEEEEF4"), -- some writing
              ("00001", "00010", "00010", '1', x"BEEEEEF5", x"BEEEEEF4", x"BEEEEEF5"),
              ("00010", "00100", "00100", '1', x"BEEEEEF6", x"BEEEEEF5", x"BEEEEEF6"),
              ("00100", "01000", "01000", '1', x"BEEEEEF7", x"BEEEEEF6", x"BEEEEEF7"),
              ("01000", "10000", "10000", '1', x"BEEEEEF8", x"BEEEEEF7", x"BEEEEEF8")
            );
    BEGIN
        CE <= '1' AFTER clock_tick / 2; -- offset so clock doesn't pulse exactly when values change
        reg2 <= "00000";
        WE <= '1';
        FOR i IN 0 to 31 LOOP -- write from input_array into registers
            reg1 <= std_logic_vector(to_unsigned(i, reg1'length));
            WAIT ON reg1;
            writeReg <= reg1;
            writeData <= input_array(i);

            WAIT FOR 1 ms;

            assert read1Data = input_array(i) AND read2Data = x"00000000"
                report "write failed (should fail on 0 register)" severity error;
        END LOOP;

        FOR i IN patterns'range LOOP -- do testing patterns in pattern_array
            WE <= patterns(i).we;
            reg1 <= patterns(i).r1;
            reg2 <= patterns(i).r2;
            writeReg <= patterns(i).wreg;
            writeData <= patterns(i).wdata;
            WAIT FOR 1 ms;
    
            assert read1Data = patterns(i).r1data AND read2Data = patterns(i).r2data
                report "bad output" severity error;
        END LOOP;

        CE <= '0';

        assert false
            report "end of register_file test" severity note;
        wait;

    END PROCESS;
END test;
