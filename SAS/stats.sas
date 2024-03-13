libname bib "/home/u63791642/datasets/";
run;

/* ------------------------------- */
/* task 1 */
data zad1;
	call streaminit(0);

*losowa liczba obserwacji >10;
	n = ceil(10+rand("uniform")*100);

* x z U[-1,1] oraz y z N(3,1);
	do i=1 to n;
		x=-1+2*rand("uniform");
		y=rand("normal",3,1);
		output;
	end;
	drop n;
run;

data stats;
	set zad1;
		suma_x+x;
		suma_y+y;
		srednia_x=suma_x/_n_;
		srednia_y=suma_y/_n_;
		min_x = min(x, min_x);
		min_y = min(min_y, y);
		max_x = max(max_x, x);
		max_y = max(max_y, y);
	output;
*bo U[-1,1], N(3,1) więc min/max nie wyjdą po za:;
	retain min_x 1 max_x -1 min_y 3 max_y 0 
	suma_x 0 suma_y 0 srednia_x 0 srednia_y 0; 
	drop x y i suma_x suma_y;
run;
proc print data=stats;
run;

/* ------------------------------- */
/* task 2 */

data zad2;
    set bib.l02z02;
    do i=1 to x;
    	output;
    end;
    drop i;
run;

/* ------------------------------- */
/* task 3 */

data zad3;
	set bib.l02z03;
	by descending x;
	retain klasyfikacja 0;
	
	if first.x then klasyfikacja+1;
	output;
run;

/* (*)gdy zbiór nieposortowany po x: */
proc sort data=bib.l02z03s;
	by descending x;
run;
data zad3_2;
	set bib.l02z03s;
	by descending x;
	retain klasyfikacja 0;
	
	if first.x then klasyfikacja+1;
	output;
run;

/* ------------------------------- */
/* task 4 */

data zad4;
	set bib.l02z04 end=last;
	retain n_wzrostow 0 n_spadkow 0;
	prev_index = lag(index);
	if _n_>1 then do;
		if index > prev_index then n_wzrostow+1;
		if index < prev_index then n_spadkow+1;
	end;
	drop prev_index;
	
	if last then do;
		keep n_wzrostow n_spadkow;
		output;
	end;
run;
proc print data=zad4;
run;

/* ------------------------------- */
/* task 5 */
data zad5_k1; 
	put "v1=" v1 "v2=" v2 "v3=" v3;
    set bib.l02z05; 
    put "v1=" v1 "v2=" v2 "v3=" v3;
	retain v3;
    v3 = v1 + v2;
run;

data zad5_k2; 
	put "v1=" v1 "v2=" v2 "v3=" v3 "v4=" v4;
    set bib.l02z05; 
	retain v3;
    v3 = v1 + v2;
    v4 = v1 + v2;
    put "v1=" v1 "v2=" v2 "v3=" v3 "v4=" v4;
run;

data zad5_k3; 
    put "2) v1=" v1 "v2=" v2 "v3=" v3 "v4=" v4;
    v3 = v1 + v2;
	put "1) v1=" v1 "v2=" v2 "v3=" v3 "v4=" v4;
    set bib.l02z05; 
	retain v4;
    v4 = v1 + v2;
run;

/* ------------------------------- */
/* task 6 */
data zad6;
	set bib.l02z04 end=last;
	retain n_maksim 0;
	prev_index = lag(index);
	prev2_index = lag2(index);
	if _n_=2 then do;
		if index<prev_index then n_maksim+1;
	end;
	
	if _n_>2 then do;
		if prev_index>index and prev_index>prev2_index then n_maksim+1;
	end;
	
	if last then do;
		keep n_maksim;
		output;
	end;
run;
proc print data=zad6;
run;

/* ------------------------------- */
/* task 7 */	
data zad7;
    set bib.l02z07 end=last;
    prev_x = lag(x);
    prev2_x = lag2(x);
    if prev_x = . then do;
        prev_x = (prev2_x + x) / 2;
    end;
    if _n_ >= 2 then output;
    if last then do;
    	prev_x = x;
    	output;
    end;
    keep prev_x;
run;
proc print data=zad7;
run;

** podwojne braki danych;
data zad7_2;
    set bib.l02z07s end=last;
    prev_x = lag(x);
    prev2_x = lag2(x);
    prev3_x = lag3(x);
    if prev_x = . then do;
        prev_x = (prev2_x + x) / 2;
    end;
    if prev2_x = . and prev_x = . then do; 
        prev2_x = prev_x;
        prev_x = (prev3_x + x) / 2;
    end;
    if _n_ >= 2 then output;
    if last then do;
    	prev_x = x;
    	output;
    end;
    keep prev_x
run;
data zad7_2;
    set zad7_2 end=last;
    p = lag(prev_x);
	p2 = lag2(prev_x);
	p3 = lag3(prev_x);
    if p = . then do;
        p = (p2 + prev_x) / 2;
    end;
    if p2 = . and p = . then do; 
        p2 = p;
        p = (p3 + prev_x) / 2;
    end;
    if _n_ >= 2 then output;
    if last then do;
    	p = prev_x;
    	output;
    end;
    keep p;
    rename p=x;
run;
proc print data=zad7_2;
run;
**;

/* ------------------------------- */
/* task 8 */
data zad8;
    set bib.l02z08;
    if rand("uniform") < 0.5 then do;
        output; 
        x = .; 
    end;
    if rand("uniform") < 0.5 then do;
        output; 
        y = .; 
    end;
    output;
run;
proc print;


/* ------------------------------- */
/* task 9 */
data Fx;
    input x fx;
    datalines;
1 0.1
2 0.15
3 0.24
4 0.4
5 0.77
6 0.83
7 0.9
8 1.0
;
data px;
    set Fx;
    px = fx - lag(fx); 
	if _n_=1 then px = fx;
	keep px;
run;
proc print data=px;
run;


/* ------------------------------- */
/* task 10 */
data max_odchylenie;
    call streaminit(0);  /* Inicjalizacja generatora liczb losowych */
    
    do _replica = 1 to 1000;  
        x1 = 0;
        x2 = 0;
        max_odchylenie1 = 0;
        max_odchylenie2 = 0;
        
        do _obs = 1 to 100;  
        	if rand("uniform") < 0.5 then x1 = x1 + 1;
        	else x1 = x1 - 1;
        	if rand("uniform") < 0.5 then x2 = x2 + 1;
        	else x2 = x2 - 1;

            max_odchylenie1 = max(max_odchylenie1, abs(x1));
            max_odchylenie2 = max(max_odchylenie2, abs(x2));
        end;
        
        put "Maks odchylenie od zera (Trajektoria 1): " max_odchylenie1
            " Maks odchylenie od zera (Trajektoria 2): " max_odchylenie2;
        keep max_odchylenie1 max_odchylenie2;
    end;
run;
proc print;
