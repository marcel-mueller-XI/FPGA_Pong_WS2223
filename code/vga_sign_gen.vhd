--! @file		vga_sign_gen.vhd
--! @brief		VGA Signal Generator
--! @details	Generates the three color signals R (red), G (green), B (blue) for the VGA signal depending on the input parameters from other modules.
--!				For each color the DE0-Board uses a resistor ladder DAC (4 bits = 16 color-levels) and in total 12 bits (4096 color-levels). 
--! @author		Paul Schwarz, Sebastian Schmaus
--! @date		13.01.2023

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PongPack.all;

entity vga_sign_gen is
	port(
		VGA_X			: out xType;									--! x-coordinate of the visible area, starts at 1 and ends at 640
		VGA_Y			: out yType;									--! y-coordinate of the visible area, starts at 1 and ends at 480
		VGA_R			: out std_logic_vector(3 downto 0);		--! Red color value, 4 bit
		VGA_G			: out std_logic_vector(3 downto 0);		--! Green color value, 4 bit
		VGA_B			: out std_logic_vector(3 downto 0);		--! Blue color value, 4 bit
		VGA_HS		: out std_logic;								--! Horizontal Synchronisation Signal
		VGA_VS		: out std_logic;								--! Vertical Synchronisation Signal
		Clk_vga		: in std_logic;								--! Clock for the pixel frequency of 25.175 MHz
		Reset			: in std_logic;								--! Asynchronous Reset
		D_ball		: in std_logic;								--! Pixel information from the ball-module, '1': white, '0': black
		D_paddle1	: in std_logic;								--! Pixel information from the paddle1-module, '1': white, '0': black
		D_paddle2	: in std_logic;								--! Pixel information from the paddle2-module, '1': white, '0': black
		D_field		: in std_logic;								--! Pixel information from the field-module, '1': white, '0': black
		D_score		: in std_logic									--! Pixel information from the score-module, '1': white, '0': black
	);
end entity vga_sign_gen;

architecture behave of vga_sign_gen is
	signal blank_sign_gen : std_logic;							--! internal Blank signal for generating the RGB-values when in visible area
	signal VGA_X_int	: xType;										--! internal signal for the x-coordinate
	signal VGA_Y_int	: yType;										--! internal signal for the y-coordinate
	signal VGA_R_int	: std_logic_vector(3 downto 0);		--! internal signal for the red color value
	signal VGA_G_int	: std_logic_vector(3 downto 0);		--! internal signal for the green color value
	signal VGA_B_int	: std_logic_vector(3 downto 0);		--! internal signal for the blue color value
begin
	
	--! Instantiation of the VGA Controller
	vga_timing : entity work.vga_controller(behave)
		port map(
			Clk_vga		=> Clk_vga,
			Reset			=> Reset,
			HSync			=> VGA_HS,
			VSync			=> VGA_VS,
			x_out			=> VGA_X_int,
			y_out			=> VGA_Y_int,
			blank			=> blank_sign_gen
		);
	
	--! Process for multiplexing the input signal (white or black) from modules of the pong game logic when the coordinate is in the visible area (640 x 480)
	multiplexer : process(Clk_vga, blank_sign_gen)
	begin
		--! Generate a white pixel when there is information from a module to be displayed and the coordinate is in the visible area (640 x 480)
		if rising_edge(Clk_vga) then
			if (D_ball = '1' or D_paddle1 = '1' or D_paddle2 = '1' or D_field = '1' or D_score = '1') and blank_sign_gen = '1' then
				VGA_R_int <= x"F";
				VGA_G_int <= x"F";
				VGA_B_int <= x"F";
			--! Generate a black pixel when there is no information from a module to be displayed or the coordinate is not in the visible area
			else
				VGA_R_int <= x"0";
				VGA_G_int <= x"0";
				VGA_B_int <= x"0";
			end if;
		end if;
	end process multiplexer;
	
	VGA_X <= VGA_X_int;
	VGA_Y <= VGA_Y_int;
	
	--! Process for synchronizing the VGA RGB Output signals, since there are combinational time delays for receiving the display information after the coordinates have been sent
	--! Compensation for delays synchronizing the signals with a sigle DFF, more DFF's can be added
	sync_proc : process(Clk_vga)
	begin
		if rising_edge(Clk_vga) then
			VGA_R <= VGA_R_int;
			VGA_G <= VGA_G_int;
			VGA_B <= VGA_B_int;
		end if;
	end process sync_proc;
	
end architecture behave;