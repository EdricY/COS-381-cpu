LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY sign_extender IS
    PORT (input: IN STD_LOGIC_VECTOR(15 downto 0);
          s: IN STD_LOGIC;
          output: OUT word);
END sign_extender;

ARCHITECTURE logic OF sign_extender IS

BEGIN
    topBits : FOR i IN 31 DOWNTO 16 GENERATE
        output(i) <= input(15) AND s AFTER 5 ps;
    END GENERATE topBits;
    output(15 downto 0) <= input(15 downto 0); 

END logic;

