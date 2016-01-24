entity proc is 
	port(pam_prog_adr: out std_logic_vector(31 downto 0); --pamięć programu
		 pam_prog_dane: in std_logic_vector(31 downto 0); 
		 pam_dan_adr1: out std_logic_vector(31 downto 0); --pamięc danych
		 pam_dan_dane1: in std_logic_vector(31 downto 0);
		 pam_dan_adr2: out std_logic_vector(31 downto 0);
		 pam_dan_dane2: out std_logic_vector(31 downto 0);
		 CLK: in std_logic;
		 RESET: in std_logic;
		 zapis_pam: out std_logic; )
	end port;

architecture arch_proc of proc is
	signal cykl std_logic_vector(2 downto 0); --potrzebujemy 5 cykli
	signal L_ROZK, R_ROZK, R_ARG, A, B, C;
begin
	process(CLK, RESET)
	begin
		if(RESET = '1') then --zerowanie wszystkiego
			pam_prog_adr <= (others => '0');
			pam_dan_adr1 <= (others => '0');
			pam_dan_adr2 <= (others => '0');
			pam_dan_dane2 <= (others => '0');
			zapis_pam <= '0';
			cykl <= (others => '0');
			L_ROZK <= (others => '0');
		elsif(CLK'event and CLK = '1') then -- najpierw zwiększamy cykl
			cykl <= cykl + 1;
			zapis_pam <= '0'; --zerowanie sygnału clk do pamięci
			if(cykl = 0) then 
				R_ROZK <= pam_prog_dane; -- zapis do rejestru rozkazów
			else 
----------------------------- PAM -> A ----------------------------- schemat w zeszycie 
				if(R_ROZK = 1) then 
					if(cykl = 1) then
						L_ROZK <= L_ROZK + 1; --zwiększamy licznik rozkazów
					elsif(cykl = 2) then
						R_ARG <= pam_prog_dane; --zapis do rejestru argumentów
					else --cykl = 3
						A <= pam_dan_dane1; --wykonanie operacji
						L_ROZK <= L_ROZK + 1;
						cykl <= (others => '0'); -- zerowanie cykli po każdej operacji
					end if;
----------------------------- PAM -> B -----------------------------					
				elsif(R_ROZK = 2) then 
					if(cykl = 1) then
						L_ROZK <= L_ROZK + 1;
					elsif(cykl = 2) then
						R_ARG <= pam_prog_dane;
					else --cykl = 3
						B <= pam_dan_dane1;
						L_ROZK <= L_ROZK + 1;
						cykl <= (others => '0');
					end if;
----------------------------- C -> PAM -----------------------------					
				elsif(R_ROZK = 3) then
					if(cykl = 1) then
						L_ROZK <= L_ROZK + 1;
					elsif(cykl = 2) then
						R_ARG <= pam_prog_dane;
					elsif(cykl = 3) then
						pam_dan_adr2 <= R_ARG;
						pam_dan_dane2 <= C;
					else --cykl 4
						zapis_pam <= '1';
						L_ROZK <= L_ROZK + 1;
						cykl <= (others => '0');
					end if;
----------------------------- Skok bezwarunkowy -----------------------------					
				elsif(R_ROZK = 4) then
					if(cykl = 1) then
						L_ROZK <= L_ROZK + 1;
					elsif(cykl = 2) then
						R_ARG <= pam_prog_dane;
					else
						L_ROZK <= R_ARG;
						cykl <= (others => '0');
					end if;
----------------------------- Skok warunkowy -----------------------------					
				elsif(R_ROZK = 5) then 
					if(cykl = 1) then
						L_ROZK <= L_ROZK + 1;
					elsif(cykl = 2) then
						R_ARG <= pam_prog_dane;
					else
						if( C = 0) then --jeżeli warunek jest spełniony
							L_ROZK <= R_ARG;
						else
							L_ROZK <= L_ROZK + 1;
						end if;
						cykl <= (others => '0');
					end if;
----------------------------- Operacje arytmetyczno-logiczne (ALU) -----------------------------		
				elsif(R_ROZK = 6) then
					if(cykl = 1) then		--rozkazy: 6  7   8  9
						C <= A or B; 		--        or and not +
						L_ROZK <= L_ROZK + 1;
						cykl <= (others => '0');
					end if;
				end if;
			end if;
		end if;
	end process;
end arch_proc;