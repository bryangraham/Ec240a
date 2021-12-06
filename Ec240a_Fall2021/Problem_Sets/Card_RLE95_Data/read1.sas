comment program read1: reads nls data from flat file;
comment see codebook code_bk.txt;
data one;

title1 'input nls data set and run example regression';

infile '***put full address of file here***/nls.flt';

input id    /*sequential id*/
    nearc2  /*grew up near 2-yr college*/
    nearc4  /*4-yr college*/
    nearc4a /*4-yr public college*/
    nearc4b /*near 4-yr priv college*/
    ed76  /*educ in 1976*/
    ed66  /*educ in 1966*/
    age76 /*age in 1976*/
    daded /*dads education missing=avg*/
    nodaded /* 1 if dad ed imputed*/
    momed /*moms education*/
    nomomed /* 1 if mom ed imputed*/
    weight
    momdad14 /*1 if lived with mom and dad age 14*/
    sinmom14 /*1 if lived with single mom age 14*/
    step14  /*1 if lived with step parent age 14*/
    reg661 /* region=1 in 1966 */
    reg662
    reg663
    reg664
    reg665
    reg666
    reg667
    reg668
    reg669
    south66 /*lived in south in 1966*/
    work76 /* worked in 1976*/
    work78 /* worked in 1978*/
    lwage76  /*log wage (outliers trimmed) 1976 */
    lwage78
    famed /*mom-dad education class 1-9*/
    black
    smsa76r /*in smsa in 1976*/
    smsa78r /*in smsa in 1978*/
    reg76r /*in south in 1976*/
    reg78r /*in south in 1978*/
    reg80r /* in south in 1980*/
    smsa66r /* in smsa in 1966*/
    wage76 /*raw wage cents per hour 1976*/
    wage78
    wage80
    noint78 /*1 if noninterview in 78*/
    noint80
    enroll76 /*1 if enrolled in 76*/
    enroll78
    enroll80
    kww  /*the kww score*/
    iq  /* a normed iq score*/
    marsta76 /*mar status in 1976*/
    marsta78
    marsta80
    libcrd14 ;  /*1 if lib card in home age 14*/


*construct potential experience and its square;
exp76=age76-ed76-6;
exp762=exp76*exp76;

*construct dummies for interactions of family education;
f1=(famed=1);  /*mom and dad both > 12 yrs ed*/
f2=(famed=2);  /* mom&dad >=12 and not both exactly 12*/
f3=(famed=3);  /*mom=dad=12*/
f4=(famed=4);  /*mom >=12 and dad missing*/
f5=(famed=5);  /*father >=12 and mom not in f1-f4 */
f6=(famed=6);  /*mom>=12 and dad nonmissing*/
f7=(famed=7);  /*mom and dad both >=9 */
f8=(famed=8);  /*mom and dad both nonmissing*/

proc means;                                                                     
                                                                                
proc corr;                                                                      
var ed76 kww iq libcrd14 lwage76 lwage78;
                                                                                
proc freq;                                                                      
tables nearc4*nearc2 famed daded momed;

proc reg s;
model ed76=f1-f8;
model ed76=momed daded nomomed nodaded;
model lwage76=ed76 exp76 exp762 black smsa76r reg76r smsa66r                    
      reg662-reg669;
model lwage76=ed76 exp76 exp762 black smsa76r reg76r smsa66r                    
      reg662-reg669 daded momed nodaded nomomed f1-f8                           
      momdad14 sinmom14;                                                        
