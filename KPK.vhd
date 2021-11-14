library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
use work.all;

entity KPK is
	port( reset, clk, i_enter			: IN std_logic; --in_enter apadah
			X_in, Y_in			: IN std_logic_vector( 7 downto 0 ); --8 bit 2 input
			KPK_OUT				: OUT std_logic_vector( 15 downto 0 ) 
		);
end KPK;

architecture KPK_arc of KPK is

--WAIT FOR FSM CODE!!!
---- komponen fsm untuk mengontrol alur
--component fsm is 
--	port( rst, clk, proses				: in std_logic; 
--		  compare						: in std_logic_vector( 1 downto 0 ); 
--		  enable, Sel_1, Sel_Y, Sel_Z, Load_1, Load_2, ChangeYZ : out STD_Logic
--		); 
--end component;

-- komponen Mux untuk memilih mengeluarkan input atau hasil sub nya ke register
component Mux is 
	port( reset, selector 	: IN std_logic; 
			Load_IN, Sub_IN 	: IN std_logic_vector( 7 downto 0 );
	   	OUTPUT 				: OUT std_logic_vector( 7 downto 0 ) 
		); 
end component;
 
--WAIT FOR COMPARATOR CODE!!!
---- komponen komparator untuk membandINgkan lebih besar x atau y
--component comparator is 
--	port( rst 		: IN std_logic; 
--		  x, y 		: IN std_logic_vector( 7 downto 0 ); 
--		  OUTPUT 	: OUT std_logic_vector( 1 downto 0 ) 
--		); 
--end component;

-- komponen Adder untuk menjumlah x dengan y atau y dengan x
component Adder is 
	port( reset			: IN std_logic; 
			comparison	: IN std_logic_vector( 1 downto 0 ); 
			x, y		: IN std_logic_vector( 7 downto 0 ); 
			XAddX, YAddY: OUT std_logic_vector( 7 downto 0 ) 
		); 
end component;
 
-- komponen Register untuk menyimpan x atau y sebelumnya
component Register is 
	port( reset, clk, LOAD: IN std_logic; 
			INPUT				 : IN std_logic_vector( 7 downto 0 ); 
			OUTPUT		  	 : OUT std_logic_vector( 7 downto 0 ) 
		); 
end component; 

-- WAIT FOR FSM
---- signal yang digunakan sementara
--signal Load_1, Load_2, Select_1, Select_Y, Select_Z, enable, ChangeYZ	: std_logic; 
--signal Compare_OUT									: std_logic_vector( 1 downto 0 ); 
--signal result										: std_logic_vector( 7 downto 0 );
--signal Sub_12, Sub_21, Mux_1, Mux_2, Mux_Y, Mux_Z, Reg_1, Reg_2	: std_logic_vector( 7 downto 0 ); 
--
--begin
--	
--	-- FSM controller 
--	TOFSM	: fsm 			port map( rst, clk, i_enter, Compare_OUT, enable, Select_1, Select_Y, Select_Z, Load_1, Load_2, ChangeYZ ); 
--	
--	-- Datapath 
--	PMux_1	: mux 			port map( rst, Select_1, X_IN, Sub_12, Mux_1 ); 
--	PMux_Y	: mux 			port map( rst, Select_Y, Y_IN, Sub_21, Mux_Y ); 
--	PMux_Z	: mux 			port map( rst, Select_Z, Z_IN, Sub_21, Mux_Z ); 
--	PMux_2	: mux 			port map( rst, ChangeYZ, Mux_Y, Mux_Z, Mux_2 ); 
--	PReg_1	: regis 		port map( rst, clk, Load_1, Mux_1, Reg_1 ); 
--	PReg_2	: regis 		port map( rst, clk, Load_2, Mux_2, Reg_2 );
--	P_COMP	: comparator 	port map( rst, Reg_1, Reg_2, Compare_OUT ); 
--	P_SUB	: subtractor 	port map( rst, Compare_OUT, Reg_1, Reg_2, Sub_12, Sub_21 );
--	POUT_REG: regis 		port map( rst, clk, enable, Sub_12, result ); 
	
	-- hasil KPK
	KPK_OUT <= result;
	 
end KPK_arc;
