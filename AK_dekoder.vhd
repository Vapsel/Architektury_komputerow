entity dekoder is
	port(	Adres_wyjścia 	: in 	std_logic_vector (1 downto 0);
		Wyjście		: out   std_logic_vector (3 downto 0);
		);
end dekoder;

architecture arch_dekoder of dekoder is

	begin
		Wyjście(0) <= '1' when Adres_wyjścia = "00" else '0';
		Wyjście(1) <= '1' when Adres_wyjścia = "01" else '0';
		Wyjście(2) <= '1' when Adres_wyjścia = "10" else '0';
		Wyjście(3) <= '1' when Adres_wyjścia = "11" else '0';

end arch_dekoder;
	
