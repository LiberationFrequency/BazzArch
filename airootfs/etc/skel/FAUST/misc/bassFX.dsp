//import("tonestack.lib");
import("filter.lib");
import("effect.lib");
import("math.lib");
import("music.lib");
import("guitarix.lib");

tstack = _:component("tonestack.lib").bassman(t,m,l):_ 
	with {
          t = hgroup("[1:] Tonestack", vslider("[0:] Treble[style:knob]", 0.25, 0, 1, 0.01));
          m = hgroup("[1:] Tonestack", vslider("[1:] Middle[style:knob]", 0.5, 0, 1, 0.01));
          l = hgroup("[1:] Tonestack", vslider("[2:] Bass[style:knob]", 0.75, 0, 1, 0.01));
};




//---------------------------------BassBooster-------------------------
/*
declare id     "amp.bass_boost";
declare name   "Bassbooster";
declare groups ".bassbooster[Bassbooster]";

import("filter.lib");
*/
//------------------------------------------------------------------
// DAFX, Digital Audio Effects (Wiley ed.)
// chapter 2 : filters
// section 2.3 : Equalizers
// page 53 : second order shelving filter design
//------------------------------------------------------------------

lfboost(F,G) = tf2(b0,b1,b2,a0,a1)
with {
  V = db2linear(G);
  K = tan(PI*F/SR);
  D = 1 + sqrt(2)*K + K*K;

  b0 = (1 + sqrt(2*V)*K + V*K*K) / D;
  b1 = 2 * (V*K*K - 1) / D;
  b2 = (1 - sqrt(2*V)*K + V*K*K) / D;
  a0 = 2 * (K*K - 1) / D;
  a1 = (1 - sqrt(2)*K + K*K) / D;
};
level = hgroup("[2:] BassBooster", hslider(".bassbooster.Level", 10, 0.5, 20, 0.5) : smooth(0.9999)); 


//process = lfboost(120, level);











//--------------------------------BassEnhancer-----------------------------------------------
// declare id   "bassEnhancer";
// declare name "Bass Enhancer";
// declare shortname "BassEnhancer";
// declare category "Misc";

//------------------------------------
//Based at:
//"LOW COMPLEXITY VIRTUAL BASS ENHANCEMENT ALGORITHM FOR PORTABLE MULTIMEDIA DEVICE"
//MANISH ARORA, HAN-GIL MOON, AND SEONGCHEOL JANG
//Audio lab, DM R&D Center, Samsung Electronics co. Ltd, Suwon, South Korea
//------------------------------------



//Controls
lp_freq = hgroup("[3:] BassEnhancer", hslider("Frequency",100,60,240,5));
harmonics_volume = hgroup("[3:] BassEnhancer", hslider("HarmonicsdB[name:Harmonics]",0, -16, +32, 0.1): db2linear : smooth(0.999));

//Can be moved to .lib
X = (_,_)<:(!,_,_,!);
switch(c,x,y) = sel(c,x,y)
with { 
	sel(c,x,y) = (1-c)*x + c*y; 
};

//NLD and consts
harm1 = 0.03;
harm2 = 0.015;
get_const(a,b,x,y) = (x <= y)*a + (x > y)*b;
nld1(a,b) = _<:(_,_,X,_,_:_,X,_,_,_:((get_const(a,b):1-_),_,get_const(a,b),_):(_*_,_*_:(_+_)))~_~_~_;



be = _<:hp_branch,(_,_:>lp_branch<:_,_),(_,_:>be_branch<:_,_),hp_branch:>_ 
with {
	hp_branch = dcblockerat(20) : highpass(8, lp_freq);
	lp_branch = dcblockerat(20) : lowpass(8,lp_freq);
	be_branch = lowpass(8,lp_freq) : nld1(harm1,harm2) : _*harmonics_volume; 
};




// --------------------freeverb--------------------------------------


/*
declare name "Freeverb";
declare category "Reverb";

declare version 	"0.01";
declare author 		"brummer";
declare license 	"BSD";
declare copyright 	"(c)brummer 2008";


import("effect.lib"); 
import("filter.lib");


*/
/*-----------------------------------------------
		freeverb  by "Grame"
  -----------------------------------------------*/

// Filter Parameters

combtuningL1	= 1116;
combtuningL2	= 1188;
combtuningL3	= 1277;
combtuningL4	= 1356;
combtuningL5	= 1422;
combtuningL6	= 1491;
combtuningL7	= 1557;
combtuningL8	= 1617;

allpasstuningL1	= 556;
allpasstuningL2	= 441;
allpasstuningL3	= 341;
allpasstuningL4	= 225;

roomsizeSlider 	= hgroup("[4:] FreeVerb", vslider("RoomSize[name:Room Size]", 0.66, 0, 1, 0.025)*0.28 + 0.7);
dampslider 	= hgroup("[4:] FreeVerb", vslider("damp[name:HF Damp]",0.33, 0, 1, 0.025));
combfeed 	= roomsizeSlider;
//wetslider 	= 0.5 + vslider("wet_dry[name:Wet/Dry]", 0, -0.5, 0.5, 0.1);
wet_dry = hgroup("[4:] FreeVerb", hslider("wet_dry[name:Wet/Dry] [style:knob]",  50, 0, 100, 1) : /(100));
dry = 1 - wet_dry;

// Reverb components

monoReverb(fb1, fb2, damp, spread)
	= _ <:	comb(combtuningL1+spread, fb1, damp),
			comb(combtuningL2+spread, fb1, damp),
			comb(combtuningL3+spread, fb1, damp),
			comb(combtuningL4+spread, fb1, damp),
			comb(combtuningL5+spread, fb1, damp),
			comb(combtuningL6+spread, fb1, damp),
			comb(combtuningL7+spread, fb1, damp),
			comb(combtuningL8+spread, fb1, damp)
		+>
		 	allpass (allpasstuningL1+spread, fb2)
		:	allpass (allpasstuningL2+spread, fb2)
		:	allpass (allpasstuningL3+spread, fb2)
		:	allpass (allpasstuningL4+spread, fb2)
		;

//----------------------------------------------------------------

fxctrl(g,w,Fx) =  _ <: (*(g) <: _ + Fx ), *(1-w) +> _;




fv = _<:*(dry),(*(wet_dry):fxctrl(0.015,wet_dry, monoReverb(combfeed, 0.5, dampslider, 23))):>_;













process = tstack : lfboost(120, level) : be;