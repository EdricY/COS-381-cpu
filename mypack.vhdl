LIBRARY ieee;
USE ieee.std_logic_1164.all;
PACKAGE p IS
    SUBTYPE word IS STD_LOGIC_VECTOR(31 DOWNTO 0); 
    TYPE word_array IS ARRAY(31 DOWNTO 0) OF word;
    TYPE word_half_array IS ARRAY(15 DOWNTO 0) OF word;
    TYPE word_array4 IS ARRAY(3 DOWNTO 0) OF word;
    TYPE word_pair IS ARRAY(1 DOWNTO 0) OF word;
    SUBTYPE op_type IS STD_LOGIC_VECTOR(3 DOWNTO 0);
    SUBTYPE reg_address IS STD_LOGIC_VECTOR(4 DOWNTO 0);
    TYPE reg_addr_array4 IS ARRAY(3 DOWNTO 0) OF reg_address;
    CONSTANT clock_tick: TIME := 500 ps;  -- 1 GHz
    CONSTANT p_clock_tick: TIME := 160 ps; -- 3.125 GHz
END PACKAGE;
