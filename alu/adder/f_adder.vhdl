LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY f_adder IS
    PORT (a, b, c_in: IN STD_LOGIC;
          c_out, s: OUT STD_LOGIC);
END f_adder;

ARCHITECTURE logic OF f_adder IS
    SIGNAL bxc, nbxc, na, bc, cx, cy, sx, sy: STD_LOGIC;
BEGIN
    bxc <= b XOR c_in AFTER 5 ps;
    nbxc <= NOT bxc AFTER 5 ps;
    na <= NOT a AFTER 5 ps;

    sx <= na AND bxc AFTER 5 ps;
    sy <= a AND nbxc AFTER 5 ps;

    s <= sx OR sy AFTER 5 ps;

    cx <= b AND c_in AFTER 5 ps;
    cy <= a AND bxc AFTER 5 ps;

    c_out <= cx OR cy AFTER 5 ps;

END logic;

