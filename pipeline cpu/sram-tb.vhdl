LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY sram_tb IS
END sram_tb;

ARCHITECTURE test OF sram_tb IS
    SIGNAL ncs, nwe, noe: STD_LOGIC;
    SIGNAL addr, data: STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    sram: ENTITY work.sram64kx8 PORT MAP(ncs, addr, data, nwe, noe);

    PROCESS BEGIN
	-- start using the memory chip
	ncs <= '0';

	-- disconnect from the data lines and set the address
	data <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
	addr <= X"00000000";
	-- but don't ask for anything from the memory this cycle
	nwe <= '1';
	noe <= '1';
	wait for 1 ns;

	-- read from the previously set address
	noe <= '0';
	wait for 500 ps;
	noe <= '1';
	wait for 500 ps;

	-- set the data and address so we can write to the memory
	data <= X"33333333";
	addr <= X"00000008";

	-- and write the value
	nwe <= '0';
	wait for 500 ps;
	nwe <= '1';
	wait for 500 ps;

	-- change the address
	addr <= X"00000004";
	-- and disconnect the data lines since we expect to read from
	-- memory
	data <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

	-- and read the value
	noe <= '0';
	wait for 500 ps;
	noe <= '1';
	wait for 500 ps;

	-- change the address to the value we've written to already
	-- (to show we can read values previously written)
	addr <= X"00000008";

	-- and read the value
	noe <= '0';
	wait for 500 ps;
	noe <= '1';
	wait for 500 ps;

	-- change the address back to an address with a preset value
	addr <= X"0000000C";

	-- and read that value
	noe <= '0';
	wait for 500 ps;
	noe <= '1';
	wait for 500 ps;

	-- set the data to the value we want to display on the screen
	data <= X"00000041"; -- 'A'
	-- and set the address to the location that causes writes to occur
	addr <= X"0000FFFC";

	-- and "write" the data to the screen
	nwe <= '0';
	wait for 500 ps;
	nwe <= '1';
	wait for 500 ps;

	-- change the data to display on screen
	data <= X"00000042"; -- 'B'

	-- and "write" the data to the screen
	nwe <= '0';
	wait for 500 ps;
	nwe <= '1';
	wait for 500 ps;

	-- complete the display with a newline character
	data <= X"0000000A"; -- newline

	-- and "write" the newline to the screen
	nwe <= '0';
	wait for 500 ps;
	nwe <= '1';
	wait for 500 ps;

	-- disconnect from the data lines so we can read a value from
	-- the keyboard
	data <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
	-- and set the address to the location that causes reads to occur
	addr <= X"0000FFF8";

	-- and "read" the data from the screen
	noe <= '0';
	wait for 500 ps;
	noe <= '1';
	wait for 500 ps;

	-- and "read" another character from the screen
	noe <= '0';
	wait for 500 ps;
	noe <= '1';
	wait for 500 ps;

	-- and "read" a final character from the screen
	noe <= '0';
	wait for 1 ns;

	-- stop using the memory chip
	ncs <= '1';
	wait;
    END PROCESS;
END test;
