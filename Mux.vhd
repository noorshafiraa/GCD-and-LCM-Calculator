library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 

entity Mux is 
	port( reset, selector 	: IN std_logic; 
		  Load_IN, Sub_IN 	: IN std_logic_vector( 7 downto 0 );
	   	  OUTPUT 			: OUT std_logic_vector( 7 downto 0 ) 
		); 
end Mux;
 
architecture Mux_arc of Mux is 
begin 	
	-- proses untuk menentukan mana yang akan diload menjadi register
	process( reset, selector, Load_IN, Sub_IN ) 
	begin 
	
		if( reset = '1' ) then 
			OUTPUT <= "00000000"; 		-- kondisi 0
		elsif selector = '0' then 
			OUTPUT <= Load_IN; 		-- pilih x_input
		else 
			OUTPUT <= Sub_IN; 	-- pilih hasil operasi
		end if; 
		
	end process; 

end Mux_arc;