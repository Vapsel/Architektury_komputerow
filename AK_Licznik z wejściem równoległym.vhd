
--					||||||||	wejście
--		tryb	|---------------|
--		------->|				|	RESET
--				|	Licznik		|<-------
--		CLK		|				|
--		------->|				|
--				|---------------|
--					||||||||	wyjście
		
entity licznik_r is 
	port(CLK: in std_logic;
		RESET: in std_logic;
		wy: inout std_logic_vector(31 downto 0);
		we: inout std_logic_vector(31 downto 0);
		tryb: in std_logic);
end licznik_r;

architecture arch_licznik_r of licznik_r is
begin
	process(RESET, CLk)
	begin
		if(RESET = '1') then
			wy <= (others => '0');
		elsif(CLK'event and CLK = '1') then
			-- Tryb 0 oznacza złykłe działania licznika
			if(tryb = '0') then
				wy <= wy + 1;
			-- Tryb 1 oznacza przpisywanie wejścia
			else
				wy <= we;
			end if;
		end if;
	end process;
end arch_licznik_r;
