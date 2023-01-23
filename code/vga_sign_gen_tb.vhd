--! @file		vga_sign_gen.vhd
--! @brief		VGA Signal Generator Testbench
--! @author		Paul Schwarz, Sebastian Schmaus
--! @date		13.01.2023

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_sign_gen_tb is
end entity vga_sign_gen_tb;

architecture sim of vga_sign_gen_tb is
	signal VGA_HS_int, VGA_VS_int, Clk_vga_int, Reset_int, D_ball_int, D_paddle1_int, D_paddle2_int, D_field_int, D_score_int : std_logic;
	signal VGA_R_int, VGA_G_int, VGA_B_int	: std_logic_vector(3 downto 0);
	signal VGA_X_int, VGA_Y_int				: integer range 0 to 1023;
begin
	--! Instantiation of the VGA Signal Generator
	dut : entity work.vga_sign_gen(behave)
		port map(
			VGA_X			=> VGA_X_int,
			VGA_Y			=> VGA_Y_int,
			VGA_R			=> VGA_R_int,
			VGA_G			=> VGA_G_int,
			VGA_B			=> VGA_B_int,
			VGA_HS		=> VGA_HS_int,
			VGA_VS		=> VGA_VS_int,
			Clk_vga		=> Clk_vga_int,
			Reset			=> Reset_int,
			D_ball		=> D_ball_int,
			D_paddle1	=> D_paddle1_int,
			D_paddle2	=> D_paddle2_int,
			D_field		=> D_field_int,
			D_score		=> D_score_int
		);
	
	--! Instantiation of the VGA Signal Generator Tester
	tester : entity work.vga_sign_gen_tester(sim)
		port map(
			VGA_X			=> VGA_X_int,
			VGA_Y			=> VGA_Y_int,
			VGA_R			=> VGA_R_int,
			VGA_G			=> VGA_G_int,
			VGA_B			=> VGA_B_int,
			VGA_HS		=> VGA_HS_int,
			VGA_VS		=> VGA_VS_int,
			Clk_vga		=> Clk_vga_int,
			Reset			=> Reset_int,
			D_ball		=> D_ball_int,
			D_paddle1	=> D_paddle1_int,
			D_paddle2	=> D_paddle2_int,
			D_field		=> D_field_int,
			D_score		=> D_score_int
		);
end architecture sim;