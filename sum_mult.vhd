library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;

entity sum_mult is
	port( satuan, puluhan, ratusan	: IN std_logic_vector( 7 downto 0 ); 
		  sum : OUT std_logic_vector( 7 downto 0 ) 
		);
end sum_mult;

architecture rtl of sum_mult is
begin

	sum <= satuan + puluhan + ratusan;

end rtl; 