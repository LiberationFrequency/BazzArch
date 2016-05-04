import("music.lib");
import("filter.lib");

myFbComb = +~(delay(2048,delLength)*(-a1))
with{
	a1 = hslider("a1",0,-1,0.999,0.001) : smooth(0.999);
	delLength = hslider("delLength",1,1,2000,1);
};

process = myFbComb;