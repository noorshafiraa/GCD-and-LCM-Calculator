library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 

entity Mux_16 is 
	port( reset, selector 	: IN std_logic; 
		  Load_IN, Sub_IN 	: IN std_logic_vector( 15 downto 0 );
	   	  OUTPUT 			: OUT std_logic_vector( 15 downto 0 ) 
		); 
end Mux_16;
 
architecture Mux_arc of Mux_16 is 
begin 	
	-- proses untuk menentukan mana yang akan diload menjadi register
	process( reset, selector, Load_IN, Sub_IN ) 
	begin 
	
		if( reset = '1' ) then 
			OUTPUT <= "0000000000000000"; 		-- kondisi 0
		elsif selector = '0' then 
			OUTPUT <= Load_IN; 		-- pilih x_input
		else 
			OUTPUT <= Sub_IN; 	-- pilih hasil operasi
		end if; 
		
	end process; 

end Mux_arc;