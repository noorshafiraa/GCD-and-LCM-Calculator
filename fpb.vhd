library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
use work.all;

-- !!! NOT PROOFREAD !!!
-- !!! HAVEN'T PASSED COMPILATION !!!
-- last update 16-11-21 21:30




entity FPB is
	port( rst, clk, i_enter, switch			: IN std_logic; 
		  A_in, B_in, C_in, D_in, P_in, Q_in	: IN std_logic_vector( 7 downto 0 ); 
		  FPB_OUT						: OUT std_logic_vector( 7 downto 0 ) 
		);
end FPB;

architecture FPB_arc of FPB is

-- komponen fsm untuk mengontrol alur
component fsm is 
	port( rst, clk, proses, switch				: in std_logic;
			compare						: in std_logic_vector( 1 downto 0 ); 
			SevSegment : out std_logic_vector (1 to 7);
			SevSegment_Display : out std_logic_vector(0 downto 0);
			enable, Sel_X, Sel_Y, Sel_A, Sel_B, Sel_C, Sel_D, Sel_AB, Sel_CD, Load_A, Load_B, Load_C, Load_D, Load_FPB_AB, Load_FPB_CD, En_X, En_Y : out std_logic
		); 
end component;

-- komponen mux untuk memilih mengeluarkan INput atau hasil sub nya ke register
component mux is 
	port( reset, selector 		: IN std_logic; 
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
	port( reset			: IN std_logic; 
		  comparison	: IN std_logic_vector( 1 downto 0 ); 
		  x, y			: IN std_logic_vector( 7 downto 0 ); 
		  XSubY, YSubX	: OUT std_logic_vector( 7 downto 0 ) 
		); 
end component;
 
-- komponen regis untuk menyimpan x atau y sebelumnya
component regis is 
	port( reset, clk, load	: IN std_logic; 
		  INPUT				: IN std_logic_vector( 7 downto 0 ); 
		  OUTPUT				: OUT std_logic_vector( 7 downto 0 ) 
		); 
end component; 

-- signal yang digunakan sementara
signal Load_A, Load_B, Load_C, Load_D, Load_FPB_AB, Load_FPB_CD, Select_A, Select_B, Select_C, Select_D, Select_AB, Select_CD, Select_X, Select_Y, En_X, En_Y, enable : std_logic; 
signal Compare_OUT1, Compare_OUT2, Compare_OUT3		: std_logic_vector( 1 downto 0 ); 
signal SevSegment 											:  std_logic_vector (1 to 7);
signal SevSegment_Display 									:  std_logic_vector(0 downto 0);
signal result													: std_logic_vector( 7 downto 0 );
signal Sub_AB, Sub_BA, Sub_CD, Sub_DC, Sub_PQ, Sub_QP, Sub_FPB_ABCD, Sub_FPB_CDAB, Mux_A, Mux_B, Mux_C, Mux_D, Mux_P, Mux_Q, Mux_AB, Mux_CD, Reg_A, Reg_B, Reg_C, Reg_D, Reg_FPB_AB, Reg_FPB_CD	: std_logic_vector( 7 downto 0 ); 

begin
	
	-- FSM controller 
	TOFSM	: fsm 			port map(rst, clk, i_enter, switch, Compare_OUT1, SevSegment, SevSegment_Display, enable, Select_X, Select_Y, Select_A, Select_B, Select_C, Select_D, Select_AB, Select_CD, Load_A, Load_B, Load_C, Load_D, Load_FPB_AB, Load_FPB_CD, En_X, En_Y ); 
	
	-- Datapath 
	PMux_A	: Mux 			port map( rst, Select_A, A_in, Sub_AB, Mux_A ); 
	PMux_B	: Mux 			port map( rst, Select_B, B_IN, Sub_BA, Mux_B ); 
	PMux_C	: Mux 			port map( rst, Select_C, C_IN, Sub_CD, Mux_C ); 
	PMux_D	: Mux 			port map( rst, Select_D, D_IN, Sub_DC, Mux_D );
	PMux_AB	: Mux 			port map( rst, Select_AB, P_IN, Sub_PQ, Mux_P );
	PMux_CD	: Mux 			port map( rst, Select_CD, Q_IN, Sub_QP, Mux_Q );
	PReg_A	: Regis 		port map( rst, clk, Load_A, Mux_A, Reg_A ); 
	PReg_B	: Regis 		port map( rst, clk, Load_B, Mux_B, Reg_B );
	PReg_C	: Regis 		port map( rst, clk, Load_C, Mux_C, Reg_C );
	PReg_D	: Regis 		port map( rst, clk, Load_D, Mux_D, Reg_D );
	PReg_FPB_AB	: Regis 		port map( rst, clk, Load_FPB_AB, Mux_AB, Reg_FPB_AB );
	PReg_FPB_CD	: Regis 		port map( rst, clk, Load_FPB_CD, Mux_CD, Reg_FPB_CD );
	P_COMP_1	: Comparator 	port map( rst, Reg_A, Reg_B, Compare_OUT1 );
	P_COMP_2	: Comparator 	port map( rst, Reg_C, Reg_D, Compare_OUT2 );
	P_COMP_3	: Comparator 	port map( rst, Reg_FPB_AB, Reg_FPB_CD, Compare_OUT3 ); 
	P_SUB_1	: Subtractor 	port map( rst, Compare_OUT1, Reg_A, Reg_B, Sub_AB, Sub_BA );
	P_SUB_2	: Subtractor 	port map( rst, Compare_OUT2, Reg_C, Reg_D, Sub_CD, Sub_DC );
	P_SUB_3	: Subtractor 	port map( rst, Compare_OUT3, Reg_FPB_AB, Reg_FPB_CD, Sub_FPB_ABCD, Sub_FPB_CDAB );
	POUT_REG: Regis 		port map( rst, clk, enable, Sub_FPB_ABCD, result ); 
	
	-- hasil FPB
	FPB_OUT <= result;
	 
end FPB_arc;
