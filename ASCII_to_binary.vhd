library ieee;
use ieee.std_logic_1164.all;

entity 	ASCII_to_binary is 
	port(
		ASCII_in	: in std_logic_vector(7 downto 0);
		binary_out	: out std_logic_vector(7 downto 0)
		);
end entity;

architecture convert_arc of ASCII_to_binary is
begin

process(ASCII_in)
begin
	if ASCII_in = "00110000" then --0
		binary_out <= "00000000"; 
	elsif ASCII_in = "00110001" then --1
		binary_out <= "00000001";
	elsif ASCII_in = "00110010" then --2
		binary_out <= "00000010";
	elsif ASCII_in = "00110011" then --3
		binary_out <= "00000011";
	elsif ASCII_in = "00110100" then --4
		binary_out <= "00000100";
	elsif ASCII_in = "00110101" then --5
		binary_out <= "00000101";
	elsif ASCII_in = "00110110" then --6
		binary_out <= "00000110";
	elsif ASCII_in = "00110111" then --7
		binary_out <= "00000111";
	elsif ASCII_in = "00111000" then --8
		binary_out <= "00001000";
	elsif ASCII_in = "00111001" then --9
		binary_out <= "00001001";
	end if;

end process;
end convert_arc ;