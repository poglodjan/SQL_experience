libname bib "/home/u63791642/datasets/setsLab3/";
run;
libname bib_2 "/home/u63791642/datasets/setsLab2/";
run;

/* ------------------------------- */
/* zadanie 1 */
/* ------------------------------- */

*a) bez użycia BY;
data srednie;
  set zad1;
  
  if _n_ = 1 then do;
    suma_y = 0;
    licznik = 0;
  end;

  if x = lag(x) then do;
    suma_y + y;
    licznik + 1;
  end;
  else do;
    srednia_y = suma_y / licznik;
    output;
    suma_y = y;
    licznik = 1;
  end;

  if last.id then do;
    srednia_y = suma_y / licznik;
    output;
  end;
  
  drop suma_y licznik y;
run;
data srednie;
  set srednie;
  x = lag(x);
  if _n_ > 1 then output;
run;
proc print;
run;

*b) z użyciem BY;
data zad1;
	set bib.l03z01;
run;
proc means data=zad1 mean;
	by x;
	var y;
run;

/* ------------------------------- */
/* zadanie 2 */
/* ------------------------------- */
data zad2;
  do i=1 to 5000;
  	x=rand("uniform")*120;
  	output;
  end;
run;

data zad2_podzielone;
	set zad2;
	
	if x<=20 then warstwa=1;
	else if x<=40 then warstwa=2;
	else if x<=60 then warstwa=3;
	else if x<=80 then warstwa=4;
	else if x<=100 then warstwa=5;
	else if x<=120 then warstwa=6;
	drop i;
run;
proc sort data=zad2_podzielone;
  by warstwa;
run;

data statystyki;
	set zad2_podzielone;
	by warstwa;
	
	retain max_w_warstwie min_w_warstwie n_obserwacji;
	
	if first.warstwa then do;
		max_w_warstwie=0;
		min_w_warstwie=120;
		n_obserwacji=1;
	end;
	
	n_obserwacji+1;
	if x>max_w_warstwie then max_w_warstwie=x;
	if x<min_w_warstwie then min_w_warstwie=x;
	
	if last.warstwa then output;
	drop x;
run;
proc print data=statystyki;
run;

/* ------------------------------- */
/* zadanie 3 */
/* ------------------------------- */

data zad3;
	set bib.l03z03;
    by x;

    if first.x then do;
        grupa = 1;
        count_x = 1;
    end;
    else count_x + 1;

    if count_x > 12 then do;
        grupa + 1;
        count_x = 1;
    end;

    if last.x then output;

    *drop count_x;
run;
proc print;

/* ------------------------------- */
/* zadanie 4 */
/* ------------------------------- */
*a);
proc sort data=bib.l03z04;
    by liczba litera;
run;
data zad4_a;
	set bib.l03z04;
	by liczba litera;

    retain counter;

    if first.liczba then do;
        counter = 0;
    end;

    if first.litera then do;
        counter = counter + 1;
    end;

    if last.liczba then do;
        if counter>=4 then output; 
    end;
    drop litera;
run;
proc print;

/* ------------------------------- */
*b);
/* ------------------------------- */
data zad4_b;
	set bib.l03z04;
	by liczba litera;

    retain counter;

    if first.liczba then do;
        counter = 0;
    end;

    if first.litera then do;
        counter = counter + 1;
    end;
    drop litera;
run;
proc sort data=zad4_b nodup;
    by descending counter;
run;
proc print;
data zad4_b;
	set zad4_b;
	max_c = max(max_c, counter);
    retain max_c;
	if max_c<=counter then output;
	keep liczba counter;
run;
proc print;



/* ------------------------------- */
*c);
/* ------------------------------- */
proc sort data=bib.l03z04;
    by litera;
run;
data zad4_c;
	set bib.l03z04;
    by litera;

    retain suma_litera licznik;

    if first.litera then do;
        suma_litera = 0;
        licznik = 0;
    end;

    if licznik < 5 then do;
        suma_litera + liczba;
        licznik + 1;
    end;

    if last.litera then do;
        srednia = suma_litera / licznik;
        output;
    end;

    drop suma_litera licznik liczba;
run;

/* ------------------------------- */
*d);
/* ------------------------------- */
data zad4_d;
	set bib.l03z04;
    by litera;
	retain licznik;
	
    if lag(litera) ne litera then do;
        licznik = 0;
    end;
    licznik + 1;
run;
data max_licznik;
    set zad4_d;
    by litera
    retain max_licznik;

    if first.litera then max_licznik = licznik;
    else max_licznik = max(max_licznik, licznik);

    if last.litera then output;

    drop liczba licznik;
run;
data merged_4d;
	merge zad4_d max_licznik;
	by litera;
	if litera=litera then output;
	drop licznik;
run;
proc print;
data zad4_d;
	set merged_4d;
    by litera;
	retain suma_ostatnich5 licznik;

    if first.litera then do;
        suma_ostatnich5 = 0;
        licznik = 0;
    end;
	
	if max_licznik < 5 then do;
    suma_ostatnich5 = suma_ostatnich5 + liczba;
    licznik + 1;
	end;
	else licznik + 1;
	
	if max_licznik>=5 and licznik > (max_licznik - 5) then do;
	    suma_ostatnich5 = suma_ostatnich5 + liczba;
	end;

    if last.litera then do;
        srednia_ostatnich5 = suma_ostatnich5 / min(licznik, 5);
        output;
    end;
    keep litera srednia_ostatnich5;
run;
proc print;
/* ------------------------------- */
*e);
/* ------------------------------- */
data zad4_e;
	set bib.l03z04;
    by litera;

    retain czy_0 czy_9;

    if first.litera then do;
        czy_0 = 0;
        czy_9 = 0;
    end;

    if liczba=9 then czy_9 = 1;
    if liczba=0 then czy_0 = 1;
    
    if czy_9=czy_0 and czy_9=1 then output;
    drop liczba;
run;
proc sort data=zad4_e nodupkey;
    by litera;
run;
proc print;

/* ------------------------------- */
*f);
/* ------------------------------- */
data zad4_f;
	set bib.l03z04;
    by litera liczba;

    retain max_counter aktualny_counter;

    if first.litera then do;
        max_counter = 0;
        aktualny_counter = 0;
    end;

    if liczba = lag(liczba) then do;
        aktualny_counter + 1;
    end;
    else do;
        aktualny_counter = 1;
    end;

    if aktualny_counter > max_counter then do;
        max_counter = aktualny_counter;
    end;

    if last.litera then do;
        output;
    end;

    drop aktualny_counter;
run;

data merged_f;
    merge bib.l03z04 (in=a) zad4_f (in=b);
    by litera;
    if a and b;
    drop liczba;
run;
proc sort data=merged_f nodup;
    by descending max_counter;
run;

data zad4_f;
	set merged_f;
	max_c = max(max_c, max_counter);
    retain max_c;
	if max_c<=max_counter then output;
	keep litera max_counter;
run;
proc print;

/* ------------------------------- */
* zadanie 5;
/* ------------------------------- */

proc sort data=bib.l03z05;
    by grupa argument;
run;
data zad5;
	length czy_funkcja $5;
	set bib.l03z05;
    by grupa;
    retain czy_funkcja;
    if first.grupa then do;
        argument_min = argument;
        argument_max = argument;
        czy_funkcja="TAK";
    end;
    
    if argument = lag(argument) and wartosc ne lag(wartosc) then czy_funkcja="NIE";
	
    keep grupa czy_funkcja;
run;
proc sort data=zad5 nodup;
    by grupa czy_funkcja;
run;
data zad5;
	set zad5;
	if czy_funkcja="TAK" and grupa=lag(grupa) and "NIE"=lag(czy_funkcja) then return;
	else output;
proc print data=zad5;
run;

/* ------------------------------- */
* zadanie 6;
/* ------------------------------- */
* a);
data zad6_a;
	set bib.l03z06;
run;
proc means data=zad6_a mean;
	class plec partia;
	var p;
	output out=srednie_poziomy_poparcie mean=;
run;
proc print;

/* ------------------------------- */
* b);
data zad6_b;
  set bib.l03z06 end=koniec;
  by id;
  retain suma_p 0 licznik 0;

  if first.id then suma_p = 0;
  if partia in ('A', 'B', 'C') then suma_p + p;

   if last.id then do;
     if suma_p < 100 then do;
     licznik+1;
     end;
   end;
  
  if koniec then output;
  keep licznik;
run;
/* ------------------------------- */
* c);
data poparcie;
	set bib.l03z06;
  	by id;

  retain poparcie_A poparcie_B poparcie_C;

  if partia = 'A' then poparcie_A = p;
  else if partia = 'B' then poparcie_B = p;
  else if partia = 'C' then poparcie_C = p;

  if last.id then do;
  	output;
    poparcie_A = 0;
    poparcie_B = 0;
    poparcie_C = 0;
  end;
  
  keep id poparcie_A poparcie_B poparcie_C;
run;
data zad5_c;
	set poparcie end=koniec;
	retain AB 0 AC 0 BC 0;
	if poparcie_A+poparcie_B>max(poparcie_A+poparcie_C,poparcie_C+poparcie_B) then AB+1;
	else if poparcie_A+poparcie_C>max(poparcie_B+poparcie_C,poparcie_C+poparcie_B) then AC+1;
	else if poparcie_C+poparcie_B>max(poparcie_A+poparcie_C,poparcie_A+poparcie_B) then BC+1;
	if koniec then output;
	keep AB AC BC;
run;
proc print;


/* ------------------------------- */
* zadanie 7;
/* ------------------------------- */
proc sort data=bib.l03z07 nodup;
    by okr;
run;
data zad7_zapis;
	set bib.l03z07;
	by okr;

  retain pierwsza_obserwacja ostatnia_obserwacja;

  if first.okr then pierwsza_obserwacja = pcz;
  else pierwsza_obserwacja=.;
  if last.okr then ostatnia_obserwacja = pcz;
  else ostatnia_obserwacja=.;
  drop pcz;
run;
proc sort data=zad7_zapis nodupkey;
    by okr pierwsza_obserwacja ostatnia_obserwacja;
run;
data srednie;
	set zad7_zapis;
	temp = lag(ostatnia_obserwacja);
	if temp ne . then do;
		srednia = (temp+pierwsza_obserwacja)/2;
		output;
	end;
	keep okr srednia;
run;
data merged_7;
	merge bib.l03z07(in=in1) srednie(in=in2);
    by okr;
    if in1 and in2 then output;
run;
data zad_7_res;
	set merged_7;
	if pcz=. then pcz=srednia;
	drop srednia;
run;
proc print;

data zad_7_2;
	set zad_7_res;
	by okr;

  retain suma_pcz licznik min_pcz max_pcz;

  if first.okr then do;
    suma_pcz = 0;
    licznik = 0;
    min_pcz = .;
    max_pcz = .;
  end;

  if not missing(pcz) then do;
    suma_pcz + pcz;
    licznik + 1;

    if licznik = 1 then min_pcz = pcz;
    else if pcz < min_pcz then min_pcz = pcz;

    if pcz > max_pcz then max_pcz = pcz;
  end;

  if last.okr then do;
    srednia = suma_pcz / licznik;
    zakres_srednich = max_pcz - min_pcz;
    output;
  end;
	keep okr srednia zakres_srednich;
run;
proc print data=zad_7_2;
run;

/* ------------------------------- */
* zadanie 8;
/* ------------------------------- */
data zad7;
set bib_2.l02z03s;
  by descending x
  retain klasyfikacja;

  if first.x then klasyfikacja + 1;

  output;

  drop x;
run;
proc print;


