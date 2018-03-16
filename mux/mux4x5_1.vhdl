LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY Mux4x5_1 IS
    PORT (values : reg_addr_array4;
          sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
          output: OUT reg_address);
END Mux4x5_1;


ARCHITECTURE logic OF Mux4x5_1 IS
    TYPE reg_addr_array4 IS ARRAY(3 DOWNTO 0) OF reg_address;
    TYPE selector IS ARRAY(4 DOWNTO 0) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL temp_array: selector;
BEGIN

    setTemp: FOR i IN 4 DOWNTO 0 GENERATE
        setTempInner: FOR j IN 3 DOWNTO 0 GENERATE
            temp_array(i)(j) <= values(j)(i);
        END GENERATE setTempInner;
    END GENERATE setTemp;

    m4gen : FOR i IN 4 DOWNTO 0 GENERATE
        m4: ENTITY work.mux4_1(logic) PORT MAP (temp_array(i), sel(1 downto 0), output(i));
    END GENERATE m4gen;

END logic;
