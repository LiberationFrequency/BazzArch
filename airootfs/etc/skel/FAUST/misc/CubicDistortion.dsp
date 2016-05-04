import("music.lib");
import("filter.lib");

distortion = +(offset) : *(pregain) : clip(-1,1) : cubic : dcblocker
with{
	drive = hslider("Drive",0,0,1,0.01) : smooth(0.999);
	offset = hslider("Offset",0,-0.1,0.1,0.01) : smooth(0.999);
	pregain = pow(10,drive*2);
	clip(lo,hi) = min(hi) : max(lo);
	cubic(x) = x - x*x*x/3;
};

process = distortion;