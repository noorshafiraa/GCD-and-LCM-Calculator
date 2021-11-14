library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 

entity Register is
	port( reset, clk, LOAD: IN std_logic; 
		  INPUT			: IN std_logic_vector( 7 downto 0 ); 
		  OUTPUT		: OUT std_logic_vector( 7 downto 0 ) 
		); 
end Register;
 
architecture Register_arc of Register is 
begin 
	-- proses untuk mengubah nilai register
	process( reset, clk, LOAD, INPUT ) 
	begin
	 		
		if( reset = '1' ) then                   -- kondisi reset, Regis kosong
			OUTPUT <= "00000000"; 
		elsif( clk'event and clk = '1') then   -- Cek Regis tiap Rising Clock
			if( LOAD = '1' ) then 					-- kondisi load, simpan input menjadi output
				OUTPUT <= INPUT; 
			end if; 
		end if; 
	
	end process; 

end Register_arc;