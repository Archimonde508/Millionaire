#/bin/bash

#najpierw usunmy niepotrzebne spacje, gwiazdki, odstepy, numery pytan
sed 's/-----------------------------------------------------------------------------//' pytania1.txt | sed 's/Answer://' | sed 's/  *//' | sed 's/*//' | grep -v '^[[:space:]]*$' | sed 's/#[0-9][0-9][0-9][0-9] //' > pytania2.txt

#niektore pytania zajmuja dwie linijki, ale zawsze koncza sie znakiem '?'
#Niestety, znak '?' wystepuje nie tylko w pytaniach
tr -cd '?' < pytania2.txt | wc -c 
#pytan jest 1012, zas znak '?' wystepuje 10 razy nizej
#usunmy te niepotrzebne znaki zapytania:

sed 's/Love?/Love/' pytania2.txt | sed 's/Cashpoint?/Cashpoint/' | sed 's/Bus Stop?/Bus Stop/' | sed 's/Chip Shop?/Chip Shop/' | sed 's/to me?/to me/'  | sed 's/Sorry Now?/Sorry Now/' |sed 's/ on?/ on/' | sed 's/Which?/Which/' > pytaniaFinal.txt

tr -cd '?' < pytaniaFinal.txt | wc -c #liczba znakow zapytania = liczba pytan

LICZNIK=1 
KONIEC_PETLI=$(expr 6 \* 1012) #tyle bedzie linijek, skoro kazde z 1012 pytan bedzie miec 6 linijek

while [ $LICZNIK -lt $KONIEC_PETLI ] #do konca pliku
do
	LICZNIK2=$((LICZNIK+1))
	TEST=$(sed "${LICZNIK2}q;d" pytaniaFinal.txt) #sprawdzmy co jest linijke wyzej

	if [[ $TEST == *"?"* ]]; then # sprawdzamy czy w test jest '?'
		PIERWSZY_WYRAZ=$(sed "${LICZNIK}q;d" pytaniaFinal.txt) #wezmy wyraz z wyzej linijki
		PIERWSZY_WYRAZ_POPRAWIONY="${PIERWSZY_WYRAZ::-1}" #usunmy znak konca linii lub cos tam co powoduje niedzialanie
		FINAL="${PIERWSZY_WYRAZ_POPRAWIONY} ${TEST}" #polaczmy go z tym nizej
		sed -i "${LICZNIK}s/.*/${FINAL}/" pytaniaFinal.txt #polaczony wyraz wstawiamy do wyzszej linijki
		sed -i "${LICZNIK2}d" pytaniaFinal.txt #nizsza linijke usuwamy
	fi

	LICZNIK=$((LICZNIK+6)) #przejdzmy do pierwszej linii kolejnego pytania
done

wc -l pytaniaFinal.txt #powinno zwrocic 6 * 1012 czyli 6072
#w czterech miejscach zwrocony jest blad najprawdopodobniej spowodowany wystepowaniem znaku "'", ale nie wplywa to na dzialanie algorytmu
