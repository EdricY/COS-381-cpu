LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY ALU IS
    PORT (Value1, Value2: IN word;
          Operation: IN op_type;
          ValueOut: OUT word;
          Overflow, Negative, Zero, CarryOut: OUT STD_LOGIC);
END ALU;

ARCHITECTURE logic OF ALU IS

SIGNAL sh_amt: reg_address;
SIGNAL sh_zfl, sh_cfl, sh_ofl, sh_nfl: STD_LOGIC;
SIGNAL a_zfl, a_cfl, a_ofl, a_nfl: STD_LOGIC;

SIGNAL zflags, cflags, oflags, nflags: STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";

SIGNAL results: word_half_array;

SIGNAL adder_result: word;
SIGNAL shift_result: word;
SIGNAL slt_result : word := x"00000000";
SIGNAL slt_opp_signs : STD_LOGIC;
SIGNAL slt_val1 : STD_LOGIC;
SIGNAL slt_val2 : STD_LOGIC;

BEGIN
    sh_amt <= Value2(4 downto 0);                  --                rshift
    b_shift: ENTITY work.b_shifter(logic) PORT MAP (Value1, sh_amt, Operation(0), shift_result, sh_zfl, sh_cfl, sh_ofl, sh_nfl);

    --                                              a       b       sub            unsig        sum           z      c      o      n
    adder: ENTITY work.f_adder32(logic) PORT MAP (Value1, Value2, Operation(2), Operation(0), adder_result, a_zfl, a_cfl, a_ofl, a_nfl);
    
    slt_opp_signs <= Value1(31) XOR Value2(31) AFTER 5 ps;
    slt_val1 <= Value1(31) AND slt_opp_signs AFTER 5 ps; --if opposite signs, return sign of Value1
    slt_val2 <= adder_result(31) AND (NOT slt_opp_signs) AFTER 10 ps;
    slt_result(0) <= slt_val1 OR slt_val2 AFTER 5 ps;

    logicgen : FOR i IN 0 TO 31 GENERATE
        results(8)(i) <= Value1(i) XOR Value2(i) AFTER 5 ps;
        results(9)(i) <= Value1(i) NOR Value2(i) AFTER 5 ps;
        results(10)(i) <= Value1(i) NAND Value2(i) AFTER 5 ps;
        results(11)(i) <= Value1(i) OR Value2(i) AFTER 5 ps;
        results(12)(i) <= NOT Value1(i) AFTER 5 ps;
    END GENERATE logicgen;
   
    zfcxor: ENTITY work.zflag_check(logic) PORT MAP(results(8), zflags(8));
    zfcnor: ENTITY work.zflag_check(logic) PORT MAP(results(9), zflags(9));
    zfcnand: ENTITY work.zflag_check(logic) PORT MAP(results(10), zflags(10));
    zfcor: ENTITY work.zflag_check(logic) PORT MAP(results(11), zflags(11));
    zfccomp: ENTITY work.zflag_check(logic) PORT MAP(results(12), zflags(12));
    nflags (8) <= results(8)(31);
    nflags (9) <= results(9)(31);
    nflags (10) <= results(10)(31);
    nflags (11) <= results(11)(31);
    nflags (12) <= results(12)(31);

    results(0) <= adder_result;
    zflags (0) <= a_zfl;
    cflags (0) <= a_cfl;
    oflags (0) <= a_ofl;
    nflags (0) <= a_nfl;
    results(1) <= adder_result;
    zflags (1) <= a_zfl;
    cflags (1) <= a_cfl;
    oflags (1) <= a_ofl;
    nflags (1) <= a_nfl;
    results(4) <= adder_result;
    zflags (4) <= a_zfl;
    cflags (4) <= a_cfl;
    oflags (4) <= a_ofl;
    nflags (4) <= a_nfl;
    results(5) <= slt_result;
    zflags (5) <= a_zfl;
    cflags (5) <= '0';
    oflags (5) <= '0';
    nflags (5) <= '0';

    results(2) <= shift_result;
    zflags (2) <= sh_zfl;
    cflags (2) <= sh_cfl;
    oflags (2) <= sh_ofl;
    nflags (2) <= sh_nfl;
    results(3) <= shift_result;
    zflags (3) <= sh_zfl;
    cflags (3) <= sh_cfl;
    oflags (3) <= sh_ofl;
    nflags (3) <= sh_nfl;

    
    m16z: ENTITY work.mux16_1(logic) PORT MAP (zflags, Operation, Zero);
    m16c: ENTITY work.mux16_1(logic) PORT MAP (cflags, Operation, CarryOut);
    m16o: ENTITY work.mux16_1(logic) PORT MAP (oflags, Operation, Overflow);
    m16n: ENTITY work.mux16_1(logic) PORT MAP (nflags, Operation, Negative);

    m16x32: ENTITY work.Mux16x32_1(logic) PORT MAP (results, Operation, ValueOut);
    
END logic;
