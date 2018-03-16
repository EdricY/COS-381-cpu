LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux2_1 IS
    PORT (i0, i1, s: IN STD_LOGIC;
          output: OUT STD_LOGIC);

END mux2_1;

ARCHITECTURE logic OF mux2_1 IS
    SIGNAL x, y, z: STD_LOGIC;
BEGIN
    z <= NOT s AFTER 5 ps;
    x <= z AND i0 AFTER 5 ps;
    y <= s AND i1 AFTER 5 ps;

    output <= x OR y AFTER 5 ps;

END logic;
