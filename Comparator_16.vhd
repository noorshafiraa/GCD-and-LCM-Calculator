library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;
 
entity comparator_16 is 
	port( rst	: in std_logic; 
		  x, y	: in std_logic_vector( 15 downto 0 ); 
		  output: out std_logic_vector( 1 downto 0 ) 
		); 
end comparator_16; 

architecture comparator_arc of comparator_16 is 

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
		elsif ( x = y ) then
			output <= "11"; -- x = y 
		else
			output <= "00";
		end if; 
		
	end process; 
	
end comparator_arc;