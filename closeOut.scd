~wind = f = { var par;
	if(~windMute.value){ Synth("wind",[\bus, ~bWind,  \buf, ~buWind, \effectKnobsBus, ~bEffectKnobsBcr, \rate, 1+0.2.rand, \pos, 0, \pan, 2.0.rand -1], ~gChannel7) };
	par = ~windParameter.value.linexp(0,1,0.05,5);
	par + par.sqrt.sum3rand;
};
c.sched(1,~wind);
MidiHidSystem.instanceList.do({ |item|  item.targetOut !? { item.feedback } }); // added here because the feedback send upon initialization of each MidiCC fails due to the target not yet being ready; the target creates a parameterBus, which it sets to the current value of the target, but reading this target value takes time, during this time you cannot correctly poll the outputValue; in the closeOut we can do it, because of is previous s.sync
"SUDJ succesfully booted".log;