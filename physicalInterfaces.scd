/*
TODO:
- when loading a new track, also reset the gain to 0dB; this requires a modification to MidiHid
*/

// naming
~mXone = MidiInOutPair("XoneDX-SuperCollider","SuperCollider-XoneDX");
~mBcr = MidiInOutPair("BCR2000-SuperCollider","SuperCollider-BCR2000");
~mLaunchPad = MidiInOutPair("MIDIIN2 (LPMiniMK3 MIDI)","MIDIOUT2 (LPMiniMK3 MIDI)", [240, 0, 32, 41, 2, 13, 14, 1, 247], [45, 21]); // we send the sysex message to change to programmer mode

// novation launchpad


// midi xone
// shift
~uShift = false; // global shift button modifier; we use the u to indicate a user input modifier
MidiButton([16, 12, ~mXone], {~uShift = true}, {~uShift = false}, \direct, targetOut: {~uShift});
MidiButton([16, 13, ~mXone], {~uShift = true}, {~uShift = false}, \direct, targetOut: {~uShift});
MidiButton([16, 14, ~mXone], {~uShift = true}, {~uShift = false}, \direct, targetOut: {~uShift});
MidiButton([16, 15, ~mXone], {~uShift = true}, {~uShift = false}, \direct, targetOut: {~uShift});
// eq
MidiCC([1, 11, ~mXone], ServerTarget(~sChannel1,\highGain), mode:\absolute);
MidiCC([2, 11, ~mXone], ServerTarget(~sChannel1,\midGain), mode:\absolute);
MidiCC([18, 11, ~mXone], ServerTarget(~sChannel1,\lowGain), mode:\absolute);
MidiCC([17, 11, ~mXone], ServerTarget(~sChannel1,\filter), mode:\absolute);

MidiCC([19, 11, ~mXone], ServerTarget(~sChannel2,\highGain), mode:\absolute);
MidiCC([5, 11, ~mXone], ServerTarget(~sChannel2,\midGain), mode:\absolute);
MidiCC([20, 11, ~mXone], ServerTarget(~sChannel2,\lowGain), mode:\absolute);
MidiCC([4, 11, ~mXone], ServerTarget(~sChannel2,\filter), mode:\absolute);

MidiCC([24, 11, ~mXone], ServerTarget(~sChannel3,\highGain), mode:\absolute);
MidiCC([23, 11, ~mXone], ServerTarget(~sChannel3,\midGain), mode:\absolute);
MidiCC([9, 11, ~mXone], ServerTarget(~sChannel3,\lowGain), mode:\absolute);
MidiCC([7, 11, ~mXone], ServerTarget(~sChannel3,\filter), mode:\absolute);

MidiCC([10, 11, ~mXone], ServerTarget(~sChannel4,\highGain), mode:\absolute);
MidiCC([26, 11, ~mXone], ServerTarget(~sChannel4,\midGain), mode:\absolute);
MidiCC([11, 11, ~mXone], ServerTarget(~sChannel4,\lowGain), mode:\absolute);
MidiCC([25, 11, ~mXone], ServerTarget(~sChannel4,\filter), mode:\absolute);

// channel faders
MidiCC([3, 11, ~mXone], ServerTarget(~sChannel1,\faderVolume), mode:\absolute);
MidiCC([6, 11, ~mXone], ServerTarget(~sChannel2,\faderVolume), mode:\absolute);
MidiCC([8, 11, ~mXone], ServerTarget(~sChannel3,\faderVolume), mode:\absolute);
MidiCC([28, 11, ~mXone], ServerTarget(~sChannel4,\faderVolume), mode:\absolute);

// channel que
MidiButton([10, 11, ~mXone], ServerTarget(~sChannel1, \que), mode: \toggle);
MidiButton([15, 11, ~mXone], ServerTarget(~sChannel2, \que), mode: \toggle);
MidiButton([25, 11, ~mXone], ServerTarget(~sChannel3, \que), mode: \toggle);
MidiButton([30, 11, ~mXone], ServerTarget(~sChannel4, \que), mode: \toggle);

// channel crossfader switch
MidiButton([8, 11, ~mXone], ServerTarget(~sChannel1, \crossfaderSelectorL));
MidiButton([9, 11, ~mXone], ServerTarget(~sChannel1, \crossfaderSelectorR));
MidiButton([13, 11, ~mXone], ServerTarget(~sChannel2, \crossfaderSelectorL));
MidiButton([14, 11, ~mXone], ServerTarget(~sChannel2, \crossfaderSelectorR));
MidiButton([23, 11, ~mXone], ServerTarget(~sChannel3, \crossfaderSelectorL));
MidiButton([24, 11, ~mXone], ServerTarget(~sChannel3, \crossfaderSelectorR));
MidiButton([28, 11, ~mXone], ServerTarget(~sChannel4, \crossfaderSelectorL));
MidiButton([29, 11, ~mXone], ServerTarget(~sChannel4, \crossfaderSelectorR));

// crossfader
MidiCC([13, 11, ~mXone], ServerTarget(~sMixer, \crossFader), mode:\absolute);

// MidiHidSystem
MidiButton.new([60, 0, ~mBcr], BoolLangTarget(MidiHidSystem,\macroToggle));
MidiButton([61, 0, ~mBcr], BoolLangTarget(MidiHidSystem,\activateGlobalSensitivity));

// // DJ console
// select playlist // for now you need to do this manually
~libraryConsole.loadPlaylist(~musicLibrary.playlists.at("$ROOT".asSymbol, \Custom, \All));
//~libraryConsole.activeTrackArray = ~musicLibrary.findPlaylistByTitle("beatsync")[0].asArray;
//~libraryConsole.filter(3);

// browse tracks
// we use the same approach as currently in Traktor, we can scroll through the library and needledrop with the same encoder
//MidiButton([18, 11, ~mXone], { ~uNeedleDrop = true }, { ~uNeedleDrop = false }, mode: \direct); // emulate push behavior because BoolLangTarget does not support boolean objects themselves
MidiButton([18, 11, ~mXone], BoolLangTarget(~prelistenDeck, \playPause), mode: \push);
MidiCC([33, 11, ~mXone], BoolLangTarget(~libraryConsole, \nextTrack), mode: \forwardBackwardButton, active: { ~prelistenDeck.playPause.not });
MidiCC([33, 11, ~mXone], ContinuousLangTarget(~prelistenDeck, \needledropping) , mode: \relative, active: { ~prelistenDeck.playPause });
MidiButton([36, 11, ~mXone], BoolLangTarget(~prelistenDeck, \sync), mode: \toggle, active: { ~uShift.not });
MidiButton([36, 11, ~mXone], { ~prelistenDeck.setAsMaster }, targetOut: { ~prelistenDeck.sync }, mode: \direct, active: { ~uShift });

// // DJ deck
// deck1
// loadTrack
MidiButton([22, 12, ~mXone],{ ~deck1.loadAndPlayDouble(~prelistenDeck); ~libraryConsole.setReferenceTrack }, mode: \direct);

//
//MidiButton([22, 12, ~mXone],{ ~sChannel1~deck1.loadAndPlayDouble(~prelistenDeck); ~libraryConsole.setReferenceTrack }, mode: \direct, active: { ~deck1.playPause.not });

//play
MidiButton([19, 12, ~mXone], BoolLangTarget(~deck1, \playPause), mode: \toggle);
//que
MidiButton([20, 12, ~mXone], { ~deck1.que }, mode: \direct, active: { ~uShift.not });
MidiButton([20, 12, ~mXone], { ~deck1.phraseQue }, mode: \direct, active: { ~uShift });
//jogwheel
MidiCC([38, 12, ~mXone], ContinuousLangTarget(~deck1, \pitchbend, clip: false), mode: \forwardBackwardButton, active: { ~uShift.not });
MidiCC([38, 12, ~mXone], ContinuousLangTarget(~deck1, \needledropping) , mode: \relative, active: { ~uShift });
//sync
MidiButton([7, 12, ~mXone], BoolLangTarget(~deck1, \sync), mode: \toggle, active: { ~uShift.not });
MidiButton([7, 12, ~mXone], { ~deck1.setAsMaster; ~libraryConsole.referenceTrack_(~deck1.track) }, targetOut: { ~deck1.sync }, mode: \direct, active: { ~uShift });
MidiButton([2, 12, ~mXone], BoolLangTarget(~deck1, \userInducedGridOffsetSetpoint), mode: \direct); // TODO test and add for other decks ("adjust" button, next to sync)
//tempo
MidiCC([36, 12, ~mXone], ContinuousLangTarget(~deck1, \tempo, clip: false), mode: \relative);
//beatjump
MidiButton([3, 12, ~mXone], {~deck1.beatJump(-8)}, mode: \direct); // we could also make this a toggle, that way you can cancel the scheduled beatJump, which would require us to use a DynamicTask
MidiButton([13, 12, ~mXone], {~deck1.beatJump(8)}, mode: \direct);
MidiButton([2, 12, ~mXone], {~deck1.beatJump(-1)}, mode: \direct);
MidiButton([12, 12, ~mXone], {~deck1.beatJump(1)}, mode: \direct);
//loop
MidiButton([1, 12, ~mXone], BoolLangTarget(~deck1, \loop), mode: \toggle);
MidiCC([35, 12, ~mXone], BoolLangTarget(~deck1, \loopSize), mode: \forwardBackwardButton);

// deck2
// loadTrack
MidiButton([22, 13, ~mXone],{ ~deck2.loadAndPlayDouble(~prelistenDeck); ~libraryConsole.setReferenceTrack }, mode: \direct);
//play
MidiButton([19, 13, ~mXone], BoolLangTarget(~deck2, \playPause), mode: \toggle);
//que
MidiButton([20, 13, ~mXone], { ~deck2.que }, mode: \direct, active: { ~uShift.not });
MidiButton([20, 13, ~mXone], { ~deck2.phraseQue }, mode: \direct, active: { ~uShift });
//jogwheel
MidiCC([38, 13, ~mXone], ContinuousLangTarget(~deck2, \pitchbend, clip: false), mode: \forwardBackwardButton, active: { ~uShift.not });
MidiCC([38, 13, ~mXone], ContinuousLangTarget(~deck2, \needledropping) , mode: \relative, active: { ~uShift });
//sync
MidiButton([7, 13, ~mXone], BoolLangTarget(~deck2, \sync), mode: \toggle, active: { ~uShift.not });
MidiButton([7, 13, ~mXone], { ~deck2.setAsMaster; ~libraryConsole.referenceTrack_(~deck2.track) }, targetOut: { ~deck2.sync }, mode: \direct, active: { ~uShift });
//tempo
MidiCC([36, 13, ~mXone], ContinuousLangTarget(~deck2, \tempo, clip: false), mode: \relative);
//beatjump
MidiButton([3, 13, ~mXone], {~deck2.beatJump(-8)}, mode: \direct); // we could also make this a toggle, that way you can cancel the scheduled beatJump, which would require us to use a DynamicTask
MidiButton([13, 13, ~mXone], {~deck2.beatJump(8)}, mode: \direct);
MidiButton([2, 13, ~mXone], {~deck2.beatJump(-1)}, mode: \direct);
MidiButton([12, 13, ~mXone], {~deck2.beatJump(1)}, mode: \direct);
//loop
MidiButton([1, 13, ~mXone], BoolLangTarget(~deck2, \loop), mode: \toggle);
MidiCC([35, 13, ~mXone], BoolLangTarget(~deck2, \loopSize), mode: \forwardBackwardButton);

// deck 3
// loadTrack
MidiButton([22, 14, ~mXone],{ ~deck3.loadAndPlayDouble(~prelistenDeck); ~libraryConsole.setReferenceTrack }, mode: \direct);
//play
MidiButton([19, 14, ~mXone], BoolLangTarget(~deck3, \playPause), mode: \toggle);
//que
MidiButton([20, 14, ~mXone], { ~deck3.que }, mode: \direct, active: { ~uShift.not });
MidiButton([20, 14, ~mXone], { ~deck3.phraseQue }, mode: \direct, active: { ~uShift });
//jogwheel
MidiCC([38, 14, ~mXone], ContinuousLangTarget(~deck3, \pitchbend, clip: false), mode: \forwardBackwardButton, active: { ~uShift.not });
MidiCC([38, 14, ~mXone], ContinuousLangTarget(~deck3, \needledropping) , mode: \relative, active: { ~uShift });
//sync
MidiButton([7, 14, ~mXone], BoolLangTarget(~deck3, \sync), mode: \toggle, active: { ~uShift.not });
MidiButton([7, 14, ~mXone], { ~deck3.setAsMaster; ~libraryConsole.referenceTrack_(~deck3.track) }, targetOut: { ~deck3.sync }, mode: \direct, active: { ~uShift });
//tempo
MidiCC([36, 14, ~mXone], ContinuousLangTarget(~deck3, \tempo, clip: false), mode: \relative);
//beatjump
MidiButton([3, 14, ~mXone], {~deck3.beatJump(-8)}, mode: \direct); // we could also make this a toggle, that way you can cancel the scheduled beatJump, which would require us to use a DynamicTask
MidiButton([13, 14, ~mXone], {~deck3.beatJump(8)}, mode: \direct);
MidiButton([2, 14, ~mXone], {~deck3.beatJump(-1)}, mode: \direct);
MidiButton([12, 14, ~mXone], {~deck3.beatJump(1)}, mode: \direct);
//loop
MidiButton([1, 14, ~mXone], BoolLangTarget(~deck3, \loop), mode: \toggle);
MidiCC([35, 14, ~mXone], BoolLangTarget(~deck3, \loopSize), mode: \forwardBackwardButton);

// deck 4
// loadTrack
MidiButton([22, 15, ~mXone],{ ~deck4.loadAndPlayDouble(~prelistenDeck); ~libraryConsole.setReferenceTrack }, mode: \direct);
//play
MidiButton([19, 15, ~mXone], BoolLangTarget(~deck4, \playPause), mode: \toggle);
//que
MidiButton([20, 15, ~mXone], { ~deck4.que }, mode: \direct, active: { ~uShift.not });
MidiButton([20, 15, ~mXone], { ~deck4.phraseQue }, mode: \direct, active: { ~uShift });
//jogwheel
MidiCC([38, 15, ~mXone], ContinuousLangTarget(~deck4, \pitchbend, clip: false), mode: \forwardBackwardButton, active: { ~uShift.not });
MidiCC([38, 15, ~mXone], ContinuousLangTarget(~deck4, \needledropping) , mode: \relative, active: { ~uShift });
//sync
MidiButton([7, 15, ~mXone], BoolLangTarget(~deck4, \sync), mode: \toggle, active: { ~uShift.not });
MidiButton([7, 15, ~mXone], { ~deck4.setAsMaster; ~libraryConsole.referenceTrack_(~deck4.track) }, targetOut: { ~deck4.sync }, mode: \direct, active: { ~uShift });
//tempo
MidiCC([36, 15, ~mXone], ContinuousLangTarget(~deck4, \tempo, clip: false), mode: \relative);
//beatjump
MidiButton([3, 15, ~mXone], {~deck4.beatJump(-8)}, mode: \direct); // we could also make this a toggle, that way you can cancel the scheduled beatJump, which would require us to use a DynamicTask
MidiButton([13, 15, ~mXone], {~deck4.beatJump(8)}, mode: \direct);
MidiButton([2, 15, ~mXone], {~deck4.beatJump(-1)}, mode: \direct);
MidiButton([12, 15, ~mXone], {~deck4.beatJump(1)}, mode: \direct);
//loop
MidiButton([1, 15, ~mXone], BoolLangTarget(~deck4, \loop), mode: \toggle);
MidiCC([35, 15, ~mXone], BoolLangTarget(~deck4, \loopSize), mode: \forwardBackwardButton);

// bcr
// channel 1
MidiCC([81, 0, ~mBcr], ServerTarget(~sChannel1, \pan));
MidiCC([89, 0, ~mBcr], ServerTarget(~sChannel1, \push), mode: \absolute);
MidiCC([97, 0, ~mBcr], ServerTarget(~sChannel1, \gain), mode: \absolute);

// channel 2
MidiCC([82, 0, ~mBcr], ServerTarget(~sChannel2, \pan));
MidiCC([90, 0, ~mBcr], ServerTarget(~sChannel2, \push), mode: \absolute);
MidiCC([98, 0, ~mBcr], ServerTarget(~sChannel2, \gain), mode: \absolute);

// channel 3
MidiCC([83, 0, ~mBcr], ServerTarget(~sChannel3, \pan));
MidiCC([91, 0, ~mBcr], ServerTarget(~sChannel3, \push), mode: \absolute);
MidiCC([99, 0, ~mBcr], ServerTarget(~sChannel3, \gain), mode: \absolute);

// channel 4
MidiCC([84, 0, ~mBcr], ServerTarget(~sChannel4, \pan));
MidiCC([92, 0, ~mBcr], ServerTarget(~sChannel4, \push), mode: \absolute);
MidiCC([100, 0, ~mBcr], ServerTarget(~sChannel4, \gain), mode: \absolute);

// barcodeScanner
~hidList = HID.findAvailable;
~barcodeScanner = HID.openAt(~hidList.selectKeys({ |item| item.productName =="HID POS" })[0]); // we find and open the hid Pos device, assuming there is only one, and it is the barcode scanner
~barcodeSource = HidSource(4,~barcodeScanner);
HidValRaw(~barcodeSource, {|valRaw| 
    var valRawString, playlist;
    valRawString = valRaw.asString;
    // we check whether the barcode refers to a playlist (meaning the first digit is 1)
    if(valRawString[0].digit == 1){
        playlist = ~musicLibrary.barcodeDictionary.at(valRawString.copyRange(1, 10).asSymbol);
        ~libraryConsole.loadPlaylist(playlist);
        "playlist % loaded to libraryConsole by barcode".format(playlist.name).log(HidValRaw);
    }
}); 

//launchpad
MidiButton([81, 0, ~mLaunchPad], ContinuousLangTarget(~libraryConsole, \tempoFilter, clip: false), mode: \direct, buttonValue: 1);
MidiButton([82, 0, ~mLaunchPad], ContinuousLangTarget(~libraryConsole, \tempoFilter, clip: false), mode: \direct, buttonValue: 2);
MidiButton([83, 0, ~mLaunchPad], ContinuousLangTarget(~libraryConsole, \tempoFilter, clip: false), mode: \direct, buttonValue: 3);
MidiButton([84, 0, ~mLaunchPad], ContinuousLangTarget(~libraryConsole, \tempoFilter, clip: false), mode: \direct, buttonValue: 4);
MidiButton([85, 0, ~mLaunchPad], ContinuousLangTarget(~libraryConsole, \tempoFilter, clip: false), mode: \direct, buttonValue: 5);
MidiButton([71, 0, ~mLaunchPad], ContinuousLangTarget(~libraryConsole, \tempoMultiplier, clip: false), mode: \direct, buttonValue: 0.5);
MidiButton([72, 0, ~mLaunchPad], ContinuousLangTarget(~libraryConsole, \tempoMultiplier, clip: false), mode: \direct, buttonValue: 1);
MidiButton([73, 0, ~mLaunchPad], ContinuousLangTarget(~libraryConsole, \tempoMultiplier, clip: false), mode: \direct, buttonValue: 2);
MidiButton([61, 0, ~mLaunchPad], ContinuousLangTarget(~libraryConsole, \keyFilter, clip: false), mode: \direct, buttonValue: 1);
MidiButton([62, 0, ~mLaunchPad], ContinuousLangTarget(~libraryConsole, \keyFilter, clip: false), mode: \direct, buttonValue: 2);
MidiButton([63, 0, ~mLaunchPad], ContinuousLangTarget(~libraryConsole, \keyFilter, clip: false), mode: \direct, buttonValue: 3);
MidiButton([64, 0, ~mLaunchPad], ContinuousLangTarget(~libraryConsole, \keyFilter, clip: false), mode: \direct, buttonValue: 4);

// we turn off automatic midi feedback
MidiHidSystem.enabled_(false);