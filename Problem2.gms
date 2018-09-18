
Sets
   n 'Nodes' / n1*n8 /
   k 'Keys' / k1*k30 /;
alias(n,m)

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
   diagonals(n)    'removing diagonals as connections'
;

total..      z =e=  sum((n,m), w(n,m))/2   ;

maxK(k).. sum(n, x(n,k)) =l= 4;

*as 700kB/186kB = 3, we can only hold 3 keys in a node
memory(n).. sum(k, x(n,k)) =l= 3;

*if both node n and node m has key k, then the LHS will be 1, allowing h to be 1, indicating that they have key k in common
identify(n,m,k).. (x(n,k)+x(m,k))/2 =g= h(n,m,k);

*same method as above, if node n and m have 3 keys in common, allow w (the secure connection counter) to be 1
secure(n,m).. (sum(k, h(n,m,k)))/3 =g= w(n,m);

*Unfortunately this program treats the issue of connections in a NxN matrix instead of simply the upper or lower triangle
*making the problem a lot harder to solve than it should be. This is due to me not knowing how to construct and maintain
*triangle-matrixes for the decicion variables in GAMS, something witch can easily be implemented in a proper language such as
*Java, Python or C++. At least I set diagonals to 0, as they should not count towards "connections", likewise I devide the total
*with 2, to remove the symmetry of the decicion variable matrix. Connection A->B and B->A is the same connection. 
diagonals(n).. w(n,n) =e= 0;

option threads=4;
Model Keys / all /;

solve Keys using mip maximizing z;

display w.l,x.l, z.l ;
