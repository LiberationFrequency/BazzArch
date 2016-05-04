declare id "tube2";

import("music.lib");
import("effect.lib");
import("guitarix.lib");

resonator = (+ <: (delay(4096, d-1) + delay(4096, d))/2.0)~*(1.0-a)
with {
d = 1 - vslider("Vibrato[style:knob][OWL:PARAMETER_C]", 1, 0, 0.99, 0.01);
a = 0.9 - vslider("Resonance[style:knob][OWL:PARAMETER_B]", 0.5, 0, 0.9, 0.01);
};

fuzzy = vslider("Fuzz[name:tube][style:knob][OWL:PARAMETER_A]", 1, -3, 10, 1);

tube1 = component("HighShelf.dsp").hs : nonlin1 : resonator : +(anti_denormal_ac) : speakerbp(130,5000) * fuzzy * 0.5;
process(x) = x + tube1(x) : sym_clip(0.7);
