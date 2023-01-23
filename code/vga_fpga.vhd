--! @file		vga_fpga.vhd
--! @brief		VGA Signal Generator Top-Level Instantiation
--! @detail		Pin K22 (nCEO) mapped to VGA_B[0] must be used for I/O-Assignments to avoid errors -> Assignments -> Device -> Device and Pin Options -> Dual Purpose Pins
--! @author		Paul Schwarz, Sebastian Schmaus
--! @date		13.01.2023

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PongPack.all;

entity vga_fpga is
	port(
		VGA_R		: out std_logic_vector(3 downto 0);		--! Red color value, 4 bit
		VGA_G		: out std_logic_vector(3 downto 0);		--! Green color value, 4 bit
		VGA_B		: out std_logic_vector(3 downto 0);		--! Blue color value, 4 bit
		VGA_HS	: out std_logic;								--! Horizontal Synchronisation Signal
		VGA_VS	: out std_logic;								--! Vertical Synchronisation Signal
		Clk_50	: in std_logic;								--! Clock from the DE0-Board, 50 MHz
		Reset		: in std_logic;									--! Asynchronous Reset
		
		A1_inc : in std_logic;
		B1_inc : in std_logic;
		A2_inc : in std_logic;
		B2_inc : in std_logic;
		
		Sound_out : out std_logic;
		
		Hex_s1_out : out std_logic_vector(3 downto 0);
		Hex_s2_out : out std_logic_vector(3 downto 0);
		
		Button_start_out : in std_logic;
		Button_resetMatch_out : in std_logic;
		
		--Debugg
      TestSignal : out std_logic_vector(7 downto 0)
	);
end entity vga_fpga;

architecture behave of vga_fpga is
	signal Clk_vga_int	: std_logic;
	signal VGA_X_int		: xType;
	signal VGA_Y_int		: yType;
	signal D_ball_int		: std_logic;
	signal D_paddle1_int	: std_logic;
	signal D_paddle2_int	: std_logic;
	signal D_field_int	: std_logic;
	signal D_score_int	: std_logic;
	
	-- field konstanten
	signal top_left_x_int : xType;
	signal top_left_y_int : yType;
	signal bottom_right_x_int : xType;
	signal bottom_right_y_int : yType;
	
	-- paddles 
	signal p1B_x_int : xType;
	signal p1B_y_int : yType;
	signal p1A_y_int : yType;
	signal p1A_x_int : yType;
	signal p2B_x_int : xType;
	signal p2B_y_int : xType;
	signal p2A_y_int : yType;
	signal p2A_x_int : xType;
	
	-- ball
	signal start_ball_int 		: std_logic;
	signal paddle_bounce_int 	: std_logic;
	signal field_bounce_int 	: std_logic;
	signal out_left_int 			: std_logic;
	signal out_right_int 		: std_logic;
	signal ball_outOfField_int	: std_logic;
	
	-- score
	signal score_max_int : std_logic;
	signal reset_score_int : std_logic;
begin
--Debugg
    TestSignal <= start_ball_int & ball_outOfField_int & reset_score_int & '0' & '0' & A1_inc & '1' & '1' ;
	--! Instantiation of the VGA Signal Generator
	sign_gen : entity work.vga_sign_gen(behave)
		port map(
			VGA_X			=> VGA_X_int,				-- hier später in der Theoerie auf dem Top-Level internes Signal das zu den anderen Modulen geht
			VGA_Y			=> VGA_Y_int,
			VGA_R			=> VGA_R,
			VGA_G			=> VGA_G,
			VGA_B			=> VGA_B,
			VGA_HS		=> VGA_HS,
			VGA_VS		=> VGA_VS,
			Clk_vga		=> Clk_vga_int,
			Reset			=> Reset,
			D_ball		=> D_ball_int,
			D_paddle1	=> D_paddle1_int,
			D_paddle2	=> D_paddle2_int,
			D_field		=> D_field_int,
			D_score		=> D_score_int
		);
	
	--! Instantiation of the pll megafunction created with the MegaWizard Plug-In Manager
	mypll : entity work.pll
		port map(
			areset	=> Reset,
			inclk0	=> Clk_50,
			c0			=>	Clk_vga_int,
			locked	=> open
		);
	
	-- links
	paddle1 : entity work.paddle
		generic map(
			xpos => 20,
			PADDLE_SPEED => 11
		)
		port map( 
				--inputs
			clk 	=> Clk_vga_int,
			reset => Reset,
			a	=> A1_inc,
			b	=> B1_inc,

			p_a_x => p1a_x_int,
			p_b_x => p1b_x_int,
			p_a_y => p1a_y_int,
			p_b_y => p1b_y_int,
			
			color_p => D_paddle1_int,
			x => VGA_X_int,
			y => VGA_Y_int
		);
	
	-- rechts
	paddle2 : entity work.paddle
		generic map(
			xpos => 600,
			PADDLE_SPEED => 11
		)		
		port map( 
				--inputs
			clk 	=> Clk_vga_int,
			reset => Reset,
			a	=> A2_inc,
			b	=> B2_inc,

			p_a_x => p2a_x_int,
			p_b_x => p2b_x_int,
			p_a_y => p2a_y_int,
			p_b_y => p2b_y_int,
			
			color_p => D_paddle2_int,
			x => VGA_X_int,
			y => VGA_Y_int
		);
		
		-- 1: links a: oben links b: unten rechts
		ball : entity work.ball
		port map( 
				clk 				=> Clk_vga_int,
				x_Value			=> VGA_X_int,
				Y_Value			=> VGA_Y_int,
				pixle_Colour	=> D_ball_int,
				p1B_x => p1B_x_int,
				p1A_y => p1A_y_int,								
				p1B_y	=> p1B_y_int,
				
				p2A_x => p2a_x_int,
				p2A_y => p2a_y_int,										
				p2B_y	=> p2b_y_int,
				
				top_left_x   => top_left_x_int,     
				top_left_y   => top_left_y_int,     
				bottom_right_x    => bottom_right_x_int,
				bottom_right_y   => bottom_right_y_int,		
			
				start_ball			=> start_ball_int,
				paddle_bounce		=> paddle_bounce_int,
				field_bounce		=> field_bounce_int,
				ball_outOfField	=> ball_outOfField_int,
				out_left				=> out_left_int,
				out_right			=> out_right_int
		
		);
		
	field : entity work.Pong_Field
		port map(  
		x_value				=> VGA_X_int,
		y_value				=> VGA_Y_int,
		
		color_field			=> D_field_int,
		top_left_x        => top_left_x_int,
		top_left_y        => top_left_y_int,
		top_right_x       => open,
		top_right_y       => open,
		bottom_left_x     => open,
		bottom_left_y     => open,
		bottom_right_x    => bottom_right_x_int,
		bottom_right_y    => bottom_right_y_int
		
		);
	
	sound : entity work.Pong_Sound
		port map(  
			Clk					=> clk_vga_int,
			Reset          	=> Reset,
			Start					=> Start_ball_int,
			paddle_bounce		=> paddle_bounce_int,
			field_bounce		=> field_bounce_int,
			ball_outOfField	=> ball_outOfField_int,
			Score_max			=> score_max_int,
			
			Sound					=> Sound_out
		);
		
	Score : entity work.Pong_Score
		port map ( 
			Clk					=> clk_vga_int,
			Reset          	=> Reset,
			reset_score      	=> reset_score_int,
			ball_outOfField	=> ball_outOfField_int,
			out_left				=> out_left_int,
			out_right			=> out_right_int,
			x_in					=> VGA_X_int,
			y_in					=> VGA_Y_int,
			
			Score_max			=> Score_max_int,
			color_field			=> D_score_int,
			HEX_s1				=> Hex_s1_out,
			HEX_s2				=> HEx_s2_out			
		);
		
	Control : entity work.Control
		port map ( 
			clk		=> clk_vga_int,
			reset		=> reset,

			-- INPUTS
			button_start 		=> button_start_out,
			button_resetMatch => button_resetMatch_out,
			ball_outOfField 	=> ball_outOfField_int,
			score_max			=> score_max_int,
			-- OUTPUTS
			reset_score 		=> reset_score_int,
			start_ball 			=> start_ball_int
		);
	
end architecture behave;