library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
use work.all;

-- !!! NOT PROOFREAD !!!
-- !!! HAVEN'T PASSED COMPILATION !!!
-- last update 16-11-21 10:41
-- note :
--		top level fpb.vhd kurang lebih sudah lancar dan belum ditemukan masalah
--		belum berhasil compile karena ada 17 errors at fsm.vhd
--		Error (10500): VHDL syntax error at fsm.vhd(209) near text "when";  expecting "end", or "(", or an identifier ("when" is a reserved keyword), or a sequential statement


entity FPB is
	port( rst, clk, i_enter			: IN std_logic; 
		  A_in, B_in, C_in, D_in, P_in, Q_in	: IN std_logic_vector( 7 downto 0 ); 
		  FPB_OUT						: OUT std_logic_vector( 7 downto 0 ) 
		);
end FPB;

architecture FPB_arc of FPB is

-- komponen fsm untuk mengontrol alur
component fsm is 
	port( rst, clk, proses, switch, FPB_AB, FPB_CD, FPB_ABCD			: in std_logic; 
		  compare																	: in std_logic_vector( 1 downto 0 ); 
		  enable, Sel_X, Sel_Y, Sel_A, Sel_B, Sel_C, Sel_D, Sel_AB, Sel_CD : out std_logic;
		  Load_A, Load_B, Load_C, Load_D, Load_FPB_AB, Load_FPB_CD 	: out std_logic
		); 
end component;

-- komponen mux untuk memilih mengeluarkan INput atau hasil sub nya ke register
component mux is 
	port( rst, selector 		: IN std_logic; 
		  Load_IN, Sub_IN 	: IN std_logic_vector( 7 downto 0 );
	   	  OUTPUT 			: OUT std_logic_vector( 7 downto 0 ) 
		); 
end component;
 
-- komponen komparator untuk membandINgkan lebih besar x atau y
component comparator is 
	port( rst 		: IN std_logic; 
		  x, y 		: IN std_logic_vector( 7 downto 0 ); 
		  OUTPUT 	: OUT std_logic_vector( 1 downto 0 ) 
		); 
end component;

-- komponen subtractor untuk mengurangi x dengan y atau y dengan x
component subtractor is 
	port( rst			: IN std_logic; 
		  comparison	: IN std_logic_vector( 1 downto 0 ); 
		  x, y			: IN std_logic_vector( 7 downto 0 ); 
		  XSubY, YSubX	: OUT std_logic_vector( 7 downto 0 ) 
		); 
end component;
 
-- komponen regis untuk menyimpan x atau y sebelumnya
component regis is 
	port( rst, clk, load	: IN std_logic; 
		  INPUT				: IN std_logic_vector( 7 downto 0 ); 
		  OUTPUT				: OUT std_logic_vector( 7 downto 0 ) 
		); 
end component; 

-- signal yang digunakan sementara
signal Load_A, Load_B, Load_C, Load_D, Load_FPB_AB, Load_FPB_CD, Select_A, Select_B, Select_C, Select_D, Select_AB, Select_CD, enable: std_logic; 
signal Compare_OUT											: std_logic_vector( 1 downto 0 ); 
signal result													: std_logic_vector( 7 downto 0 );
signal Sub_AB, Sub_BA, Sub_CD, Sub_DC, Sub_FPB_ABCD, Sub_FPB_CDAB, Mux_A, Mux_B, Mux_C, Mux_D, Mux_AB, Mux_CD, Reg_A, Reg_B, Reg_C, Reg_D, Reg_FPB_AB, Reg_FPB_CD	: std_logic_vector( 7 downto 0 ); 

begin
	
	-- FSM controller 
	TOFSM	: fsm 			port map(rst, clk, i_enter, Compare_OUT, enable, Load_A, Load_B, Load_C, Load_D, Load_FPB_AB, Load_FPB_CD, Select_A, Select_B, Select_C, Select_D, Select_AB, Select_CD); 
	
	-- Datapath 
	PMux_A	: mux 			port map( rst, Select_A, A_in, Sub_AB, Mux_A ); 
	PMux_B	: mux 			port map( rst, Select_B, B_IN, Sub_BA, Mux_B ); 
	PMux_C	: mux 			port map( rst, Select_C, C_IN, Sub_CD, Mux_C ); 
	PMux_D	: mux 			port map( rst, Select_D, D_IN, Sub_DC, Mux_D );
	PMux_AB	: mux 			port map( rst, Select_AB, P_IN, Sub_PQ, Mux_P );
	PMux_CD	: mux 			port map( rst, Select_CD, Q_IN, Sub_QP, Mux_Q );
	PReg_A	: regis 		port map( rst, clk, Load_A, Mux_A, Reg_A ); 
	PReg_B	: regis 		port map( rst, clk, Load_B, Mux_B, Reg_B );
	PReg_C	: regis 		port map( rst, clk, Load_C, Mux_C, Reg_C );
	PReg_D	: regis 		port map( rst, clk, Load_D, Mux_D, Reg_D );
	PReg_FPB_AB	: regis 		port map( rst, clk, Load_FPB_AB, Mux_AB, Reg_FPB_AB );
	PReg_FPB_CD	: regis 		port map( rst, clk, Load_FPB_CD, Mux_CD, Reg_FPB_CD );
	P_COMP_1	: comparator 	port map( rst, Reg_A, Reg_B, Compare_OUT );
	P_COMP_2	: comparator 	port map( rst, Reg_C, Reg_D, Compare_OUT );
	P_COMP_3	: comparator 	port map( rst, Reg_FPB_AB, Reg_FPB_CD, Compare_OUT ); 
	P_SUB_1	: subtractor 	port map( rst, Compare_OUT, Reg_A, Reg_B, Sub_AB, Sub_BA );
	P_SUB_2	: subtractor 	port map( rst, Compare_OUT, Reg_C, Reg_D, Sub_CD, Sub_DC );
	P_SUB_3	: subtractor 	port map( rst, Compare_OUT, Reg_FPB_AB, Reg_FPB_CD, Sub_FPB_ABCD, Sub_FPB_CDAB );
	POUT_REG: regis 		port map( rst, clk, enable, Sub_FPB_ABCD, result ); 
	
	-- hasil FPB
	FPB_OUT <= result;
	 
end FPB_arc;