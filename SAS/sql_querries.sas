libname bib "/home/u63791642/datasets/setLab8/";
run;

/* --------- */
/* zadanie 1 */
/* --------- */
*1;

proc sql;
	select 
		coalesce(mean(x),0) as avg_x,
		coalesce(mean(y),0) as avg_y,
		coalesce(mean(z),0) as avg_z,
		coalesce(mean(t),0) as avg_t,
		coalesce(std(x),0) as std_x,
		coalesce(std(y),0) as std_y,
		coalesce(std(z),0) as std_z,
		coalesce(std(t),0) as std_t,
		coalesce(max(x),0) as max_x,
		coalesce(max(y),0) as max_y,
		coalesce(max(z),0) as max_z,
		coalesce(max(t),0) as max_t
		from bib.l08z01;
quit;
proc print; 

*2;
proc sql;
	select count(*) as missing_x
	from bib.l08z01
	where x is null;
quit;

*3;
proc sql;
	select
	count(*) as count_z_60
	from bib.l08z01
	where z>60;
quit;

*4;
proc sql;
	select count(*) as sum_gt30
	from
	(
		select
			case when x is null then -1 else x end as x,
			case when y is null then -1 else y end as y,
			case when z is null then -1 else z end as z,
			case when t is null then -1 else t end as t
		from bib.l08z01
	) as bez_null
	where x + y + z + t > 30;
quit;

*5 - t podzielne na 2;
proc sql;
	select coalesce(mean(t),0) as srednia_t from
	(
	select *, 
	case mod(y,3) 
		when 0 then 'Grupa 0'
		when 1 then 'Grupa 1'
		when 2 then 'Grupa 2'
		else 'Grupa NULL'
	end as grupa
	from bib.l08z01
	where mod(t,2) = 0
	);
quit;
proc sql;
	select coalesce(mean(t),0) as srednia_t from
	(
	select *, 
	case mod(y,3) 
		when 0 then 'Grupa 0'
		when 1 then 'Grupa 1'
		when 2 then 'Grupa 2'
		else 'Grupa NULL'
	end as grupa
	from bib.l08z01
	where mod(t,5) = 0
	);
quit;
proc sql;
	select coalesce(mean(t),0) as srednia_t from
	(
	select *, 
	case mod(y,3) 
		when 0 then 'Grupa 0'
		when 1 then 'Grupa 1'
		when 2 then 'Grupa 2'
		else 'Grupa NULL'
	end as grupa
	from bib.l08z01
	where t>50
	);
quit;

/* --------- */
/* zadanie 2 */
/* --------- */

*1;
proc sql;
    select 
        a.srednia_a as srednia_a,
        b.srednia_b as srednia_b
    from 
        (select coalesce(mean(w), 0) as srednia_a from bib.l08z02 where o='A') as a
    full join
        (select coalesce(mean(w), 0) as srednia_b from bib.l08z02 where o='B') as b
    on 1=1;
quit;
***************;
data l08z02;
    set bib.l08z02;
run;
proc means data=l08z02 noprint;
    where o='A';
    var w;
    output out=mean_a mean=mean_a;
run;
proc means data=l08z02 noprint;
    where o='B';
    var w;
    output out=mean_b mean=mean_b;
run;
data result;
    merge mean_a mean_b;
    keep mean_a mean_b;
run;
proc print data=result;
run;


*2;
proc sql;
	select max(w) as maksymalny_wynik
	from bib.l08z02 
	where k in ('III','IV') and o='C';
quit;
**********;
data wynik_4gl;
	set bib.l08z02 end=last;
	where k in ('III','IV') and o='C';
	retain maksymalny_wynik .;
	if w > maksymalny_wynik then maksymalny_wynik=w;
	if last then output;
	keep maksymalny_wynik;
run;

*3;
proc sql;
	select o, mean(w) as sredni_wynik,
	case 
		when mean(w) >= 7 then 'Wysoki'
		when mean(w) >=5 then 'Sredni'
		else 'Niski'
		end as klasyfikacja
	from bib.l08z02
	group by o;
quit;
**********;
proc sort data=bib.l08z02 out=sorted_l08z02;
    by o;
run;
data klasyfikacja;
	set sorted_l08z02;
	by o;
	
	retain sredni_wynik Wysoki Sredni Niski;
	
	if first.o then do;
		sredni_wynik = 0;
        Wysoki = 0;
        Sredni = 0;
        Niski = 0;
    end;
    
    sredni_wynik+w;
    
    if last.o then do;
    	sredni_wynik = sredni_wynik/_n_;
		if sredni_wynik >= 7 then klasyfikacja = 'Wysoki';
    	else if sredni_wynik >= 5 then klasyfikacja = 'Sredni';
        else klasyfikacja = 'Niski';
        output;
    end;
    keep r k o klasyfikacja;
run;
    

*4;
proc sql;
	select distinct r, k
	from bib.l08z02
	group by r, k
	having max(w) > any(select max(w) from bib.l08z02 group by o);
quit;
*************;
proc sort data=bib.l08z02 out=sorted_l08z02;
    by r k;
run;
data distinct_values;
	set sorted_l08z02;
	by r k;
	
	if first.k then max_w = 0;
	max_w = max(max_w, w);

    if last.k and max_w > 0 then output;
run;

*5;
proc sql;
    select distinct o
    from bib.l08z02 
    having max(w) = any(
        select max(w)
        from bib.l08z02
        where (k in ('II','I')) 
        group by o
    );
quit;
*********;
proc sort data=bib.l08z02 out=sorted_l08z02;
    by o descending w;
run;
data max_values;
    set sorted_l08z02;
    by o;

    if first.o and k in ('II','I') then output;
run;
proc sort data=max_values out=final_result nodupkey;
    by o;
run;

*6;
proc sql;
	select r, k, o
	from bib.l08z02
	group by r, k
	having w = max(w);
quit;
*********;
proc sort data=bib.l08z02 out=sorted_l08z02;
    by r k descending w;
run;
data max_values;
    set sorted_l08z02;
    by r k;

    if first.k then output;
run;


*7;
proc sql;
	select count(*) as wyniki_lepsze
	from bib.l08z02
	where o='A' and 
	w>any(select min(w) from bib.l08z02 where o='B');
quit;
***************;
data better_results;
    set bib.l08z02;
    retain min_w 1000;
    where o='A' and w > min_w;

    if o='B' then min_w = min(min_w, w);
run;
proc sql;
    select count(*) as wyniki_lepsze
    from better_results;
quit;

*8;
proc sql;
	select distinct o from
	(
    select dane.o, dane.w, dane.k, dane.r, b.roznica
    from bib.l08z02 as dane
    left join (
        select o, a.max_w - a.min_w as roznica 
        from (
            select o, max(w) as max_w, min(w) as min_w 
            from bib.l08z02 
            group by o
        ) as a
    ) as b
    on dane.o = b.o
	)
	group by o having
	max(roznica) = (select max(max_w-min_w) as max_roznica 
	from(
		select o, max(w) as max_w, min(w) as min_w
		from bib.l08z02
		group by o
		)
	);
quit;

*9;
proc sql;
	select distinct k from(
	select k,o,count(*) as counted from(
	select dane.o, dane.k, dane.w, a.max_w from bib.l08z02 as dane left join 
	(select o, max(w) as max_w from bib.l08z02
	group by o) as a 
	on dane.o = a.o
	)
	where max_w=w
	group by k
	)
	where counted>1;
quit;

*10;
proc sql;
	select a.r, a.k, a.o, a.w, b.o, b.w from (
    select dane.o, dane.r, dane.k, dane.w
    from bib.l08z02 as dane
    right join(
        select distinct r, k 
        from bib.l08z02 
        where o = 'A'
    ) as a
    on a.r=dane.r and a.k=dane.k
    where o in ('A','B')
    group by dane.r,dane.k
	) as a
	inner join 
	(
    select dane.o, dane.r, dane.k, dane.w
    from bib.l08z02 as dane
    right join(
        select distinct r, k 
        from bib.l08z02 
        where o = 'A'
    ) as a
    on a.r=dane.r and a.k=dane.k
    where o in ('A','B')
    group by dane.r,dane.k
	) as b
	on a.r = b.r and a.k = b.k
	where a.o = 'A' and b.o = 'B' and a.w>b.w;
quit;

/* --------- */
/* zadanie 3 */
/* --------- */

*1;
proc sql;
    select distinct x, y, licznik
    from (
        select x, y, count(*) as licznik
        from bib.l08z03 as dane
        group by x, y
    )
    group by x
    order by licznik desc;
quit;


*2;
proc sql;
    select x, y, licznik
    from (
        select x, y, count(*) as licznik
        from bib.l08z03 as dane
        group by x, y
    )
    group by x
    order by licznik desc;
quit;

*3;
proc sql;
	select x,y from (
	select x,y,count(*) as c from (
	select x,y, min_y from(
    select x,y,min(y) as min_y
    from bib.l08z03
    group by x
	)
	where min_y=y
	group by x
	)
	group by x)
	where c = 1;
quit;

*4;
proc sql;
	select x,y, count(*) as powtarzalnosc
	from bib.l08z03
	group by x,y
	having powtarzalnosc = 1;
quit;

*5;
proc sql;
	select x,y, powtarzalnosc, max(powtarzalnosc) as max_p from (
	select x,y, count(*) as powtarzalnosc
	from bib.l08z03
	group by x,y
	)
	group by x
	having max_p = powtarzalnosc;
quit;

*6;
proc sql;
    select *,
        case 
            when abs(y - lag(y)) = 1 then 1
            else 0
        end as roznica_1
    from bib.l08z03;
quit;

*7;
proc sql;
	select x, count(distinct y) as unique
	from bib.l08z03
	group by x
	having unique>=(select count(distinct y) 
	from bib.l08z03)/2;
quit;

*8;
proc sql;
	select y, count(distinct x) as unique
	from bib.l08z03
	group by y
	having unique>=(select count(distinct x) 
	from bib.l08z03)/2;
quit;

/* --------- */
/* zadanie 4 */
/* --------- */

*1;
proc sql;
	select distinct id from(
	select id,year,min(year) as min_year from bib.l08z04
	group by id
	having min_year>=2003
	);
quit;

*2;
proc sql;
	select id,count(*) as counted
	from (
	select id,year,min(year) as min_year, 
	max(year) as max_year from bib.l08z04
	)
	where year=min_year OR year=max_year
	group by id
	having counted>=2;
quit;

*3;
proc sql;
	select id,count(*) as counted
	from (
	select id,year,min(year) as min_year, 
	max(year) as max_year from bib.l08z04
	)
	group by id
	having counted=(
	select count(distinct year) from bib.l08z04
	);
quit;

/* --------- */
/* zadanie 5 */
/* --------- */

*t1;
proc sql;
	select count(distinct t1.x) from 
	bib.l08z05t1 as t1;
quit;

*2;
proc sql;
	select count(distinct t2.x) from 
	bib.l08z05t2 as t2;
quit;

* obydwa;
proc sql;
	select count(distinct t2.x) from 
	bib.l08z05t1 as t1
	inner join
	bib.l08z05t2 as t2
	on t1.x = t2.x;
quit;

* rozłączne;
proc sql;
	select sum(
	case when t1.x is null or t2.x is null then 1 else 0 end) as niewspolnych
	from
	(
    select * from
    bib.l08z05t1 as t1
	full join
	bib.l08z05t2 as t2
	on t1.x = t2.x
	);
quit;

/* --------- */
/* zadanie 6 */
/* --------- */

*1;
proc sql;
	select distinct a1, x1 from(
	select a1,a2,x1,x2, min(x2) as min_x2, max(x2) as max_x2 from bib.l08z06
	group by a1,a2
	having x1 between min_x2 and max_x2)
	group by a1;
quit;

*2;
proc sql;
	create table dane as
	select * from(
	select az.a, sum(count_A,count_B) as suma from
	(select a1 as a, count(*) as count_A from bib.l08z06 group by a1) as az
	full join 
	(select a2 as a, count(*) as count_B from bib.l08z06 group by a2) as bz
	on az.a=bz.a
	)
	order by suma desc;
quit;
data wynik;
	set dane;
	if _n_=1 then output;
run;
proc print;

/* --------- */
/* zadanie 7 */
/* --------- */

*1;
proc sql;
	select month(dzien) as miesiac,
	count(*) as liczba_brakow 
	from bib.l08z07
	where r2 is null
	group by miesiac
	order by liczba_brakow desc;
quit;

*2;
proc sql;
	select miesiac, sum(rozproszenie) as suma_rozproszenia from
	(
	select month(dzien) as miesiac, r1, avg(r1) as mean,
	abs(avg(r1)-r1) as rozproszenie
	from bib.l08z07
	where r1 is not null
	group by miesiac
	)
	group by miesiac
	order by suma_rozproszenia desc;
quit;
