*grouping;


/*
DATA;
If you omit the arguments, the DATA step automatically
names each successive data set that you create as DATAn,
where n is the smallest integer that makes the name
unique.

SET;
When you execute a DATA or PROC step without specifying 
an input data set, by default, SAS uses the _LAST_ data set.

*/


data a;
  x=1;output;
  x=2;output;
  x=3;output;
  x=4;output;
  x=5;output;
run;

/* jeszcze troche o poleceniu SET */

data b2;
  set a END = moja_zmienna_na_koniec;
  if moja_zmienna_na_koniec then output;
  put _all_;
run;
/* moja_zmienna_na_koniec nie jest wypisywana do zbioru */
data b2;
  set a end = moja_zmienna_na_koniec;
  M_Z_N_K = moja_zmienna_na_koniec;
  put _all_;
run;

/* nazwa zbioru, w ktorym procesujemy */
data b2;
  set a INDSNAME = moja_nazwa_zbioru;
  put _all_;
run;

/* dlugosc? */
data b2;
  length moja_nazwa_zbioru $ 41; /* lib.8+dot.1+set.32 */
  set a INDSNAME = moja_nazwa_zbioru;
run;

/* moja_nazwa_zbioru nie jest wypisywana do zbioru */
data b2;
  length moja_nazwa_zbioru $ 41; /*lib.8+dot.1+set.32*/
  set a indsname = moja_nazwa_zbioru;
  M_N_Z = moja_nazwa_zbioru;
run;

/*
  numer wlasnie wczytanej obserwacji -> zobacz przyklad
  z dokumentacji "Finding the Current Observation Number"
*/
data b2;
  set a CUROBS = wlasnie_wczytana_obserwacja;
  put _all_;
run;

data b2;
  set a CUROBS = wlasnie_wczytana_obserwacja;
  W_W_O = wlasnie_wczytana_obserwacja;
run;


/* liczba obserwacji w zbiorze - uwaga, dostepna na etapie kompilacji */
data b2;
  set a NOBS = liczba_obserwacji_w_zbiorze;
  put _all_;
run;

data b2;
  set a NOBS = liczba_obserwacji_w_zbiorze;
  L_O_W_Z = liczba_obserwacji_w_zbiorze;
run;

data b2;
  if 0 then set a NOBS = liczba_obserwacji_w_zbiorze;
  L_O_W_Z = liczba_obserwacji_w_zbiorze;
  put _all_;
run;

/*
data a;
  do i = 1 to 10;
    output;
  end;
run;

data a2;
  do j = 1 to 10;
    output;
  end;
run;


data b;
  if 0=mod(_N_,3) then SET A;
run;

data b;
  if 0=mod(_N_,2) then SET A;
run;

data b;
  if 0=mod(_N_,1) then SET A;
run;
data b;
  if 1 then SET A;
run;
data b;
  SET A;
run;

data b;
  set a2;
  if 0=mod(_N_,3) then SET A;
run;
*/

* hfgfdffhgfjh ;
%* jhgfjhghj ;



data a;
  x=1;output;
  x=2;output;
  x=3;output;
  x=4;output;
  x=5;output;
run;

data b2;
 x = 5;
 set a;
run;
/*
  tabela 'b2' ma jedna zmienna 'x', wydawac by sie moglo,
  ze 'x' ma wszedzie piatki, ale te piatki sa nadpisywane
  przez wartosci wczytane z tabeli 'a'
*/

/* jeszcze 2 slowa o petlach */

data loop_0;
  do I = 1 by 0;
    J + 1; /* sum statement: retain J 0; J = sum(J, 1); 
              zmienna + <wyrazenie>; 
              np. x + (y + z);
            */
    output;
    if J > 10 then leave;
  end;
run;


data loop_1;
  call streaminit(2024);

  do I = 1 to 1d6 by 1 until(exit > 0.9);  /* 1e6 = 1000000 = 1d6 */
    exit = rand('uniform');
    output;
  end;
run;


data loop_2;
  call streaminit(2024);

  do J = 5 by -1 while(J > 0);

    test = rand('uniform');
    if (test > 0.5) then
      do I = 1 by 1 until(exit1 > 0.9);
        exit1 = rand('uniform');
        output;
      end;
    else
      do I = -1 by -1 until(exit2 < 0.1);
        exit2 = rand('uniform');
        output;
      end;

  end;

run;

data _null_;
  do i = 42 until(j>17); /* ! */
    j+1;
    put _all_;
  end;
run;


/*
do i = S1 <to E1 <by B1 <until|while(C1)>>>
     <,S2 <to E2 <by B2 <until|while(C2)>>>>
      ....
     <,Sn <to En <by Bn <until|while(Cn)>>>>
   ;

...

end;
*/



/** Przetwarzanie w grupach; */
/** BY-group processing; */

data a / NESTING; /*pomocniczy zbior testowy*/
    do x='a','b','c';
        do y='AA','BB','CC';
            z=FLOOR(10*RANUNI(17));
            u=floor(10*ranuni(42));
            output;
        end;
    end;
run;
proc print data = a;
run;

data b;
    set a;
    BY x;
run;
/*
  WAZNE zbior musi byc posortowany 
  po zmiennej grupujacej
*/
/*
  Polecenie BY
  grupuje obserwacje wzglÄdem zmiennej 'x' 
  i dodaje dwie ukryte zmienne systemowe: 
  first.x oraz last.x,
  ktore dzialaja tak, ze: 
  first.x = 1 dla pierwszej obserwacji 
              w kazdej grupie, 
  last.x = 1 dla ostatniej obserwacji 
             w kazdej z grup, 
  poza tym zera
*/


data b;
    set a;
    by y;
run;
/* y nie byl posortowany i pojawiĹ siÄ komunikat:
  "BLAD: Zmienne BY nie sa prawidlowo posortowane
   w zbiorze"
*/

/*a tu jest "zywy" dowod istnienia dodatkowych
  zmiennych first.x i last.x */
data b;
    set a;
    by x;
    putlog _all_;
run;

data b2;
    set a;
    by x;
    fx = first.x;
    lx = last.x;
run;
proc print;
run;


data b3;
 set a;
 by x;
    if (1 = first.x) then output;
run;
proc print;
run;
/*ten kod wypisuje w tabeli tylko pierwsza 
  obserwacje w kazdej grupie
*/

data b4;
    put "stan wektora PDV: " _all_;
    set a;
    by x;
run;

data b5;
    put "stan wektora PDV: " _all_;
    if 0 then 
      do;
          set a;
          by x;
      end;
    stop;
run;
/*
  ten kod uswiadamia, ze utworzenie zmiennych
  first.x i last.x nastepuje juz w fazie
  kompilacji
*/

/*
  UWAGA, to gdzie zdeklarujemy przypiasnie zmiennej
  wartosci ze zmiennej FIRST. lub LAST. ma 
  znaczenie!
*/
/*miedzy tym kodem i kolejnym 
  jest roznica w wyswietlaniu!!! 
  pierwszy wypisuje "niepoprawnie",
  tzn. faktyczny stan zmiennych first.x i last.x 
  jest inny niĹź wyĹwietlonych fx i lx
*/
data b6;
                  put 'Stan wektora PDV:';
                  put '1 data   ' _all_;
  fx=first.x;
  lx=last.x;
                  put '2 przyp  ' _all_;
  set a;
  by x;
                  put '3 set    ' _all_;
  output;
                  put '4 output ' _all_;
run;

data b7;
                  put 'Stan wektora PDV:';
                  put '1 data   ' _all_;
  set a;
  by x;
                  put '2 set    ' _all_;
  fx=first.x;
  lx=last.x;
                  put '3 przyp  ' _all_;
  output;
                  put '4 output ' _all_;
run;
/************************************/

/*mozna grupowac po wiecej niz jednej zmiennej, 
  lecz wczesniej dobrze jest zastosowac sortowanie
 (help radzi zeby sortowac zmienne w takiej samej
  kolejnosci jak potem chcemy ich uzyc w 'BY')
*/
proc SORT data = a;
  by x y;
run;

/*CIEKAWOSTKA, jesli zbior jest juĹź posortowany po
  zmiennych, ktore wylistowalismy, to SAS nie
  bedzie drugi raz sortowal */
proc CONTENTS 
  data = a 
  out  = info
;
run;

proc SORT data = a;
  by x y;
run;

data b8;
  set a;
  by x y;
  put _all_;
run;

data a / NESTING; /*pomocniczy zbior testowy*/
  do x = 'a', 'b', 'c';
    do y = 'AA', 'BB', 'BB', 'CC'; /* BB jest 2 razy */
      z = floor(10 * ranuni(17));
      u = floor(10 * ranuni(42));
      output;
    end;
  end;
run;
proc CONTENTS 
  data = a 
  out  = info
;
run;

data b9;
  set a;
  by x y;
  put _all_;
run;

/* uwaga o kolejnosci */
data a; /*pomocniczy zbior testowy*/
 do i = 3 to 1 by (-1); /* moze byc -1*/
  do j = 1 to 4;
   x = ranuni(0); 
   output;
  end;
 end;
 drop j;
run;
proc print;
run;


data b;
/* grupuje po 'i', 
   ale 'i' jest posortowane malejaco 
   wiec bedzie BLAD!*/
 set a;
 by i;
run;

data b;
/* wystarczy dodac DESCENDING przed 'i' 
   i bedzie dobrze :-)*/
 set a;
 by DESCENDING i;
 putlog _ALL_;
run;

data a; /* pomocniczy zbior testowy */
 do i = 3 to 1 by (-1);
  do j = 1,1,2,2;
   x = ranuni(0); 
   output;
  end;
 end;
run;
proc print;
run;


data b;
 set a;
 by DESCENDING i j; /* descending dotyczy tylko i */
 putlog _ALL_;
run;

data b_Error;
 set a;
 by DESCENDING i DESCENDING j; /* descending dotyczy i oraz j */
 putlog _ALL_;
run;


data a;/*pomocniczy zbior testowy*/
 do i = "A", "B", "A", "C";
  do j = 1 to 3;
   x=ranuni(0);
   output;
  end;
 end;
run;
proc print;
run;

data b;
/*grupuje po 'i', ale 'i' nie jest posortowane 
  malejaco wiec bedzie BLAD! */
 set a;
 by i;
run;

data b;
/* wystarczy dodac NOTSORTED przed 'i' 
   i bedzie dobrze :-)*/
 set a;
 by NOTSORTED i;
 putlog _all_;
run;

/* SORTOWANIE */
/* PROC SORT */

data z;
 input x y;
cards;
2 3
23 25
23 22
2 4
23 22
1 2
1 2
;
run;

PROC CONTENTS data = z;
run;

/*
 do posortowania ('proc SORT') 
 wez dane ze zbioru 'z' ('data = z') 
 i posortuje je po zmiennej 'x' ('by x'), 
 a wynik zapisz do zbioru 'zs1' ('out = zs1')
*/
proc SORT DATA=z OUT=zs1;
 BY x;
run;

PROC CONTENTS data = zs1;
run;



data z(SORTEDBY = x);
 input x y;
cards;
2 3
23 25
23 22
2 4
23 22
1 2
1 2
;
run;

PROC CONTENTS data = z;
run;


proc SORT data=z;
 by x;
run;


/* FORCE */
proc SORT data=z out=zs1f;
 by x;
run;
proc SORT data=zs1f out=zs1f;
 by x;
run;

proc SORT data=zs1f out=zs1f FORCE;
 by x;
run;

PROC CONTENTS data = zs1f;
run;



data z;
 input x y;
cards;
2 3
23 25
23 22
2 4
23 22
1 2
1 2
;
run;
proc print;
run;

/*
EQUALS | NOEQUALS
*/
proc sort data=z out=zs1a EQUALS;
 by x;
run;
proc print;
run;


proc sort data=z out=zs1b NOEQUALS;
 by x;
run;
proc print;
run;



/* sortowanie wielu zmiennych */
proc sort data=z out=zs2;
 by x y;
run;

proc sort data=z out=zs2;
 by _ALL_;
run;

proc sort data=z out=zs2;
 by x -- y;
run;


/* NODUP - wywalaj powtarzajace sie 
  obserwacje (cale wiersze) */
proc sort data=z out=zs3 nodup;
 by x;
run;



/* j.w. */
proc sort data=z out=zs4 noduprecs;
 by x;
run;


data z(sortedby = x);
 input x y;
cards;
2 3
23 25
23 22
2 4
23 22
23 22
23 22
23 22
1 2
1 2
;
run;

/* dedykowany zbior dla duplikatow */
proc sort data=z out=zs5 DUPOUT=zs5d noduprecs;
 by x;
run;



/* NODUPKEY - wywalaj powtarzajace sie 
   wartosci zmiennych wymienionych w kluczu BY 
*/
proc sort data=z out=zs6 nodupkey;
    by x;
run;



data a;/*pomocniczy zbior testowy*/
 input x y;
cards;
1 2
1 2
0 2
1 3
1 3
1 3
1 2
9 8
9 8
9 7
;
run;



proc sort data=a out=as nodup;
 by x;
run;
proc print data = as;
run;



proc sort data=a out=as;
 by x _all_; /* _all_ */
run;
proc sort data=as out=ass nodup;
 by x;
run;
proc print data = ass;
run;


/* inna opcja */
proc sort data=a out=as EQUALS;
 by x y;
run;
data ass;
  set as;
  by x y;
  if first.y then output;
run;
proc print data = ass;
run;

/*
Wiecej z dokumentacji SAS 9.1.3:

"NODUPRECS checks for and eliminates duplicate observations. If you specify this option, then
PROC SORT compares all variable values for each observation to those for 
previous observation (Liczba Pojedyncza!!) that was written to the output data set. 
If an exact match is found, then the observation is not written to the output data set."

https://support.sas.com/documentation/onlinedoc/91pdf/sasdoc_913/base_proc_8977.pdf
strony: 1047/1048

Albo z artykulow konferencyjnych:
https://support.sas.com/resources/papers/proceedings/proceedings/sugi25/25/po/25p221.pdf
*/

/* test wydajnosci */
data big_a; /*pomocniczy zbior testowy*/
do ____i____ = 1 to 1000000; /* klonowanie zbioru 1'000'000 razy*/
    do ____j____ = 1 to NOBS;
        set a NOBS = NOBS point = ____j____;
        output;
    end;
end;
stop;
drop ____i____ ____j____;
run;


proc sort data=big_a out=as;
 by _all_;
run;
proc sort data=as out=ass nodup;
 by x;
run;


proc sort data=big_a out=as1 EQUALS;
 by _all_;
run;
data ass1;
 set as1;
 by x y;
 if first.y then output;
run;


/* jak jest z lokalsami? */
data alfabet_pl;
infile cards dlm=" ";
input symbol $ :2. @@;
cards;
Q W E R T Y U I O P A S D F G H J K L Z X C V B N M
q w e r t y u i o p a s d f g h j k l z x c v b n m
0 9 8 7 6 5 4 3 2 1
00 99 88 77 66 55 44 33 22 11
Ä Ĺť Ĺ Ĺš Ä Ä Ĺ Ă Ĺ Ä Ĺź Ĺ Ĺş Ä Ä Ĺ Ăł Ĺ
;
run;
proc print;
run;





Proc SORT
data=alfabet_pl
out=alfabet_pl_sort1
;
    by symbol;
run;

proc contents data = alfabet_pl_sort1;
run;




/* jak po polsku?*/
Proc SORT
data=alfabet_pl
out=alfabet_pl_sort2a
POLISH
;
    by symbol;
run;





Proc SORT
data=alfabet_pl
out=alfabet_pl_sort2
SORTSEQ=POLISH
;
    by symbol;
run;

proc contents data = alfabet_pl_sort2;
run;




/* zmiana sortowania WIELKIE przed malymi */
Proc SORT
  data=alfabet_pl
  out=alfabet_pl_sort3
  SORTSEQ=LINGUISTIC
  (
  CASE_FIRST=UPPER
  LOCALE=pl_PL
  )
;
    by symbol;
run;

proc contents data = alfabet_pl_sort3;
run;






/*
NUMERIC_COLLATION=ON
*/
Proc SORT
data=alfabet_pl
out=alfabet_pl_sort4
SORTSEQ=LINGUISTIC
(
CASE_FIRST=UPPER
LOCALE=pl_PL
NUMERIC_COLLATION=ON
)
;
    by symbol;
run;

proc contents data = alfabet_pl_sort4;
run;


/* 
DESCENDING i REVERSE
REVERSE odwraca sortowanie zmiennych tekstowych
DESCENDING w BY pozwala na odwracanie porzadku
w tekstowych i numerycznych
REVERS nie mozna uzywac z SORTSEQ
*/
data z;
input x y $;
cards;
1 A
1 B
1 C
2 A
2 B
2 C
3 A
3 B
3 C
;
run;





Proc SORT
data=z
out=z1
REVERSE
;
    by x y;
run;
proc print;
run;





Proc SORT
data=z
out=z2
REVERSE
;
    by descending x descending y;
run;
proc print;
run;



/* OVERWRITE 
kasuje zbior wejsciowy zanim do wynikowego
(o takiej samej nazwie) zostana wpisane dane
*/
Proc SORT
data=z
out=z
OVERWRITE
;
    by x y;
run;





/*
TAGSORT

przechowuje tylko zmienne z BY i numer obserwacji z oryginalnego zbioru, 
przez co plik posredni do sortowania jest mniejszy

TAGSORT nie jest kompatybilna z OVERWRITE

TAGSORT nie dziala przy sortowaniu wielowatkowym

*/

DATA dlugie_napisy;
    do i = 1 to 100000;
        x = ranuni(17);
        a1 = "BLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLE";
        b1 = "BLABLABALBLABLABALBLABLABALBLABLABALBLABLABALBLABLABAL";
        c1 = "BLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLU";
        d1 = "BLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLO";
        a2 = "BLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLE";
        b2 = "BLABLABALBLABLABALBLABLABALBLABLABALBLABLABALBLABLABAL";
        c2 = "BLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLU";
        d2 = "BLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLO";
        a3 = "BLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLE";
        b3 = "BLABLABALBLABLABALBLABLABALBLABLABALBLABLABALBLABLABAL";
        c3 = "BLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLU";
        d3 = "BLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLO";
        a4 = "BLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLE";
        b4 = "BLABLABALBLABLABALBLABLABALBLABLABALBLABLABALBLABLABAL";
        c4 = "BLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLU";
        d4 = "BLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLO";
        output;
    end;
run;

Proc SORT
data=dlugie_napisy
out=dlugie_napisy_TAGSORT
TAGSORT
;
    by x;
run;



Proc SORT
data=dlugie_napisy
out=dlugie_napisy_NOTAGSORT
;
    by x;
run;








/* THREADS | NOTHREADS
    zezwala lub nie na sortowanie wielowatkowe
    nie wspolpracuje z TAGSORT
*/
DATA dlugi;
    do i = 1 to 10000000;
        x = ranuni(17);
        y = mod(i,10);
        output;
    end;
run;



Proc SORT
data=dlugi
out=dlugi_THREADS
THREADS
;
    by y x;
run;



Proc SORT
data=dlugi
out=dlugi_NOTHREADS
NOTHREADS
;
    by y x;
run;


Proc SORT
data=dlugi
out=dlugi_THREADS
THREADS           EQUALS
;
    by y x;
run;

/* KEY - ciekawostka */

data z;
 input x y;
cards;
2 3
23 25
23 22
2 4
23 22
1 2
1 2
;
run;


proc sort data = z out = b1;
 by x y;
run;

proc sort data = z out = k1a;
 key x y;
run;

proc sort data = z out = k1b;
 key x; 
 key y;
run;


proc sort data = z out = b2;
 by descending x y;
run;

proc sort data = z out = k2;
 key x / descending; 
 key y;
run;


proc sort data = z out = b3;
 by descending x descending y;
run;

proc sort data = z out = k3;
 key x y / descending; 
run;


/* po co jest call streaminit ? */
data text_call_streaminit;
  call streaminit(1234);

  do I = 1 to 3;
    exit = rand('uniform');
    output;
  end;
run;

data text_call_streaminit2;
  call streaminit(1234);

  do I = 1 to 3;
    exit = rand('uniform');
    output;
  end;
run;

/* NOUNIQUEKEY */

data a;
  do x = 1,2,2,3,4,4,5,6,6;
    y + 10;
    output;
  end;
run;

proc sort 
  data = a 
  out = no_uniq_a
  NOUNIQUEKEY
;
  by x;
run;

proc sort 
  data = a 
  out = no_uniq_a
  NOUNIQUEKEY
  UNIQUEOUT = uniq_a
;
  by x;
run;



/************************/

/*** tablice; ***/

/* czyli praca w "szerz" :-) */
data a; /* pomocniczy zbior testowy */
 input x1 x2 x3 x4 x5;
 ya = x1+x2;
 yb = x2+x3;
 yc = x3+x4;
 yd = x4+x5;
cards;
1 2 3 4 5
2 3 4 5 6
6 7 8 9 2
;
run;
proc print;
run;

/* polecenie: przemnozyc kazda zmienna ze 
   zbioru 'a' przez 10. */
/*
 jak jest 5 zmiennych to "od biedy" 
 mozna recznie zrobic to tak jak ponizej ...
*/
data b1;
 set a;
 x1=x1*10;
 x2=x2*10;
 x3=x3*10;
 x4=x4*10;
 x5=x5*10;
run;
proc print;
run;


/*
  ... ale dla 10000 to
  juz by nam sie nie chcialo :-)
*/


data b2;
 set a;
 do i = 1 to 5;
  xi = xi * 10;
 end;
run;
/*
  ten kod jest bez sensu, wywali tylko 
  kolumne kropek dla nowo powstaĹej 
  zmiennej 'xi' z komunikatem o dzialaniu 
  na brakach danych.
*/






/*
 polecenie ARRAY definiuje tablice (to nie jest taka 
 tablica jak np. w C czy C++, to jest raczej  
 wygodne odwolywanie sie do duzej liczby zmiennych)
*/
/*ZOBACZ HELPA!!! napisz ARRAY w indexie*/

data b3;
  set a;
  ARRAY zosia [5] x1 x2 x3 x4 x5;
  /*
  array zosia {5} x1 x2 x3 x4 x5;
  array zosia (5) x1 x2 x3 x4 x5;
  */
  /* 
   'zosia' to nazwa tablicy (nie moze byc taka jak 
   nazwa istniejacych juz zmiennych!)

   '[5]' to liczba zmiennych/elementow ("wymiar" danych),
   napis '[5]' oznacza ze mamy piec zmiennych o
   indeksach 1 do 5, rownowaznie mozna napisac '[1:5]'

   gdy chcialoby sie miec 5 zmiennych o innym indeksie 
   (zaczynajacym sie np. od 3) to mozna napisac '[3:8]'

   potem jest lista zmiennych 'x1 x2 x3 x4 x5', jak jest duzo
   zmiennych o takim samym prefiksie i numerycznym sufiksie to
   mozna napisac 'x1-x5'

   jak po wymiarze danych napisze sie '$' to bedzie
   tablica znakowa
  */
      do i = 1 to 5;
          zosia{i} = zosia[i] * 50;
          /* do elementu z tablicy odwoĹujemy siÄ przez
             jego indeks 'zosia{i}' albo 'zosia[i]' */
      end;
run;
proc print;
run;

data b6;
  set a;
  ARRAY zosia [5] x1 x2 x3 x4 x5;
    do i = 1 to 5;
        zosia[i]=zosia{i}*50;
    end;
  drop i; /* zmienna indeksujaca wpada do zbioru */
run;
proc print;
run;


data b7;
  set a;
  array zosia [*] x1-x5 y:;
  /*
  moge nie napisac jawnie ile ma byc zmiennych 
  napis '[*]' powoduje, ze SAS "domysli sie"
  po liscie, napis 'x1-x5' oznacza dla SASa, ze ma w tablicy
  zmienne od x1 do x5, napis 'y:' oanacza "wszystkie zmienne 
  zaczynajace sie na y" 
  */
    temp = DIM(zosia);
    put temp=;
    do i=1 to DIM(zosia); /* DIM(zosia) okresla wymiar tablicy */
        zosia(i) = zosia{i} * 150;
    end;
  drop i;
run;
/*
  The DIM function returns the number of elements in
  a one-dimensional array or the number of elements in
  a specified dimension of a multidimensional array when
  the lower bound of the dimension is 1. Use DIM in array
  processing to avoid changing the upper bound of an iterative
  DO group each time you change the number of array elements.

  Syntax:

  DIM<bound-n> (array-name)
  DIM(array-name, bound-n)

  DIM42(zosia)
  DIM(zosia,42)
*/

/*
  mozna tez indeksowac z wiodacymi zerami
*/
data test1 (drop=i);
   array a{12} A001-A012;
   do i = 2 to 10;
      a{i} = i;
   end;
run;
proc print noobs data=test1;
run;
proc contents data=test1;
run;

data test2 (drop=i);
   array a{12} A1-A12;
   do i = 2 to 10;
      a{i} = i;
   end;
run;
proc print noobs data=test2;
run;
proc contents data=test2;
run;


data test3 (drop=i);
   array abc{-1:12} ; /* zerknij do outputu! */
   do i = 2 to 10;
      abc{i} = i;
   end;
run;
proc print noobs data=test3;
run;
proc contents data=test3;
run;

data test4 (drop=i);
   set test3;
   array abc{-1:12} abc1-abc14 ; /* zerknij do outputu! */
   do i = -1 to 12;
      abc{i} = abc{i} * 1000;
   end;
run;
proc print noobs data=test4;
run;


data test5a (drop=i);
   array abc{-1:12} ; 
   do i = -1 to 12;
      abc{i} = i;
   end;
run;
proc print noobs data=test5a;
run;

data test5b (drop=i);
   set test5a;
   array abc{-1:12} ;
   do i = -1 to 12;
      abc{i} = abc{i} * 1000;
   end;
run;

data test5c (drop=i);
   set test5a;
   array abc{*} abc:;
   do i = 1 to 14;
      abc{i} = abc{i} * 1000;
   end;
run;

proc print noobs data=test5b;
run;
proc print noobs data=test5c;
run;



/*
LBOUND i HBOUND to funkcje, ktore zwracaja informacje
o dolnym i gornym wymiarze indeksu zmeinnej

tutaj bylo by to lbound(zosia)=1 hbound(zosia)=5

SYNTAX jak dla DIM, dzialanie analogiczne

hbound(zosia,n) - lbound(zosia,n) + 1 = DIM(zosia,n)
*/

data test5d (drop=i);
   set test5a;
   /*array abc{*} abc:;*/
   array abc{-1:12} ;

   lb = LBOUND(abc); 
   HB = HBOUND(abc);
   put lb= hb=;

   do i = LBOUND(abc) to HBOUND(abc);
      abc{i} = abc{i} * 1000;
   end;
run;




/* NAZYWANIE TABLICY */



/*
  tu wyskoczy blad - bo jedna ze zmiennych w tablicy nazywa sie
  tak jak tablica!!!
*/
data a;
 array z(3) $ z t u ('a','b','c');
run;

/* tu ok - nazwa zbioru i nazwa zmiennej nie maja nic wspllnego */
data w;
 array z(3) $ w t u ('a','b','c');
run;

/* tu tez ok - nazwa zbioru i nazwa tablicy nie maja nic wspolnego */
data w;
 array w(3) $ z t u ('a','b','c');
run;

data w24;
 array w(3) $ 24 z t u ('a','b','c');
run;


/* nazwa tablicy moze byc nazwa funkcji,
   ale nie jest to zalecane!, uwaga na nawiasy !!! 
*/
data b4;
  set a;
  array sin (5) x1 x2 x3 x4 x5;
  do i = 1 to 5;
      sin{i} = sin[i] * 50;
  end;
run;

data b5;
  set a;
  array sin [5] x1 x2 x3 x4 x5;
  do i = 1 to 5;
      sin{i} = sin[i] * 50;
  end;
run;

data b5;
  set a;
  array sin [5] x1 x2 x3 x4 x5;
  do i = 1 to 5;
      sin{i} = sin(i); /* :-( */
  end;
run;

data b5;
  set a;
  przed = sin(1); /* uwaga !!! */
  array sin [5] x1 x2 x3 x4 x5 (1:5);
  po    = sin(1); /* uwaga !!! */
run;
proc print;
run;
/*
  Using the name of a SAS function as 
  an array name can cause unpredictable 
  results. 

  If you inadvertently use a function 
  name as the name of the array, SAS 
  treats parenthetical references that 
  involve the name as array references, 
  not function references, for the duration 
  of the DATA step. A warning message is
  written to the SAS log.  
*/




data a; /* pomocniczy zbior testowy */
 do x=1 to 5;
  output;
 end;
run;

/*
  ponizszy kod utworzy zbior sasowy z 4 zmiennymi:
  x tablica1 tablica2 tablica3
  ponadto napis '(3*7)' na koncu deklaracji tablicy
  oznacza "w kazdym wierszu wstaw liczbe 7 na 3 pozycjach"
*/
data b1;
 set a;
 array tablica(3) (3*7);
run;

data b2;
 set a;
 array tablica(4) (3*7);
 /* tutaj jedna zmienna wiecej zainicjowana kropkami
    i komunikat ze za malo danych do wpisania */
run;

data b3;
 set a;
 array tablica(2) (3*7);
 /* tu napisze ze ma za duzo rzeczy do wstawienia
    i nadmiarowe zgubi */
run;

data b4;
 set a;
 array tablica(3) (0 2*1);
run;

data b5;
 set a;
 array tablica(6) (0:5);
run;

data b5b;
 set a;
 array tablica(6) (2*(3:5));
run;

/* czy zmienne tablicowe sa "utrzymywane"? 
   - RETAIN dziaĹa automatycznie */
data b6;
 set a;
 array tablica(3) (0:2); /* (3*17) */

 if _n_ = 2 then 
  do j = 1 to dim(tablica);
    tablica[j] = 3.14;
  end;

 drop j;
run;
proc print;
run;


data b7;
 set a;
 array tablica[3] ;

  if _n_ = 1 then 
    do j = 1 to dim(tablica);
      tablica[j] = j-1;
    end;

  if _n_ = 2 then 
    do j = 1 to dim(tablica);
      tablica[j] = 42;
    end;

 drop j;
run;
proc print;
run;
/*
  If you have not previously specified the attributes of the
  array elements (such as length or type), the attributes of
  any initial values that you specify are automatically assigned
  to the corresponding array element. Initial values are retained
  until a new value is assigned to the array element.

  When any (or all) elements are assigned initial values, all
  elements behave as if they were named in a RETAIN statement.
*/
data b8;
 set a;
 array tablica(3) $ ; /* <- tekstowa! */

 retain tablica 'o';

 if _n_ = 2 then 
  do j = 1 to dim(tablica);
   tablica[j] = 'ABC';
  end;

 drop j;
run;

data b9;
 set a;
 array tablica(3) $ (3 * "o");

 if _n_ = 2 then 
  do j = 1 to dim(tablica);
   tablica[j] = 'ABC';
  end;

 drop j;
run;

data b10;
 set a;
 array tablica(3) $ 20 (3 * "o"); /* zmiana dlugosci */

 if _n_ = 2 then
   do j = 1 to dim(tablica);
     tablica[j] = 'ABC';
   end;

 drop j;
run;

/* tablice tymczasowe */
data a1;
 array t(5) _TEMPORARY_ (5*1);
run;
data a2;
 array t(5) (5*1);
run;


data b11;
 set a;
 array tablica[3] $ 20 _TEMPORARY_ (3 * "o"); 

 if _n_ = 2 then 
  do j = 1 to dim(tablica);
   tablica[j] = 'ABC';
  end;

 drop j;
run;

/*
Temporary data elements behave like 
DATA step variables with these exceptions:
 
- They do not have names. Refer to temporary 
  data elements by the array name and dimension.  

- They do not appear in the output data set. 

- You cannot use the special subscript 
  asterisk (*) to refer to all the elements.
 
- Temporary data element values are always 
  automatically retained, rather than being 
  reset to missing at the beginning of the
  next iteration of the DATA step.
 
- Arrays of temporary elements are useful 
  when the only purpose for creating an array 
  is to perform a calculation. To preserve the 
  result of the calculation, assign it to a variable. 
  You can improve performance time by using 
  temporary data elements.  

*/
/* uwaga */
data _null_;
  array y [1e2] _temporary_;
run;
data _null_;
  array y [100] _temporary_;
run;



data b11;
 set a;
 array tablica(3) $ 20 _TEMPORARY_ (3 * "o"); 

 if _n_ = 2 then
     do j = 1 to dim(tablica);
         tablica[j] = 'ABC';
     end;

 do j = 1 to dim(tablica);
     napis = napis || tablica[j]; /* || = !! */
 end;

 drop j;
run;
proc print;
run;
/* napis jest ustawiany domyslnie jako numeryczny */
proc contents data = b11;
run;


/*
uwaga na boku:

numeryczne braki danych w SASie:
._, ., .A, .B, ..., .O, ..., .Z

*/



data b12_1;
 set a;
 array tablica(3) $ 20 _TEMPORARY_ (3 * "o");

 LENGTH napis $ 50;
 napis = "";

 if _n_ = 2 then 
     do j = 1 to dim(tablica);
         tablica[j] = 'ABC';
     end;

 do j = 1 to dim(tablica);
         napis = napis || tablica[j];
 end;

 drop j;
run;
proc print;
run;

data b12_2;
 set a;
 array tablica(3) $ 20 _TEMPORARY_ (3 * "o");

 length napis $ 50;
 napis = " ";

 if _n_ = 2 then
     do j = 1 to dim(tablica);
         tablica[j] = 'ABC';
     end;

 do j = 1 to dim(tablica);
    napis = STRIP(napis) || STRIP(tablica[j]); /* LEFT() TRIM() */
    /*napis = CATs(napis, tablica[j]);*/ 
 end;

 drop j;
run;
proc print;
run;

/*
data b12_2a;
 set a;
 array tablica(3) $ 20 _TEMPORARY_ (3 * "o");

 length napis $ 50;
 napis = "X";

 if _n_ = 2 then
     do j = 1 to dim(tablica);
         tablica[j] = '  ABC  ';
     end;

 do j = 1 to dim(tablica);
         napis = STRIP(napis) || TRIM(tablica[j]); *LEFT() TRIM();
 end;

 drop j;
run;
proc print;
run;
*/


data b12_3;
 set a;
 array tablica(3) $ 20 _TEMPORARY_ (3 * "o");

 length napis $ 50;
 retain napis " ";

 if _n_ = 2 then do;
     do j = 1 to dim(tablica);
         tablica[j] = 'ABC';
     end;
 end;

 do j = 1 to dim(tablica);
         napis = strip(napis) || strip(tablica[j]);
 end;

 drop j;
proc print; /* !!! ciekawostka! */
run;

data a; /*pomocniczy zbior sasowy*/
 m = 17;
 array t[3];
     do j=1 to 5;
         do i=1 to dim(t);
            t[i]=ranuni(102);
         end;
         output;
     end;
 keep m t1-t3;
run;
proc print;
run;

data b1;
  set a;
  array t(3); /*znamy zmienne wiec tak wystarczy*/
run;

data b1;
  set a;
  array t(3); /*znamy zmienne wiec tak wystarczy*/

  do I = lbound(t) to hbound(t); drop I;
   t[i] = t[i] + 3;
  end;
run;


data b2;
 set a;
 array ttt(3) t1-t3;
 /* zmienilismy nazwe tablicy wiec podajemy
    jakie zmienne ze zbioru A mamy jej przypisac */
 y=ttt(2);
run;

/* a jesli zmiennimy kolejnoĹÄ ?? */
data b3;
    array ttt(3) t1-t3;
    set a;
    y=ttt(2);
run;

data test;
  x3=3; x4=4; x5=5;
run;
data _null_;
  set test;
   array x [3:5] x:;
/* array x [3:5]   ; */
/* array x [3]     ; */
/* array x [3]   x:; */
/* array x [0:2] x:; */
/* array x [-5:-3] x:; */

  d=dim(x);
  l=lbound(x);
  h=hbound(x);
  put _all_;

  do i = l to h;
    put i= x[i]=;
  end;
run;


/* _TEMPORARY_ */
/* _ALL_ */
/* _CHARACTER_ */
/* _NUMERIC_ */

data a;/*pomocniczy zbior sasowy*/
  x=42; 
  y='Napis1';
  z=3.14; 
  t='Inny napis';
run; 

data b;
  set a;
  array numer(*) _NUMERIC_; 
  /* stworzy tablice o nazwie 'numer' i wrzuci do niej 
     wszystkie zmienne numeryczne, ktore wystpuja w zbiorze */

  do i=1 to dim(numer);
    put numer[i]= @;
  end;

  put;

  array znak(*) $ _CHARACTER_;
  /* stworzy tablice o nazwie 'znak' i wrzuci do niej 
     wszystkie zmienne znakowe, ktore wystpuja w zbiorze */

  do i=1 to dim(znak);
    put znak[i]= @;
  end;

  drop i;
run;


data a;/*pomocniczy zbior sasowy*/
  x=1; y=2; z=3; t=4;
run;
 
data b;
  set a;
  array w(*) _all_; 
  /* wstawi wszystkie zmienne do tablicy 'w' */
  do i=1 to dim(w);
    put w[i] @;
  end;
run;

/* Tablica tymczasowa */
data u;
  wa=1; wb=2; wc=3;
run;

data x8;
  set u;
  array x[*] _NUMERIC_;
  array y[3];

  do i = 1 to dim(y);
      y[i] = x[i] * 2;
  end;
run;

data x9;
  set u;
  array x[*] _NUMERIC_;
  array y[3] _TEMPORARY_;

  do i =1 to dim(y);
      y[i] = x[i] * 2;
  end;
run;

data x10;
  set u;
  array x[*] _NUMERIC_;
  wd = 4;

  do i =1 to dim(x);
      put x[i] =;
  end;
run;

data x11;
  set u;
  wd = 4;
  array x[*] _NUMERIC_;

  do i =1 to dim(x);
      put x[i] =;
  end;
run;

data x12;
  wd = 4;
  set u;
  array x[*] _NUMERIC_;

  do i =1 to dim(x);
      put x[i] =;
  end;
run;



/** LEKTURA DO DOMU **/
/** LEKTURA DO DOMU **/
/** LEKTURA DO DOMU **/
/** LEKTURA DO DOMU **/



/* tablice dwuwymiarowe */

data a1;

  array t(5,4) (20*1); /* reprezentacja? */

run;




data a2;
  array t(5,4) (20*1);

  /* jaka jest organizacja? */

  i = 1;
  j = 1;
  t[i,j] = 2;

  keep t:;
run;



data a3;
  array t(5,4) (1:20);

  /* jaka jest organizacja? */

  i = 1;
  j = 2;
  t[i,j] = -12;


  i = 2;
  j = 1;
  t[i,j] = -21;

  i = 2;
  j = 2;
  t[i,j] = -22;

  keep t:;
run;



data a4;
  array t(5,4) (20*1);

  /* jaka jest organizacja? */

  i = 1;
  do j = 1 to dim2(t);
    t[i,j] = 10*j;  /*i = wiersze, j = kolumny*/
  end;

  keep t:;
run;




data a5;
  array t(5,4) (20*1);

  /*jaka jest organizacja?*/

  k = 1;
  do w = 1 to dim1(t);
    t[w,k] = 10*w;
  end;

  keep t:;
run;


data _null_;
    x1 = 1; x2 = 2;

    array xs[*] x1 x2 x1 x2 x1 x2 x1 x2;

    d = dim(xs);

    put d=;

    if addrlong(xs[1]) = addrlong(xs[3]) then put "the same address" ;
                                         else put "different address";
    do _N_ = 1 to dim(xs);
      addr_xs=addrlong(xs[_N_]);
      put "for " _N_= " array xs refers to " addr_xs= hex16. addr_xs= binary32.;
    end;
run;


/* multi dimentional array */
data _null_;
    array xs[0:1,0:1,0:1,0:1,0:1,0:1,0:1,0:1,0:1,0:1] (0:1023);

    array d[0:10] d0 - d10;

    d[0] = .;
    do _N_ = 1 to 10;
        d[_N_] = dim(xs,_N_);
    end;

    put (d[*]) (=);

    put xs[0,0,0,0,0,0,0,0,0,0]=;
    put xs[0,0,0,0,0,0,0,0,0,1]=;
    put xs[0,0,0,0,0,0,0,0,1,0]=;
    put xs[0,0,0,0,0,0,0,0,1,1]=;
    put xs[0,0,0,0,0,0,0,1,0,0]=;
    put xs[0,0,0,0,0,0,0,1,0,1]=;
    put xs[0,0,0,0,0,0,0,1,1,0]=;
    put xs[0,0,0,0,0,0,0,1,1,1]=;
    /* ... */
    put xs[1,0,0,0,0,0,0,0,0,0]=;
    /* ... */
    put xs[1,1,1,1,1,1,1,1,1,1]=;
run;


/* zrobmy sobie transpozycje */
data a;/* pomocniczy zbior sasowy */
 array t(99);
 format t: best3.;
 do j=1 to 5;
  do i=1 to dim(t);
   t(i)=100*j + i;
  end;
  output;
 end;
 keep t:;
run;



data bt; /* bedziemy transponowac tabele 'a' */
  set a end = eof;
  array tymcz(5, 99) _temporary_; 

  /* wczytujemy zbior do tablicy TYMCZ */
  array wej(*) t:; /* tablica ktora przechowa 
                      poszczegolne obserwacje */
  do i=1 to dim(wej);
      tymcz(_N_, i) = wej(i);
  end;

  /* wypiszemy transponowana tablice do zbioru */
  array w(5); /* tablica, ktora przechowa nam 
                 obserwacje do outputu */

  if eof then do;
      do j=1 to 99;
          do i=1 to dim(w);
              w[i]=tymcz(i,j);
          end; 
          output;
      end;
  end; 

  drop i j t:;
run;
/*****************************************************************************/

/* zmiana wymiaru tablicy gdy uzywamy _ALL_ */
data a; /* pomocniczy zbior sasowy */
 input x;
cards;
1
2
3
; 
run;
data b;
 set a;
 array t(*) _all_;
 r=dim(t);put _all_;
run;

data b;
 z=3;
 set a;
 array t(*) _all_;
 r=dim(t);put _all_;
run;

data b;
 set a;
 array t(*) _all_;
 z=3;
 r=dim(t);put _all_;
run;
/*
  jaka bedzie wartosc zmiennej 'r'? i od czego zalezy gdy 
  uĹźyjemy _ALL_? 
  dorzuca wszystkie wczesniej zdefinowane: 
  "These SAS variable lists enable you to reference 
   variables that have been previously defined in the same 
   DATA step" (z helpa o _ALL_)
*/


/* !!! TABLICE + LAG - zachowanie !!!
  "If the argument of LAGn is an array name, a separate
   queue is maintained for each variable in the array."
*/
data arr1;
    do i=1 to 5;
        xx = i;
        yy = i**2;
        zz = i*2;
        output;
    end;
run;
data arr2;
  set arr1;
    array xyz(*) xx yy zz;
    array abc(3);

    do j=1 to dim(xyz);
        abc[j] = lag(xyz[j]);
    end;
run;

/*
dodatkowe informacje
PDF:
1) https://support.sas.com/resources/papers/proceedings16/6406-2016.pdf
2) https://support.sas.com/resources/papers/proceedings/proceedings/sugi30/242-30.pdf
VIDEO:
1) https://communities.sas.com/t5/SAS-Global-Forum-Proceedings/An-Introduction-to-SAS-Arrays/ta-p/918898
2) https://communities.sas.com/t5/Ask-the-Expert/Using-Arrays-and-DO-Loops-Do-Over-or-Do-I-Q-amp-A-Slides-and-On/ta-p/831451
*/








/* czy jest cos takiego jak LEAD? 
   albo NEXT? taki Lag ale do przodu? */





/* POINT */

data aa;
  a=1;output;
  a=2;output;
  a=3;output;
  a=4;output;
  a=5;output;
run;

data b;
i=3;
    SET aa POINT=i;
output;
STOP; /* !!! WAZNE !!! */
/*(output;)*/run;




data b2;          put "1) " _all_;
i=3; j=3;         put "2) " _all_;
set aa point=i;   put "3) " _all_;
output;           put "4) " _all_;
stop;             put "5) " _all_;
run;

data b3;
  i=3;
  set aa point=i;
  output;
  if _N_ = 3 then stop;
run;

data b4;
if _N_=1 then i=3;
set aa point=i;
output;
if _N_ = 3 then stop;
run;


data b5;
  do i = 1,3,5;
      set aa point=i;
      output;
  end;
stop;
run;


data b6;
  do point = nobs to 1 by -1;
      set aa point=point NOBS=nobs;

      /* INSTRUKCJE */

      output;
  end;
  stop;
run;

ods html;
proc contents data = aa;
run;


data b6x;
do point = 1 to nobs by 1;
    set aa point=point NOBS=nobs;

    /* INSTRUKCJE */
    K = a ** 2; 
    put _all_;

    output;
end;
stop;
run;

data b6y;
    set aa ;

    /* INSTRUKCJE */
    K = a ** 2; 
    put _all_;
run;

proc COMPARE base = b6x compare = b6y;
run;


/* zmienna w zbiorze i jako "pointer" */
/* UWAGA! zobacz loga */
data A;
  id=17;
  a=0;
run;

data B;
  id = 1; 
    set A point=id;
    output;
  stop;
run;





/* lektura domowa *
/* "LEAD"* */


data b7;
  put "_ " _all_;

  SET aa nobs=nobs;
  put "0 " _all_;

  if _N_ < nobs then 
    do;
      point=(_N_+1);
      SET aa(RENAME = (a=a_next)) point=point ;
    end;
  else a_next =. ;

  put "1 " _all_ /;
run;


data b7_2;
  set aa nobs=nobs;

  if _N_ < nobs-1 then 
    do;
      point=(_N_+2);
      set aa(RENAME = (a=a_next)) point=point ;
    end;
  else a_next =. ;
run;


/* ##############  */


data b6xxx;
  do point = nobs to 1 by -1;
    set aa point=point NOBS=nobs;

    j = lag3(a);

    output;
  end;
stop;
run;

data b6xxx2;
  do point = nobs to 1 by -1;
    set b6xxx point=point NOBS=nobs;

    output;
  end;
stop;
run;
