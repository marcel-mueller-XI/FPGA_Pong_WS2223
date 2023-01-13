-- Control

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.PongPack.all;


entity Control is
port(
	clk		: in std_logic;			--! main clk
	reset	: in std_logic;			--! asynchronos reset

	-- INPUTS
	button_start 		: in std_logic; --! button input, in order to start the game
	button_resetMatch : in std_logic; --! button in order to reset the match (reset score)
	ball_outOfField 	: in std_logic; --! inputs wheather the ball is outside the field -> score
	score_max			: in std_logic; --! inputs score_max wheather the match ends due to one player reached max score
	
	-- OUTPUTS
	reset_score 		: out std_logic;	--! triggers the score module to reset its score
	start_ball 			: out std_logic	--! triggers the ball logic module to start the game with that the ball
);
end entity Control;

architecture behave of Control is
	type STATE_TYPE is (idle, game_ready, game_running, match_over, reset_score_state);
	signal current_state : STATE_TYPE;
	signal next_state	 : STATE_TYPE;

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
	nextState : process (current_state, button_start, button_resetMatch, ball_outOfField, score_max)
	begin
		next_state <= current_state;
		case( current_state ) is
		
			when idle =>
				next_state <= game_ready;
			when game_ready =>
				if(score_max = '1') then
					next_state <= match_over;
				elsif(button_resetMatch = '1') then
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

end architecture behave;