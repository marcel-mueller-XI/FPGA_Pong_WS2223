------------------------------------------------------
-- Aufgabe: 	Pong										 	 --
-- Datei:	   Pong_Sound.vhd					 			 --
-- Autor:   	Jonas Sachwitz & Marco Stütz      	 --
-- Datum:   	10.01.2023                       	 --
------------------------------------------------------

-- ToDo * * * * * * * * * * * * * * * * * * * * * * * *

-- Doku: Töne nicht mit Schleifen, da zu viel Hardwareumsetzung bei zB 70k Durchläufen

-- ToDo * * * * * * * * * * * * * * * * * * * * * * * *

LIBRARY ieee;
USE ieee.std_logic_1164.all;

--! brief Pong_Sound
--!
--! Finite state machine (FSM) to output the sound for the pong game.
--!
--! @startuml
--! state s0
--! state s_playing
--! state s_paddle_bounce
--! state s_field_bounce
--! state s_ball_outOfField
--! state s_victory
--!
--! s0 --> s_playing : Start = '1'
--! s_playing --> s_paddle_bounce : paddle_bounce = '1'
--! s_playing --> s_field_bounce : field_bounce = '1' 
--! s_playing --> s_ball_outOfField : ball_outOfField = '1' 
--! s_paddle_bounce --> s_playing : count_timing >= '10_000_000'
--! s_ball_outOfField --> s_victory : count_timing >= '30_000_000', Score_max = '1'
--! s_ball_outOfField --> s_playing : count_timing >= '30_000_000', Score_max != '1'
--! s_victory --> s0 : count_timing >= '250_000_000'
--! s_field_bounce --> s_playing : count_timing >= '10_000_000'
--!
--! @enduml

ENTITY Pong_Sound IS
	PORT(
		Clk					: 	IN		std_logic; 	--! clock signal: 25,175 MHz
		Reset          	:  IN 	std_logic; 	--! asynchronous reset
		Start					:	IN		std_logic; 	--! true if the game has started
		paddle_bounce		:	IN		std_logic; 	--! true if the paddle was hit
		field_bounce		:	IN		std_logic; 	--! true if the edge was hit
		ball_outOfField	:	IN		std_logic; 	--! true if the goal was hit
		Score_max			:	IN		std_logic; 	--! true if the score reached victory conditions
		
		Sound					:	OUT	std_logic	--! output for the sound signal
  );
END Pong_Sound;

ARCHITECTURE behave OF Pong_Sound IS

   TYPE 		STATE_TYPE IS ( s0, s_playing, s_paddle_bounce, s_field_bounce, s_ball_outOfField, s_victory);
	
	SIGNAL 	current_state 	: 	STATE_TYPE;		--! register for internal state --> clocked_proc
	
	SIGNAL 	next_state 		: 	STATE_TYPE;		--! register for logically built next interlan state --> nextstate_proc

	signal	count_timing	:	integer := 0;	--! counter for timing between states [1 = 200 µs]
	signal	count_melody	:	integer := 0;	--! counter for melody timing [1 = 200 µs]
	signal	index_melody	:	integer := 0;	--! index for multiplexer
	signal	count_paddle	:	integer := 0;	--! counter for paddle sound [1 = 200 µs]
	signal	count_edge		:	integer := 0;	--! counter for edge sound [1 = 200 µs]
	signal	count_goal		:	integer := 0;	--! counter for goal sound [1 = 200 µs]
	signal	count_g			:	integer := 0;	--! counter for g-tone [1 = 200 µs]
	
	signal	clk_paddle		:	std_logic;		--! PWM signal for paddle sound [tone = f']
	signal	clk_edge			:	std_logic;		--! PWM signal for edge sound [tone = c']
	signal	clk_goal			:	std_logic;		--! PWM signal for goal sound [tone = c'']
	signal	clk_g				:	std_logic;		--! PWM signal for tone g [tone = g']
	signal	victory			:	std_logic;		--! PWM signal for victory
BEGIN

	victory 	<= 	clk_g 	WHEN 	index_melody = 1 OR index_melody = 3 OR index_melody = 7 ELSE
						'0'		WHEN  index_melody = 0 ELSE
						clk_edge;
	
	clocked_proc : PROCESS( Clk, Reset)
	BEGIN
		IF (Reset = '1') THEN
			current_state <= s0;					-- state after a reset
		ELSIF rising_edge(Clk) THEN
			current_state <= next_state;		-- take over next state
		END IF;
	END PROCESS clocked_proc;
	
	nextstate_proc : PROCESS( current_state, count_timing, Start, field_bounce, ball_outOfField, paddle_bounce, Score_max)
	BEGIN
		next_state <= current_state;
		CASE current_state IS
		
			WHEN s0 =>					-- beginning state
				IF 	( Start = '1' ) 			THEN
					next_state <= s_playing;
				END IF;
				
			WHEN s_playing =>			-- state while playing
				IF 	( paddle_bounce = '1' ) 	THEN
					next_state <= s_paddle_bounce;
				ELSIF ( field_bounce = '1' ) 		THEN
					next_state <= s_field_bounce;
				ELSIF ( ball_outOfField = '1' ) THEN
					next_state <= s_ball_outOfField;
				END IF;
				
			WHEN s_paddle_bounce =>		-- state when the ball hits a paddle
				IF 	( count_timing >= 5_000_000 ) THEN		-- 200 ms
					next_state <= s_playing;
				END IF;
				
			WHEN s_field_bounce =>		-- state when the ball hits an edge
				IF 	( count_timing >= 5_000_000 ) THEN		-- 200 ms
					next_state <= s_playing;
				END IF;
				
			WHEN s_ball_outOfField =>	-- state when the ball hits a goal
				IF 	( count_timing >= 15_000_000 )	THEN	-- 600 ms
					IF 	( Score_max = '1' ) 			THEN
						next_state <= s_victory;
					ELSE
						next_state <= s_playing;
					END IF;
				END IF;
				
			WHEN s_victory =>				-- state when the score reached winning conditions
				IF 	( count_timing >= 125_000_000 ) THEN	-- 5 s
					next_state <= s0;
				END IF;
			
			WHEN OTHERS =>
				next_state <= s0;
				
		END CASE;
	END PROCESS nextstate_proc;
	
	output_proc : PROCESS( current_state, clk_paddle, clk_edge, clk_goal, victory )
	BEGIN
		Sound <= '0'; 	-- Default Assignment for D-Latch problem
		CASE current_state IS
		
			WHEN s0 =>
				Sound <= '0';
				
			WHEN s_playing =>
				NULL;
				
			WHEN s_paddle_bounce =>
				IF (clk_paddle = '1' ) THEN
					Sound <= '1';
				END IF;
				
			WHEN s_field_bounce =>
				IF (clk_edge = '1' ) THEN
					Sound <= '1';
				END IF;
				
			WHEN s_ball_outOfField =>
				IF (clk_goal = '1' ) THEN
					Sound <= '1';
				END IF;
				
			WHEN s_victory =>
				IF (victory = '1' ) THEN
					Sound <= '1';
				END IF;
				
			WHEN OTHERS
				=>NULL;
				
		END CASE;
	END PROCESS output_proc;
	
	timer_proc : PROCESS( Clk, Reset )		--! timer for states and melody
	BEGIN
		IF (Reset = '1') THEN
			count_timing <= 0;
			count_melody <= 0;
		ELSIF rising_edge(Clk) THEN
			-- counter for melody - - - - - - - - - - - - - - - - - - - - - - - - - -
			IF (current_state = s_victory) THEN
				IF ( count_melody >= 12_250_000)	THEN	-- 500ms
					count_melody <= 0;
					IF (index_melody >= 10) THEN
						index_melody <= 0;
					ELSE
						index_melody  <= index_melody + 1;
					END IF;
				ELSE
					count_melody <= count_melody + 1;
				END IF;
				ELSE -- für immer selben Start, sonst kann Zähler noch irgendwo stehen
					index_melody <= 0;
					count_melody <= 0;
			END IF;
			-- counter for state timing - - - - - - - - - - - - - - - - - - - - - - -
			IF current_state /= next_state THEN
				count_timing <= 0;
			ELSE
				count_timing <= count_timing + 1;
			END IF;
		END IF;
	END PROCESS timer_proc;
	
	proc_sound_paddle: process(Clk)			--! tone f' [352 Hz]
		variable count_paddle_temp : integer;
	begin
		if (rising_edge(Clk)) then
			count_paddle_temp := count_paddle + 1;
			count_paddle 		<= count_paddle_temp;
			if (count_paddle_temp >= 35510) then	--> 352Hz
				count_paddle 	<= 0;
				if ( Clk_paddle = '0') then
					Clk_paddle 	<= '1';
				else
					Clk_paddle 	<= '0';
				end if;
			end if;
		end if;	
	end process proc_sound_paddle;
	
	proc_sound_edge: process(Clk)				--! tone c'' [527 Hz]
		variable count_edge_temp : integer;
	begin
		if (rising_edge(Clk)) then
			count_edge_temp 	:= count_edge + 1;
			count_edge			<= count_edge_temp;
			if (count_edge_temp >= 23718) then		--> 527Hz
				count_edge 	<= 0;
				if ( Clk_edge = '0') then
					Clk_edge <= '1';
				else
					Clk_edge <= '0';
				end if;
			end if;
		end if;	
	end process proc_sound_edge;
	
	proc_sound_goal: process(Clk)				--! tone c' [264 Hz]
		variable count_goal_temp : integer;
	begin
		if (rising_edge(Clk)) then
			count_goal_temp 	:= count_goal + 1;
			count_goal			<= count_goal_temp;
			if (count_goal_temp >= 47348) then		--> 264Hz
				count_goal <= 0;
				if ( Clk_goal = '0') then
					Clk_goal <= '1';
				else
					Clk_goal <= '0';
				end if;
			end if;
		end if;	
	end process proc_sound_goal;
	
	proc_tone_g: process(Clk)					--! tone g' [396 Hz]
		variable count_g_temp : integer;
	begin
		if (rising_edge(Clk)) then
			count_g_temp 	:= count_g + 1;
			count_g			<= count_g_temp;
			if (count_g_temp >= 31565) then			--> 396Hz
				if ( Clk_g = '0') then
					Clk_g <= '1';
				else
					Clk_g <= '0';
				end if;
				count_g <= 0;
			end if;
		end if;	
	end process proc_tone_g;

END behave;