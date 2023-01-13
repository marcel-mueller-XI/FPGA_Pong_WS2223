-- IncrementalEncoder
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.myPack.all;


entity IncrementalEncoder is
   port( 
      Reset         : in     std_logic;  --! Asynchronous Reset
      Clk           : in     std_logic;  --! Clock
      A             : in     std_logic;  --! Spur A - Incrementalencoder
      B             : in     std_logic;  --! Spur B - Incrementalencoder 
      En            : out    std_logic;  --! Enable, 1 Clk Period high
      Up_nDown      : out    std_logic;  --! '1' -> Up, '0' -> Down
                                         --!  valid only when En = '1'
		current_state_debug : out STATE_TYPE
   );
end entity IncrementalEncoder;

architecture behave of IncrementalEncoder is
	signal current_state : STATE_TYPE;
	signal next_state 	: STATE_TYPE;
	-- signal temp_state 	: STATE_TYPE;
	
	signal En_int			: std_logic;
	
begin
	current_state_debug <= current_state;
	En <= En_int;
	
	current_state <= next_state;

--	output_proc : process (current_state, temp_state)
--	begin
--		En_int <= '0';
--		
--		case current_state is
--			when AB =>
--				if (temp_state = AnB_Ae) then
--					En_int <= '1';
--					Up_nDown <= '1';	-- A'event -> B'event == up
--				elsif (temp_state = nAB_Be) then
--					En_int <= '1';
--					Up_nDown <= '0';	-- B'event -> A'event == down
--				end if;
--			when nAnB =>
--				if (temp_state = nAB_Ae) then
--					En_int <= '1';
--					Up_nDown <= '1';	-- A'event -> B'event == up
--				elsif (temp_state = AnB_Be) then
--					En_int <= '1';
--					Up_nDown <= '0';	-- B'event -> A'event == down
--				end if;
--			when others =>
--		end case;
--		
--		temp_state <= current_state;
--	end process output_proc;
	
	clocked_proc : process (Clk, Reset)	-- Kombintorik Generierung nächster innerer Zustand, 
	begin											-- Speicherung der Inneren Zustandes und Output Kombinatorik
		
		-- next_state <= current_state;
		if(Reset = '1') then
			next_state <= start;
		elsif rising_edge(Clk) then
			En_int <= '0';
			Up_nDown <= '0';

			case current_state is
				when start =>
					if(A = '1' and B = '1') then
						next_state <= AB;
					elsif (A = '0' and B = '0') then
						next_state <= nAnB;
					end if;
				-----------------------------------------
				when nAnB =>
					if (A = '1') then
						next_state <= AnB_Ae;
					elsif (B = '1') then
						next_state <= nAB_Be;
					end if;
				when AB =>
					if (A = '0') then
						next_state <= nAB_Ae;
					elsif (B = '0') then
						next_state <= AnB_Be;
					end if;
				-------------------
				when nAnB_out =>
					next_state <= nAnB;
				when AB_out =>
					next_state <= AB;
				------------------------------------------
				when AnB_Ae =>
					if (A = '0') then
						next_state <= nAnB;	-- Prellen
					elsif (B = '1') then
						En_int <= '1';
						Up_nDown <= '1';
						next_state <= AB_out;-- Out
					end if;
				when nAB_Ae =>
					if (A = '1') then
						next_state <= AB;		-- Prellen
					elsif (B = '0') then
						En_int <= '1';
						Up_nDown <= '1';
						next_state <= nAnB_out;-- Out
					end if;
				------------------------------------------
				when nAB_Be =>
					if (A = '1') then
						En_int <= '1';
						Up_nDown <= '0';
						next_state <= AB_out;-- Out
					elsif (B = '0') then
						next_state <= nAnB;	-- Prellen
					end if;
				when AnB_Be =>
					if (A = '0') then
						En_int <= '1';
						Up_nDown <= '0';
						next_state <= nAnB_out;-- Out
					elsif (B = '1') then
						next_state <= AB;		-- Prellen
					end if;
				------------------------------------------
				when others =>
					next_state <= start;
			end case;
		end if;
	end process clocked_proc;


end architecture behave;