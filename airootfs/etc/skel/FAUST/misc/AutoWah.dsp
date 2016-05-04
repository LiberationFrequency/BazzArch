//-----------------------------------------------
//     Auto-Wha
//-----------------------------------------------

import("effect.lib"); //for crybaby definition
a = hslider("Mapping",1,1,10,0.1) ;

Sum(n,x) = +(x - (x @ n)) ~ _;
Average(n,x) = x * (1<<22) : int : abs : Sum(n) : float : /(1<<22)
	      : /(n);
Map(x) = x * a : max(0) : min(1) ;
process(x) = x : crybaby(x : Average(1000) : Map) ;