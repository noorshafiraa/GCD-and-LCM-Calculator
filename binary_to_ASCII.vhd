library ieee;
use ieee.std_logic_1164.all;

entity 	ASCII_to_binary is 
	port(
		binary_in	: in std_logic_vector(3 downto 0);
		ASCII_out	: out std_logic_vector(7 downto 0)
		);
end entity;

architecture convert_arc of ASCII_to_binary is
begin

process(binary_in)
begin
	if binary_in = "0000" then --0
		ASCII_out <= "00110000"; 
	elsif binary_in = "0001" then --1
		ASCII_out <= "00110001";
	elsif binary_in = "0010" then --2
		ASCII_out <= "00110010";
	elsif binary_in = "0011" then --3
		ASCII_out <= "00110011";
	elsif binary_in = "0100" then --4
		ASCII_out <= "00110100";
	elsif binary_in = "0101" then --5
		ASCII_out <= "00110101";
	elsif binary_in = "0110" then --6
		ASCII_out <= "00110110";
	elsif binary_in = "0111" then --7
		ASCII_out <= "00110111";
	elsif binary_in = "1000" then --8
		ASCII_out <= "00111000";
	elsif binary_in = "1001" then --9
		ASCII_out <= "00111001";
	end if;

end process;
end convert_arc ;