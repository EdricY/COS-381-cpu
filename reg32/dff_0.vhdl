LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Dff_0 IS
    PORT (D, WE, clock: IN STD_LOGIC;
	  Q : OUT STD_LOGIC := '0';
      Qprime: OUT STD_LOGIC := '1');
END Dff_0;

ARCHITECTURE Behavior OF Dff_0 IS
BEGIN

    PROCESS
    BEGIN
	WAIT UNTIL clock'EVENT AND clock = '1';
	-- could also be rising_edge(clock);
	IF WE = '1' AND (D = '1' OR D= '0') THEN
	    Q <= D AFTER 20 ps;
	    Qprime <= NOT D AFTER 20 ps;
	END IF;
    END PROCESS;
END Behavior;
