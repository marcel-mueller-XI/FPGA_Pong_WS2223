--! @file		vga_gen.vhd
--! @brief		Instantiation of the pll megafunction created with the MegaWizard Plug-In Manager for test purposes on the hardware DE0-Board
--! @author		Paul Schwarz, Sebastian Schmaus
--! @date		13.01.2023

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_gen is
	port(
		signal Clk_50		: in std_logic;
		signal Areset		: in std_logic;
		signal Clk_out		: out std_logic;
		signal locked_out : out std_logic
	);
end entity vga_gen;

architecture behave of vga_gen is

begin
	pixel_pll : entity work.pll
		port map(
			areset	=> Areset,			--! reset, asynchron
			inclk0	=> Clk_50,			--! input clock 50MHz
			c0			=>	Clk_out,			--! output clock 25.175 MHz
			locked	=> locked_out 		--! enable signal, when final frequence is ready
		);
end architecture behave;