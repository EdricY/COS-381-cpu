LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY decoder5_32 IS
    PORT (input : IN reg_address;
          e: IN STD_LOGIC;
          output : OUT word);
END decoder5_32;

ARCHITECTURE logic OF decoder5_32 IS
    SIGNAL d1_o0, d1_o1: STD_LOGIC;
    SIGNAL d2a_o, d2b_o: STD_LOGIC_VECTOR(3 downto 0);
BEGIN
    d1: ENTITY work.decoder1_2(logic) PORT MAP (input(4), e, d1_o0, d1_o1);

    d2a: ENTITY work.decoder2_4(logic) PORT MAP (input(3 downto 2), d1_o0, d2a_o);
    d2b: ENTITY work.decoder2_4(logic) PORT MAP (input(3 downto 2), d1_o1, d2b_o);

    d2c: ENTITY work.decoder2_4(logic) PORT MAP (input(1 downto 0), d2a_o(0), output(3 downto 0));
    d2d: ENTITY work.decoder2_4(logic) PORT MAP (input(1 downto 0), d2a_o(1), output(7 downto 4));
    d2e: ENTITY work.decoder2_4(logic) PORT MAP (input(1 downto 0), d2a_o(2), output(11 downto 8));
    d2f: ENTITY work.decoder2_4(logic) PORT MAP (input(1 downto 0), d2a_o(3), output(15 downto 12));

    d2g: ENTITY work.decoder2_4(logic) PORT MAP (input(1 downto 0), d2b_o(0), output(19 downto 16));
    d2h: ENTITY work.decoder2_4(logic) PORT MAP (input(1 downto 0), d2b_o(1), output(23 downto 20));
    d2i: ENTITY work.decoder2_4(logic) PORT MAP (input(1 downto 0), d2b_o(2), output(27 downto 24));
    d2j: ENTITY work.decoder2_4(logic) PORT MAP (input(1 downto 0), d2b_o(3), output(31 downto 28));

END logic;

