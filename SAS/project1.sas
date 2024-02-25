/*
libname 
	LAB01
	BASE
	"path.."
;

data wynik;
	SET LAB01.l01 end=e;
	retain s 0 p 1;
	s=s+n;
	p=p*n;
	if 1=e then put _all_;
run;
*/

/*
3. Napisać program znajdujący liczbę dni, które upłynęły od dnia urodzin piszącego program do dnia dzisiejszego. 
*/

dm 'clear log';

data _null_; * _null_ Nie tworzy nowego zbioru sasowego;
  format birthdate date9.; *date format 01FEB1999;
  birthdate = mdy(3, 9, 2002); *my birthdate;
  today = today(); 
  days_since_birth = today - birthdate;
  put "Liczba dni od urodzin do dzisiaj: " days_since_birth;
run;

* _______________________________;
4.
*/

data wyniki;
	input kod $ kol1 kol2 ocena;
	cards;
	AD11423 19 23 3.5
	AG19020 16 21 3
	AW93048 35 12 4
	RG04729  4 15 2
	DR03827  8 11 2
	;
run;

libname bibl "~/home/u63791642/sasuser.v94/datasets";

* dodanie nowego użytkownika i aktualizacja;
data bibl.wyniki;
    set wyniki end=last; 
	output;
	
    if last then do;
        kod = 'AC45632';
        kol1 = 13;
        kol2 = 29;
        ocena = 4;
        output;
	end;
    
	if kod = 'AG19020' then do;
        kol1 = 20;
        ocena = 3.5;
        output;
    end;
run;

* dodanie zmiennej wyniki;
data bibl.wyniki;
    set bibl.wyniki;
    suma = kol1 + kol2;
run;

proc print data=bibl.wyniki;
run;

* _____________________________________________;
* 5. Średnie ze zbioru wyniki z kolokwiów 1 i 2;

proc means data=bibl.wyniki mean;
    var kol1 kol2;
run;

* _______________________________;
* 7. Kopie iris. Polecenie delete;
data A;
    set sashelp.iris;
run;
data B;
    set sashelp.iris;
run;
data C;
    set sashelp.iris;
run;

proc datasets lib=work;
    delete A;
run;
proc datasets lib=work;
    delete B;
run;
proc datasets lib=work;
    delete C;
run;
	
