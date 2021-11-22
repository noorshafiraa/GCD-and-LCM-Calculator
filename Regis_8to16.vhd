library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 

entity Regis_8to16 is
	port( reset, clk, LOAD: IN std_logic; 
		  INPUT			: IN std_logic_vector( 7 downto 0 ); 
		  OUTPUT		: OUT std_logic_vector( 15 downto 0 ) 
		); 
end Regis_8to16;
 
architecture Register_arc of Regis_8to16 is 
begin 
	-- proses untuk mengubah nilai register
	process( reset, clk, LOAD, INPUT ) 
	begin
	 		
		if( reset = '1' ) then                   -- kondisi reset, Regis kosong
			OUTPUT <= "0000000000000000"; 
		elsif( clk'event and clk = '1') then   -- Cek Regis tiap Rising Clock
			if( LOAD = '1' ) then 					-- kondisi load, simpan input menjadi output
				OUTPUT <= "0000000000000000";
				OUTPUT (7 downto 0) <=  INPUT;
			end if; 
		end if; 
	
	end process; 

end Register_arc;