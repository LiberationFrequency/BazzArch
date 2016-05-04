import("music.lib");
import("filter.lib");

monoFreeverb(fb1,fb2,damp,spread) = _ <: par(i,8,lpcf(combtuningL(i),fb1,damp)) :> seq(i,4,allpass_comb(1024,allpasstuningL(i),-fb2))
with{
	lpcf(dt,fb,damp) = (+:delay(2048,dt))~ (*(1-damp) : (+ ~ *(damp)) : *(fb));
	origSR = 44100;
	cTuning = (1116,1188,1277,1356,1422,1491,1557,1617);
	combtuningL(i) = take(i+1,cTuning)*SR/origSR : int : +(spread);
	aTuning = (556,441,341,225);
	allpasstuningL(i) = take(i+1,aTuning)*SR/origSR : int;
};

stereoFreeverb(fb1,fb2,damp,spread) = + <: monoFreeverb(fb1,fb2,damp,0),monoFreeverb(fb1,fb2,damp,spread);

freeverbDemo = _,_ <: 
	(*(g)*fixedgain,*(g)*fixedgain : stereoFreeverb(combfeed,allpassfeed,damping,spatSpread)),
	*(1-g),*(1-g) :> _,_
with{
	origSR = 44100;
	scaleroom = 0.28;
	offsetroom = 0.7;
	allpassfeed = 0.5;
	scaledamp = 0.4;
	fixedgain = 0.1;
	mainGroup(x) = vgroup("Freeverb",x);
	knobsGroup(x) = mainGroup(hgroup("[0]",x));
	combfeed = knobsGroup(hslider("[0]Room Size [style:knob]",0.5,0,1,0.01)*scaleroom*SR/origSR + offsetroom);
	damping = knobsGroup(hslider("[1]Damping [style:knob]",0.5,0,1,0.01)*scaledamp*SR/origSR);
	spatSpread = knobsGroup(hslider("[2]Spatial Spread [style:knob]",0.5,0,1,0.01)*46*SR/origSR : int);
	g = mainGroup(hslider("[1]Dry/Wet",0.3,0,1,0.01));
};

process = freeverbDemo;