LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY comparator IS
    PORT (a, b: IN word;
          eql: OUT STD_LOGIC);
END comparator;

ARCHITECTURE logic OF comparator IS
SIGNAL c: word; 
BEGIN
    
    xgen : FOR i IN 0 TO 31 GENERATE
        c(i) <= a(i) XOR b(i) AFTER 5 ps;
    END GENERATE xgen;

    zfc: ENTITY work.zflag_check(logic) PORT MAP(c, eql);

END logic;
