
Sets
   n 'Nodes' / n1*n8 /
   k 'Keys' / k1*k30 /;
alias(n,m)

Parameters
q   'needed connections for Security ' /3/
t   'maximum usage of a key'           /4/
mem 'maximum amount of keys in a node' /3/
;

Free Variables
   z      'Total Secure Connections';

Binary Variables
   w(n,m)     'Secure Connection n to m'
   x(n,k)     'If a key is allocated to node n'
   h(n,m,k)   'if node n and m have key k in common'
   ;
Equation
   total           'Amount of Secure Connections'
   maxK(k)         'each key can only be used 4 times'
   memory(n)       'each node can only hold 3 keys'
   identify(n,m,k) 'checking if two nodes have a a key in common'
   secure(n,m)     'if two nodes have enough keys to establish a secure connection'
;

total..      z =e=  sum((n,m), w(n,m))   ;

maxK(k).. sum(n, x(n,k)) =l= t;

*as 700kB/186kB = 3, we can only hold 3 keys in a node
memory(n).. sum(k, x(n,k)) =l= mem;

*if both node n and node m has key k, then the LHS will be 1, allowing h to be 1, indicating that they have key k in common
identify(n,m,k).. ((x(n,k)+x(m,k))/2)$(ord(n)>ord(m)) =g= h(n,m,k);

*same method as above, if node n and m have 3 keys in common, allow w (the secure connection indicator) to be 1
secure(n,m).. ((sum(k, h(n,m,k)))/q)$(ord(n)>ord(m)) =g= w(n,m);

*I'm sure there is some smarter way of constructing the secure connection requierement, but using a double indicator dummy-
*variable was an easy solution, but not that effecient. We usually want to avoid introducing indicators to ease computation.

*The $(ord(n)>ord(m)) conditional is in order to avoid calculating on an NxN matrix, but only on the upper triangle.
*This mean that w(a,b) will denote a connection between a and b ; w(a,b)=w(b,a). This proved to cut the calculation time in half.
* using the $(ord(n)>ord(m)) will set the binary h to 0 if the index is not of the upper triangle and when CPLEX imports the model
* it will simply drop the zero-variables so it should not affect performance. 

Option optcr=0.0;

Model Keys / all /;

solve Keys using mip maximizing z;

display w.l,x.l, z.l ;
