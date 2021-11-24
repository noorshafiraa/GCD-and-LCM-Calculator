library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sums_of_mult is

	port 
	(
		dig_ratusan	   : in unsigned (7 downto 0);
		dig_puluhan	   : in unsigned (7 downto 0);
		dig_satuan	   : in unsigned (7 downto 0);
		result  : out unsigned (7 downto 0)
	);

end entity;

architecture rtl of sums_of_mult is
signal full_product_rat	: unsigned (15 downto 0);
signal full_product_pul	: unsigned (15 downto 0);
signal result_rat	: unsigned (7 downto 0);
signal result_pul	: unsigned (7 downto 0);
begin

	full_product_rat <= dig_ratusan * "01100100"; -- dig_puluhan * 100
	result_rat <= full_product_rat (7 downto 0);
	
	full_product_pul <= dig_puluhan * "00001010"; -- dig_puluhan * 10
	result_pul <= full_product_pul (7 downto 0);
	
	result <= result_rat + result_pul + dig_satuan;
	
end rtl;


