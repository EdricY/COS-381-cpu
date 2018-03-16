LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux4_1 IS
    PORT (input : IN STD_LOGIC_VECTOR(3 downto 0);
          sel : IN STD_LOGIC_VECTOR(1 downto 0);
          output: OUT STD_LOGIC);
END mux4_1;

ARCHITECTURE logic OF mux4_1 IS
    SIGNAL m2ao, m2bo: STD_LOGIC;
BEGIN
    m2a: ENTITY work.mux2_1(logic) PORT MAP (input(0), input(1), sel(0), m2ao);
    m2b: ENTITY work.mux2_1(logic) PORT MAP (input(2), input(3), sel(0), m2bo);
    m2c: ENTITY work.mux2_1(logic) PORT MAP (m2ao, m2bo, sel(1), output);

END logic;



