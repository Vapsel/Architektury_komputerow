entity RSout is
	port(TX: out std_logic;						-- linia nadawcza
		we: inout std_logic_vector(7 downto 0);
		START: in std_logic;
		CLK: in std_logic;
		RESET: in std_logic;
		GOTOWY: out std_logic)	-- 0 zaczynamy przetwarzać sygnał   
end RSout;						-- 1 koniec przetwarzania


architecture arch_RSout of RSout is
begin
    process(CLK, RESET, START)
    begin
		if(RESET = '1') then
			TX <= '1';
			GOTOWY <= '1';
		elsif(CLK'event and CLK = '1') then
			if(START = '1') then
				GOTOWY <= '0';
				NrBitu <= (others => '0'); -- Aktualnie obsługiwany nr bitu
				TX <= '0'; -- Wysyłamy bit startu
			end if;
			if(NrBitu < 9) then -- Robimy dla każdego bitu
				TX <= we(0);
				we <= '1' & we(7 downto 1); -- Załatwiamy bit stopu		'1'.7.6.5.4.3.2.1
				NrBitu <= NrBitu + 1; -- Obracamy sygnał (obsługujemy kolejny bit)		0.7.6.5.4.3.2.1
			end if;
		-- Czy jest to poprawne zagnieżdżenie if else
		elsif(NrBitu = 9) then
			GOTOWY <= '1';
			NrBitu <= NrBitu + 1;
		end if;
	end process;
end arch_RSout;
