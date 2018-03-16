LIBRARY ieee;
USE ieee.std_logic_1164.all;



ENTITY mux32_1 IS
    PORT (input : IN STD_LOGIC_VECTOR(31 downto 0);
          sel : IN STD_LOGIC_VECTOR(4 downto 0);
          output: OUT STD_LOGIC);
END mux32_1;

ARCHITECTURE logic OF mux32_1 IS
    SIGNAL m4io, m4jo: STD_LOGIC;
    SIGNAL stage2i0, stage2i1: STD_LOGIC_VECTOR(3 downto 0);
BEGIN
    m4a: ENTITY work.mux4_1(logic) PORT MAP (input(3 downto 0), sel(1 downto 0), stage2i0(0));
    m4b: ENTITY work.mux4_1(logic) PORT MAP (input(7 downto 4), sel(1 downto 0), stage2i0(1));
    m4c: ENTITY work.mux4_1(logic) PORT MAP (input(11 downto 8), sel(1 downto 0), stage2i0(2));
    m4d: ENTITY work.mux4_1(logic) PORT MAP (input(15 downto 12), sel(1 downto 0), stage2i0(3));
    m4e: ENTITY work.mux4_1(logic) PORT MAP (input(19 downto 16), sel(1 downto 0), stage2i1(0));
    m4f: ENTITY work.mux4_1(logic) PORT MAP (input(23 downto 20), sel(1 downto 0), stage2i1(1));
    m4g: ENTITY work.mux4_1(logic) PORT MAP (input(27 downto 24), sel(1 downto 0), stage2i1(2));
    m4h: ENTITY work.mux4_1(logic) PORT MAP (input(31 downto 28), sel(1 downto 0), stage2i1(3));

    m4i: ENTITY work.mux4_1(logic) PORT MAP (stage2i0, sel(3 downto 2), m4io);
    m4j: ENTITY work.mux4_1(logic) PORT MAP (stage2i1, sel(3 downto 2), m4jo);
   
    m2a: ENTITY work.mux2_1(logic) PORT MAP (m4io, m4jo, sel(4), output);

END logic;

