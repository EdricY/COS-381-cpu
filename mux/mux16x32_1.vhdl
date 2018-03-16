LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY Mux16x32_1 IS
    PORT (values : IN word_half_array;
          sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          output: OUT word);
END Mux16x32_1;


ARCHITECTURE logic OF Mux16x32_1 IS
    TYPE word_half_array IS ARRAY(15 DOWNTO 0) OF word;
    TYPE selector IS ARRAY(31 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL temp_array: selector;
BEGIN

    setTemp: FOR i IN 31 DOWNTO 0 GENERATE
        setTempInner: FOR j IN 15 DOWNTO 0 GENERATE
            temp_array(i)(j) <= values(j)(i);
        END GENERATE setTempInner;
    END GENERATE setTemp;

    m16gen : FOR i IN 31 DOWNTO 0 GENERATE
        m16: ENTITY work.mux16_1(logic) PORT MAP (temp_array(i), sel(3 downto 0), output(i));
    END GENERATE m16gen;

END logic;
