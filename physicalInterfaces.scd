// naming
~mXone = MidiInOutPair("XoneDX-SuperCollider","SuperCollider-XoneDX");
~mBcr = MidiInOutPair("BCR2000-SuperCollider","SuperCollider-BCR2000");

// shift
~uShift = false; // global shift button modifier; we use the u to indicate a user input modifier
MidiButton([16, 12, ~mXone], {~uShift = true}, {~uShift = false}, \direct);
MidiButton([16, 14, ~mXone], {~uShift = true}, {~uShift = false}, \direct);

// midi xone
// channel faders
MidiCC([3, 11, ~mXone], ServerTarget(~sChannel1,\faderVolume), mode:\absolute);
MidiCC([6, 11, ~mXone], ServerTarget(~sChannel3,\faderVolume), mode:\absolute);
MidiCC([8, 11, ~mXone], ServerTarget(~sChannel2,\faderVolume), mode:\absolute);
MidiCC([28, 11, ~mXone], ServerTarget(~sChannel4,\faderVolume), mode:\absolute);

// channel que
MidiButton([10, 11, ~mXone], ServerTarget(~sChannel1, \que), \toggle);
MidiButton([15, 11, ~mXone], ServerTarget(~sChannel3, \que), \toggle);
MidiButton([30, 11, ~mXone], ServerTarget(~sChannel4, \que), \toggle);
MidiButton([25, 11, ~mXone], ServerTarget(~sChannel2, \que), \toggle);

// channel crossfader switch
MidiButton([8, 11, ~mXone], ServerTarget(~sChannel1, \crossfaderSelectorL));
MidiButton([9, 11, ~mXone], ServerTarget(~sChannel1, \crossfaderSelectorR));
MidiButton([13, 11, ~mXone], ServerTarget(~sChannel3, \crossfaderSelectorL));
MidiButton([14, 11, ~mXone], ServerTarget(~sChannel3, \crossfaderSelectorR));
MidiButton([23, 11, ~mXone], ServerTarget(~sChannel2, \crossfaderSelectorL));
MidiButton([24, 11, ~mXone], ServerTarget(~sChannel2, \crossfaderSelectorR));
MidiButton([28, 11, ~mXone], ServerTarget(~sChannel4, \crossfaderSelectorL));
MidiButton([29, 11, ~mXone], ServerTarget(~sChannel4, \crossfaderSelectorR));

// crossfader
MidiCC([13, 11, ~mXone], ServerTarget(~sMixer, \crossFader), mode:\absolute);

// MidiHidSystem
MidiButton.new([60, 0, ~mBcr], BoolLangTarget(MidiHidSystem,\macroToggle));
MidiButton([61, 0, ~mBcr], BoolLangTarget(MidiHidSystem,\activateGlobalSensitivity));

// // DJ console
// select playlist // for now you need to do this manually
~libraryConsole.activeTrackArray = ~musicLibrary.playlists[12].asArray;
~libraryConsole.filter(4);

// browse tracks
// we use the same approach as currently in Traktor, we can scroll through the library and needledrop with the same encoder
//MidiButton([18, 11, ~mXone], { ~uNeedleDrop = true }, { ~uNeedleDrop = false }, mode: \direct); // emulate push behavior because BoolLangTarget does not support boolean objects themselves
MidiButton([18, 11, ~mXone], BoolLangTarget(~prelistenDeck, \playPause), mode: \push);
MidiCC([33, 11, ~mXone], BoolLangTarget(~libraryConsole, \nextTrack), mode: \forwardBackwardButton, active: { ~prelistenDeck.playPause.not });
MidiCC([33, 11, ~mXone], ContinuousLangTarget(~prelistenDeck, \needledropping) , mode: \relative, active: { ~prelistenDeck.playPause });

// // DJ deck
// loadTrack
MidiButton([22, 12, ~mXone],{ ~deck1.loadAndPlayDouble(~prelistenDeck); ~libraryConsole.setReferenceTrack }, mode: \direct);

//play
MidiButton([19, 12, ~mXone], BoolLangTarget(~deck1, \playPause), mode: \toggle);

//que
MidiButton([20, 12, ~mXone], { ~deck1.que }, mode: \direct);
//jogwheel
MidiCC([38, 12, ~mXone], ContinuousLangTarget(~deck1, \pitchbend, clip: false), mode: \forwardBackwardButton, active: { ~uShift.not });
MidiCC([38, 12, ~mXone], ContinuousLangTarget(~deck1, \needledropping) , mode: \relative, active: { ~uShift });
~deck1.sync;
//sync
m = MidiButton([7, 12, ~mXone], { ~deck1.setAsMaster }, { |val, longPress| if(longPress.not){ ~deck1.sync_(~deck1.sync.not) }}, targetOut: {~deck1.sync}, mode: \direct, delay: 0.3 );//on long press set as master (this includes engaging sync), on short press toggle sync
//m.targetOut.value
/*//tempo
MidiCC([], ContinuousLangTarget(~deck1, \tempo), mode: \relative, constrained: false);
//beatjump
MidiButton([], {~deck1.beatJump(-8)}, mode: \direct); // we could also make this a toggle, that way you can cancel the scheduled beatJump, which would require us to use a DynamicTask
MidiButton([], {~deck1.beatJump(8)}, mode: \direct);
//loop
MidiButton([], BoolLangTarget(~deck1, \loop), mode: \toggle);
MidiCC([], BoolLangTarget(~deck1, \loopSize), mode: \forwardBackwardButton);


 */