/* ------------------------------- */
/* zadanie 1 */
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
/* zadanie 9 */
data Fx;
    input x fx;
    datalines;
1 0.1
2 0.3
3 0.5
4 0.7
5 1.0
;

proc print data=Fx;
run;

data px;
    set Fx;
    if _n_ = 1 then prev_fx = 0; 
    px = fx - prev_fx; 
    prev_fx = fx; 
    output;
run;

proc print data=px;
run;


/* ------------------------------- */
/* zadanie 10 */
data trajektoria1 trajektoria2 max_odchylenie wspolne_wierzcholki przeciecia;
    retain x1 0 x2 0;
    array max_odchylenie{8} 0;
    array wspolne_wierzcholki{2} (0 0);
    array poprzednie_x{2} (0 0);
    array przeciecia{2} (0 0);
    n = 1000; /* liczba kroków w trajektorii */

    do i = 1 to n;
        x1 = x1 + rand("normal");
        x2 = x2 + rand("normal");

        /* (a) Maksymalne odchylenia od zera */
        max_odchylenie[1] = max(max_odchylenie[1], abs(x1));
        max_odchylenie[2] = max(max_odchylenie[2], abs(x2));

        /* (b) Liczba wspólnych wierzchołków */
        wspolne_wierzcholki[1] + (poprzednie_x[1] ne 0 and x1 = 0);
        wspolne_wierzcholki[2] + (poprzednie_x[2] ne 0 and x2 = 0);

        /* (c) Liczba przecięć */
        przeciecia[1] + (poprzednie_x[1] > 0 and x1 < 0);
        przeciecia[2] + (poprzednie_x[2] > 0 and x2 < 0);

        poprzednie_x[1] = x1;
        poprzednie_x[2] = x2;
        
        output trajektoria1;
        output trajektoria2;
    end;

    drop i n;
run;

/* Wypisanie wyników do loga */
proc print data=max_odchylenie noobs; 
    var max_odchylenie1 max_odchylenie2;
    title 'Maksymalne odchylenia od zera';
run;

proc print data=wspolne_wierzcholki noobs; 
    var wspolne_wierzcholki1 wspolne_wierzcholki2;
    title 'Liczba wspólnych wierzchołków';
run;

proc print data=przeciecia noobs; 
    var przeciecia1 przeciecia2;
    title 'Liczba przecięć';




	
