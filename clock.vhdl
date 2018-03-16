LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY clock IS
    PORT (E: IN STD_LOGIC;
          Q: OUT STD_LOGIC);
END clock;

ARCHITECTURE logic OF clock IS
SIGNAL P: STD_LOGIC := '1';
BEGIN

        P <= P NAND E AFTER clock_tick;
        Q <= P;

END logic;

ARCHITECTURE pipelined OF clock IS
SIGNAL P: STD_LOGIC := '1';
BEGIN

        P <= P NAND E AFTER p_clock_tick;
        Q <= P;

END pipelined;
