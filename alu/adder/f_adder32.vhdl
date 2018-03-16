LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY f_adder32 IS
    PORT (a, b: IN word;
          sub_cont, unsig_cont: IN STD_LOGIC;
          sum_out: OUT word;
          zfl, cfl, ofl, nfl: OUT STD_LOGIC);
END f_adder32;


ARCHITECTURE logic OF f_adder32 IS
    SIGNAL bx, c, sum: word;
    SIGNAL oflow_u, oflow_s: STD_LOGIC;
    SIGNAL za, zb, zc, zd, ze, zf, zg, zh, zx, zy: STD_LOGIC;
    SIGNAL sig_cont: STD_LOGIC;
BEGIN

    bx(0) <= b(0) XOR sub_cont AFTER 5 ps;
    fa0: ENTITY work.f_adder(logic) PORT MAP(a(0), bx(0), sub_cont, c(0), sum(0));

    fa32: FOR i IN 1 to 31 GENERATE
        bx(i) <= b(i) XOR sub_cont AFTER 5 ps;
        fa: ENTITY work.f_adder(logic) PORT MAP(a(i), bx(i), c(i-1), c(i), sum(i));
    END GENERATE fa32;

    cfl <= c(31);

    oflow_s <= c(30) XOR c(31) AFTER 5 ps;
    oflow_u <= c(31);
    m2a: ENTITY work.mux2_1(logic) PORT MAP (oflow_s, oflow_u, unsig_cont, ofl);

    sig_cont <= NOT unsig_cont AFTER 5 ps;
    nfl <= sum(31) AND sig_cont AFTER 5 ps;
    
    zfc: ENTITY work.zflag_check(logic) PORT MAP(sum, zfl);

    sum_out <= sum;

END logic;
