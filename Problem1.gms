Sets
   n 'Nodes'   / Node1, Node2, Node3 /
   a 'Assets'  / Cash,  Bonds, DStock, IStock /
   Alias(a,ap);

Parameters
Vv(a) 'Target Variance Value for each Asset'
        / Cash               0.00008836
          Bonds    	      0.00006724
          DStock             0.0001790244
          IStock             0.00024649 /
          
Vm(a) 'Target Mean Value for each Asset'
        / Cash                0.050
          Bonds    	       0.065
          DStock              0.071
          IStock              0.075 /;

Table cr(a,ap) 'Target Correlations'
                        Cash                   Bonds                DStock              IStock
   Cash                 1.0                      0.6                 -0.2                -0.1
   Bonds                0.6                      1.0                 -0.3                -0.2
   DStock              -0.2                     -0.3                  1.0                 0.6
   IStock              -0.1                     -0.2                  0.6                 1.0
   ;

Scalar ProbM 'Probability from parent' / 1 /
       Wm 'Mean Weight' / 1/
       Wv 'Variance Weight' /1/
       Wc 'Correlation Weight' /1/
       Wmr 'Mean Reversion Weight' /0.5/
       Rb 'Return on bonds last period' /0.065/
       MRL 'Mean Reversion Level' /0.0591/;

Free Variables
   R(n,a) 'Realisation of asset at node'
   z      'total squared error';

Positive Variables
   P(n)   'Probability of Node'
   M(a)   'Mean of asset'
   V(a)   'Variance of asset'
   C(a,ap)   'Variance of asset'
   ;
Equation
   cost      'SquaredError'
   mean(a)   'Mean definition'
   Prob   'Probability of Paren'
   NonEq 'dont want probs to be equal'
   NonSmall(n) 'dont want too small probs'
   corr(a,ap)   'Correlation definition'
   variance(a) 'Variance definition'
;

cost..      z =e=  Wm*sum(a,sqr(M(a)-Vm(a)))+Wv*sum(a,sqr(V(a)-Vv(a)))  + Wc*sum((a,ap),sqr(C(a,ap)-cr(a,ap)))
+Wmr*sqr(M('Bonds')-(0.3*MRL+(1-0.3)*Rb))    ;

prob.. sum(n, P(n)) =e= ProbM   ;
mean(a).. sum(n, P(n)*R(n,a)) =e= M(a);
variance(a).. sum(n,   P(n)*sqr(R(n,a)-M(a) ) ) =e= V(a);
corr(a,ap).. sum(n,   P(n)*(R(n,a)-M(a) )*(R(n,ap)-M(ap)  ) )/sqrt(Vv(a)*Vv(ap)) =e= C(a,ap);

NonEq.. P('Node2') =g= P('Node1')*0.5+0.5*P('Node3');
NonSmall(n).. P(n) =g= 0.1;


Model Matching / all /;

solve Matching using nlp minimizing z;

display R.l,P.l ;
