import("music.lib");
import("filter.lib");

myEcho = _ <: *(dry), (+~(fdelay(65536,delLength)*feedback*-1) : *(1-dry)) :> _
with{
	delLength = hslider("Time (ms)",250,0.1,1000,0.1)*0.001*SR : smooth(0.999);
	feedback = hslider("Feedback",0,0,1,0.001) : smooth(0.999);
	dry = hslider("Wet/Dry",1,0,1,0.01) : smooth(0.999);
};

process = myEcho;