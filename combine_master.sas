%macro master_monthly_dataset(type,begdate,enddate);
        %let type=%lowcase(&type);

        %do d=&begdate %to &enddate;

            %let yyyymmdd=%sysfunc(putn(&d, yymmddn8.));

            %if %sysfunc(exist(taqmsec.&type._&yyyymmdd)) %then taqmsec.&type._&yyyymmdd;

        %end;
%mend master_monthly_dataset;

%macro master_dataset(begyear, endyear, month);
    %do y = &begyear %to &endyear;  

        %let startdt = %sysfunc(inputn(%eval(&y*10000+&month*100+1), yymmdd8.));
        %let enddt = %sysfunc(inputn(%eval(&y*10000+&month*100+29), yymmdd8.));

        data master_combined_&y.&month;
            set %master_monthly_dataset(mastm,begdate=&startdt,enddate=&enddt) open=defer;

        proc export data=master_combined_&y.&month
        outfile = "/home/umd/jingyili/megabase/data/master_&y.0&month..csv" dbms=csv replace;

    %end;
%mend master_dataset;

%master_dataset(begyear=2012,endyear=2012, month=2);
%master_dataset(begyear=2016,endyear=2016, month=2);
