// start library console
~libraryConsole = LibraryConsole.new(~prelistenDeck, c);

// set master clock
~prelistenDeck.clock.master = c; // there is one standard master clock
~deck1.clock.master = c; 
~deck2.clock.master = c; 
~deck3.clock.master = c; 
~deck4.clock.master = c; 

// wind noise sound
~windMute = Value.new(false);
~windParameter = Value.new(1);