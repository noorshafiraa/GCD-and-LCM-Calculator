library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;
 
entity comparator is 
	port( rst	: in std_logic; 
		  x, y	: in std_logic_vector( 7 downto 0 ); 
		  output: out std_logic_vector( 1 downto 0 ) 
		); 
end comparator; 

architecture comparator_arc of comparator is 

begin 
	
	-- proses untuk menentukan mana yang lebih besar diantara x dan y
	process( x, y, rst ) 
	begin 
	
		if( rst = '1' ) then 
			output <= "00"; -- kondisi 0 
		elsif( x > y ) then 
			output <= "10"; -- x > y 
		elsif( x < y ) then 
			output <= "01"; -- y > x 
		else
			output <= "11"; -- x = y 
		end if; 
		
	end process; 
	
end comparator_arc;