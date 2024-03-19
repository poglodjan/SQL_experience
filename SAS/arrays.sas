libname bib "/home/u63791642/datasets/setsLab4/";
run;

/* ------------------------------- */
/* zadanie 1 */
/* ------------------------------- */

*a);
proc freq data=bib.l04z01;
	tables id*(pytanie_1-pytanie_41) / sparse out=odpowiedzi_osoby;
run;

data odpowiedzi;
  set bib.l04z01;
  array odpowiedzi{41} $1. pytanie_1-pytanie_41;
  
  do i=1 to dim(odpowiedzi);
  	odpowiedz = odpowiedzi[i];
  	osoba_odpowiedz_count = put(id, 8.);
  	count = count+1;
  	output;
  end;
run;

*b);
proc freq data=bib.l04z01;
	tables (pytanie_1-pytanie_41) / out=odpowiedzi_freq;
run;

*c);
proc freq data=bib.l04z01;
	tables (pytanie_1-pytanie_41) / out=liczba_odpowiedzi (keep=pytanie_: odpowiedz frequency);
run;

*d);
data braki;
	set bib.l04z01;
	n_brakow = NMISS(of pytanie_:);
run;

data braki_filtr;
	set braki;
	if n_brakow>1;
	keep n_brakow;
run;

proc print data=braki_filtr(obs=1) noobs;
	var n_brakow;
run;


/* ------------------------------- */
/* zadanie 2 */
/* ------------------------------- */
data zad;
	set bib.l04z02;
	array A{39} A1-A39; 
    array Wybrane{12} Wybrana1-Wybrana12; 

    do i = 1 to m;
        do j = 1 to 12; 
            index = int(ranuni(0) * (u - l + 1)) + l; 
            Wybrane{j} = A{index}; 
        end;
        output;
    end;
run;

proc print data=zad noobs;
    var Wybrana:;
run;

/* ------------------------------- */
/* zadanie 3 */
/* ------------------------------- */
%let n = 10;

data pascal_triangle;
    array pascal{&n, &n} _temporary_;


    do i = 1 to &n;
        pascal{i, 1} = 1;
        pascal{i, i} = 1;
    end;

    
    do i = 3 to &n;
        do j = 2 to i - 1;
            pascal{i, j} = pascal{i - 1, j - 1} + pascal{i - 1, j};
        end;
    end;
run;

proc print data=pascal_triangle noobs;
    var pascal:;
run;


/* ------------------------------- */
/* zadanie 4 */
/* ------------------------------- */

* zbior z 83 brakami danych: ;
data braki_index;
    do i = 1 to 83;
        index = rand("integer", 1, 1600); 
        output;
    end;
run;

proc sort data=braki_index;
    by index;
run;

data L04z04_kwadrat;
    set L04z04_kwadrat;
    
    if _n_ = 1 then set braki_index;
    
    array kwadrat{40,40};

    do i = 1 to 83;
        row = ceil(index / 40); 
        col = mod(index, 40); 
        if col = 0 then col = 40; 

        kwadrat{row, col} = .; 
        
        set braki_index(keep=index) point=i; 
    end;

    drop i row col index;
run;

/* ------------------------------- */
/* zadanie 4 */
/* ------------------------------- */

data L04z05_ord;
    set bib.l04z02;
    array A[39] A1-A39; 
	array temp[39];
    
    do i = 1 to dim(A);
        temp[i] = A[i]; 
    end;

    call sortc(of temp[*]); 

    do i = 1 to dim(A);
        A[i] = temp[i]; 
    end;

    drop i; 
run;
proc print data=L04z05_ord(obs=5);
run;

/* ------------------------------- */
/* zadanie 6 */
/* ------------------------------- */

data L04z06;
    set bib.L04z06;

    rok = input(substr(data, 1, index(data, '.') - 1), 4.);
	miesiac = input(substr(data, 1, index(data, '.') - 1), 4.);
	dzien = input(substr(data, index(data, '.') + 1), 2.);
    nowa_data = mdy(miesiac, dzien, rok);

    array parts[2] $3.;

    do i = 1 to countw(kod, ',');
        parts[i] = scan(kod, i, ',');
        if substr(parts[i], 1, 1) = 'W' then waga = input(substr(parts[i], 3), 8.);
        else if substr(parts[i], 1, 1) = 'P' then numer = input(substr(parts[i], 3), 8.);
    end;

    drop rok miesiac dzien i;
run;

proc print data=L04z06(obs=5);
run;

/* ------------------------------- */
/* zadanie 7 */
/* ------------------------------- */
data;
	set bib.l04z07;
	liczba = b0 * 2**10 + b1 * 2**9 + b2 * 2**8 + b3 * 2**7 + b4 * 2**6 
           + b5 * 2**5 + b6 * 2**4 + b7 * 2**3 + b8 * 2**2 + b9 * 2**1 + b10;

    drop b0-b10; 
run;
proc print;


/* ------------------------------- */
/* zadanie 8 */
/* ------------------------------- */
proc sort data=bib.L04z08;
    by a1 a2 a3 a4 a5 a6 a7;
run;
data L04z08_avg;
    set bib.l04z08;
    by a1 a2 a3 a4 a5 a6 a7;

    if first.a1 then sumx = x1; else sumx + x1;
    if last.a1 then avgx1 = sumx / _N_;

    if first.a2 then sumx = x2; else sumx + x2;
    if last.a2 then avgx2 = sumx / _N_;

    if first.a3 then sumx = x3; else sumx + x3;
    if last.a3 then avgx3 = sumx / _N_;

    if first.a4 then sumx = x4; else sumx + x4;
    if last.a4 then avgx4 = sumx / _N_;

    if first.a5 then sumx = x5; else sumx + x5;
    if last.a5 then avgx5 = sumx / _N_;

    if first.a6 then sumx = x6; else sumx + x6;
    if last.a6 then avgx6 = sumx / _N_;

    if first.a7 then sumx = x7; else sumx + x7;
    if last.a7 then avgx7 = sumx / _N_;

    drop x1-x7 sumx;
run;
proc print;

/* ------------------------------- */
/* zadanie 9 */
/* ------------------------------- */
data L04z09_new;
    set bib.l04z02;
    
    array gl {*} g1-g39;
    array gm {*} g1-g39;
    array gu {*} g1-g39;

    array sum_gl {*} sum_gl1-sum_gl39;
	array sum_gm {*} sum_gm1-sum_gm39;
	array sum_gu {*} sum_gu1-sum_gu39;

    do i = 1 to dim(gl);
        sum_gl[i] = 0;
        sum_gm[i] = 0;
        sum_gu[i] = 0;
    end;

    
    do i = 1 to dim(gl);
        var_index = input(scan(vname(gl[i]), 2, 'g'), 8.);
        if l = var_index then sum_gl[i] + gl[i];
        if m = var_index then sum_gm[i] + gm[i];
        if u = var_index then sum_gu[i] + gu[i];
    end;

    
    do i = 1 to dim(gl);
        var_index = input(scan(vname(gl[i]), 2, 'g'), 8.);
        if l = var_index then gl_avg = sum_gl[i] / countw(l, ',');
        if m = var_index then gm_avg = sum_gm[i] / countw(m, ',');
        if u = var_index then gu_avg = sum_gu[i] / countw(u, ',');
    end;

    drop i;
run;

/* _____________ */
/* arrays theory */
/* ------------- */


data b3;
  set a;
  ARRAY zosia [5] x1 x2 x3 x4 x5;
      do i = 1 to 5;
          zosia{i} = zosia[i] * 50;
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
  drop i;
run;
proc print;
run;


data b7;
  set a;
  array zosia [*] x1-x5 y:;

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
   array abc{-1:12} ;
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
   array abc{-1:12} abc1-abc14 ; 
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


data a;
 array z(3) $ z t u ('a','b','c');
run;

data w;
 array z(3) $ w t u ('a','b','c');
run;

data w;
 array w(3) $ z t u ('a','b','c');
run;

data w24;
 array w(3) $ 24 z t u ('a','b','c');
run;


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

run;

data b3;
 set a;
 array tablica(2) (3*7);

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
   - RETAIN dzialaa automatycznie */
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

proc contents data = b11;
run;




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
proc print; 
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
  array t(3); 
run;

data b1;
  set a;
  array t(3); 

  do I = lbound(t) to hbound(t); drop I;
   t[i] = t[i] + 3;
  end;
run;


data b2;
 set a;
 array ttt(3) t1-t3;
 y=ttt(2);
run;

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

  d=dim(x);
  l=lbound(x);
  h=hbound(x);
  put _all_;

  do i = l to h;
    put i= x[i]=;
  end;
run;

data a;
  x=42; 
  y='Napis1';
  z=3.14; 
  t='Inny napis';
run; 

data b;
  set a;
  array numer(*) _NUMERIC_; 

  do i=1 to dim(numer);
    put numer[i]= @;
  end;

  put;

  array znak(*) $ _CHARACTER_;

  do i=1 to dim(znak);
    put znak[i]= @;
  end;

  drop i;
run;


data a;
  x=1; y=2; z=3; t=4;
run;
 
data b;
  set a;
  array w(*) _all_; 
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

data a1;

  array t(5,4) (20*1); /* reprezentacja? */

run;




data a2;
  array t(5,4) (20*1);

  i = 1;
  j = 1;
  t[i,j] = 2;

  keep t:;
run;



data a3;
  array t(5,4) (1:20);


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

  i = 1;
  do j = 1 to dim2(t);
    t[i,j] = 10*j; 
  end;

  keep t:;
run;




data a5;
  array t(5,4) (20*1);

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

  array wej(*) t:; /* tablica ktora przechowa 
                      poszczegolne obserwacje */
  do i=1 to dim(wej);
      tymcz(_N_, i) = wej(i);
  end;

  array w(5); 

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

data a; 
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
STOP; 
run;




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

