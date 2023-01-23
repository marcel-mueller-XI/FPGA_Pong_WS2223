--! @file		vga_sign_gen_tester.vhd
--! @brief		VGA Signal Generator Tester
--! @author		Paul Schwarz, Sebastian Schmaus
--! @date		13.01.2023

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_sign_gen_tester is
	port(
		VGA_X			: in integer range 0 to 1023;				--! x-coordinate of the visible area
		VGA_Y			: in integer range 0 to 1023;				--! y-coordinate of the visible area
		VGA_R			: in std_logic_vector(3 downto 0);		--! Red color value, 4 bit
		VGA_G			: in std_logic_vector(3 downto 0);		--! Green color value, 4 bit
		VGA_B			: in std_logic_vector(3 downto 0);		--! Blue color value, 4 bit
		VGA_HS		: in std_logic;								--! Horizontal Synchronisation Signal
		VGA_VS		: in std_logic;								--! Vertical Synchronisation Signal
		Clk_vga		: out std_logic;								--! Clock for the pixel frequency of 25.175 MHz
		Reset			: out std_logic;								--! Asynchronous Reset
		D_ball		: out std_logic;								--! Pixel information from the ball-module, '1': white, '0': black
		D_paddle1	: out std_logic;								--! Pixel information from the paddle1-module, '1': white, '0': black
		D_paddle2	: out std_logic;								--! Pixel information from the paddle2-module, '1': white, '0': black
		D_field		: out std_logic;								--! Pixel information from the field-module, '1': white, '0': black
		D_score		: out std_logic								--! Pixel information from the score-module, '1': white, '0': black
	);
end entity vga_sign_gen_tester;

architecture sim of vga_sign_gen_tester is
	signal Clk_int : std_logic := '0';
begin
	--! Generate the pixel frequency 25.175 MHz
	Clk_int <= not Clk_int after 19.86 ns;
	Clk_vga <= Clk_int;
	
	Reset <= '1', '0' after 30 ns;
	
	--! Generate pixel information for test purposes
	D_field <= '1' when VGA_X >= 1 and VGA_X <= 320 and VGA_Y >= 1 and VGA_Y <= 240 else
				  '0';
				  
	D_ball		<= '0';
	D_paddle1	<= '0';
	D_paddle2	<= '0';
	D_score		<= '0';
end architecture sim;