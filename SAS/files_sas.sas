libname bib "/home/u63791642/datasets/setLab5/";
run;


/* --------- */
/* zadanie 1 */
/* --------- */

data L05z01;
   infile "/home/u63791642/datasets/setLab5/L05z01_plik1.txt";
   input id $ nazwisko $ wzrost $ plec $ numer;
run;

data L05z02;
   infile "/home/u63791642/datasets/setLab5/L05z01_plik2.txt" dlm='?/\|*^@!#$' truncover;
   input id $ nazwisko $ numer $ imie $ plec $ waga;
run;

data L05z03;
   infile "/home/u63791642/datasets/setLab5/L05z01_plik3.txt";
   input @1 id 2. @3 nazwisko $10. @13 imie $6. @19 waga 2. @21 plec $2. @23 wzrost 3.;
run;

data L05z04;
   infile "/home/u63791642/datasets/setLab5/L05z01_plik4.txt";
   input id imie $ nazwisko $ liczba data :date9. plec $;
   informat liczba comma10.2;
   format data ddmmyy10.;
run;

data L05z05;
   infile "/home/u63791642/datasets/setLab5/L05z01_plik5.txt";
   input id :$2. imie $20. nazwisko $20. wzrost plec waga $2. stan_konta;
   input @;
   if index("MF", upcase(substr(_infile_, _infile_, 1))) then 
   plec = upcase(substr(_infile_, _infile_, 1));
   informat stan_konta comma12.;
   format stan_konta comma12.;
   informat waga wz8.;
   informat wzrost wz8.;
   format waga wz8.;
   format wzrost wz8.;
run;
proc print;

/* --------- */
/* zadanie 2 */
/* --------- */


data eksperyment;
    infile "/home/u63791642/datasets/setLab5/L05z02_eksperyment.txt" dlm=' ';
    input date $ punkty $ wartosc $;
    if wartosc in ('START', 'STOP') then output;
    format date mmddyy10.;
run;
proc print data=eksperyment;
run;

proc sort data=eksperyment;
    by date;
run;

data wyniki;
    set eksperyment;
    by date;
    retain sum_points 0;
    if wartosc = 'START' then do;
        sum_points = punkty;
    end;
    else if wartosc = 'STOP' then do;
        output;
    end;
    else do;
        sum_points + punkty;
    end;
run;

proc sort data=wyniki;
    by descending sum_points;
run;

/* --------- */
/* zadanie 3 */
/* --------- */

data dane;
   infile "/home/u63791642/datasets/setLab5/L05z03_plik.txt" truncover;

   length data $10. q0 q1 q2 q3 q4 q5 8; /* Deklaracja zmiennych */
   input data $10. q0 q1 $ q2 q3 q4 q5;
   drop q0;
run;
data L05z03_plik;
    set dane;
    retain prev_date;
    if missing(data) then data = prev_date;
    else prev_date = data;
    drop prev_date;
run;
proc sort data=L05z03_plik;
    by data;
run;
proc print;

/* --------- */
/* zadanie 4 */
/* --------- */


data dane;
   infile "/home/u63791642/datasets/setLab5/L05z04_plik.txt" dlm=' ' truncover;
   length id 3 Id1 $5. Id2 $5. date $20. value1 value2 8;

   input id @4 Id1 @11 Id2 $ value1 value2 date $;
   date = tranwrd(date, ":", "/");
   date = put(date, yymmdd10.);
   format date $10.;
run;
data dane;
    set dane;
    retain prev_date;
    if missing(date) then date = prev_date;
    else prev_date = date;
    temp=1;
    output;
    temp=2;
	output;
    drop prev_date;
run;
proc sort data=dane;
    by id;
run;
data rozdzielone;
	set dane;
	if temp=1 then do;
		Id2=.;
		value2=.;
	end;
	if temp=2 then do;
		Id1=Id2;
		value1=value2;
	end;
	drop Id2 value2 temp;
run;
data L05z04_plik;
	set rozdzielone(rename=(Id1=osoba value1=kwota));
    retain id2 0;
    id2 +1;
    id = id2;
    drop id2;
run;
proc print;


/* --------- */
/* zadanie 5 */
/* --------- */

*a;
data L05z05_plika;
   infile "/home/u63791642/datasets/setLab5/L05z05_plik.txt" truncover;
	input line $200.;
   ID = scan(line, 1, ' ');
   LastValue = scan(line, -1, ' ');
   drop line;
run;

*b;
data L05z05_plikb;
   infile "/home/u63791642/datasets/setLab5/L05z05_plik.txt" dlm=' ' truncover;
   input id $ kod $ wynik;
run;
proc print data=L05z05_plikb noobs;
    var ID Kod Wynik;
run;

/* --------- */
/* zadanie 6 */
/* --------- */

data L05z06_plik;
    infile "/home/u63791642/datasets/setLab5/L05z06_plik.txt" truncover;
    input @;
    do i = 1 to 5;  
        input value1 : ?? 1. value2 : ?? 1. value3 : ?? 1.; 
        if not missing(value1) then do;  
        	if not missing(value2) then do;  
        	        if not missing(value3) then do;  
        	        output;
        	  		end;
        	end;
        end;
    end;
    drop i;
run;

/* --------- */
/* zadanie 7 */
/* --------- */

data L05z07_plik;
    infile "/home/u63791642/datasets/setLab5/L05z07_plik.txt" dlm=' ' truncover;
    input @1 year 4. @;
    array years{1976:1981} r1976-r1981; 
    do i = 1 to 5;
        input r1976-r1981;
        output; 
    end;
    drop i year r1976;
run;
proc print;

/* --------- */
/* zadanie 8 */
/* --------- */
data wiersze;
    infile "/home/u63791642/datasets/setLab5/L05z08_plik.txt" truncover;
    array wiersze{1}; 
    do _n_ = 1 to 112; 
        input wiersze{_n_} : 1.;
        if _n_ = _n_ then leave; 
    end;
run;
proc sort data=wiersze nodup;
	by wiersze1;
run;
data dane;
    infile "/home/u63791642/datasets/setLab5/L05z08_plik.txt" dlm='' truncover;
    input wiersze1 x1-x11;
run;
proc sort data=dane nodup;
	by wiersze1;
run;
data merged;
    merge wiersze(in=a) dane(in=b);
    by wiersze1;
    if a;
run;
proc sort data=merged nodupkey;
	by wiersze1;
run;
proc print;


/* --------- */
/* zadanie 9 */
/* --------- */

data zad9;
	set bib.l05z09;
    retain point;
    if _N_ = 1 then do; 
        array indexes{12} kol1-kol12; 
        do i = 1 to 12; 
            if not missing(indexes{i}) then do;
                point = indexes{i}; 
                output;
            end;
        end;
    end;
    else if _N_ = point then output; 
run;
proc print;

/* --------- */
/* zadanie 10 */
/* --------- */

data z10;
    retain current_node 1;
    set bib.l05z10_drzewo;
    if _n_ = 1 then output;

    do while(current_node ne .);
        if lewy = . or prawy = . then leave; 
        
        direction = ceil(rand('uniform') * 2) - 1;

        if direction = 0 then current_node = lewy;
        else current_node = prawy;

        set bib.l05z10_drzewo point=current_node;
        output;
    end;

    stop; 
run;
proc print;

/* --------- */
/* zadanie 11 */
/* --------- */

data eksperymenty;
	set bib.l05z05_plikb;
run;
proc sort data=eksperymenty;
	by id;
run;
filename raport "/home/u63791642/datasets/setLab5/L05z011_raport.txt";
data _null_;
    set eksperymenty;
    by id;

    file raport;
    if first.id then do;
        put '          Podsumowanie eksperymentu         ' _n_ / ;
        put 'Dane pacjenta nr ' id / @;
        put '+-------------------------------------------+' / @;
        put 'Wyniki eksperymentów pośrednich:';
    end;
	
	if kod='x' then put wynik @;

    if last.id then do;
        put / 'Wynik końcowy to: ' wynik @;
        put;
        put '+-------------------------------------------+' / @;
        put;
    end;
run;



/* --------- */
/* zadanie 12 */
/* --------- */

proc export data=L05z03_plik
    outfile='/home/u63791642/datasets/setLab5/L05z03.XLSX'
    dbms=xlsx replace;
run;
proc export data=L05z04_plik
    outfile='/home/u63791642/datasets/setLab5/L05z04.XLSX'
    dbms=xlsx replace;
run;
