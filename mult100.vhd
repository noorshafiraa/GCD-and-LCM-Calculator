-- Quartus Prime VHDL Template
-- Unsigned Multiply

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult100 is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		dig_ratusan	   : in unsigned (7 downto 0);
		result  : out unsigned (7 downto 0)
	);

end entity;

architecture rtl of mult100 is
signal full_product	: unsigned (15 downto 0);
begin

	full_product <= dig_ratusan * "01100100";
	result <= full_product (7 downto 0);

end rtl;
