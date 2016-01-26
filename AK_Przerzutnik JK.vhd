
--					|	RESET
--					v
--				|-----------|
--		J		|			|	Q
--		------->|			|----->
--				|			|
--		K		|			|	NQ
--		------->|			|----->
--				|			|
--				|-----------|
--					^
--					|	CLK

-- Tabela prawdy

--	J	K	Q
--	1	0	1
--	0	1	0
--	0	0	Q (podtrzymywanie stanu)
--	1	1  	-Q (zmiana stanu na przeciwny)


entity JK is
	port(	CLK: in std_logic;
		J: in std_logic;
		K: in std_logic;
		Q: out std_logic;
		NQ: out std_logic;
		RESET: in std_logic);
end JK;

architecture arch_JK of JK is
begin
	process(RESET, CLK)
	begin
		if(RESET = '1') then
			Q <= '0';
			NQ <= '1';
		elsif(CLK'event and CLK = '1') then
			if(J = '1' and K = '0') then
				Q <= '1';
				NQ <= '0';
			elsif(J = '0' and K = 1') then
				Q <= '0';
				NQ <= '1'
			elsif(J = '1' and K = '1') then
				Q <= not Q;
				NQ <= not NQ;
			-- Jeżeli J=0 i K=0 to nie trzeba nic zmieniać (podtrzymywanie stanu)
			end if;
		end if;
	end process;
end arch_JK;
