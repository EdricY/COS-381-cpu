LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY mux16_1 IS
    PORT (input : IN STD_LOGIC_VECTOR(15 downto 0);
          sel : IN STD_LOGIC_VECTOR(3 downto 0);
          output: OUT STD_LOGIC);
END mux16_1;

ARCHITECTURE logic OF mux16_1 IS
    SIGNAL m4ao, m4bo, m4co, m4do: STD_LOGIC;
    SIGNAL stage1outs: STD_LOGIC_VECTOR(3 downto 0);
BEGIN
    m4a: ENTITY work.mux4_1(logic) PORT MAP (input(3 downto 0), sel(1 downto 0), stage1outs(0));
    m4b: ENTITY work.mux4_1(logic) PORT MAP (input(7 downto 4), sel(1 downto 0), stage1outs(1));
    m4c: ENTITY work.mux4_1(logic) PORT MAP (input(11 downto 8), sel(1 downto 0), stage1outs(2));
    m4d: ENTITY work.mux4_1(logic) PORT MAP (input(15 downto 12), sel(1 downto 0), stage1outs(3));

    m4e: ENTITY work.mux4_1(logic) PORT MAP (stage1outs, sel(3 downto 2), output);

END logic;

