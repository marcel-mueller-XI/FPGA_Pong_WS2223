--! @file		vga_gen_tester.vhd
--! @brief		Tester for the pll megafunction
--! @author		Paul Schwarz, Sebastian Schmaus
--! @date		13.01.2023

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_gen_tester is
	port(
		signal Clk_50	: out std_logic;
		signal Areset	: out std_logic;
		signal Clk_out	: in std_logic
	);
end entity vga_gen_tester;

architecture sim of vga_gen_tester is
	signal Clk_int	: std_logic := '0';
begin
	--! Generate the 50 MHz frequency from the board
	Clk_int	<= not Clk_int after 10 ns;
	Clk_50	<= Clk_int;
	
	Areset	<= '0';
end architecture sim;