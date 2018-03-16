LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY register32 IS
    PORT (input: IN word;
          we, clock : IN STD_LOGIC;
          output: OUT word);

END register32;

ARCHITECTURE behavior OF register32 IS
BEGIN
    r32gen : FOR i IN 0 TO 31 GENERATE
        d: ENTITY work.dff_0(Behavior) PORT MAP (input(i), we, clock, output(i), OPEN);
    END GENERATE r32gen;

END behavior;
