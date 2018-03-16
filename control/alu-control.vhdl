LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ALUControl IS
    PORT(OpType: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
         Func: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
         Operation: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END ALUControl;

ARCHITECTURE Behavior OF ALUControl IS 
BEGIN
    PROCESS
    BEGIN
    WAIT until OpType'EVENT or Func'EVENT;
    WAIT FOR 20 ps;
    if OpType(1) = '0' then
        if OpType(0) = '0' then
            Operation <= "0000"; -- 00 -> add
        else 
            Operation <= "0100"; -- 01 -> sub
        end if;
    else
        if OpType(0) = '1' then
            Operation <= "1011"; -- 11 -> or
        else -- OpType = "10"
            if    Func = "100000" then  -- add
                Operation <= "0000";
            elsif Func = "100001" then  -- addu
                Operation <= "0001";
            elsif Func = "001000" then  -- jr
                Operation <= "1011"; --or?
            elsif Func = "100111" then  -- nor
                Operation <= "1001";
            elsif Func = "000000" then  -- sll
                Operation <= "0010";
            elsif Func = "000010" then  -- srl
                Operation <= "0011";
            elsif Func = "101010" then  -- slt
                Operation <= "0101";
            elsif Func = "100010" then  -- sub
                Operation <= "0100";
            elsif Func = "100110" then  -- xor
                Operation <= "1000";
            elsif Func = "100100" then  -- and
                Operation <= "1101";
            elsif Func = "100101" then  -- or
                Operation <= "1011";
            else
                Operation <= "0000"; --default to add?
            end if;
        end if;
    end if;

    END PROCESS;

END Behavior;

