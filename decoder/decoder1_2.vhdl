LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY decoder1_2 IS
    PORT (i, e: IN STD_LOGIC;
          o0, o1: OUT STD_LOGIC);
END decoder1_2;

ARCHITECTURE logic OF decoder1_2 IS
    SIGNAL j: STD_LOGIC;
BEGIN
    j <= NOT i AFTER 5 ps;
    o0 <= j AND e AFTER 5 ps;
    o1 <= i AND e AFTER 5 ps;

END logic;
