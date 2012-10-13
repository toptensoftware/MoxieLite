-- Nexys3Demo


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Nexys3Demo is
	Port 
	( 
		clock : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		seg : out  STD_LOGIC_VECTOR (7 downto 0);
		an : out  STD_LOGIC_VECTOR (3 downto 0);
		leds : out STD_LOGIC_VECTOR (7 downto 0);
		MemOE : out STD_LOGIC;
		MemWR : out STD_LOGIC;
		FlashCS : out STD_LOGIC;
		FlashRP : out STD_LOGIC;
		MemAdr : out STD_LOGIC_VECTOR(26 downto 1);
		MemDB : inout STD_LOGIC_VECTOR(15 downto 0)
	);
end Nexys3Demo;

architecture Behavioral of Nexys3Demo is

	signal cpu_clock : STD_LOGIC;
	signal pixel_clock : STD_LOGIC;
	signal clock_100mhz : STD_LOGIC;

	signal cpu_dout : STD_LOGIC_VECTOR(15 downto 0);
	signal cpu_din : STD_LOGIC_VECTOR(15 downto 0);
	signal cpu_addr : STD_LOGIC_VECTOR(31 downto 0);
	signal cpu_rd_n : STD_LOGIC;
	signal cpu_wr_n : STD_LOGIC;
	signal cpu_wr_h_n : STD_LOGIC;
	signal cpu_wr_l_n : STD_LOGIC;
	
	signal mem_rd : STD_LOGIC;
	signal mem_wr : STD_LOGIC;
	signal port_rd : STD_LOGIC;
	signal port_wr : STD_LOGIC;
	
	signal rom_range : STD_LOGIC;

	signal ram_range : STD_LOGIC;
	signal ram_dout : STD_LOGIC_VECTOR(15 downto 0);
	signal ram_we : STD_LOGIC_VECTOR(1 downto 0);

	signal leds_reg : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	signal debug_reg : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
	
	signal reset_n : STD_LOGIC;
	
	signal flash_read_B_n : std_logic;
	signal flash_wait_B_n : std_logic;
	signal flash_dout_B : std_logic_vector(15 downto 0);
	signal flash_addr_B : std_logic_vector(26 downto 0);

	constant rom_base_address: std_logic_vector(26 downto 0) := "000" & x"400000";
		
begin

	leds <= leds_reg;
	reset_n <= NOT reset;
	
	-- Clock Generation
	clock_core : entity work.ClockCore
		PORT MAP 
		(
			clock => clock,					-- input clock = 100Mhz
			clock_3375 => open,	
			clock_100000 => clock_100mhz,
			clock_25000 => pixel_clock,
			RESET  => reset
		);

	cpu_clock <= pixel_clock;

	moxielite : entity work.moxielite
		GENERIC MAP
		(
			BOOT_ADDRESS => x"00100000",
			BIG_ENDIAN => '0'
		)
		PORT MAP
		(
			reset_n => reset_n,
			clock => cpu_clock,
			wait_n => flash_wait_B_n,
			addr => cpu_addr(31 downto 1),
			din => cpu_din,
			dout => cpu_dout,
			rd_n => cpu_rd_n,	
			wr_n => cpu_wr_n,
			wr_h_n => cpu_wr_h_n,
			wr_l_n => cpu_wr_l_n
		);

	cpu_addr(0) <= '0';

	process(cpu_clock, reset)
	begin
		if reset='1' then
		
			leds_reg <= "00000000";
			debug_reg <= x"0000";

		else
			if rising_edge(cpu_clock) then

				-- Write port 0 -> LEDs
				if cpu_addr(7 downto 0)=x"00" and port_wr = '1' then
					leds_reg <= cpu_dout(7 downto 0);
				end if;
								
			end if;

		end if;
		
	end process;

	-- Decode read/write signals
	mem_rd <= '1' when (cpu_addr(31) = '0' and cpu_rd_n = '0') else '0';
	mem_wr <= '1' when (cpu_addr(31) = '0' and cpu_wr_n = '0') else '0';
	port_rd <= '1' when (cpu_addr(31) = '1' and cpu_rd_n = '0') else '0';
	port_wr <= '1' when (cpu_addr(31) = '1' and cpu_wr_n = '0') else '0';
	
	-- Decode memory addresses
	rom_range <= '1' when (cpu_addr(31 downto 20) = x"001") else '0';
	ram_range <= '1' when (cpu_addr(31 downto 20) = x"002") else '0';

	-- Decode RAM write
	ram_we(0) <= '1' when (ram_range = '1' and mem_wr = '1' and cpu_wr_l_n='0') else '0';
	ram_we(1) <= '1' when (ram_range = '1' and mem_wr = '1' and cpu_wr_h_n='0') else '0';
	
	-- Work out flash memory address for ROM
	flash_addr_B <= rom_base_address(26 downto 19) & cpu_addr(18 downto 0);
				
    flash_read_B_n <= '0' when (mem_rd='1' and rom_range='1' ) else '1';

	cpu_din <= 
					ram_dout when (mem_rd = '1' and ram_range = '1') else
					flash_dout_B when (mem_rd = '1' and rom_range = '1') else
					x"0000";


	-- Flash memory controller provides two ports for the main CPU ROM and 
	-- the peripheral controller ROM
	FlashMemoryController: entity work.FlashMemoryController
		PORT MAP
		(
			reset_n => reset_n,
			clock => clock_100mhz,
			MemOE_n => MemOE,
			MemWR_n => MemWR,
			FlashCS_n => FlashCS,
			FlashRP_n => FlashRP,
			MemAdr => MemAdr,
			MemDB => MemDB,
			read_A_n => '1',
			addr_A => (others=>'0'),
			dout_A => open,
			wait_A_n => open,
			read_B_n => flash_read_B_n,
			addr_B => flash_addr_B,
			dout_B => flash_dout_B,
			wait_B_n => flash_wait_B_n 
		);

	-- RAM
	RAM : entity work.ram4k16bit
		PORT MAP 
		(
			clka => cpu_clock,
			wea => ram_we,
			addra => cpu_addr(11 downto 1),
			dina => cpu_dout,
			douta => ram_dout
		);		

end Behavioral;

