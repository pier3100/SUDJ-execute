//ableton link clock, and 1/16 clock
c = LinkClock.new.latency_(s.latency);
//~c16th = TempoClock.new(c.tempo, 0, 0);

//plc functionality
~mainPLC = PLC.new(1000);

/*
~fl_plc = FunctionList.new; // all functions in this list will be evaluated at each cycly of the plc
~fl_plcMacro = FunctionList.new; // here all the mapping from server to language takes place
~c_plc = TempoClock.new(1000);// set plc rate in Hz
~r_plc = Routine{
	inf.do{ |i|
	~c_plc.timeToNextBeat.wait; //wait till next cyle start
	~fl_plc.value;      //run all functions
	~fl_plcMacro.value;
	0.1.wait;       //should be lower then cycle length, is required in order to make sure not two cycles are computed directly after each other
	};
};
~r_plc.play(~c_plc,quant:1); // schedule the routine on the clock


~r_c = Routine{
	inf.do{ |i|
	c.timeToNextBeat.wait; //wait till next cyle start
	~fl_c.value;      //run all functions
	0.1.wait;       //should be lower then cycle length, is required in order to make sure not two cycles are computed directly after each other
	};
};
~r_c.play(c,quant:1); // schedule the routine on the clock
*/

//syncing the clocks
//~changeClockFunc = { |tempo|
//	c.tempo_(tempo);
//	~c16th.tempo_(tempo * 4);
//};

//~mainPLC.add({ ~c16th.beats_(c.beats * 4) }); 
//~syncClock_func.value; //sync now
//~syncClock_controller = SimpleController(c); //sync in the future
//~syncClock_controller.put(\tempo, ~syncClock_func);
//.setTempoAtBeat(newTempo, beats) ipv gebruiken


//clock integrator
/* ~tempoIntegrator = ClockedIntegrator(1 / ~mainPLC.tempo);
~tempoIntegrator.value_(c.tempo); //the slope of the tempoIntegrator is set from a know, as described in physicalInterfaces
~mainPLC.add({ c.tempo_(~tempoIntegrator.next) });  */

// start library console
~libraryConsole = LibraryConsole.new(~prelistenDeck);

// set master clock
~prelistenDeck.clock.master = c; // there is one standard master clock
~deck1.clock.master = c; 
~deck2.clock.master = c; 
~deck3.clock.master = c; 
~deck4.clock.master = c; 
