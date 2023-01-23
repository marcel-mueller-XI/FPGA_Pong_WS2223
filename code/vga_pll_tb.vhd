--! @file		vga_gen_tb.vhd
--! @brief		Testbench for the pll megafunction
--! @author		Paul Schwarz, Sebastian Schmaus
--! @date		13.01.2023

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_gen_tb is
end entity vga_gen_tb;

architecture sim of vga_gen_tb is
	signal Clk_50_tb, Areset_tb, Clk_out_tb : std_logic;
begin
	dut : entity work.vga_gen(behave)
		port map(
			Clk_50	=> Clk_50_tb,
			Areset	=> Areset_tb,
			Clk_out	=> Clk_out_tb
		);
	
	tester : entity work.vga_gen_tester(sim)
		port map(
			Clk_50	=> Clk_50_tb,
			Areset	=> Areset_tb,
			Clk_out	=> Clk_out_tb
		);
end architecture sim;