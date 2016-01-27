-- Napisz w VHDL stukture ukladu o jednobitowych wejsciach RESET, CLK, WE1, WE2 oraz 8 bitowym wyjsciu WYJSCIE. Działanie układu:
-- a) sygnał RESET-1 powoduje asynchroniczne wyzerowania wyjścia;
-- b)jeśli WE1-0 i WE2-0 to każde zbocze opadające CLK zwiększa o jeden stan wyjścia;
-- c)jeśli WE1-0 i WE2-1 to każde zbocze opadające CLK zminiejsza o dzisięć stan wyjścia;
-- b)jeśli WE1-1 i WE2-0 to każde zbocze opadające CLK powoduje wyzerowanie wyjścia;
-- b)jeśli WE1-1 i WE2-1 to każde zbocze opadające CLK powoduje ustawienie wszystkich bitów wyjścia na 1.

--					| RESET
--					v 
--		WE1		|-----------|
--		------->|			|	WYJSCIE
--		WE2		|	układ	|------>
--		------->|			|
--				|-----------|
--					^
--					| CLK

entity uklad is
	port(RESET: in std_logic;
		CLK: in std_logic;
		WE1: in std_logic;
		WE2: in std_logic;
		WYJSCIE: out std_logic_vector(7 downto 0));
end uklad;

architecture arch_uklad of uklad is
begin
	process(RESET, CLK)
	begin
		if(RESET = '1') then
			WYJSCIE <= (others => '0');
		elsif(CLK'event and CLK = '0') then
			if(WE1 = '0') then
				if(WE2 = '0') then
					WYJSCIE = WYJSCIE + 1;
				elsif(WE2 = '1') then
					WYJSCIE = WYJSCIE - 10;
				end if;
			elsif(WE1 = '1') then
				if(WE2 = '0') then
					WYJSCIE <= (others => '0');
				elsif(WE2 = '1') then
					WYJSCIE <= (others => '1');
				end if;
			end if;
		end if;
	end process;
end arch_uklad;