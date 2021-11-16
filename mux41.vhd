library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
 
entity mux41 is
 port(
     B_in,C_in,D_in,DNCR 	: IN std_logic_vector( 7 downto 0 );
     S0,S1			: in STD_LOGIC;
     OUTPUT			: OUT std_logic_vector( 7 downto 0 )
  );	
end mux41;
 
architecture bhv of mux41 is
begin

	-- proses untuk menentukan mana yang akan diload menjadi register
	process (B_in,C_in,D_in,DNCR,S0,S1) is
	begin
	  if (S0 ='0' and S1 = '0') then
			OUTPUT <= B_in;
	  elsif (S0 ='1' and S1 = '0') then
			OUTPUT <= C_in;
	  elsif (S0 ='0' and S1 = '1') then
			OUTPUT <= D_in;
	  else
			OUTPUT <= DNCR;
	  end if;
	 
	end process;
end bhv;
