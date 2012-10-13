library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FlashMemoryController is
	Port 
	(
		reset_n : in STD_LOGIC;
		clock : in STD_LOGIC;
	
		-- Memory Device
		MemOE_n : out STD_LOGIC;
		MemWR_n : out STD_LOGIC;
		FlashCS_n : out STD_LOGIC;
		FlashRP_n : out STD_LOGIC;
		MemAdr : out STD_LOGIC_VECTOR(26 downto 1);
		MemDB : inout STD_LOGIC_VECTOR(15 downto 0);		
		
		-- Port A
		read_A_n : in STD_LOGIC;
		addr_A : in  STD_LOGIC_VECTOR (26 downto 0);
		dout_A : out  STD_LOGIC_VECTOR (7 downto 0);
		wait_A_n : out  STD_LOGIC;

		-- Port B
		read_B_n : in STD_LOGIC;
		addr_B : in  STD_LOGIC_VECTOR (26 downto 0);
		dout_B : out  STD_LOGIC_VECTOR (15 downto 0);
		wait_B_n : out  STD_LOGIC
	);
end FlashMemoryController;

architecture Behavioral of FlashMemoryController is

	type state_kind is (state_idle, state_address_valid, state_output_enable, state_sync_port);
	type port_kind is (port_A, port_B);

	signal state : state_kind := state_idle;
	signal active_port : port_kind;
	signal delay, delay_next : unsigned(2 downto 0);
	signal flash_output_enable_n : std_logic;
	signal sync_read_A_n, sync_read_B_n : std_logic;
	signal prev_read_A_n, prev_read_B_n : std_logic;
	signal read_A_pending, read_B_pending : std_logic;
	signal dout_byte : std_logic_vector(7 downto 0);
	signal have_prev_A, have_prev_B : std_logic;
	signal prev_addr_A, prev_addr_B : std_logic_vector(26 downto 0);
	signal dout_16_A, dout_16_B : std_logic_vector(15 downto 0);
	
	constant DELAY_ADDRESS_VALID : integer := 6;
	constant DELAY_OUTPUT_ENABLE : integer := 6;

begin

	-- We never write
	MemDB <= "ZZZZZZZZZZZZZZZZ";
	MemWR_n <= '1';
	
	-- Reset flash chip
	FlashRP_n <= reset_n;
	
	-- MemOE and FlashCS can both be enabled together
	MemOE_n <= '0' when (state=state_output_enable) else '1';	
	FlashCS_n <= '1' when (state=state_idle) else '0';
	
	-- Pass address of selected port to flash chip
	MemAdr <= prev_addr_A(26 downto 1) when active_port = port_A else
				 prev_addr_B(26 downto 1);
	
	-- Select output byte from latched 16 bit result of last read
	dout_A <= dout_16_A(7 downto 0) when prev_addr_A(0)='0' else dout_16_A(15 downto 8);
--	dout_B <= dout_16_B(7 downto 0) when prev_addr_B(0)='0' else dout_16_B(15 downto 8);
	dout_B <= dout_16_B;

	-- Next delay count
	delay_next <= delay + 1;
	
	wait_A_n <= NOT read_A_pending;
	wait_B_n <= NOT read_B_pending;

	process (reset_n, clock)
	begin
	
		if reset_n='0' then
		
			state <= state_idle;
			active_port <= port_A;
			delay <= (others => '0');
			sync_read_A_n <= '1';
			sync_read_B_n <= '1';
			prev_read_A_n <= '1';
			prev_read_B_n <= '1';
			read_A_pending <= '0';
			read_B_pending <= '0';
			have_prev_A <= '0';
			have_prev_B <= '0';

		elsif rising_edge(clock) then

			-- Synchronize read flags to this clock domain
			sync_read_A_n <= read_A_n;
			sync_read_B_n <= read_B_n;
			prev_read_A_n <= sync_read_A_n;
			prev_read_B_n <= sync_read_B_n;
				
			-- Detect rising edge on read_a and set wait_a
			if sync_read_A_n = '0' and prev_read_A_n = '1' then
				read_A_pending <= '1';
			end if;
			
			-- Detect rising edge on read_b and set wait_b
			if sync_read_B_n = '0' and prev_read_B_n = '1' then
				read_B_pending <= '1';
			end if;
			
			-- Update delay counter
			delay <= delay_next;
		
			case state is
			
				when state_idle =>

					-- Initiate read, port A always gets priority
					if (sync_read_A_n = '0' and prev_read_A_n = '1') or read_A_pending = '1' then
					
						if addr_A(26 downto 1) = prev_addr_A(26 downto 1) and have_prev_A = '1'then
						
							state <= state_sync_port;
						
						else

							state <= state_address_valid;

						end if;
						
						active_port <= port_A;
						prev_addr_A <= addr_A;
						delay <= (others=>'0');
					
					elsif (sync_read_B_n = '0' and prev_read_B_n = '1') or read_B_pending = '1' then
					
						if addr_B(26 downto 1) = prev_addr_B(26 downto 1) and have_prev_B = '1' then
						
							state <= state_sync_port;
						
						else
						
							state <= state_address_valid;
						
						end if;
						
						active_port <= port_B;
						prev_addr_B <= addr_B;
						delay <= (others=>'0');
						
					else
						
						read_A_pending <= '0';
						read_B_pending <= '0';
						
					end if;
				
				when state_address_valid =>
					
					-- Once address setup long enough, select chip & enable output
					if delay_next = DELAY_ADDRESS_VALID then 
						delay <= (others=>'0');
						state <= state_output_enable;
					end if;
				
				when state_output_enable =>
				
					-- Once chip enabled long enough, read data
					if delay_next = DELAY_OUTPUT_ENABLE then

						-- data available now, latch it into output register and clear wait flag
						if active_port = port_A then
							dout_16_A <= MemDB;
							have_prev_A <= '1';
						else
							dout_16_B <= MemDB;
							have_prev_B <= '1';
						end if;
												
						-- Move to the sync port state
						state <= state_sync_port;

					end if;
					
				when state_sync_port =>
				
					-- sync out the read ready flag
					if active_port = port_A then
						read_A_pending <= '0';
					else
						read_B_pending <= '0';
					end if;
											
					-- go idle for at least one clock tick
					state <= state_idle;
					
				
				when others =>
					state <= state_idle;
						
			end case;
		
		end if;
	
	end process;

	
end Behavioral;

