-- Control

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.PongPack.all;


entity Control is
port(
	clk		: in std_logic;			--! inputs main clk
	reset	: in std_logic;			--! inputs global asynchronous reset

	-- INPUTS
	button_start 		: in std_logic; --! button input, to start the game, only when the game is ready | from hardware button
	button_resetMatch 	: in std_logic;	--! button in order to reset the match (reset score), also possible when score_max is not reached | from hardware button
	ball_outOfField 	: in std_logic; --! inputs whether the ball is outside the field -> game stops, score increments (not in this module) | from collision module
	score_max			: in std_logic; --! inputs score_max wheather the match ends due to one player reached max score | from score module
	
	-- OUTPUTS
	reset_score 		: out std_logic; --! triggers the score module to reset its score | to score module
	start_ball 			: out std_logic	--! activates the ball logic module to start the game with that the ball | to ball module
);
end entity Control;

architecture behave of Control is
	type STATE_TYPE is (idle, game_ready, game_running, match_over, reset_score_state);
	signal current_state : STATE_TYPE;
	signal next_state	 : STATE_TYPE;

	signal button_resetMatch_last : std_logic;

begin

	-- #################################################################
	saveNextState : process (CLK, reset)
	begin
		if (reset = '1')	then
			current_state <= idle;
		elsif (rising_edge(clk)) then
			current_state <= next_state;
		end if;
	end process saveNextState;
	-- #################################################################
	nextState : process (current_state, button_start, button_resetMatch, button_resetMatch_last, ball_outOfField, score_max)
	begin
		next_state <= current_state;
		case( current_state ) is
		
			when idle =>
				next_state <= game_ready;
			when game_ready =>
				if(score_max = '1') then
					next_state <= match_over;
				elsif(button_resetMatch = '1' and button_resetMatch_last = '0') then
					next_state <= reset_score_state;
				elsif(button_start = '1') then
					next_state <= game_running;
				end if;
			when game_running =>
				if(ball_outOfField = '1') then
					next_state <= game_ready;
				end if;
			when match_over =>
				if(button_resetMatch = '1') then
					next_state <= reset_score_state;
				end if;
			when reset_score_state =>
				next_state <= game_ready;
			when others =>
				next_state <= idle;
		end case ;

	end process nextState;
	-- #################################################################
	outputProcess : process (current_state)
	begin
		reset_score <= '0';
		start_ball <= '0';

		case (current_state) is
			when game_running =>
				start_ball <= '1';
			when reset_score_state =>
				reset_score <= '1';
			when others =>
				
		end case;
	
	end process outputProcess;


	button_last : process (clk, reset)
	begin
		if (reset = '1')	then
			button_resetMatch_last <= '0';
		elsif (rising_edge(clk)) then
			button_resetMatch_last <= button_resetMatch;
		end if;
	end process button_last;

end architecture behave;