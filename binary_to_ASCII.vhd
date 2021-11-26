library ieee;
use ieee.std_logic_1164.all;

entity 	binary_to_ASCII is 
	port(
		binary_in	: in std_logic_vector(7 downto 0);
		ASCII_out	: out std_logic_vector(7 downto 0)
		);
end entity;

architecture convert_arc of binary_to_ASCII is
begin

process(binary_in)
begin
	if binary_in = "00000000" then --0
		ASCII_out <= "00110000"; 
	elsif binary_in = "00000001" then --1
		ASCII_out <= "00110001";
	elsif binary_in = "00000010" then --2
		ASCII_out <= "00110010";
	elsif binary_in = "00000011" then --3
		ASCII_out <= "00110011";
	elsif binary_in = "00000100" then --4
		ASCII_out <= "00110100";
	elsif binary_in = "00000101" then --5
		ASCII_out <= "00110101";
	elsif binary_in = "00000110" then --6
		ASCII_out <= "00110110";
	elsif binary_in = "00000111" then --7
		ASCII_out <= "00110111";
	elsif binary_in = "00001000" then --8
		ASCII_out <= "00111000";
	elsif binary_in = "00001001" then --9
		ASCII_out <= "00111001";
	end if;

end process;
end convert_arc ;