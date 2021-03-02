#/bin/bash
# Author           : Patryk Olszewski ( patols77@wp.pl )
# Created On       : 26.05.2020
# Last Modified By : Patryk Olszewski ( patols77@wp.pl )
# Last Modified On : 26.05.2020
# Version          : 1.0
#
# Description      :
# You will be a millionaire zenity game.
# 1000+ unique questions, 3 helpers and more...
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)



while [ $# -gt 0 ]; do
    case "$1" in
        -h|"-?"|--help)
            shift
            echo "usage: $0 [-h]"
	    echo "play zenity quiz"
	    echo "optional arguments:"
	    echo "-h, --help - show this help message and exit"	
            exit 0
            ;;
         *)
            echo "Error: unknown option '$1'"
            exit 1
        esac
done


audience() {
	#zadajmy pytanie do google'a
	ddgr --np -n 25 "$1" > zwrocWyszukiwanie.txt
	
	a1=${2::-1}
	b1=${3::-1}
	c1=${4::-1}
	d1=${5::-1}

	AA1=$(grep -i -o "$a1" zwrocWyszukiwanie.txt | wc -l) #wariant 1
	BB1=$(grep -i -o "$b1" zwrocWyszukiwanie.txt | wc -l) #wariant 2
	CC1=$(grep -i -o "$c1" zwrocWyszukiwanie.txt | wc -l) #wariant 3
	DD1=$(grep -i -o "$d1" zwrocWyszukiwanie.txt | wc -l) #wariant 4

	#wyswietlmy zlicozne powyzej odpowiedzi
	A4=" $AA1 gosci wybralo odp a.\n"
	B4="$BB1 gosci wybralo odp b.\n"
	C4="$CC1 gosci wybralo odp c.\n"
	D4="$DD1 gosci wybralo odp d.\n"
	WSUMIE="$A4 $B4 $C4 $D4"
	OSTATECZNYZEN=$(zenity --info --text "$WSUMIE" --title Glosowanie widowni\! --width 300 --height 500)

	#menu z wyborem odpowiedzi
	MENU=("$2" "$3" "$4" "$5")
	WARIANTY23=$(zenity --list --column="$1" "${MENU[@]}" --height 500 --width 700 --text "$PYTPYT")
	if [[ $WARIANTY23 == $6 ]]; then
		STATUSP=1
	else
		STATUSP=0
	fi
}

wujek() {
	WUJEK0="Dzwonimy do naszego eksperta..."
	WUJEK1=$(zenity --info --text "$WUJEK0" --title Polaczenie... --width 250 --height 100)
	echo $WUJEK1
	#pytanie wysylamy do google'a i zapisujemy w pliku
	ddgr --np -n 1 "$1" > opiniaWujka.txt	
	awc=1
	WUJA1="Okej, znalazlem w ksiazce taki fragment:"
	sed -i "${awc}s/.*/${WUJA1}/" opiniaWujka.txt
		
	#wyswietlamy odpowiedz
	WUJA2=$(cat opiniaWujka.txt)
	WUJEK3=$(zenity --info --text "$WUJA2" --title Polaczenie... --width 450 --height 200)
	echo $WUJEK3

	WUJEK4="CZAS NA ROZMOWE DOBIEGL KONCA!!!"
	WUJEK5=$(zenity --info --text "$WUJEK4" --title "Polaczenie zakonczone." --width 250 --height 100)
	echo $WUJEK5

	MENU=("$2" "$3" "$4" "$5") #panel z odpowiedzeniem na pytnaie
	WARIANTY23=$(zenity --list --column="$1" "${MENU[@]}" --height 500 --width 700 --text "$PYTPYT")
	if [[ $WARIANTY23 == $6 ]]; then
		STATUSP=1
	else
		STATUSP=0
	fi	
}

polnapol() {
	#odrzucmy dwie losowe oodpowiedzi
	if [[ $2 == $6 ]]; then
		POPRAWNA=$2
		LOSOWA2=$((RANDOM % 3))
		if [[ $LOSOWA2 -eq 0 ]]; then
			NIEPOPRAWNA=$3
		elif [[ $LOSOWA2 -eq 1 ]]; then
			NIEPOPRAWNA=$4
		elif [[ $LOSOWA2 -eq 2 ]]; then
			NIEPOPRAWNA=$5
		fi
	elif [[ $3 == $6 ]]; then
		POPRAWNA=$3
		LOSOWA2=$((RANDOM % 3))
		if [[ $LOSOWA2 -eq 0 ]]; then
			NIEPOPRAWNA=$5
		elif [[ $LOSOWA2 -eq 1 ]]; then
			NIEPOPRAWNA=$4
		elif [[ $LOSOWA2 -eq 2 ]]; then
			NIEPOPRAWNA=$2
		fi
	elif [[ $4 == $6 ]]; then
		POPRAWNA=$4
		LOSOWA2=$((RANDOM % 3))
		if [[ $LOSOWA2 -eq 0 ]]; then
			NIEPOPRAWNA=$2
		elif [[ $LOSOWA2 -eq 1 ]]; then
			NIEPOPRAWNA=$5
		elif [[ $LOSOWA2 -eq 2 ]]; then
			NIEPOPRAWNA=$3
		fi
	elif [[ $5 == $6 ]]; then
		POPRAWNA=$5
		LOSOWA2=$((RANDOM % 3))
		if [[ $LOSOWA2 -eq 0 ]]; then
			NIEPOPRAWNA=$3
		elif [[ $LOSOWA2 -eq 1 ]]; then
			NIEPOPRAWNA=$2
		elif [[ $LOSOWA2 -eq 2 ]]; then
			NIEPOPRAWNA=$4
		fi
	fi

	#niech gracz wybierze jedna z tych dwoch odpowiedzi
	LOSOWA3=$((RANDOM % 2))
	if [[ $LOSOWA3 -eq 0 ]]; then
	MENU2=("$POPRAWNA" "$NIEPOPRAWNA") 
	else
	MENU2=("$NIEPOPRAWNA" "$POPRAWNA")
	fi
	WARIANTYP=$(zenity --list --column="Kolo ratunkowe - 50/50" "${MENU2[@]}" --height 500 --width 700 --text "$PYTPYT")
	echo $WARIANTYP
	if [[ $WARIANTYP == $POPRAWNA ]]; then
		odppp=$POPRAWNA
	elif [[ $WARIANTYP == $NIEPOPRAWNA ]]; then	
		odppp=$NIEPOPRAWNA	
	fi

	if [[ $odppp == $6 ]]; then
		STATUSP=1
	else
		STATUSP=0
	fi
}

pytanie() {
	LOSOWA=$((1 + RANDOM % $ILE_PYTAN)) #losujemy numer pytania
	LINIA=$(expr 6 \* $LOSOWA + 1) #dostajemy sie do linii z tym pytaniem

	LITERKA=-2
	KONIEC_PETLI=$(($LINIA + 5))
	declare -A TAB
	LICZ=0
	while [ $LINIA -lt $KONIEC_PETLI ]
	do
		LITERKA=$((LITERKA+1))
		if [[ $LITERKA -gt -1 ]]; then #dodajmy do tablicy odpowiedzi na pytanie
			TEMP1=$(sed "${LINIA}q;d" pytaniaFinal.txt)
			TEMP2=${TABLICA_LITER[$LITERKA]}
			PYTANIE="${TEMP2} ${TEMP1}"
			TAB[$LICZ]=$PYTANIE
		else
			PYTPYT=$(sed "${LINIA}q;d" pytaniaFinal.txt) 
		fi
		LINIA=$((LINIA + 1))
		LICZ=$((LICZ + 1))
	done

	POPRAWNA_ODP=$(sed "${LINIA}q;d" pytaniaFinal.txt)
	
	#dodajmy do tablicy kola ratunkowe
	if [[ $PUZYTE -eq 0 ]]; then
		TAB[5]="Pol na pol"
	else
		TAB[5]="NIEDOSTEPNE"
	fi
	if [[ $AUZYTE -eq 0 ]]; then
		TAB[6]="Pytanie do publicznosci"
	else
		TAB[6]="NIEDOSTEPNE"
	fi
	if [[ $WUZYTE -eq 0 ]]; then
		TAB[7]="Telefon do eksperta"
	else
		TAB[7]="NIEDOSTEPNE"
	fi


	MENU=("${TAB[1]}" "${TAB[2]}" "${TAB[3]}" "${TAB[4]}" "${TAB[5]}" "${TAB[6]}" "${TAB[7]}")
	WARIANTY=$(zenity --list --column="$1" "${MENU[@]}" --height 500 --width 700 --text "$PYTPYT")
	echo $WARIANTY #wyswietlmy odpowiedzi


	if [[ $WARIANTY == "Pol na pol" ]]; then #jesli wybrano kolo ratunkowe 1
		PUZYTE=1
		LINIA=$((LINIA-5))
		STR1=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR2=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR3=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR4=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR5=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR6=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		polnapol "$STR1" "$STR2" "$STR3" "$STR4" "$STR5" "$STR6"
		if [[ $STATUSP -eq 1 ]]; then
			ODPOWIEDZ=$POPRAWNA_ODP
		else
			ODPOWIEDZ=""
		fi
	elif [[ $WARIANTY == "Pytanie do publicznosci" ]]; then #jesli wybrano kolo ratunkowe 2
		AUZYTE=1
		LINIA=$((LINIA-5))
		STR1=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR2=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR3=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR4=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR5=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR6=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		audience "$STR1" "$STR2" "$STR3" "$STR4" "$STR5" "$STR6"
		if [[ $STATUSP -eq 1 ]]; then
			ODPOWIEDZ=$POPRAWNA_ODP
		else
			ODPOWIEDZ=""
		fi
	elif [[ $WARIANTY == "Telefon do eksperta" ]]; then #jesli wybrano kolo ratunkowe 3
		WUZYTE=1
		LINIA=$((LINIA-5))
		STR1=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR2=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR3=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR4=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR5=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		LINIA=$((LINIA+1))
		STR6=$(sed "${LINIA}q;d" pytaniaFinal.txt)
		wujek "$STR1" "$STR2" "$STR3" "$STR4" "$STR5" "$STR6"
		if [[ $STATUSP -eq 1 ]]; then
			ODPOWIEDZ=$POPRAWNA_ODP
		else
			ODPOWIEDZ=""
		fi
	elif [[ $WARIANTY == "NIEDOSTEPNE" ]]; then #jesli wybrano kolo ratunkowe, ktore bylo juz uzyte
		blad1="Proba oszustwa! To kolo jest niedostepne! Pytanie niezaliczone!"
		blad22=$(zenity --info --text "$blad1" --title "Wykryto probe oszustwa!" --width 250 --height 100)
		echo $blad22
	elif [[ $WARIANTY == "" ]]; then #jesli nie wybrnano nic (wcisnieto cancel lub krzyzyk)
		blad1="Nie znasz odpowiedzi? Przegrywasz!"
		blad22=$(zenity --info --text "$blad1" --title "Tchorzostwo!" --width 250 --height 100)
	elif [[ $WARIANTY == ${TAB[1]} ]]; then #wybranie jednej z odpowiedzi...
		LINIA=$((LINIA - 4))
		ODPOWIEDZ=$(sed "${LINIA}q;d" pytaniaFinal.txt)
	elif [[ $WARIANTY == ${TAB[2]} ]]; then
		LINIA=$((LINIA - 3))
		ODPOWIEDZ=$(sed "${LINIA}q;d" pytaniaFinal.txt)
	elif [[ $WARIANTY == ${TAB[3]} ]]; then
		LINIA=$((LINIA - 2))
		ODPOWIEDZ=$(sed "${LINIA}q;d" pytaniaFinal.txt)
	elif [[ $WARIANTY == ${TAB[4]} ]]; then
		LINIA=$((LINIA - 1))
		ODPOWIEDZ=$(sed "${LINIA}q;d" pytaniaFinal.txt)
	fi

	#sprawdzmy poprawnosc odpowiedzi
	if [[ $ODPOWIEDZ == $POPRAWNA_ODP ]]; then
		KKKT="Brawo, $IMIE\!\nOdpowiedziales poprawnie!"
		PSIKUT=$(zenity --info --text "$KKKT" --title "POPRAWNA ODP!" --width 250 --height 100)
		STATUS="WIN"
	else
		STATUS="LOSE"
	fi
}


#Skrypt zaczyna swoja prace. Wyswietlmy komunikaty informacyjne
STARTE=$(zenity --info --text "Witamy w grze Milionerzy!" --title MILIONERZY\! --width 250 --height 100)
echo $STARTE
STARTE1=$(zenity --info --text "Zasady gry jak w Milionerach z TVN. Przez cala gre (12 pytan) mozesz uzyc lacznie 3 kola ratunkowe, ale 
w danym pytaniu mozesz uzyc tylko jednego z nich!" --title ZASADY\! --width 250 --height 100)
echo $STARTE1
STARTE1=$(zenity --info --text "Pierwsze kolo ratunkowe to pol na pol. Odrzuci dwie bledne odpowiedzi." --title ZASADY\! --width 250 --height 100)
echo $STARTE1
STARTE1=$(zenity --info --text "Drugie kolo ratunkowe to pytanie do publicznosci. Wyswietlimy po chwili ile osob na co glosowalo." --title ZASADY\! --width 250 --height 100)
echo $STARTE1
STARTE1=$(zenity --info --text "Trzecie to telefon do eksperta. Zwroci ci fragment ksiazki, ktora ma pod reka." --title ZASADY\! --width 250 --height 100)
echo $STARTE1

#zmienne potrzebne do zarzadzania pytaniami
ILE_PYTAN=1012
TABLICA_LITER=("a" "b" "c" "d")
TAB2=("Pierwsze" "Drugie" "Trzecie" "Czwarte" "Piate" "Szoste" "Siodme" "Osme" "Dziewiate" "Dziesiate" "Jedenaste" "Dwunaste") 
TAB3=("0 zl" "500 zl" "1,000 zl" "2,000 zl" "5,000 zl" "10,000 zl" "20,000 zl" "40,000 zl" "75,000 zl" "125,000 zl" "250,000 zl" "500,000 zl" "1,000,000 zl")
POZIOM=0
ILE_POZIOMOW=12


IMIE=$(zenity --entry --title "Przedstaw sie" --text "Podaj swoje imie: ")
if [[ $IMIE == "" ]]; then #jesli ktos nie poda imienia, to ustawiamy podstawowe imie
	blad01="Szanujemy twoja anonimosc :) Damy ci losowe imie..."
	blad022=$(zenity --info --text "$blad01" --title "Nie podano nicku!" --width 250 --height 100)
	echo $blad22
	IMIE="Gal Anonim"
fi
#zmienne odpowiadajce za zuzycie kol ratunkowych
PUZYTE=0
WUZYTE=0
AUZYTE=0
while [[ $POZIOM -lt $ILE_POZIOMOW ]]
do
#obsluga pytania
	TEMP=$((POZIOM+1))
	KOMUN="${TAB2[$POZIOM]} pytanie (za ${TAB3[$TEMP]}):"
	pytanie "$KOMUN"
	if [[ $STATUS == "WIN" ]]; then
		POZIOM=$((POZIOM+1))
	else
		KKKK="ZLA ODPOWIEDZ!!!"
		PSIKUT=$(zenity --info --text "$KKKK" --title PRZEGRALES\! --width 250 --height 100)
		echo $PSIKUT
		break
	fi

done

#wyswietlmy komunikat na koniec gry
OSTATECZNY="Brawo, $IMIE\! Wygrales kwote ${TAB3[$POZIOM]}"
OSTATECZNYZEN=$(zenity --info --text "$OSTATECZNY" --title "KONIEC GRY!" --width 250 --height 100)
echo $OSTATECZNYZEN





