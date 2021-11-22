library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;
 
entity Adder is
	port( reset		: IN std_logic; 
		  comparison: IN std_logic_vector( 1 downto 0 ); 
		  x_init, x, y_init, y	: IN std_logic_vector( 15 downto 0 ); 
		  XAddX, YAddY: OUT std_logic_vector( 15 downto 0 ) 
		);
end Adder;
 
architecture Adder_arc of Adder is 
begin 
	-- proses untuk menambahkan nilai yang lebih kecil dengan nilai awal
	process( reset, comparison, x, y ) 
	begin 
		
		if( reset = '1' or comparison = "00" ) then		-- kondisi reset 
			XAddX <= "0000000000000000"; 
			YAddY <= "0000000000000000"; 
		elsif( comparison = "10" ) then 				-- x > y
			XAddX <= x; 		
			YAddY <= ( y_init + y ); 				-- Y <= y + y_init
		elsif( comparison = "01" ) then 				-- y > x
			XAddX <= ( x_init + x );  				-- X <= x + x_init
			YAddY <= y; 							
		else								-- x = y
			XAddX <= x; 							
			YAddY <= y; 
		end if; 
		
	end process;
	 
end Adder_arc;