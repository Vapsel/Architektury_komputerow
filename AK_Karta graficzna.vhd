entity vga is
	port(	RESET	: in	 std_logic;
		CLK50	: in	 std_logic;
		posx	: in	 std_logic_vector(10 downto 0);
		posy	: in	 std_logic_vector(9 downto 0);
		kolor	: out	 std_logic_vector(2 downto 0);
		synpoz	: out	 std_logic_vector();				--synchronizacja pozioma
		synpion	: out	 std_logic_vector())				--synchronizacja pionowa
	end vga;

--kwadrat 10x10
architecture arch_vga of vga is
	signal(x: std_logic_vector(10 downto 0)); 			--potrzebujemy 11 linij żeby zapisać liczbę 1285,5
	signal(y: std_logic_vector());
	
begin
	process(CLK50, RESET)
	begin
		if(RESET = '1') then
			x <= (others => '0');
			y <= (others => '0');
		elsif(CLK50'event and CLK50 = '1') then
			x <= x + 1;
			if(x = 1588)then			--koniec linii poziomej
				x <= (others => '0');
				y <= y + 1;
				if (y = 527)then		--koniec wszystkich linii
					y <= (others => '0')
				end if;
			end if;
		end if;
	end process;
	
	synpoz <= '0' when x > = 1306 and x < 1495 else '1';	--zaokrąglanie w góre
	synpion <= '0' when y >= 494 and y < 497 else '1';
	
	kolor <= "000" when x > 1259 or y >= 480 else
		"100" when x >= posx and x < posx + 10 and y >= posy and y < posy + 10 else
		"010"; 	--zielony kolor tła
end arch_vga;






--rysujemy obrazek w kwadracie 10x10

architecture arch_vga of vga is
	signal(x: std_logic_vector(10 downto 0)); 			--potrzebujemy 11 bitów żeby zapisać liczbę 1286
	signal(y: std_logic_vector(9 down to 0));			--potrzebujemy 10 bitów dla zapisu 528
	signal(obr: std_logic_vector(299 downto 0));
	
	begin
	process(CLK50, RESET)
		begin
		if(RESET = '1') then
			obr <=	       "000 000 000 000 000 000 000 000 000 000			--rysunek 10x10
					000 000 000 000 000 000 000 000 000 000
					000 000 000 000 000 000 000 000 000 000
					000 000 000 000 000 000 000 000 000 000
					000 000 000 000 000 000 000 000 000 000
					000 000 000 000 000 000 000 000 000 000
					000 000 000 000 000 000 000 000 000 000
					000 000 000 000 000 000 000 000 000 000
					000 000 000 000 000 000 000 000 000 000
					000 000 000 000 000 000 000 000 000 000"
		
		
			x <= (others => '0');
			y <= (others => '0');
		elsif(CLK50'event and CLK50 = '1') then
			if (x >= 1259 or y >= 480) then
				kolor <= "000";
			elsif (x >= posx and x <posx + 1 and y > posy and y < posy + 10) then
				obr <= obr(296 downto 0) & obr(299 downto 297);		--przesunięcie o 3 bity w lewo; 3 z początku w koniec
			
			kolor <= obr (299 downto 297)
			else
				kolor <= "010";
			end if;

			x <= x + 1;

			if(x = 1588)then			--koniec linii poziomej
				x <= (others => '0');
				y <= y + 1;
				if (y = 527)then		--koniec wszystkich linii
					y <= (others => '0')
				end if;
			end if;
		end if;
	end process;
	
	synpoz <= '0' when x > = 1306 and x < 1495 else '1';	--zaokrąglanie w góre
	synpion <= '0' when y >= 494 and y < 497 else '1';
	
	kolor <= "000" when x > 1259 or y >= 480 else
		obr(299 downto 297) when x >= posx and x < posx + 10 and y >= posy and y < posy + 10 else
		"010"; 	--zielony kolor tła
end arch_vga;
