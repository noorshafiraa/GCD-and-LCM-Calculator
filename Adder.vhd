library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;
 
entity Adder is
	port( reset		: IN std_logic; 
		  comparison: IN std_logic_vector( 1 downto 0 ); 
		  x, y		: IN std_logic_vector( 7 downto 0 ); 
		  XAddX, YAddY: OUT std_logic_vector( 7 downto 0 ) 
		);
end Adder;
 
architecture Adder_arc of Adder is 
begin 
	-- proses untuk menambahkan nilai yang lebih kecil
	process( reset, comparison, x, y ) 
	begin 
		
		if( reset = '1' or comparison = "00" ) then 	-- kondisi reset 
			XAddX <= "00000000"; 
			YAddY <= "00000000"; 
		elsif( comparison = "10" ) then 			-- x > y
			XAddX <= x; 		
			YAddY <= ( y + y ); 						-- Y <= y + y
		elsif( comparison = "01" ) then 			-- y > x
			XAddX <= ( x + x );  					-- X <= x + x
			YAddY <= y; 							
		else												-- x = y
			XAddX <= x; 							
			YAddY <= y; 
		end if; 
		
	end process;
	 
end Adder_arc;