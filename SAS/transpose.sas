libname bib "/home/u63791642/datasets/setLab6/";
run;
 
/* --------- */
/* zadanie 1 */
/* --------- */
*a);
 
proc contents data=bib.l06z01;
run;
 
data daty;
                set bib.l06z01;
                event_A = tranwrd(event_A, ".", "/");
                temp = input(event_A, yymmdd10.);
                event_A = put(temp,ddmmyy10.);
                format event_A ddmmyy11.;
               
    event_B = compress(event_B, "-");
    format event_B ddmmyy11.;
   
    format event_C ddmmyy11.;
              
    event_D = compress(event_D, ",");
    event_D = upcase(substr(event_D, 1, 3)) || substr(event_D, 4);
                month_ = input(substr(event_D, 1, 3), $3.);
    day = input(substr(event_D, 4, 2), 2.);
    year = input(substr(event_D, 6, 4), 4.);
   
    event_D = compress(catx('', day, month_, year),' ');
    format event_D ddmmyy11.;
   
                drop temp month_ day year;
run;
 
data daty_informat;
    set daty;
    event_A = input(event_A, ddmmyy11.);
    event_B = input(event_B, date11.);
    event_C = input(event_C, ddmmyy11.);
    event_D = input(event_D, date11.);
run;
proc contents data=daty_informat;
run;
proc print;
 
* event A;
data E_a;
                set daty_informat;
                keep event_A;
run;
proc sort data=E_a;
    by event_A;
run;
data E_a;
                set E_a end=last;
                retain min_date max_date;
                if _n_ = 1 then min_date=event_A;
                if last then do;
                               max_date=event_A;
                               roznica = max_date-min_date;
                               output;
                end;
                keep roznica max_date min_date;
run;
 
* event B;
data E_b;
                set daty_informat;
                keep event_B;
run;
proc sort data=E_b;
    by event_B;
run;
data E_b;
                set E_b end=last;
                retain min_date max_date;
                if _n_ = 1 then min_date=event_B;
                if last then do;
                               max_date=event_B;
                               roznica = max_date-min_date;
                               output;
                end;
                keep roznica max_date min_date;
run;
 
* event C;
data E_c;
                set daty_informat;
                keep event_C;
run;
proc sort data=E_c;
    by event_C;
run;
data E_c;
                set E_c end=last;
                retain min_date max_date;
                if _n_ = 1 then min_date=event_C;
                if last then do;
                               max_date=event_C;
                               roznica = max_date-min_date;
                               output;
                end;
                keep roznica max_date min_date;
run;
 
* event D;
data E_d;
                set daty_informat;
                keep event_D;
run;
proc sort data=E_d;
    by event_D;
run;
data E_d;
                set E_d end=last;
                retain min_date max_date;
                if _n_ = 1 then min_date=event_D;
                if last then do;
                               max_date=event_D;
                               roznica = max_date-min_date;
                               output;
                end;
                keep roznica max_date min_date;
run;
 
data zad1_a;
                merge E_b(in=b) E_a(in=a) E_c(in=c) E_d(in=d);
                by roznica;
    if a then event = "A";
    else if b then event = "B";
    else if c then event = "C";
    else if d then event = "D";
run;
proc print;
 
data roznica_set;
    set zad1_a end=last;
    retain min_ max_;
    min_ = min(min_date, lag(min_));
    max_ = max(max_date, lag(max_));
    if last then do;
                    roznica_ = max_-min_;
                    output;
    end;
    keep roznica_;
run;
 
/* --------- */
/* zadanie 1 */
/* --------- */
*b);
 
proc sort data=daty_informat;
                by lastname firstname;
run;
data zad1_b;
                set daty_informat;
                max_subject_date=max(event_A,event_B,event_C,event_D);
                min_subject_date=min(event_A,event_B,event_C,event_D);
                duration_subject=max_subject_date-min_subject_date;
                keep duration_subject lastname firstname;
run;
proc print data=zad1_b;
 
/* --------- */
/* zadanie 1 */
/* --------- */
*c);
 
data zad1_c_ratio;
                merge zad1_b(in=a) roznica_set(in=b);
                retain roznica_ temp;
    if not missing(roznica_) then temp = roznica_;
    else if missing(roznica_) then roznica_ = temp;
    ratio = duration_subject / roznica_;
    format ratio FRACT12.;
    drop duration_subject roznica_ temp;
run;
 
proc sort data=zad1_c_ratio;
                by ratio;
run;
proc print;
 
 
 
/* --------- */
/* zadanie 2 */
/* --------- */
 
data l06z02;
                array alph[12] $1 alph1-alph12;
    do obs = 1 to 24;
        do i = 1 to 12;
            alph{i} = byte(65 + ceil(rand('uniform') * 26));
        end;
        output;
    end;
    drop i Obs;
run;
 
proc transpose data=l06z02 out=l06z02_transpose;
var alph1-alph12;
run;
proc print;
 
 
 
 
 
/* --------- */
/* zadanie 3 */
/* --------- */
data l06z03;
                set bib.l06z03;
run;
proc contents data=l06z03 out=metadata noprint;
run;
proc sort data=metadata out=sorted_metadata;
    by name;
run;
 
data output_;
               set sorted_metadata;
               keep name varnum;
run;
 
proc transpose data=output_ out=output_t(drop=_NAME_ _LABEL_);
    var varnum;
    id name;
run;
proc print;
 
 
/* --------- */
/* zadanie 4 */
/* --------- */
data l06z04;
                set bib.l06z04_a;
                format date yymmdd10.;
                format index_val nlnumi32.;
                if date ne . then do;
                               date_char = cats('d_', compress(put(date, YYMMDD10.),"-"));
                end;
                drop date;
run;
proc sort data=l06z04;
by lastname firstname;
run;
 
proc transpose data=l06z04 out=l06z04_t(drop=_NAME_);
by lastname firstname;
id date_char;
var index_val;
run;
proc sort data=l06z04_t;
                by firstname lastname;
run;
data l06z04_result;
    set l06z04_t;
    retain new_firstname new_lastname;
    new_firstname = firstname;
    new_lastname = lastname;
    firstname = new_lastname;
    lastname = new_firstname;
    drop new_firstname new_lastname;
    rename lastname=Imie firstname=Nazwisko;
run;
proc print;
 
 
/* --------- */
/* zadanie 5 */
/* --------- */
data l06z05;
                set bib.l06z05_a;
run;
proc sort data=l06z05;
                by grp;
run;
proc transpose data=l06z05 out=l06z05_t;
                by grp;
run;
proc sort data=l06z05_t;
                by _name_ grp;
run;
proc transpose data=l06z05_t out=l06z05_t2(drop=_name_);
                var COL1-COL13;
                by _name_;
                id grp;
run;
proc print;
 
 
 
/* --------- */
/* zadanie 6 */
/* --------- */
data l06z06;
                set bib.l06z06_a;
run;
Proc SORT
data=l06z06
out=l06z06_sorted
SORTSEQ=LINGUISTIC
(
CASE_FIRST=LOWER
LOCALE=pl_PL
NUMERIC_COLLATION=ON
)
;
    by i descending j;
run;
proc print;
 
 
/* --------- */
/* zadanie 7 */
/* --------- */
data l06z07;
                set bib.l06z07_a;
run;
proc sort data=l06z07 out=l06z07;
    by typ id;
run;
proc transpose data=l06z07 out=l06z07(drop=_name_) prefix=profil;
    by typ id;
    var profil typ gatunek_muzyczny;;
run;
proc sort data=l06z07;
    by id typ          profil1   profil2;
run;
proc transpose data=l06z07 out=l06z07(drop=_name_) prefix=profil;
    by id typ          profil1   profil2;
    var id;
run;
proc print;
data l06z07;
                set bib.l06z07_a;
run;
proc print;
