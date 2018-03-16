LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY zflag_check IS
    PORT (a: IN word;
          zfl: OUT STD_LOGIC);
END zflag_check;

ARCHITECTURE logic OF zflag_check IS 
SIGNAL za, zb, zc, zd, ze, zf, zg, zh, zx, zy: STD_LOGIC;
BEGIN
    za <= a( 0) OR a( 1) OR a( 2) OR a( 3) AFTER 5 ps;
    zb <= a( 4) OR a( 5) OR a( 6) OR a( 7) AFTER 5 ps;
    zc <= a( 8) OR a( 9) OR a(10) OR a(11) AFTER 5 ps;
    zd <= a(12) OR a(13) OR a(14) OR a(15) AFTER 5 ps;
    ze <= a(16) OR a(17) OR a(18) OR a(19) AFTER 5 ps;
    zf <= a(20) OR a(21) OR a(22) OR a(23) AFTER 5 ps;
    zg <= a(24) OR a(25) OR a(26) OR a(27) AFTER 5 ps;
    zh <= a(28) OR a(29) OR a(30) OR a(31) AFTER 5 ps;
    
    zx <= za OR zb OR zc OR zd AFTER 5 ps;
    zy <= ze OR zf OR zg OR zh AFTER 5 ps;
    zfl <= zx NOR zy AFTER 5 ps;

END logic;
