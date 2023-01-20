-- Control_fpga

library ieee;
use ieee.std_logic_1164.all;

entity Control_fpga is 
port(
    clk		: in std_logic;
	reset	: in std_logic;

	-- INPUTS
	button_start 		: in std_logic;
	button_resetMatch 	: in std_logic;
	ball_outOfField 	: in std_logic;
	score_max			: in std_logic;
	
	-- OUTPUTS
	reset_score 		: out std_logic;
	start_ball          : out std_logic;

    --Debugg
    TestSignal : out std_logic_vector(7 downto 0)
);
end entity Control_fpga;

architecture behave of Control_fpga is
	signal reset_sync	: std_logic;
	signal button_start_sync 		: std_logic;
	signal button_resetMatch_sync 	: std_logic;
	signal ball_outOfField_sync 	: std_logic;
	signal score_max_sync           : std_logic;
    signal reset_1, reset_2         : std_logic;
    
    signal clk_div                  : std_logic;
    signal clk_1                    : std_logic;

    -- due to low acitve buttons
    signal reset_int                : std_logic;
    signal button_start_int         : std_logic;
    signal button_resetMatch_int    : std_logic;
begin

-- low activ buttons
reset_int <= not reset;
button_start_int <= not button_start;
button_resetMatch_int <=  not button_resetMatch;

--Debugg
TestSignal <= clk_div & reset_int & reset_sync & button_start & button_resetMatch & ball_outOfField_sync & button_start_sync & button_resetMatch_sync;

-- clock divider, half
clockdivider : process (clk, reset_int)
begin
    if reset_int = '1' then
        clk_1 <= '0';
    elsif rising_edge(clk) then
        clk_1 <= not clk_1;
    end if;

end process clockdivider;

clockdivider2 : process (clk_1, reset_int)
begin
    if reset_int = '1' then
        clk_div <= '0';
    elsif rising_edge(clk_1) then
        clk_div <= not clk_div;
    end if;

end process clockdivider2;


--inputsync
inputsync : process (reset_sync, clk_div)
begin
    if reset_sync = '1' then
        button_start_sync <= '0';
        button_resetMatch_sync <= '0';
        ball_outOfField_sync <= '0';
        score_max_sync <= '0';
    elsif rising_edge(clk_div) then
        button_start_sync <= button_start_int;
        button_resetMatch_sync <= button_resetMatch_int;
        ball_outOfField_sync <= ball_outOfField;
        score_max_sync <= score_max;
    end if;
end process inputsync;

-- Reset processing sync
resetsync : process (reset_int, clk_div)
begin
    if reset_int = '1' then
        reset_1 <= '0';
        reset_2 <= '0';
    elsif rising_edge(clk_div) then
        reset_1 <= '1';
        reset_2 <= reset_1;
    end if;
end process resetsync;

reset_sync <= not reset_2;

control : entity work.Control
port map(
    clk => clk_div,
	reset => reset_sync,

	-- INPUTS
	button_start => button_start_sync,
	button_resetMatch => button_resetMatch_sync,
	ball_outOfField => ball_outOfField_sync,
	score_max => score_max_sync,
	
	-- OUTPUTS
	reset_score => reset_score,
	start_ball => start_ball
    );

end architecture behave;