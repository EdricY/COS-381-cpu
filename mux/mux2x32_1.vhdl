LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY Mux2x32_1 IS
    PORT (values : word_pair;
          sel : IN STD_LOGIC;
          output: OUT word);
END Mux2x32_1;


ARCHITECTURE logic OF Mux2x32_1 IS
    TYPE word_pair IS ARRAY(1 DOWNTO 0) OF word;
    TYPE selector IS ARRAY(31 DOWNTO 0) OF STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL temp_array: selector;
BEGIN

    setTemp: FOR i IN 31 DOWNTO 0 GENERATE
        setTempInner: FOR j IN 1 DOWNTO 0 GENERATE
            temp_array(i)(j) <= values(j)(i);
        END GENERATE setTempInner;
    END GENERATE setTemp;

    m2gen : FOR i IN 31 DOWNTO 0 GENERATE
        m2: ENTITY work.mux2_1(logic) PORT MAP (temp_array(i)(0), temp_array(i)(1), sel, output(i));
    END GENERATE m2gen;

END logic;
