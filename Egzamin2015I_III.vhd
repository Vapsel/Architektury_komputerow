--Napisz w VHDL strukturę układu generującego na wyjściu powtarzhący się sygnał 01110011. 
--Dostępne są jednobitowe wejścia: CLK, RESET oraz jednobitowe Wyjjście: WYJ.

entity uklad is
	port(	CLK   : in std_logic;
			RESET : in std_logic;
			WYJ	  : out std_logic );
end uklad;

architecture arch_uklad of uklad is
	signal rejestr : std_logic_vector(7 downto 0);
	
begin	
	process(CLK, RESET)
	begin
		if(RESET = '1') then
			rejestr <= "01110011";
		elsif(CLK'event and CLK = '1') then
			rejestr <= rejestr(0) & rejestr(7 downto 1); -- Przerzucamy pierwszy element na koniec
			WYJ <= rejestr(0); -- Wypisanie pierwszego elementu z rejestru
		end if;
	end process;
end arch_uklad;
