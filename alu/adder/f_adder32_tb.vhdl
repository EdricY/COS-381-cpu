LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY test_f_adder32 IS
END test_f_adder32;

ARCHITECTURE test OF test_f_adder32 IS
    SIGNAL sub, unsig: STD_LOGIC;
    SIGNAL sum, a, b: word;
    SIGNAL zfl, cfl, ofl, nfl: STD_LOGIC;
BEGIN
    fa32: ENTITY work.f_adder32(logic) PORT MAP (a, b, sub, unsig, sum, zfl, cfl, ofl, nfl);

    PROCESS
        TYPE pattern_type IS RECORD
            a, b: word;
            sub, unsig: STD_LOGIC;
            sum: word;
            zfl, cfl, ofl, nfl: STD_LOGIC;
        END RECORD;

        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;

        CONSTANT patterns: pattern_array :=
            -- a            b            sub  uns  sum           z    c    o    n
            ( (x"00000000", x"00000000", '0', '0', x"00000000", '1', '0', '0', '0'), -- 0 + 0
              (x"00000000", x"00000000", '1', '0', x"00000000", '1', '1', '0', '0'), -- 0 - 0
              (x"10000000", x"10000000", '0', '0', x"20000000", '0', '0', '0', '0'),
              (x"12345678", x"87654321", '0', '0', x"99999999", '0', '0', '0', '1'),
              (x"32100000", x"00000123", '0', '0', x"32100123", '0', '0', '0', '0'),
              (x"80000000", x"80000000", '0', '0', x"00000000", '1', '1', '1', '0'), -- tMax + tMax
              (x"32100000", x"00000123", '0', '0', x"32100123", '0', '0', '0', '0'),
              (x"FFFFFFFF", x"FFFFFFFF", '1', '0', x"00000000", '1', '1', '0', '0'), -- -1 - (-1)
              (x"FFFFFFFF", x"00000001", '1', '0', x"FFFFFFFE", '0', '1', '0', '1'), -- -1 - 1
              (x"80000000", x"00000001", '1', '0', x"7FFFFFFF", '0', '1', '1', '0'),
              (x"7FFFFFFF", x"80000000", '1', '0', x"FFFFFFFF", '0', '0', '1', '1'),
              (x"80000000", x"80000000", '1', '0', x"00000000", '1', '1', '0', '0'),

              (x"00000000", x"00000000", '0', '1', x"00000000", '1', '0', '0', '0'),
              (x"00000000", x"00000000", '1', '1', x"00000000", '1', '1', '1', '0'), 
              (x"10000000", x"10000000", '0', '1', x"20000000", '0', '0', '0', '0'),
              (x"12345678", x"87654321", '0', '1', x"99999999", '0', '0', '0', '0'),
              (x"32100000", x"00000123", '0', '1', x"32100123", '0', '0', '0', '0'),
              (x"80000000", x"80000000", '0', '1', x"00000000", '1', '1', '1', '0'),
              (x"32100000", x"00000123", '0', '1', x"32100123", '0', '0', '0', '0'),
              (x"FFFFFFFF", x"FFFFFFFF", '1', '1', x"00000000", '1', '1', '1', '0'), 
              (x"FFFFFFFF", x"00000001", '1', '1', x"FFFFFFFE", '0', '1', '1', '0'),
              (x"80000000", x"00000001", '1', '1', x"7FFFFFFF", '0', '1', '1', '0'),
              (x"7FFFFFFF", x"80000000", '1', '1', x"FFFFFFFF", '0', '0', '0', '0'),
              (x"80000000", x"80000000", '1', '1', x"00000000", '1', '1', '1', '0')  
            );
        

    BEGIN
        FOR i IN patterns'range LOOP
            a <= patterns(i).a;
            b <= patterns(i).b;
            sub <= patterns(i).sub;
            unsig <= patterns(i).unsig;
            
            wait for 1 ms;

            assert sum = patterns(i).sum
                report "wrong sum" severity error;
            assert zfl = patterns(i).zfl
                report "wrong z flag" severity error;
            assert cfl = patterns(i).cfl
                report "wrong c flag" severity error;
            assert ofl = patterns(i).ofl
                report "wrong o flag" severity error;
            assert nfl = patterns(i).nfl
                report "wrong n flag" severity error;


        END LOOP;

        assert false
            report "end of f_adder32 test" severity note;

        wait;
    END PROCESS;
END test;


