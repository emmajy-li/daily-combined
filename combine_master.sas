/*
%let startdt = %sysfunc(inputn(20070201, yymmdd8.));
%let enddt = %sysfunc(inputn(20070228, yymmdd8.));
*/

/* libname mast '/wrds/nyse/sasdata/taqms/mast'; */

%macro master_monthly_dataset(type,begdate,enddate);
        %let type=%lowcase(&type);
        %do d=&begdate %to &enddate;
            %let yyyymmdd=%sysfunc(putn(&d, yymmddn8.));
            %if %sysfunc(exist(taqmsec.&type._&yyyymmdd)) %then taqmsec.&type._&yyyymmdd;
        %end;
%mend master_monthly_dataset;

%macro master_dataset(begyear, endyear);
    %do y = &begyear %to &endyear;  

   	%put %eval(&y*10000+301);

        %let startdt = %sysfunc(inputn(%eval(&y*10000+301), yymmdd8.));
        %let enddt = %sysfunc(inputn(%eval(&y*10000+331), yymmdd8.));

        data master_combined_&y;
            set %master_monthly_dataset(mastm,begdate=&startdt,enddate=&enddt) open=defer;

        proc print data = master_combined_&y (obs = 10);

        proc export data=master_combined_&y
        outfile = "/home/umd/jingyili/megabase/data/master_combined_&y..csv" dbms=csv replace;

    %end;
%mend master_dataset;
 
%master_dataset(begyear=2011,endyear=2012);
