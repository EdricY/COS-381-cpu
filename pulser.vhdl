LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

--Pulse on falling edge of clock. (To pulse on rising edge, pass in NOT clock)

ENTITY pulser IS
    PORT (C: IN STD_LOGIC;
          output: OUT STD_LOGIC);
END pulser;

ARCHITECTURE logic OF pulser IS
SIGNAL P, Q: STD_LOGIC;
BEGIN
    P <= NOT C AFTER 10 ps;
    Q <= C;
    output <= P NOR Q AFTER 10 ps; 
    
END logic;
