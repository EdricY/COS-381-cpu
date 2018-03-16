LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY test_zflag_check IS
END test_zflag_check;

ARCHITECTURE test OF test_zflag_check IS 
SIGNAL a: word;
SIGNAL zfl: STD_LOGIC;
BEGIN
    zfc: ENTITY work.zflag_check(logic) PORT MAP(a, zfl);
    PROCESS
        TYPE pattern_type IS RECORD
            a: word;
            zfl: STD_LOGIC;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;
        CONSTANT patterns: pattern_array :=
            ( (x"00000000", '1'),
              (x"00000001", '0'),
              (x"FFFFFFFF", '0')
            );
    BEGIN
        FOR i IN patterns'range LOOP
            a <= patterns(i).a;
            
            wait for 1 ms;

            assert zfl = patterns(i).zfl
                report "bad zfl" severity error;

        END LOOP;

        assert false
            report "end of zflag test" severity note;

        wait;
    END PROCESS;
END test;
