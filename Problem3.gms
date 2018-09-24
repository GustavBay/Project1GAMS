
Sets
   v 'ships' / v1*v5 /
   p 'Ports' / Singapore, Incheon, Shanghai, Sydney, Gladstone, Dalian, Osaka, Victoria/
   r 'Routes' /Asia, ChinaPacific/
   ;


Parameters
k      'Minimum amount of Ports to service ' /5/
f(v)   'Fixed cost for having a ship' /v1 65, v2 60, v3 92, v4 100, v5 110/
g(v)   'max sail time per year' /v1 300, v2 250, v3 350, v4 330, v5 300/
d(p)   'minimum times to visit if selected' /Singapore 15, Incheon 18,
                                             Shanghai 32, Sydney 32,
                                             Gladstone 45, Dalian 32,
                                             Osaka 15, Victoria 18/
;

Table
c(v,r) 'cost of sending a ship on specific route'
    Asia     ChinaPacific
v1  1.41        1.9
v2  3.0         1.5
v3  0.4         0.8
v4  0.5         0.7
v5  0.7         0.8
;

Table
t(v,r) 'time to complete specific route'
    Asia     ChinaPacific
v1  14.4        21.2
v2  13.0        20.7
v3  14.4        20.6
v4  13.0        19.2
v5  12.0        20.1
;

Table
a(p,r) 'routing table'
            Asia     ChinaPacific
Singapore    1          0
Incheon      1          0
Shanghai     1          1
Sydney       0          1
Gladstone    0          1
Dalian       1          1
Osaka        1          0
Victoria     0          1
;



Free Variables
   z      'Total Cost';

Binary Variables
   y(p) 'if servicing a port or not'
   i(v) 'if a vessel is chosen or not'
   ;

Integer Variables
   x(v,r,p) 'how many times a port is being serviced by a vessel on what route'
   w(v,r)   'how many times a vessel goes on a specific route'
;

Equation
   total           'Total Costs'
   minPort         'miniumum of ports serviced'
   minServiced(p)  'minimum of times a port is serviced'
   fixedCost(v)    'if a vessel is in use, one must pay the fixed cost'
   OsakaSinga      'The company cannot service both of these ports'
   InchVic         'The company cannot service both of these ports'
   routing(v,r,p)  'assigning services to routes'
   time(v)         'a vessel can only sail within its up-time'
;

* add cost of every active vessel and add the cost of a vessel doing a specific route w many times.
total..      z =e=    sum(v, i(v)*f(v)) + sum((v,r), w(v,r)*c(v,r)) ;

*must choose at least k ports to service.
minPort.. sum(p, y(p)) =g= k;

*if the number of routes made are possitive, must be 1, else allow to minimise to 0.
* here we devide with 500 to get a fraction. 
fixedCost(v).. i(v) =g= sum(r, w(v,r))/500 ;

*a port must be serviced its minimum amount of times if chosen
minServiced(p).. sum((v,r), x(v,r,p)) =g= d(p)*y(p);

*the amount of times a port is being serviced by a vessel on a route, must be eqal the amount of times
*the vessel takes that route and is able to service that port, as a vessel must service all ports on route
routing(v,r,p).. x(v,r,p) =e= w(v,r)*a(p,r);

*max one of these ports can be choosen to service by the company
* you could make constraints based on sets, but we only have two constraints, so not necessary.
OsakaSinga.. y('Osaka')+y('Singapore') =l= 1;
InchVic..    y('Incheon')+y('Victoria') =l= 1;

* the time a vessel spends on routes must be less than it's available up-time.
time(v).. sum(r, w(v,r)*t(v,r)) =l= g(v);


Model ports / all /;

solve ports using mip minimizing z;

display y.l,x.l, w.l, i.l, z.l ;
