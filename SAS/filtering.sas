
libname bib "/home/u63791642/datasets/setLab7/";
run;
libname bib6 "/home/u63791642/datasets/setLab6/";
run;

/* --------- */
/* zadanie 1 */
/* --------- */

*a);
data zad1_a;
	set bib.l07z01;
	total = sum(of x1-x50);
	if y<3 and total>30 then output;
run;
proc print;


*b);
data zad1_b;
	set bib.l07z01;
	retain mean;
	mean = sum(of x1-x50)/50;
	if y/20 < mean then output;
run;
proc print;

*c);
data zad1_c;
	set bib.l07z01;
	where max(x1,x2) < min(x49,x50);
run;
proc print;

/* --------- */
/* zadanie 2 */
/* --------- */
data zad2;
	set bib.l07z02;
	where a<b<c<d<e<f;
run;
proc print;


/* --------- */
/* zadanie 3 */
/* --------- */

data zad3;
	set bib.l07z03;
	where substr(lastname, 1, 1) = 'B' or index(lastname, "st") > 0;
run;
proc means data=zad3 noprint;
	class sex;
	var event;
	output out=mean_zad3 mean=average_event;
run;
data mean_zad3;
	set mean_zad3;
	if _n_ = 1 then sex = "All";
	keep sex average_event;
run;
proc print;

/* --------- */
/* zadanie 4 */
/* --------- */

data zad3;
	set bib.l07z04;
	if mod(_n_,2) = 0 and mod(_n_,3) = 0 and mod(_n_,5) = 0 and mod(_n_,7) = 0 then do;
		output;
		output;
		output;
		output;
	end;
	else if mod(_n_,2) = 0 and mod(_n_,3) = 0 and mod(_n_,5) = 0 then do;
		output;
		output;
		output;
	end;
	else if mod(_n_,2) = 0 and mod(_n_,3) = 0 then do;
		output;
		output;
	end;
	else if mod(_n_,2) = 0 then output;
run;
proc print;


/* --------- */
/* zadanie 5 */
/* --------- */

*a);
data zad5_1;
	set bib.l07z03;
	where substr(firstname, 1,1) = 'J' and substr(firstname,length(firstname),1) = 'a';
run;
proc print;

*b);
data zad5_2;
	set bib.l07z03;
	where event>26 or event<10;
run;
proc print;

*c);
data zad5_3;
	set bib.l07z03;
	where month(date) = 6;
run;
proc print;

/* --------- */
/* zadanie 6 */
/* --------- */

data zad6;
	set bib.l07z03;
	where month(date) in (1,2,3,7,8,9);
run;
proc print data=zad6(firstobs=2 obs=4);
run;

/* --------- */
/* zadanie 7 */
/* --------- */

data zad7;
	set bib6.l06z03;
run;
proc transpose data=zad7 out=zad7_t(drop=_Name_ rename=(COL1=liczba));
    var _all_;
run;
data;
	set zad7_t;
	if liczba=1 then return;
	else if liczba=2 or liczba=3 then output;
	else if mod(liczba,2)=0 or mod(liczba,3)=0 then return;
	else do;
		is_prime=1;
		i=5;
		do while(i*i<=liczba);
			if mod(liczba,i)=0 or mod(liczba,(i+2)) = 0 then is_prime=0;
			i=i+6;
		end;
		if is_prime=1 then output;
	end;
	keep liczba;
run;
proc print;
