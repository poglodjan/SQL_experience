
/*
  Petle:
*/

data a0;
    do i = 1 to 10;
        x = 2 * i;
        output;
    end;
run;

* write on log;
data a0;
    do i = 1 to 10;
        put "a)" _all_;
        x = 2 * i;
        put "b)" _all_;
        output;
    end;
run;       

data a0;
    do i = 1 to 10;
        x = 2 * i;
        output;
    end;
run;

data a0;
    do i = 1 to 10;
        x = 2 * i;
        output;
        put _all_;
    end;
run;



data a0;
  put "S: " _all_;
    do i = 1 to 10;
        x = 2 * i;

        put "M: " _all_;
        output;
    end;
  put "E: " _all_;
run;


data a0_N_Error;
    set a0;
    n = _N_;
    e = _ERROR_;
    put _all_;
run;

/* _null_ */

/********************************************/

data a1;
    do i = 1 to 100;
        x = 2 * i;
        output;
    end;
run;

data a2;
    do i = 1 to 100 BY 0.1;
        x = 2 * i;
        output;
    end;
run;

* dropping column;
data a2drop;
    do i = 1 to 100 BY 0.1; 
        x = 2 * i;
        output;
    end;

    DROP i; 
run;


/* UWAGA! */
data a3;
    do i = -1 to 1 by 0.1;
        x = 2 * i;
        output;
    end;
run;
/* Numerical Accuracy in SAS Software */


data a4;
    do i = -10 to 10 by 1;
        x = 2 / i;
        output;
    end;
run;

data a5;
    do i = -1 to 1 by 0.1;
        x = 2 / i;
        output;
    end;
run;

data a6;
    do i = 10 to 0 by -1;
        x = 2 ** i; 
        output;
    end;
run;

data a7;
    do i = 1, 22, 333, 4444, 55555; 
        x = FLOOR(100 * RANUNI(i)); 
        output;
    end;
run;

/* ZONK */
/*
data a8;
    do while(i<10);
        x = 2 <> i; 
        y = 2 >< i ; 
        output;
        i = i + 1;
    end;
run;


data _null_;
     y = 2 >< i ;
     put _all_;
run;


data _null_;
run;
data;
run;
*/





data a8;
    i = 0;
    do while(i<10);
        x = 2 <> i; * x = max(2,i); 
        y = 2 >< i; * y = min(2,i);
        output;
        i = i + 1;
    end;
run;

data a9;
    i = 0;
    do until(i>=10);
        x = 2 >< i;
        output;
        i = i + 1;
    end;
run;

data a9;
    i = 0;
    do until(NOT(i<10));
        x = 2 >< i;
        output;
        i = i + 1;
    end;
run;

/* UNTIL wejdzie przynajmniej 1 raz do ciala petli */
data a10;
    i = 1; j = 1;

    do until(not(i<1));
        x = "U";
        output;
        i = i + 1;
    end;
    
    do while(j<1);
        x = "W";
        output;
        j = j + 1;
    end;
run;


data a11_in all_in;
    x1 = 1;
    x2 = 2;
    x3 = 3;
    x4 = 4;
    x5 = 5;
    x6 = 6;
run;
proc print;
run;

data a11;
    set all_in;
    do i = x5, x6, x1, x2, x3, x4, x5, x6;
       output;
    end;
run;
proc print;
run;


data a12;
    do i = '1JAN1991'd
          ,"1JAN1992"d
          ,'1JAN1993'd
          ,'1JAN1994'd
          ,'1JAN1995'd
          ,'1JAN1996'd
          ,'1JAN1997'd
          ,'01JAN1998'd /* > 31dec9999 */
          ;
        x = WEEKDAY(i);
        /* The WEEKDAY function produces an integer that
           represents the day of the week, where 1=Sunday,
           2=Monday, ..., 7=Saturday. */
        output;
    end;
run;

data a12a;
  FORMAT i date9. y DOWNAME.;
/*
  Format DATE9. wyswietla wartosc daty w postaci DDmmmYYYY.
  Format DOWNAME <=> DayOfWeekNAME
  Writes date values as the name of the day of the week.
*/
;
    do i = '1JAN1991'd
          ,'1JAN1992'd
          ,'1JAN1993'd
          ,'1JAN1994'd
          ,'1JAN1995'd
          ,'1JAN1996'd
          ,'1JAN1997'd
          ,'1JAN1998'd
          ,today()
          , 5
          ;
        x = WEEKDAY(i);
        y = i;
        /* The WEEKDAY function produces an integer that
           represents the day of the week, where 1=Sunday,
           2=Monday, ..., 7=Saturday. */
        output;
    end;
run;

data _null_ / nesting;
/* NESTING wrzuca do loga poziom zagniezdzenia */
    do i = 1 to 3;
        do j = 'A', 'B', 'C';
            k = -3;
            do while(k<0);
                put i= j= k=;
                k = k + 1;
            end;
        end;
    end;
run;

/* CONTINUE i LEAVE */
data _null_1;
    do i = 1 to 5;
        do j = 1 to 5;
            if i = j then CONTINUE;
            /* przesk. do nastepnego obrotu*/
            output;
        end;
    end;
run;

data _null_2;
    do i = 1 to 5;
        do j = 1 to 5;
            if i > j then CONTINUE;
            /* przesk. do nastepnego obrotu*/
            output;
        end;
    end;
run;

data _null_3;
    do i = 1 to 5;
        do j = 1 to 5;
            if i = j then LEAVE;
            /*przerywa petle*/
            output;
        end;
    end;
run;

data _null_4;
    do i = 1 to 5;
        do j = 1 to 5;
            if i > j then LEAVE;
            /*przerywa petle*/
            output;
        end;
    end;
run;

/******************/

data a13;
    do i = 'A', 'AB', 'ABC', 'ABCD', 'ABCDE';
        x = LENGTH(i);
        output; 
        put x=;
    end;
run;


data a13x;
    do i = 'ABCDE', 'ABCD', 'ABC', 'AB', 'A', '';
        x = LENGTH(i); /* LENGTHN() */
        output; 
        put x=;
    end;
run;

/* compilation phase */

/*
  ustawienie dlugosci zmiennej _tekstowej_ jest robione na
  podstawie pierwszej dostepnej wartosci

  dla zmiennych _numerycznych_ z automatu jest 8 bajtow
*/

data a14;
    x = "krĂłtka";                    output;
    x = "dĹuga";                     output;
    x = "super dĹugaĹna";            output;
    x = "najnajnajnajdĹugaĹniejsza"; output;
run;
proc print data = a14;
run;

/*

  dla zmiennych numerycznych
  LENGTH nazwa_zmiennej dlugosc;

    For numeric variables, 2 to 8 or 3 to 8,
    depending on your operating environment.

  dla zmiennych tekstowych
  LENGTH nazwa_zmiennej $ dlugosc;

    For character variables, 1 to 32767 under all
    operating environments
*/

data a14;
    LENGTH x $ 100;
    x = "krĂłtka";                    output;
    x = "dĹuga";                     output;
    x = "super dĹugaĹna";            output;
    x = "najnajnajnajdĹugaĹniejsza"; output;
run;
proc print data = a14;
run;



data a14c;
    LENGTH x $ 100;
    x = "krĂłtka";                    y=LENGTH(x); output;
    x = "dĹuga";                     y=length(x); output;
    x = "super dĹugaĹna";            y=length(x); output;
    x = "najnajnajnajdĹugaĹniejsza"; y=length(x); output;
    x = "   krĂłtka";                 y=length(x); output; /* 3 spacje przed */
    x = "krĂłtka   ";                 y=length(x); output; /* 3 spacje po */
run;
proc print data = a14c;
run;


data a14d;
    LENGTH x $ 100;
    x = "krótka";                    y=length(x); z=KLENGTH(x); output;
    x = "długa";                     y=length(x); z=klength(x); output;
    x = "super długaśna";            y=length(x); z=klength(x); output;
    x = "najnajnajnajdłuższa"; y=length(x); z=klength(x); output;
    x = "   krótka";                 y=length(x); z=klength(x); output; /* 3 spacje przed */
    x = "krótka   ";                 y=length(x); z=klength(x); output; /* 3 spacje po */
run;
proc print data = a14d;
run;

data a14e;
    LENGTH x $ 100;
    x = "ĹťĂłĹÄ"; y=length(x); z=klength(x); output;
run;

data a14e7;
    LENGTH x $ 7;
    x = "ĹťĂłĹÄ"; y=length(x); z=klength(x); output; put _ALL_;
run;



/*zbior testowy*/
data a;
    do i = 1 to 10 by 1;
        x = 1 + MOD(i,3);
        output;
    end;
run;

data b1;
  set a;
  x = x + 100;
  y = 6 * x;
run;

/*
  zachowanie zmiennej y i zachowanie zmiennej _N_!
*/
data b1;              putlog "1)" _all_;
  set a;              putlog "2)" _all_;
  x = x + 100;        putlog "3)" _all_;
  y = 6 * x;          putlog "4)" _all_;putlog;
run;

/* "missingowanie" Y przy obrocie petli glownej */
data b1;
  set a;
  x = x + 100;
  if x > 101 then y = 5;
run;



data b1;              putlog "1)" _all_;
 x=5; y=7; z=_n_;     putlog "2)" _all_;
 output;              putlog "3)" _all_;
 x=6;                 putlog "4)" _all_;
 output;              putlog "5)" _all_;
run;
/*
  tutaj 3 kolumny, w pierwszym wierszu kolejno
  x=5,y=7,z=1, w drugim x=6,y=7,z=1,
  dlaczego?! dlatego ze mamy TYLKO 1 obrot pÄtli glownej
  (co prawda 2 outputy),
  ale wartosc y i z sie nie zmienia!!
*/


/* chcemy zmienna, ktora kumuluje kolejne wartosci x */
data b2;
  set a;
  y = y + x;
run;

data b2;
  y = 0;
  set a;
  y = y + x;
run;

data b2;
  set a;
  if _n_ = 1 then y = 0;
  y = y + x;
run;

data b2;
  put _all_;
  set a;
  y = y + x;

  RETAIN y 0;
run;

data b3;
  set a;
  y + x; /* sum statement */
run;

/* RETAIN */

/*
  If a variable name is specified only in the RETAIN
  statement and you do not specify an initial value,
  the variable is not written to the data set, and a note
  stating that the variable is uninitialized is written
  to the SAS log. If you specify an initial value, the
  variable is written to the data set.
*/

data b2;
  set a;
  retain y 0 z;
  y = y + x;
run;


/*
  data b2;
    set a;
    retain y 0 z;
    retain a1-a3 17;
    retain b1-b3 (2 3 4);
    retain c1-c3 (2);
    retain d1-d3 (7:9);
    y = y + x;
  run;
*/



/* x = x + 42;         */
/* A moze jakis skrot? */
data b1;
  set a;
  x += 100;
run;

data b1;
  set a;
  x =+ 100; /* x =(+ 100); */
run;

data b1;
  set a;
  x + 100; /* dokladniej o tym na kolejnych zajeciach */
run;

data b1;
  set a;
  i * 100; /* juĹź nie dziala */
run;

data b1;
  set a;
  i - 100; /* juĹź nie dziala */
run;


data b1;
  set a;
  i + (-100); /* juĹź dziala */
run;

data b1;
  set a;
  x * 100; /* polecenie X !!! :-) */
run;


/* if-then-else */
/*
  if <warunek> then 
    do;
         ...
    end;
  else
    do;
         ...
    end;

  SAS evaluates the expression in an IF-THEN statement
  to produce a result that is either non-zero, zero,
  or missing. 

  A non-zero and nonmissing result causes
  the expression to be true.

  A result of zero or missing
  causes the expression to be false.
*/

data _null_;
  x=10;

  if x > 5 then
    put x best2. " to duzo";
  else
    put x best2. " to malo";
run;


data _null_;
  x=1.889;

  if x > 5 then
    do;
      put x best2. " to duzo";
      put "dobrze ze duzo :-)";
    end;
  else
    do;
      put x best2. " to malo";
      put "slabo ze malo :-(";
    end;
run;






data _null_;
  do i = 1 to 3;
    if i = 2 then 
      do;
        put 'Dwojka to i=' i;
      end;
    else; * <- bez średnika;
      do;
        put 'Inne niz dwojka to i=' i;
      end;
  end;
run;


/* powinno byc: */
data _null_;
  do i = 1 to 3;
    if i = 2 then
      do;
        put 'Dwojka to i=' i;
      end;
    else 
      do;
        put 'Inne niz dwojka to i=' i;
      end;
  end;
run;

/* mozna robic zagniezdzone if'y */
data a;
  input x @@; /* Lab nr 5 */
cards;
4 8 10 12 19
;
run;

data _null_;
set a;
    if x < 5
      then put x= best2. "jest mniejsze niz 5";
    else
      if x < 7
        then put x= best2. "jest mniejsze niz 7";
      else
        if x < 9
          then put x= best2. "jest mniejsze niz 9";
        else
          if x < 11
            then put x= best2. "jest mniejsze niz 11";
          else
            if x < 13
              then put x= best2. "jest mniejsze niz 13";
            else
              put x= best2. "jest wieksze niz 13!";
run;

/* Uwaga/Ciekawostka! - "dangling ELSE problem" */

data in;
  a=1; b=0; output;
  a=0; b=1; output;
  a=1; b=1; output;
  a=0; b=0; output;
run;

data out;
  set in;

  if a then     if b then v1=1;      else v1=2; /* do ktorego IFa nalezy to ELSE? */
  
  if a then do; if b then v2=1; end; else v2=2;
 
  if a then do; if b then v3=1; else v3=2; end;
run;
proc print;
run;



/*********************************************************/

/* x ^= 7; x ne 7; x ~= 7; */

data a;
  x=1;output;
  x=2;output;
  x=3;output;
  x=4;output;
  x=5;output;
run;


/* select statement */
/* dwie wersje!     */
/*
  SELECT <(select-expression)> ;
    WHEN-1 (when-expression-1 <..., when-expression-n> )
            statement;
    <...
    WHEN-n (when-expression-1 <...,when-expression-n> )
            statement;
    >
    < OTHERWISE  statement;>
  END;
*/

data _null_;
set a;
    select (x);
        when (4) put x= best2. "jest pierwsze 4";
        when (4) put x= best2. "jest drugie   4";
    end;
run;

data _null_;
set a;
    select (x);
        when (4)  put x= best2. "jest pierwsze 4";
        when (4)  put x= best2. "jest drugie   4";
        otherwise put x= best2. "nie jest 4";
    end;
run;

data _null_;
set a;
    select;
        when (x=4)  put x= best2. "jest pierwsze 4";
        when (x=4)  put x= best2. "jest drugie   4";
        when (x=19) put x= best2. "jest pierwsze 19";
        otherwise   put x= best2. "nie jest 4 i 19";
    end;
run;

data _null_;
set a;
    select;
        when (x=4, x=8) put x= best2. "jest 4 lub 8";
        when (x>19)     put x= best2. "jest wieksze niz 19";
        otherwise       put x= best2. "nie jest inne";
    end;
run;



/* ifn() ifc() */


data c;
  set a;

  y = ifn(x>3,1,0);

  z = ifc(x>3,"A","ABC"); /* length!! */

run;

data c1;
  length z $ 1;
  set a;

  y = ifn(x>3,1,0);

  z = ifc(x>3,"A","B");

run;

data c2;
  set a;

  y = ifn(x>3,1,0);

  length z $ 1;
  z = ifc(x>3,"A","B");

run;

options MSGLEVEL=I; /* I | N */
/****************************************************/

/* funkcja LAG i DIF      */
/* UWAGA z kazdzym wystapieniem funkcji LAG() w kodzie
   zwiazana jest oddzielna, dedykowana danemu wystapieniu, 
   kolejka pomocnicza w pamieci
*/

data a;
 do x=1 to 7;
  output;
 end;
run;

data b1;
  *put 'jeden ' _all_;
   set a;
  *put 'dwa   ' _all_;
   y = LAG(x);
  *put 'trzy  ' _all_;
run;
/*
  mozna uzyc LAG tak by wygladalo, ze przypisze 
  zmiennej 'y' wartosc 'x' z poprzedniej obserwacji, 
  swego rodzaju "patrzenie wstecz"
*/
/*
  The queue for each occurrence of LAGn is initialized
  with n missing values, where n is the length of the
  queue (for example, a LAG2 queue is initialized with
  two missing values). When an occurrence of LAGn is
  executed, the value at the top of its queue is removed
  and returned, the remaining values are shifted upwards,
  and the new value of the argument is placed at the
  bottom of the queue. Hence, missing values are returned
  for the first n executions of each occurrence of LAGn,
  after which the lagged values of the argument begin to
  appear.
*/
data b2;
  *put 'jeden ' _all_;
   set a;
  *put 'dwa   ' _all_;
   y=LAG2(x);
  *put 'trzy  ' _all_;
run;

data aa;
  length c $ 7;
  c="ABC"; output;
  c="AB"; output;
  c="A"; output;
run;

data bb2;
   set aa;
   d=LAG(c);
run;

data bb2_2;
   set aa;
   d=LAG(c !! "XYZ123456");
run;

/* DIFn is defined as DIFn(x) = x-LAGn(x) */
data b3;
 set a;
 y=dif(x);
run;
/* DIF(x) czytamy jak 'x-LAG(x)' */

data b4;
 set a;
 y=dif2(x);
run;
/* DIF2(x) czytamy jak 'x-LAG2(x)' */

data b5;
 set a;
 y1=dif2(x);
 y2=dif(dif(x));
run;
/* dif2(x) != dif(dif(x)) */

data b6;
 set a;
 y1=lag(x);
 y2=lag2(x);
run;
/* dwie tabele w pamieci */

data b7;      putlog "1)" _all_;
 set a;       putlog "2)" _all_;
 y1=lag(x);   putlog "3)" _all_;
 y2=lag2(y1); putlog "4)" _all_;putlog;
run;

/*
  Storing values at the bottom of the queue and returning
  values from the top of the queue occurs _only_ when the
  function is executed. An occurrence of the LAGn function
  that is executed conditionally will store and return
  values only from the observations for which the
  condition is satisfied.
*/

data b8;
 set a;
 if mod(x,2) = 0 then y = lag(x);
run;
/* kropki na nieparzystych bo 'y' jest misingowana!!, */
/* co robi SAS?:

  Inicjuje wektor PDV [x=.|y=.|_N_=0|_ERROR_=0], w pamieci
  tworzy sobie kolejke pomocnicza dla
  LAG(x) zainicjonowana brakiem danych (kropka)

  Pierwszy obrot petli glownej, wektor PDV ma postac
  [x=1|y=.|_N_=1|_ERROR_=0], 'y' dostaje kropke
  bo tak byl zainicjowany wektor PDV, ale 'IF' sie nie
  wykonuje, w pamieci kolejka LAG(x) zostaje bez zmian.

  OUTPUT. x=1 y=.

  Kolejny obrot petli glownej, wcztywana jest wartosc 'x' 
  czyli 2, na poczÄtku 'y' jest kropka bo jest
  misingowana, wykonywany jest 'IF' i 'y' staje sie
  kropka (ta z kolejki LAG(x)) a w kolejce LAG(x) wstawiana jest
  aktualna wartosc 'x' odczytana z wektora PDV, czyli 2.

  OUTPUT. x=2 y=.

  Trzeci obrot petli glownej, wektor PDV
  [x=3|y=.|_N_=3|_ERROR_=0], ('y' jest . bo byl
  misingowany), nie jest wykonywany 'IF' wiÄc LAG(x) bez
  zmian.

  OUTPUT. x=3 y=.

  Czwarty obrot petli glownej, wektor PDV
  [x=4|y=.|_N_=4|_ERROR_=0], 'IF' jest wykonywany, 'y'
  dostaje wartosc z gory kolejki LAG(x) czyli 2,
  w kolejce LAG(x) pojawia siÄ aktualna wartosc 'x'
  czyli 4.

  OUTPUT x=4 y=2 itd.
*/

data b9;
    set a;
    if mod(x,2)=0 then y=lag(x);
    if mod(x,3)=0 then z=lag(x);
run;
/* analogicznie jak wyzej, z tym, ze w pamieci sa dwie
   kolejki dla LAG(x)
*/

data b10;
    set a;
    if mod(x,2) = 0 then y = lag(r);
    /* tutaj wszedzie gdzie sa parzyste (poza
       wielokrotnosciami 3) mamy kropki, bo r jest
       niezainicjowany i misingowany*/
    if mod(x,3) = 0 then y = lag(x);
run;

/*
  potwierdzenie, ze faktycznie sa oddzielne kolejki dla
  kazdego wystapienia LAG
*/
data b11;
set a;
    y = lag(x);
    if y > 3 then z = lag(x);
run;

data b12;
 set a;
 if x <= 5 then y = lag(x);
  else y = lag(x);
run;
/*
  na obserwacji 6 bedzie kropka, bo wtedy pierwszy raz
  wykonywany jest drugi z LAG'ow.
*/

data b13;
    set a;
    if 3 = lag(x) then y='bla bla bla';
run;
/*
  wszystko co jest po 'THEN' wykona sie dla
  czwartej obserwacji
*/

/* dwa kolejne kody sa rownowazne */
data b14;
 set a;
 if 1 = (x - lag(x)) then x = x + 1;
run;

data a15;
 set a;
 z=lag(x);
 if 1 = (x - z) then x = x + 1;
run;
/************************/

/* PRZYKLAD 1. przeglad */
data b16;
    set a;
    r = LAG(x);
    p = LAG2(x);
    q = LAG(LAG(x)); /* LAG(LAG(x))=LAG2(x) */

    t = DIF(x);
    y = DIF2(x);
    z = DIF(DIF(x));
    /* (DIF(x)-LAG(DIF(x))) =
                    x - LAG(x) - LAG(x-LAG(x)) */
    z1 = x - LAG(x) - LAG(t);
run;

/* PRZYKLAD 2. argument moze byc wyrazeniem */
data _null_;
  x = 1;
  put "s) " i= x=;
  do i = 1 to 12;
    put "1) " i= x=;
    x = lag2(x + 1); /* argument moze byc wyrazeniem */
    put "2) " i= x=;
  end;
  put "e) " i= x=;
run;
