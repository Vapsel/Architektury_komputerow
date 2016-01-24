entity PS2 is
	port(RESET: in std_logic;
		DATA: in std_logic;
		CLK: in std_logic;
		wy: out std_logic_vector(7 downto 0))
end PS2;

architecture arch_PS2 of PS2 is
	signal NrBitu:std_logic_vector(3 downto 0);
	signal rejestr: std_logic_vector(10 downto 0);
begin
	process(RESET, CLK)
	begin
		if(RESET = '1') then
			PRDATA <= (others => '1');
			S1 <= (others => '1');
			AKTSTAN <= '1';					
			NrBitu <= (others => '0');
			rejestr <= (others => '0');
			wy <= (others => '0');
		elsif(CLK'event and CLK = '0') then -- CLK = '1' ???
			PRDATA <= DATA & PRDATA(3 downto 1);					
			S1 <= CLK & S1(2 downto 1);
			if (CLK + S1(2) + S1(1) < 2 and AKTSTAN = '1') then
				AKTSTAN <='0';						
				NrBitu <= NrBitu + 1;
				if(PRDATA(4) + PRDATA(3) + PRDATA(2) + PRDATA(1) + DAtA > 2) then
					REJ <= '1' & REj(10 downto 1);
				else
					REJ <= '0' & REJ(10 downto 1);
				end if;
				if(NrBitu = 10) then
					NrBitu <= (others => '0');
					wy <= REJ(9 downto 2);
				end if;
			end if;
			if(CLK + S1(2) + S1(1) > 1 and AKTSTAN = '0') then
				AKTSTAN <= '1';
			end if;
		end if;
	end process;
end arch_PS2;