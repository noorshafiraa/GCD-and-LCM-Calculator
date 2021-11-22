library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
use work.all;




entity Main is
	port( rst, clk, i_enter, switch_FPB, switch_KPK		: IN std_logic; 
		  A_in, B_in, C_in, D_in, X_in, Y_in 	: IN std_logic_vector( 7 downto 0 );
		  KPK_FPB_OUT						: OUT std_logic_vector( 15 downto 0 ) 
		);
end Main;

architecture Main_arc of Main is

-- komponen fsm untuk mengontrol alur
component fsm is 
	port( rst, clk, proses, switch_FPB, switch_KPK			: in std_logic;
			compare1, compare2, compare3, compare4						: in std_logic_vector( 1 downto 0 ); 
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

-- komponen mux untuk memilih mengeluarkan INput atau hasil sub nya ke register
component mux_16 is 
	port( reset, selector 		: IN std_logic; 
		  Load_IN, Sub_IN 	: IN std_logic_vector( 15 downto 0 );
	   	  OUTPUT 			: OUT std_logic_vector( 15 downto 0 ) 
		); 
end component;
 
-- komponen komparator untuk membandINgkan lebih besar x atau y
component comparator is 
	port( rst 		: IN std_logic; 
		  x, y 		: IN std_logic_vector( 7 downto 0 ); 
		  OUTPUT 	: OUT std_logic_vector( 1 downto 0 ) 
		); 
end component;

-- komponen komparator untuk membandINgkan lebih besar x atau y
component comparator_16 is 
	port( rst 		: IN std_logic; 
		  x, y 		: IN std_logic_vector( 15 downto 0 ); 
		  OUTPUT 	: OUT std_logic_vector( 1 downto 0 ) 
		); 
end component;


-- komponen adder untuk menambahkan x dengan x_init atau y dengan y_init
component Adder is
	port( reset		: IN std_logic; 
		  comparison: IN std_logic_vector( 1 downto 0 ); 
		  x_init, x, y_init, y	: IN std_logic_vector( 15 downto 0 ); 
		  XAddX, YAddY: OUT std_logic_vector( 15 downto 0 ) 
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

-- komponen regis untuk menyimpan x atau y sebelumnya
component regis_16 is 
	port( reset, clk, load	: IN std_logic; 
		  INPUT				: IN std_logic_vector( 15 downto 0 ); 
		  OUTPUT				: OUT std_logic_vector( 15 downto 0 ) 
		); 
end component; 

component Regis_8to16 is
	port( reset, clk, LOAD: IN std_logic; 
		  INPUT			: IN std_logic_vector( 7 downto 0 ); 
		  OUTPUT		: OUT std_logic_vector( 15 downto 0 ) 
		); 
end component;

-- signal yang digunakan sementara
signal Load_A, Load_B, Load_C, Load_D, Load_FPB_AB, Load_FPB_CD, Select_A, Select_B, Select_C, Select_D, Select_AB, Select_CD, Select_X, Select_Y, En_X, En_Y, enable : std_logic; 
signal Compare_OUT1, Compare_OUT2, Compare_OUT3, Compare_OUT4		: std_logic_vector( 1 downto 0 ); 
signal SevSegment 											:  std_logic_vector (1 to 7);
signal SevSegment_Display 									:  std_logic_vector(0 downto 0);
signal result_FPB													: std_logic_vector( 15 downto 0 );
signal Sub_AB, Sub_BA, Sub_CD, Sub_DC, Sub_FPB_ABCD, Sub_FPB_CDAB, Mux_A, Mux_B, Mux_C, Mux_D, Mux_P, Mux_Q, Reg_A, Reg_B, Reg_C, Reg_D, Reg_FPB_AB, Reg_FPB_CD	: std_logic_vector( 7 downto 0 ); 
signal result_KPK												: std_logic_vector( 15 downto 0);
signal Add_XX, Add_YY, Mux_X, Mux_Y, Reg_X16, Reg_Y16, Reg_X, Reg_Xinit, Reg_Y, Reg_Yinit : std_logic_vector ( 15 downto 0);

begin
	
	-- FSM controller 
	TOFSM	: fsm 			port map(rst, clk, i_enter, switch_FPB, switch_KPK, Compare_OUT1, Compare_OUT2, Compare_OUT3, Compare_OUT4, SevSegment, SevSegment_Display, enable, Select_X, Select_Y, Select_A, Select_B, Select_C, Select_D, Select_AB, Select_CD, Load_A, Load_B, Load_C, Load_D, Load_FPB_AB, Load_FPB_CD, En_X, En_Y ); 
	
	-- Datapath FPB
	PMux_A	: Mux 			port map( rst, Select_A, A_in, Sub_AB, Mux_A ); 
	PMux_B	: Mux 			port map( rst, Select_B, B_in, Sub_BA, Mux_B ); 
	PMux_C	: Mux 			port map( rst, Select_C, C_in, Sub_CD, Mux_C ); 
	PMux_D	: Mux 			port map( rst, Select_D, D_in, Sub_DC, Mux_D );
	PMux_AB	: Mux 			port map( rst, Select_AB, Sub_BA, Sub_FPB_ABCD, Mux_P );
	PMux_CD	: Mux 			port map( rst, Select_CD, Sub_DC, Sub_FPB_CDAB, Mux_Q );
	PReg_A	: Regis 		port map( rst, clk, Load_A, Mux_A, Reg_A ); 
	PReg_B	: Regis 		port map( rst, clk, Load_B, Mux_B, Reg_B );
	PReg_C	: Regis 		port map( rst, clk, Load_C, Mux_C, Reg_C );
	PReg_D	: Regis 		port map( rst, clk, Load_D, Mux_D, Reg_D );
	PReg_FPB_AB	: Regis 		port map( rst, clk, Load_FPB_AB, Mux_P, Reg_FPB_AB );
	PReg_FPB_CD	: Regis 		port map( rst, clk, Load_FPB_CD, Mux_Q, Reg_FPB_CD );
	P_COMP_1	: Comparator 	port map( rst, Reg_A, Reg_B, Compare_OUT1 );
	P_COMP_2	: Comparator 	port map( rst, Reg_C, Reg_D, Compare_OUT2 );
	P_COMP_3	: Comparator 	port map( rst, Reg_FPB_AB, Reg_FPB_CD, Compare_OUT3 ); 
	P_SUB_1	: Subtractor 	port map( rst, Compare_OUT1, Reg_A, Reg_B, Sub_AB, Sub_BA );
	P_SUB_2	: Subtractor 	port map( rst, Compare_OUT2, Reg_C, Reg_D, Sub_CD, Sub_DC );
	P_SUB_3	: Subtractor 	port map( rst, Compare_OUT3, Reg_FPB_AB, Reg_FPB_CD, Sub_FPB_ABCD, Sub_FPB_CDAB );
	POUT_REG_FPB: Regis_8to16 		port map( rst, clk, enable, Sub_FPB_CDAB, result_FPB ); 
	-- Datapath KPK
	PMux_X	: Mux_16			port map( rst, Select_X, Reg_X16, Add_XX, Mux_X );
	PMux_Y	: Mux_16			port map( rst, Select_Y, Reg_Y16, Add_YY, Mux_Y );
	PReg_X8	: Regis_8to16	port map( rst, clk, En_X, X_in, Reg_X16 );
	PReg_Y8	: Regis_8to16	port map( rst, clk, En_X, Y_in, Reg_Y16 );
	PReg_X	: Regis_16 		port map( rst, clk, En_X, Mux_X, Reg_X );
	PReg_Xinit	: Regis_16 	port map( rst, clk, En_X, Reg_X16, Reg_Xinit );
	PReg_Y	: Regis_16 		port map( rst, clk, En_Y, Mux_Y, Reg_Y );
	PReg_Yinit	: Regis_16	port map( rst, clk, En_Y, Reg_Y16, Reg_Yinit );
	P_COMP_4	: Comparator_16	port map( rst, Reg_X, Reg_Y, Compare_OUT4 ); 
	P_ADD_1 	: Adder 			port map( rst, Compare_OUT4, Reg_Xinit, Reg_X, Reg_Yinit, Reg_Y, Add_XX, Add_YY ); 
	POUT_REG_KPK: Regis_16 		port map( rst, clk, enable, Add_YY, result_KPK ); 
	
	
	-- hasil FPB
	process ( switch_FPB, switch_KPK, result_FPB, result_KPK )
	begin
	if (switch_FPB = '1') then
		KPK_FPB_OUT <= result_FPB;
	elsif (switch_KPK = '1') then
		KPK_FPB_OUT <= result_KPK;
	end if;
	end process;
		
end Main_arc;
