LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY decoder2_4 IS
    PORT (input : IN STD_LOGIC_VECTOR(1 downto 0);
          e : IN STD_LOGIC;
          output: OUT STD_LOGIC_VECTOR(3 downto 0));
END decoder2_4;

ARCHITECTURE logic OF decoder2_4 IS
    SIGNAL d1a_out0, d1a_out1: STD_LOGIC;
BEGIN
    d1a: ENTITY work.decoder1_2(logic) PORT MAP (input(1), e, d1a_out0, d1a_out1);
    d1b: ENTITY work.decoder1_2(logic) PORT MAP (input(0), d1a_out0, output(0), output(1));
    d1c: ENTITY work.decoder1_2(logic) PORT MAP (input(0), d1a_out1, output(2), output(3));

END logic;



