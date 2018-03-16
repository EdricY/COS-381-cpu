LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY Mux32x32_1 IS
    PORT (values : IN word_array;
          sel : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
          output: OUT word);
END Mux32x32_1;


ARCHITECTURE logic OF Mux32x32_1 IS
    SIGNAL temp_array: word_array;
BEGIN

    setTemp: FOR i IN values'range GENERATE
        setTempInner: FOR j IN values(0)'range GENERATE
            temp_array(i)(j) <= values(j)(i);
        END GENERATE setTempInner;
    END GENERATE setTemp;

    m32gen : FOR i IN 31 DOWNTO 0 GENERATE
        m32: ENTITY work.mux32_1(logic) PORT MAP (temp_array(i), sel, output(i));
    END GENERATE m32gen;

END logic;
