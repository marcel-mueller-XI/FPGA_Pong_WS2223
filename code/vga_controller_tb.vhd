--! @file		vga_controller_tb.vhd
--! @brief		Testbench for the VGA Controller
--! @author		Paul Schwarz, Sebastian Schmaus
--! @date		13.01.2023

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_controller_tb is
end entity vga_controller_tb;

architecture sim of vga_controller_tb is
	signal Clk_vga_int, Reset_int, HSync_int, VSync_int, blank_int	: std_logic;
	signal x_out_int, y_out_int												: integer range 0 to 1023;
begin
	--! Instantiation of the VGA Controller
	dut : entity work.vga_controller(behave)
		port map(
			Clk_vga	=> Clk_vga_int,
			Reset		=> Reset_int,
			HSync		=> HSync_int,
			VSync		=> VSync_int,
			x_out		=> x_out_int,
			y_out		=> y_out_int,
			blank		=> blank_int
		);
	
	--! Instantiation of the VGA Controller Tester
	tester : entity work.vga_controller_tester(sim)
		port map(
			Clk_vga	=> Clk_vga_int,
			Reset		=> Reset_int,
			HSync		=> HSync_int,
			VSync		=> VSync_int,
			x_out		=> x_out_int,
			y_out		=> y_out_int,
			blank		=> blank_int
		);
end architecture sim;