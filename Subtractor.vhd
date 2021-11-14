library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;
 
entity Subtractor is
	port( reset		: IN std_logic; 
		  comparison: IN std_logic_vector( 1 downto 0 ); 
		  x, y		: IN std_logic_vector( 7 downto 0 ); 
		  XSubY, YSubX: OUT std_logic_vector( 7 downto 0 ) 
		);
end Subtractor;
 
architecture Subtractor_arc of Subtractor is 
begin 
	-- proses untuk mengurangi nilai yang lebih besar dengan lebih kecil
	process( reset, comparison, x, y ) 
	begin 
		
		if( reset = '1' or comparison = "00" ) then 	-- kondisi reset 
			XSubY <= "00000000"; 
			YSubX <= "00000000"; 
		elsif( comparison = "10" ) then 			-- x > y
			XSubY <= ( x - y ); 					-- X <= x - y
			YSubX <= y; 
		elsif( comparison = "01" ) then 			-- y > x
			XSubY <= x;  							-- y <= y - x
			YSubX <= ( y - x ); 
		else										-- x = y
			XSubY <= x; 						
			YSubX <= y; 
		end if; 
		
	end process;
	 
end Subtractor_arc;