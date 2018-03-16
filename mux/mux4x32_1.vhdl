LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY Mux4x32_1 IS
    PORT (values : word_array4;
          sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
          output: OUT word);
END Mux4x32_1;


ARCHITECTURE logic OF Mux4x32_1 IS
    TYPE word_array4 IS ARRAY(3 DOWNTO 0) OF word;
    TYPE selector IS ARRAY(31 DOWNTO 0) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL temp_array: selector;
BEGIN

    setTemp: FOR i IN 31 DOWNTO 0 GENERATE
        setTempInner: FOR j IN 3 DOWNTO 0 GENERATE
            temp_array(i)(j) <= values(j)(i);
        END GENERATE setTempInner;
    END GENERATE setTemp;

    m4gen : FOR i IN 31 DOWNTO 0 GENERATE
        m4: ENTITY work.mux4_1(logic) PORT MAP (temp_array(i), sel(1 downto 0), output(i));
    END GENERATE m4gen;

END logic;
