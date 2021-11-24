-- Quartus Prime VHDL Template
-- Unsigned Multiply

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult10 is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		dig_puluhan	   : in unsigned (7 downto 0);
		result  : out unsigned (7 downto 0)
	);

end entity;

architecture rtl of mult10 is
signal full_product	: unsigned (15 downto 0);
begin

	full_product <= dig_puluhan * "00001010"; -- dig_puluhan * 10
	result <= full_product (7 downto 0);

end rtl;