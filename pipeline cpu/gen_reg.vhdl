LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY gen_reg IS
    GENERIC (N : integer);
    PORT (input: IN STD_LOGIC_VECTOR(N-1 downto 0);
          we, clock : IN STD_LOGIC;
          output: OUT STD_LOGIC_VECTOR(N-1 downto 0));

END gen_reg;

ARCHITECTURE behavior OF gen_reg IS
BEGIN
    rgen : FOR i IN 0 TO N-1 GENERATE
        d: ENTITY work.dff_0(behavior) PORT MAP (input(i), we, clock, output(i), OPEN);
    END GENERATE rgen;

END behavior;
