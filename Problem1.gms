Sets
   r 'Roles' / GK, CDF, LB, RB, CMF, LW, RW, OMF, CFW, SFW /
   f 'Formations' /442, 352, 4312, 433, 343, 4321 /
   p 'Players' /p1*p25/;


Table req(f,r) 'Required number of players per Formation'
        GK     CDF     LB     RB     CMF     LW     RW     OMF     CFW     SFW
442     1      2       1      1      2       1      1      0       2       0
352     1      3       0      0      3       1      1      0       1       1
4312    1      2       1      1      3       0      0      1       2       0
433     1      2       1      1      3       0      0      0       1       2
343     1      3       0      0      2       1      1      0       1       2
4321    1      2       1      1      3       0      0      2       1       0
;
Table fitness(p,r) 'Fitness of Player at each role'
        GK     CDF     LB     RB     CMF     LW     RW     OMF     CFW     SFW
p1      10     0       0      0      0       0      0      0       0       0
p2      9      0       0      0      0       0      0      0       0       0
p3      8.5    0       0      0      0       0      0      0       0       0
p4      0      8       6      5      4       2      2      0       0       0     
p5      0      9       7      3      2       0      2      0       0       0
p6      0      8       7      7      3       2      2      0       0       0
p7      0      6       8      8      0       6      6      0       0       0
p8      0      4       5      9      0       6      6      0       0       0
p9      0      5       9      4      0       7      2      0       0       0
p10     0      4       2      2      9       2      2      0       0       0
p11     0      3       1      1      8       1      1      4       0       0
p12     0      3       0      2      10      1      1      0       0       0
p13     0      0       0      0      7       0      0      10      6       0
p14     0      0       0      0      4       8      6      5       0       0
p15     0      0       0      0      4       6      9      6       0       0
p16     0      0       0      0      0       7      3      0       0       0
p17     0      0       0      0      3       0      9      0       0       0
p18     0      0       0      0      0       0      0      6       9       6
p19     0      0       0      0      0       0      0      5       8       7
p20     0      0       0      0      0       0      0      4       4       10
p21     0      0       0      0      0       0      0      3       9       9
p22     0      0       0      0      0       0      0      0       8       8
p23     0      3       1      1      8       4      3      5       0       0
p24     0      3       2      4      7       6      5      6       4       0
p25     0      4       2      2      6       7      5      2       2       0
;

Free Variables
   z      'total benefit';

Binary Variables
   w(f)     'What formation to choose'
   x(p,r,f) 'Which player at each role'
   ;
Equation
   total           'Total Benefit'
   strat           'what strat/formation to choose'
   plays(p,f)      'a player can only play one role at a time'
   require(f,r)    'choice must comply with formation'
;

total..      z =e=  sum((p,r,f), fitness(p,r)*x(p,r,f))   ;

*You can only pick one formation
strat.. sum(f, w(f)) =e= 1;

*all players can play each role, but only one at a time
plays(p,f).. sum(r, x(p,r,f)) =l= 1;

*the amount of players allocated to a role must equal the requirement of the formation chosen
require(f,r).. sum(p, x(p,r,f)) =e= req(f,r)*w(f);


Model FCK / all /;

solve FCK using mip maximizing z;

display w.l,x.l, z.l ;
