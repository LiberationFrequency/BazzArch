//-----------------------------------------------
//     Single Side Modulation
//-----------------------------------------------

import("math.lib") ; // for PI definition
import("music.lib") ; // for osci definition

biquad(a1,a2,b0,b1,b2) = + ~ conv2(a1,a2) : conv3(b0,b1,b2)
with{
	conv3(k0,k1,k2,x) = k0*x + k1*x' + k2*x'' ;
	conv2(k0,k1,x)    = k0*x + k1*x' ;
};

cosci(freq) = s1 + d * (s2 - s1)
with{
	cosinwaveform = time*(2*PI)/tablesize : cos ;
		i = int(phase(freq)) ;
		d = decimal(phase(freq)) ;
		s1 = rdtable(tablesize+1,cosinwaveform,i) ;
		s2 = rdtable(tablesize+1,cosinwaveform,i+1) ;
};


f1 = biquad(-0.02569, 0.260502, -0.260502, 0.02569, 1) :
	biquad(1.8685, -0.870686, 0.870686, -1.8685, 1) ;
f2 = biquad(1.94632, -0.94657, 0.94657, -1.94632, 1) :
	biquad(0.83774, -0.06338, 0.06338, -0.83774, 1) ;

a = hslider("Freq shift",0,-10000,10000,1);

process(sig) = f1(sig)*cosci(a) - f2(sig)*osci(a),
	       f1(sig)*cosci(a) + f2(sig)*osci(a);