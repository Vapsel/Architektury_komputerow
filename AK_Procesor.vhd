entity proc is
	port (
		pam_prog_adr   : out std_logic_vector(31 downto 0); --pamięć programu
		pam_prog_dane  : in std_logic_vector(31 downto 0);
		pam_dan_adr1   : out std_logic_vector(31 downto 0); --pamięć danych
		pam_dan_dane1  : in std_logic_vector(31 downto 0);
		pam_dan_adr2   : out std_logic_vector(31 downto 0);
		pam_dan_dane2  : out std_logic_vector(31 downto 0);
		CLK            : in std_logic;
		RESET          : in std_logic;
		zapis_pam      : out std_logic; )
end proc;

architecture arch_proc of proc is
	signal cykl std_logic_vector(1 downto 0); --potrzebujemy 4 cykli
	signal L_ROZK, R_ROZK, R_ARG, A, B, C std_logic_vector(31 downto 0);
begin
	process (CLK, RESET)
	begin
		if (RESET = '1') then --zerowanie wszystkiego
			pam_prog_adr <= (others => '0'); -- Zaczynamy program od pierwszego rozkazu
			pam_dan_adr1 <= (others => '0');
			pam_dan_adr2 <= (others => '0');
			pam_dan_dane2 <= (others => '0');
			zapis_pam <= '0';
			cykl <= (others => '0');
			L_ROZK <= (others => '0');
		elsif (CLK'event and CLK = '1') then -- najpierw zwiększamy cykl
			cykl <= cykl + 1;
			zapis_pam <= '0'; --zerowanie sygnału CLK do pamięci
			if (cykl = 0) then
				R_ROZK <= pam_prog_dane; -- zapis do rejestru rozkazów
				
			elsif (cykl = 1) then           -- Dla każdej opercji najpierw
				L_ROZK <= L_ROZK + 1;       -- zwiększamy licznik rozkazów i 
				pam_prog_adr <= L_ROZK + 1; -- przekazujemy go stan do pamięci programu
				
				-------- Operacje logiczne --------- 
				if (R_ROZK = 6) then --rozkazy: 6,   7,   8,  9
					C <= A or B;    --operacje: or, and, not, +
					L_ROZK <= L_ROZK + 1;
					pam_prog_adr <= L_ROZK + 1l
					cykl <= (others => '0');
				end if;
					
			elsif (cykl = 2) then
				R_ARG <= pam_prog_dane; -- Zapis danych do rejestru argrumentów dla skoków
				pam_dan_adr1 <= pam_prog_dane; -- Ustalamy odpowiedni adres pamięci, z którego będziemy odczytywać później dane
				if (R_ROZK = 3) then -- C->PAM
					pam_dan_adr2 <= R_ARG; -- Adres w pamięci do którego zapisujemy dane
					pam_dan_dane2 <= C;
				end if;
			
			elsif (cykl = 3) then
				L_ROZK <= L_ROZK + 1;
				pam_prog_adr <= L_ROZK + 1;
				cykl <= (others => '0'); -- Po każdej opercji zerujemy cykl
				--------- PAM->A ---------
				if (R_ROZK = 1) then 
					A <= pam_dan_dane1; -- pobieramy dane do rejestru A
				-------- PAM->B ----------
				elsif (R_ROZK = 2) then 
					B <= pam_dan_dane1; -- pobieramy dane do rejestru B
				-------- C->PAM ----------
				elsif (R_ROZK = 3) then 
					zapis_pam <= '1';
				--- Skok bezwarunkowy ----
				elsif (R_ROZK = 4) then 
					L_ROZK <= R_ARG;
					pam_prog_adr <= R_ARG;
				----- Skok warunkowy -----
				elsif (R_ROZK = 5) then 
					if (C = 0) then -- Jeżeli warunek jest spełniony
						L_ROZK <= R_ARG;
						pam_prog_adr <= R_ARG;
					end if;
				end if;
			end if;
		end if;
	end process;
end arch_proc;
