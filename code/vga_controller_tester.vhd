--! @file		vga_controller_tester.vhd
--! @brief		Tester for the VGA Controller
--! @author		Paul Schwarz, Sebastian Schmaus
--! @date		13.01.2023

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_controller_tester is
	port(
		Clk_vga	: out std_logic;						--! Clock for the pixel frequency of 25.175 MHz
		Reset		: out std_logic;						--! Asynchronous Reset
		HSync		: in std_logic;						--! Horizontal Synchronization Signal
		VSync		: in std_logic;						--! Vertical Synchronization Signal 
		x_out		: in integer range 0 to 1023;		--! x-coordinate of the visible area
		y_out		: in integer range 0 to 1023;		--! y-coordinate of the visible area
		blank		: in std_logic							--! Blank signal for differentiation between visible and not visible area. '0': not in visible area, '1': in visible area
	);
end entity vga_controller_tester;

architecture sim of vga_controller_tester is
	signal Clk_vga_int : std_logic := '0';
begin
	--! Generate the pixel frequency 25.175 MHz
	Clk_vga_int <= not Clk_vga_int after 19.86 ns;
	Clk_vga <= Clk_vga_int;
	
	Reset <= '1', '0' after 20 ns;
end architecture sim;