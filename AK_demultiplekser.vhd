entity demultiplekser is
	port(	Adres_wyjścia 	: in 	std_logic_vector (1 downto 0);
		Wyjście		: out   std_logic_vector (3 downto 0);
		Wejście		: in	std_logic;
		);
end demultiplekser;

architecture arch_demultiplkser of demultiplekser is

	begin
		Wyjście(0) <= Wejście when Adres_wyjścia = "00" else '0';
		Wyjście(1) <= Wejście when Adres_wyjścia = "01" else '0';
		Wyjście(2) <= Wejście when Adres_wyjścia = "10" else '0';
		Wyjście(3) <= Wejście when Adres_wyjścia = "11" else '0';

end arch_demultiplkser;
	
