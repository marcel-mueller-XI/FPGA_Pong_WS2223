------------------------------------------------------
-- Aufgabe: 	Pong										 	 --
-- Datei:	   Pong_Score.vhd					 			 --
-- Autor:   	Jonas Sachwitz & Marco Stütz      	 --
-- Datum:   	10.01.2023                        	 --
------------------------------------------------------

-- ToDo * * * * * * * * * * * * * * * * * * * * * * * *

--

-- ToDo * * * * * * * * * * * * * * * * * * * * * * * *

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;   -- unsigned / signed
library work;
use work.PongPack.all;  -- own project package

--! @brief Pong_Score
--! 
--! Score-Module for the pong game. 
--! Counts the Score per team and outputs pixel-data for the VGA-interface
--! 
--! Generic: 		"Max" sets the maximal reachable Score
--! In-/Output:  	"Score_max" is '1' until a "Reset" or a "reset_score" is set to '1'
--!          		(rising edge of the signal is enough)
--! Output:  		"HEX_s1/s2" can be used directly for the HEX7SEG-Module in the Top-Level
--! Output:  		"color_field" = '1' for white and = '0' for black

ENTITY Pong_Score IS
	GENERIC (
		Max					:	integer	:= 5									--! generic for the maximum score [standard = 5]
	);
	PORT(
		Clk					: 	IN		std_logic; 								--! clock signal: 25,175 MHz
		Reset          	:  IN 	std_logic; 								--! asynchronous reset
		reset_score      	:  IN 	std_logic; 								--! reset from control
		ball_outOfField	:	IN		std_logic; 								--! true if the ball hits the goal
		out_left				:	IN		std_logic; 								--! true if the ball hits left goal
		out_right			:	IN		std_logic; 								--! true if the ball hits right goal
		x_in					:	IN		xType; 									--! x-coordinates of output [10bit]
		y_in					:	IN		yType; 									--! y-coordinates of output [10bit]
		
		Score_max			:	OUT	std_logic;								--! output for the sound signal
		color_field			:	OUT	std_logic;								--! output for VGA, '1' for white, '0' for black
		HEX_s1				: 	OUT   std_logic_vector (3 DOWNTO 0);	--! output score side 1 for HEX7SEG
		HEX_s2				: 	OUT   std_logic_vector (3 DOWNTO 0)		--! output score side 2 for HEX7SEG
  );
END Pong_Score;

ARCHITECTURE behave OF Pong_Score IS

	signal	s1						:	integer range 0 to 15 := 0;		--! Score for side 1
	signal	s2						:	integer range 0 to 15 := 0;		--! Score for side 2
	signal 	x_gridposition		:	std_logic_vector (4 DOWNTO 0);	--! Position of Input X in the grid
	signal 	x_column				:	std_logic_vector (2 DOWNTO 0);	--! Position of Input X in the column
	signal 	y_gridposition		:	std_logic_vector (4 DOWNTO 0);	--! Position of Input Y in the grid
	signal 	y_row					:	std_logic_vector (2 DOWNTO 0);	--! Position of Input Y in the column
	signal 	VGA_inPos1			:	std_logic;
	signal 	VGA_inPos2			:	std_logic;
	signal 	x_in_vector			:	std_logic_vector (9 DOWNTO 0);
	signal 	y_in_vector			:	std_logic_vector (9 DOWNTO 0);
	
	TYPE 		row 		IS ARRAY(0 TO 7) OF std_logic_vector (7 downto 0);
	TYPE 		Bitmap 	IS ARRAY(0 TO 9) OF row;
	constant bitmap_score 	: 	Bitmap := 
	 ((X"3E", x"63", X"73", X"7B", X"6F", X"67", X"3E", X"00" ), 	-- U+0030 (0)
    ( X"0C", X"0E", X"0C", X"0C", X"0C", X"0C", X"3F", X"00" ), 	-- U+0031 (1)
    ( X"1E", X"33", X"30", X"1C", X"06", X"33", X"3F", X"00" ),	-- U+0032 (2)
    ( X"1E", X"33", X"30", X"1C", X"30", X"33", X"1E", X"00" ),   -- U+0033 (3)
    ( X"38", X"3C", X"36", X"33", X"7F", X"30", X"78", X"00" ),   -- U+0034 (4)
    ( X"3F", X"03", X"1F", X"30", X"30", X"33", X"1E", X"00" ),   -- U+0035 (5)
    ( X"1C", X"06", X"03", X"1F", X"33", X"33", X"1E", X"00" ),   -- U+0036 (6)
    ( X"3F", X"33", X"30", X"18", X"0C", X"0C", X"0C", X"00" ),   -- U+0037 (7)
    ( X"1E", X"33", X"33", X"1E", X"33", X"33", X"1E", X"00" ),   -- U+0038 (8)
    ( X"1E", X"33", X"33", X"3E", X"30", X"18", X"0E", X"00" ));  -- U+0039 (9)
	 
	
BEGIN
	-- Integer-Input to vector * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	x_in_vector <= std_logic_vector(to_unsigned(x_in,10));
	y_in_vector <= std_logic_vector(to_unsigned(y_in,10));
	
	-- Input-Vector to Gridposition and row/column * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	x_gridposition(0) <= x_in_vector(5);
	x_gridposition(1) <= x_in_vector(6);
	x_gridposition(2) <= x_in_vector(7);
	x_gridposition(3) <= x_in_vector(8);
	x_gridposition(4) <= x_in_vector(9);
	y_gridposition(0) <= y_in_vector(5);
	y_gridposition(1) <= y_in_vector(6);
	y_gridposition(2) <= y_in_vector(7);
	y_gridposition(3) <= y_in_vector(8);
	y_gridposition(4) <= y_in_vector(9);

	x_column(0) 		<= x_in_vector(2);
	x_column(1) 		<= x_in_vector(3);
	x_column(2) 		<= x_in_vector(4);
	y_row(0) 			<= y_in_vector(2);
	y_row(1) 			<= y_in_vector(3);
	y_row(2) 			<= y_in_vector(4);
	
	-- write output vor VGA interface * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	VGA_inPos1   <= '1' WHEN (x_gridposition = "00110" AND y_gridposition = "00010")
                        ELSE '0';
    VGA_inPos2   <= '1' WHEN (x_gridposition = "01101" AND y_gridposition = "00010")
                        ELSE '0';
    color_field <= bitmap_score(s1)(to_integer(unsigned(y_row)))(to_integer(unsigned(x_column))) WHEN  VGA_inPos1 = '1' ELSE
                        bitmap_score(s2)(to_integer(unsigned(y_row)))(to_integer(unsigned(x_column))) WHEN  VGA_inPos2 = '1'
                        ELSE '0';

	-- write output for 7 segment display * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	HEX_s1 <= std_logic_vector(to_unsigned(s1,4));
	HEX_s2 <= std_logic_vector(to_unsigned(s2,4));
	
	-- process for counting the score * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	score_proc : PROCESS( clk, Reset)
		-- Variables for statements with changed values inside the process
		VARIABLE s1_temp : integer range 0 to 15;			
		VARIABLE s2_temp : integer range 0 to 15;
	BEGIN
		IF (Reset = '1') THEN										   -- asynchronous reset
			Score_max <= '0';
			s1 <= 0;
			s2 <= 0;
			s1_temp := 0;
			s2_temp := 0;
		ELSIF rising_edge(clk) THEN
			IF (reset_score = '1') THEN							   -- reset from controler
				Score_max <= '0';											
				s1 <= 0;
				s2 <= 0;
				s1_temp := 0;
				s2_temp := 0;
			ELSIF (ball_outOfField = '1') THEN
				IF ( out_left = '1' ) THEN								-- left side out(1)
					s1_temp := s1 + 1;
					s1 <= s1_temp;
					IF (s1_temp >= Max) THEN
						Score_max <= '1';
					END IF;
				ELSIF	( out_right = '1' ) THEN						-- right side out(2)
					s2_temp := s2 + 1;
					s2 <= s2_temp;
					IF (s2_temp >= Max) THEN
						Score_max <= '1';
					END IF;
				END IF;	
			END IF;
		END IF;
	END PROCESS score_proc;
	
END behave;