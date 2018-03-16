LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY b_shifter IS
    PORT (in_val: IN word;
          shift_amt: IN reg_address;
          right_shift: IN STD_LOGIC;
          res: OUT word;
          zfl, cfl, ofl, nfl: OUT STD_LOGIC);
END b_shifter;



ARCHITECTURE logic OF b_shifter IS
SIGNAL temp0: word;
TYPE mux_in_array IS ARRAY (0 to 31) OF STD_LOGIC_VECTOR(3 downto 0);

SIGNAL mux_in_a, mux_in_b, mux_in_c, mux_in_d, mux_in_e : mux_in_array;
SIGNAL sel_a, sel_b, sel_c, sel_d, sel_e : STD_LOGIC_VECTOR(1 downto 0);

SIGNAL za, zb, zc, zd, ze, zf, zg, zh, zx, zy: STD_LOGIC;

SIGNAL cfl_options_l, cfl_options_r: word;
SIGNAL cfl_l, cfl_r: STD_LOGIC;

SIGNAL ofl_rec_l, ofl_rec_r: word;
SIGNAL oa_r, ob_r, oc_r, od_r, oe_r, of_r, og_r, oh_r, ox_r, oy_r: STD_LOGIC;
SIGNAL oa_l, ob_l, oc_l, od_l, oe_l, of_l, og_l, oh_l, ox_l, oy_l: STD_LOGIC;
SIGNAL ofl_l, ofl_r: STD_LOGIC;
SIGNAL res_a, res_b, res_c, res_d, res_e : word;



BEGIN
    
    
    -- a -----------------------------
    sel_a(0) <= shift_amt(0);
    sel_a(1) <= right_shift;

    mux_in_a(0)(1) <= '0';
    ofl_rec_l(0) <= in_val(31) AND shift_amt(0) AFTER 5 ps;
    ma_in32_left: FOR i IN 1 to 31 GENERATE
        mux_in_a(i)(1) <= in_val(i-1);
    END GENERATE ma_in32_left;

    ma_in32_right: FOR i IN 0 to 30 GENERATE
        mux_in_a(i)(3) <= in_val(i+1);
    END GENERATE ma_in32_right;
    mux_in_a(31)(3) <= '0';
    ofl_rec_r(0) <= in_val(0) AND shift_amt(0) AFTER 5 ps;


    ma_in32: FOR i IN 0 to 31 GENERATE -- if shift_amt(0) == 0, don't change
        mux_in_a(i)(0) <= in_val(i);
        mux_in_a(i)(2) <= in_val(i);
    END GENERATE ma_in32;

    ma32: FOR i IN 0 to 31 GENERATE
        ma: ENTITY work.mux4_1(logic) PORT MAP (mux_in_a(i), sel_a, res_a(i));
    END GENERATE ma32;

    -- b -----------------------------
    sel_b(0) <= shift_amt(1);
    sel_b(1) <= right_shift;

    mux_in_b(0)(1) <= '0';
    mux_in_b(1)(1) <= '0';
    ofl_rec_l(1) <= res_a(31) AND shift_amt(1) AFTER 5 ps;
    ofl_rec_l(2) <= res_a(30) AND shift_amt(1) AFTER 5 ps;
    mb_in32_left: FOR i IN 2 to 31 GENERATE
        mux_in_b(i)(1) <= res_a(i-2);
    END GENERATE mb_in32_left;

    mb_in32_right: FOR i IN 0 to 29 GENERATE
        mux_in_b(i)(3) <= res_a(i+2);
    END GENERATE mb_in32_right;
    mux_in_b(30)(3) <= '0';
    mux_in_b(31)(3) <= '0';
    ofl_rec_r(1) <= res_a(0) AND shift_amt(1) AFTER 5 ps;
    ofl_rec_r(2) <= res_a(1) AND shift_amt(1) AFTER 5 ps;

    mb_in32: FOR i IN 0 to 31 GENERATE -- if shift_amt(1) == 0, don't change
        mux_in_b(i)(0) <= res_a(i);
        mux_in_b(i)(2) <= res_a(i);
    END GENERATE mb_in32;

    mb32: FOR i IN 0 to 31 GENERATE
        mb: ENTITY work.mux4_1(logic) PORT MAP (mux_in_b(i), sel_b, res_b(i));
    END GENERATE mb32;

    -- c -----------------------------
    sel_c(0) <= shift_amt(2);
    sel_c(1) <= right_shift;

    mux_in_c_ground: FOR i IN 0 to 3 GENERATE
        mux_in_c(i)(1) <= '0';
        mux_in_c(31-i)(3) <= '0';

        ofl_rec_l(i+3) <= res_b(31-i) AND shift_amt(2) AFTER 5 ps;
        ofl_rec_r(i+3) <= res_b(i) AND shift_amt(2) AFTER 5 ps;
    END GENERATE mux_in_c_ground;

    mc_in32_left: FOR i IN 4 to 31 GENERATE
        mux_in_c(i)(1) <= res_b(i-4);
    END GENERATE mc_in32_left;

    mc_in32_right: FOR i IN 0 to 27 GENERATE
        mux_in_c(i)(3) <= res_b(i+4);
    END GENERATE mc_in32_right;

    mc_in32: FOR i IN 0 to 31 GENERATE -- if shift_amt(2) == 0, don't change
        mux_in_c(i)(0) <= res_b(i);
        mux_in_c(i)(2) <= res_b(i);
    END GENERATE mc_in32;

    mc32: FOR i IN 0 to 31 GENERATE
        mc: ENTITY work.mux4_1(logic) PORT MAP (mux_in_c(i), sel_c, res_c(i));
    END GENERATE mc32;

    -- d -----------------------------
    sel_d(0) <= shift_amt(3);
    sel_d(1) <= right_shift;

    mux_in_d_ground: FOR i IN 0 to 7 GENERATE
        mux_in_d(i)(1) <= '0';
        mux_in_d(31-i)(3) <= '0';
        
        ofl_rec_l(i+7) <= res_c(31-i) AND shift_amt(3) AFTER 5 ps;
        ofl_rec_r(i+7) <= res_c(i) AND shift_amt(3) AFTER 5 ps;
    END GENERATE mux_in_d_ground;

    md_in32_left: FOR i IN 8 to 31 GENERATE
        mux_in_d(i)(1) <= res_c(i-8);
    END GENERATE md_in32_left;

    md_in32_right: FOR i IN 0 to 23 GENERATE
        mux_in_d(i)(3) <= res_c(i+8);
    END GENERATE md_in32_right;

    md_in32: FOR i IN 0 to 31 GENERATE -- if shift_amt(3) == 0, don't change
        mux_in_d(i)(0) <= res_c(i);
        mux_in_d(i)(2) <= res_c(i);
    END GENERATE md_in32;

    md32: FOR i IN 0 to 31 GENERATE
        md: ENTITY work.mux4_1(logic) PORT MAP (mux_in_d(i), sel_d, res_d(i));
    END GENERATE md32;

    -- e -----------------------------
    sel_e(0) <= shift_amt(4);
    sel_e(1) <= right_shift;
    
    mux_in_e_ground: FOR i IN 0 to 15 GENERATE
        mux_in_e(i)(1) <= '0';
        mux_in_e(31-i)(3) <= '0';
        
        ofl_rec_l(i+15) <= res_d(31-i) AND shift_amt(4) AFTER 5 ps;
        ofl_rec_r(i+15) <= res_d(i) AND shift_amt(4) AFTER 5 ps;
    END GENERATE mux_in_e_ground;

    me_in32_left: FOR i IN 16 to 31 GENERATE
        mux_in_e(i)(1) <= res_d(i-16);
    END GENERATE me_in32_left;

    me_in32_right: FOR i IN 0 to 15 GENERATE
        mux_in_e(i)(3) <= res_d(i+16);
    END GENERATE me_in32_right;

    me_in32: FOR i IN 0 to 31 GENERATE -- if shift_amt(4) == 0, don't change
        mux_in_e(i)(0) <= res_d(i);
        mux_in_e(i)(2) <= res_d(i);
    END GENERATE me_in32;

    me32: FOR i IN 0 to 31 GENERATE
        me: ENTITY work.mux4_1(logic) PORT MAP (mux_in_e(i), sel_e, res_e(i));
    END GENERATE me32;


    -- zfl -----------------------------
    za <= res_e( 0) OR res_e( 1) OR res_e( 2) OR res_e( 3) AFTER 5 ps;
    zb <= res_e( 4) OR res_e( 5) OR res_e( 6) OR res_e( 7) AFTER 5 ps;
    zc <= res_e( 8) OR res_e( 9) OR res_e(10) OR res_e(11) AFTER 5 ps;
    zd <= res_e(12) OR res_e(13) OR res_e(14) OR res_e(15) AFTER 5 ps;
    ze <= res_e(16) OR res_e(17) OR res_e(18) OR res_e(19) AFTER 5 ps;
    zf <= res_e(20) OR res_e(21) OR res_e(22) OR res_e(23) AFTER 5 ps;
    zg <= res_e(24) OR res_e(25) OR res_e(26) OR res_e(27) AFTER 5 ps;
    zh <= res_e(28) OR res_e(29) OR res_e(30) OR res_e(31) AFTER 5 ps;
    
    zx <= za OR zb OR zc OR zd AFTER 5 ps;
    zy <= ze OR zf OR zg OR zh AFTER 5 ps;
    zfl <= zx NOR zy AFTER 5 ps; --15 ps to calc after res_e

    -- cfl -----------------------------
    cfl_options_l(0) <= '0';
    cfl_options_r(0) <= '0';

    cfl_options: FOR i IN 1 to 31 GENERATE
        cfl_options_l(i) <= in_val(32-i);
        cfl_options_r(i) <= in_val(i-1);
    END GENERATE cfl_options;

    cfl_m32l: ENTITY work.mux32_1(logic) PORT MAP (cfl_options_l, shift_amt, cfl_l);
    cfl_m32r: ENTITY work.mux32_1(logic) PORT MAP (cfl_options_r, shift_amt, cfl_r);
    cfl_m2: ENTITY work.mux2_1(logic) PORT MAP (cfl_l, cfl_r, right_shift, cfl);

    -- ofl -----------------------------
    ofl_rec_r(31) <= '0';
    ofl_rec_l(31) <= '0';
    oa_r <= ofl_rec_r( 0) OR ofl_rec_r( 1) OR ofl_rec_r( 2) OR ofl_rec_r( 3) AFTER 5 ps;
    ob_r <= ofl_rec_r( 4) OR ofl_rec_r( 5) OR ofl_rec_r( 6) OR ofl_rec_r( 7) AFTER 5 ps;
    oc_r <= ofl_rec_r( 8) OR ofl_rec_r( 9) OR ofl_rec_r(10) OR ofl_rec_r(11) AFTER 5 ps;
    od_r <= ofl_rec_r(12) OR ofl_rec_r(13) OR ofl_rec_r(14) OR ofl_rec_r(15) AFTER 5 ps;
    oe_r <= ofl_rec_r(16) OR ofl_rec_r(17) OR ofl_rec_r(18) OR ofl_rec_r(19) AFTER 5 ps;
    of_r <= ofl_rec_r(20) OR ofl_rec_r(21) OR ofl_rec_r(22) OR ofl_rec_r(23) AFTER 5 ps;
    og_r <= ofl_rec_r(24) OR ofl_rec_r(25) OR ofl_rec_r(26) OR ofl_rec_r(27) AFTER 5 ps;
    oh_r <= ofl_rec_r(28) OR ofl_rec_r(29) OR ofl_rec_r(30) OR ofl_rec_r(31) AFTER 5 ps;

    ox_r <= oa_r OR ob_r OR oc_r OR od_r AFTER 5 ps;
    oy_r <= oe_r OR of_r OR og_r OR oh_r AFTER 5 ps;
    ofl_r <= ox_r OR oy_r AFTER 5 ps;

    oa_l <= ofl_rec_l( 0) OR ofl_rec_l( 1) OR ofl_rec_l( 2) OR ofl_rec_l( 3) AFTER 5 ps;
    ob_l <= ofl_rec_l( 4) OR ofl_rec_l( 5) OR ofl_rec_l( 6) OR ofl_rec_l( 7) AFTER 5 ps;
    oc_l <= ofl_rec_l( 8) OR ofl_rec_l( 9) OR ofl_rec_l(10) OR ofl_rec_l(11) AFTER 5 ps;
    od_l <= ofl_rec_l(12) OR ofl_rec_l(13) OR ofl_rec_l(14) OR ofl_rec_l(15) AFTER 5 ps;
    oe_l <= ofl_rec_l(16) OR ofl_rec_l(17) OR ofl_rec_l(18) OR ofl_rec_l(19) AFTER 5 ps;
    of_l <= ofl_rec_l(20) OR ofl_rec_l(21) OR ofl_rec_l(22) OR ofl_rec_l(23) AFTER 5 ps;
    og_l <= ofl_rec_l(24) OR ofl_rec_l(25) OR ofl_rec_l(26) OR ofl_rec_l(27) AFTER 5 ps;
    oh_l <= ofl_rec_l(28) OR ofl_rec_l(29) OR ofl_rec_l(30) OR ofl_rec_l(31) AFTER 5 ps;

    ox_l <= oa_l OR ob_l OR oc_l OR od_l AFTER 5 ps;
    oy_l <= oe_l OR of_l OR og_l OR oh_l AFTER 5 ps;
    ofl_l <= ox_l OR oy_l AFTER 5 ps;

    ofl_m2: ENTITY work.mux2_1(logic) PORT MAP (ofl_l, ofl_r, right_shift, ofl);

    -- nfl -----------------------------
    nfl <= res_e(31);


    res <= res_e; 

END logic;
