// naming
~mXone = MidiInOutPair("XoneDX-SuperCollider");
~mBcr = MidiInOutPair("BCR2000-SuperCollider","SuperCollider-BCR2000");

~uShift = false; // global shift button modifier; we use the u to indicate a user input modifier

// midi xone
// channel faders
MidiCC([~mXone, 11, 3], ServerTarget(~sChannel1,\faderVolume), mode:\absolute);
MidiCC([~mXone, 11, 6], ServerTarget(~sChannel3,\faderVolume), mode:\absolute);
MidiCC([~mXone, 11, 8], ServerTarget(~sChannel2,\faderVolume), mode:\absolute);
MidiCC([~mXone, 11, 28], ServerTarget(~sChannel4,\faderVolume), mode:\absolute);

// channel que
MidiButton([~mXone, 11, 10], ServerTarget(~sChannel1, \que), \toggle);
MidiButton([~mXone, 11, 15], ServerTarget(~sChannel3, \que), \toggle);
MidiButton([~mXone, 11, 25], ServerTarget(~sChannel2, \que), \toggle);
MidiButton([~mXone, 11, 30], ServerTarget(~sChannel4, \que), \toggle);

// channel crossfader switch
MidiButton([~mXone, 11, 8], ServerTarget(~sChannel1, \crossfaderSelectorL));
MidiButton([~mXone, 11, 9], ServerTarget(~sChannel1, \crossfaderSelectorR));
MidiButton([~mXone, 11, 13], ServerTarget(~sChannel3, \crossfaderSelectorL));
MidiButton([~mXone, 11, 14], ServerTarget(~sChannel3, \crossfaderSelectorR));
MidiButton([~mXone, 11, 23], ServerTarget(~sChannel2, \crossfaderSelectorL));
MidiButton([~mXone, 11, 24], ServerTarget(~sChannel2, \crossfaderSelectorR));
MidiButton([~mXone, 11, 28], ServerTarget(~sChannel4, \crossfaderSelectorL));
MidiButton([~mXone, 11, 29], ServerTarget(~sChannel4, \crossfaderSelectorR));

// crossfader
MidiCC([~mXone,11,13], ServerTarget(~sMixer,\crossFader), mode:\absolute);

// MidiHidSystem
MidiButton([~mBcr, 0, 60], BoolLangTarget(MidiHidSystem,\macroToggle));
MidiButton([~mBcr, 0, 61], BoolLangTarget(MidiHidSystem,\activateGlobalSensitivity));


// // DJ console
// select playlist // for now you need to do this manually
~libraryConsole.activeTrackArray = ~musicLibrary.playlists[2].asArray;
~libraryConsole.filter(3);

// browse tracks
// we use the same approach as currently in Traktor, we can scroll through the library and needledrop with the same encoder
~uNeedleDrop = false;
MidiButton([], { ~uNeedleDrop = true }, { ~uNeedleDrop = false }, mode: \direct); // emulate push behavior because BoolLangTarget does not support boolean objects themselves
MidiCC([], BoolLangTarget(~libraryConsole, \nextTrack), mode: \forwardBackwardButton, active: ~uNeedleDrop.not);
MidiCC([], ContinuousLangTarget(~prelistenDeck, \needledropping), mode: \relative, , active: ~uNeedleDrop);

// // DJ deck
// loadTrack
MidiButton([],{ ~deck1.loadDoubleAndPlay(~prelistenDeck); ~libraryConsole.setReferenceTrack }, mode: \direct);
//play
MidiButton([], BoolLangTarget(~deck1, \playPause), mode: \toggle);
//que
MidiButton([], { ~deck1.que }, mode: \direct);
//jogwheel
MidiCC([], ContinuousLangTarget(~deck1, \pitchbend), mode: \forwardBackwardButton);
//sync
~syncLongPressDeck1 = false;
MidiButton([], { ~deck1.setAsMaster }, { |val, longPress| if(longPress.not){ ~deck1.sync_(~deck1.sync.not) }}, mode: \direct, delay: 0.3 );//on long press set as master (this includes engaging sync), on short press toggle sync
//tempo
MidiCC([], ContinuousLangTarget(~deck1, \tempo), mode: \relative, constrained: false);
//beatjump
MidiButton([], {~deck1.beatJump(-8)}, mode: \direct); // we could also make this a toggle, that way you can cancel the scheduled beatJump, which would require us to use a DynamicTask
MidiButton([], {~deck1.beatJump(8)}, mode: \direct);
//loop
MidiButton([], BoolLangTarget(~deck1, \loop), mode: \toggle);
MidiCC([], BoolLangTarget(~deck1, \loopSize), mode: \forwardBackwardButton);


