/*
TODO:
- when loading a new track, also reset the gain to 0dB; this requires a modification to MidiHid
*/

// naming
~mXone = MidiInOutPair("XoneDX-SuperCollider","SuperCollider-XoneDX");
~mBcr = MidiInOutPair("BCR2000-SuperCollider","SuperCollider-BCR2000");
~mLaunchPad = MidiInOutPair("LPMini-SuperCollider","MIDIOUT2 (LPMiniMK3 MIDI)", [240, 0, 32, 41, 2, 13, 14, 1, 247], [45, 21]); // we send the sysex message to change to programmer mode

// novation launchpad


// midi xone
// shift
~uShift = false; // global shift button modifier; we use the u to indicate a user input modifier
~uS1 = false;
~uS2 = false;
~uS3 = false;
~uS4 = false;

MidiButton([16, 12, ~mXone], {~uShift = true; ~uS1 = true}, {~uShift = false; ~uS1 =  false}, \direct, targetOut: {~uShift});
MidiButton([16, 13, ~mXone], {~uShift = true; ~uS2 = true}, {~uShift = false; ~uS2 =  false}, \direct, targetOut: {~uShift});
MidiButton([16, 14, ~mXone], {~uShift = true; ~uS3 = true}, {~uShift = false; ~uS3 =  false}, \direct, targetOut: {~uShift});
MidiButton([16, 15, ~mXone], {~uShift = true; ~uS4 = true}, {~uShift = false; ~uS4 =  false}, \direct, targetOut: {~uShift});

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

//splitQue crossfader
MidiCC([21, 11, ~mXone], ServerTarget(~sOutputs, \splitQue), mode: \absolute);

// MidiHidSystem
MidiButton.new([60, 0, ~mBcr], BoolLangControllerTarget(MidiHidSystem,\macroToggle));
MidiButton([61, 0, ~mBcr], BoolLangControllerTarget(MidiHidSystem,\activateGlobalSensitivity));

// // DJ console
// select playlist // for now you need to do this manually
~libraryConsole.loadPlaylist(~musicLibrary.playlists.at("$ROOT".asSymbol, \Special, \All));
~libraryConsole.nextTrack_; // we select the first track of the playlist
//~libraryConsole.activeTrackArray = ~musicLibrary.findPlaylistByTitle("beatsync")[0].asArray;
//~libraryConsole.filter(3);

// browse tracks
MidiButton([17, 11, ~mXone], { ~prelistenDeck.playPause_(false); ~libraryConsole.nextTrack_(false); ~prelistenDeck.playPause_(true) }, mode: \direct);
MidiButton([18, 11, ~mXone], { ~prelistenDeck.playPause_(false); ~libraryConsole.nextTrack_(true); ~prelistenDeck.playPause_(true) }, spacingTime: 0.4, mode: \direct); // spacingTime = 1, because the button mallfunctions and often registers two pushes instead of one
MidiButton([19, 11, ~mXone], BoolLangLangTarget(~prelistenDeck, \playPause), spacingTime: 0.4, mode: \toggle);
MidiCC([33, 11, ~mXone], ContinuousLangTarget(~prelistenDeck, \needledropping) , mode: \relative, active: { ~prelistenDeck.playPause });

//sync prelistenDeck
MidiButton([36, 11, ~mXone], BoolLangLangTarget(~prelistenDeck, \sync), mode: \toggle, active: { ~uShift.not });
MidiButton([36, 11, ~mXone], { ~prelistenDeck.setAsMaster; ~libraryConsole.setReferenceTrack(~prelistenDeck.track) }, targetOut: { ~prelistenDeck.sync }, mode: \direct, active: { ~uShift });

// we use the same approach as currently in Traktor, we can scroll through the library and needledrop with the same encoder
//MidiButton([18, 11, ~mXone], { ~uNeedleDrop = true }, { ~uNeedleDrop = false }, mode: \direct); // emulate push behavior because BoolLangControllerTarget does not support boolean objects themselves
//MidiButton([18, 11, ~mXone], BoolLangControllerTarget(~prelistenDeck, \playPause), mode: \push);
//MidiCC([33, 11, ~mXone], BoolLangControllerTarget(~libraryConsole, \nextTrack), mode: \forwardBackwardButton, active: { ~prelistenDeck.playPause.not });
//MidiCC([33, 11, ~mXone], ContinuousLangTarget(~prelistenDeck, \needledropping) , mode: \relative, active: { ~prelistenDeck.playPause });

// // DJ deck

// deck1
// loadTrack
MidiButton([22, 12, ~mXone],{ ~deck1.loadCopy(~prelistenDeck).if{ ~musicLibrary.playlists.at("$ROOT".asSymbol, \Special, \History).addTrack(~prelistenDeck.track); MidiHidSystem.findByTarget(~sChannel1, \gain).resetInitial; MidiHidSystem.findByTarget(~sChannel1, \pan).resetInitial; MidiHidSystem.findByTarget(~sChannel1, \push).resetInitial; ~prelistenDeck.pause; ~libraryConsole.reset;  } }, mode: \direct);
//MidiButton([22, 12, ~mXone],{ ~sChannel1~deck1.loadAndPlayDouble(~prelistenDeck); ~libraryConsole.setReferenceTrack }, mode: \direct, active: { ~deck1.playPause.not });
//play
MidiButton([19, 12, ~mXone], BoolLangLangTarget(~deck1, \playPause), mode: \toggle);
//que
MidiButton([20, 12, ~mXone], { ~deck1.que }, mode: \direct, active: { ~uShift.not });
MidiButton([20, 12, ~mXone], { ~deck1.queShift }, mode: \direct, active: { ~uShift });
//jogwheel
MidiCC([38, 12, ~mXone], ContinuousLangTarget(~deck1, \scratch, clip: false), mode: \forwardBackwardButton, active: { ~uShift.not });
MidiCC([38, 12, ~mXone], ContinuousLangTarget(~deck1, \pitchbend, clip: false), mode: \forwardBackwardButton, active: { ~uShift.not });
MidiCC([38, 12, ~mXone], ContinuousLangTarget(~deck1, \needledropping), mode: \relative, sensitivity: 0.2, active: { ~uShift });
MidiCC([31, 12, ~mXone], ContinuousLangTarget(~deck1, \needledropping), mode: \plcFeedbackOnly);
//sync
MidiButton([7, 12, ~mXone], BoolLangLangTarget(~deck1, \sync), mode: \toggle, active: { ~uShift.not });
MidiButton([7, 12, ~mXone], { ~deck1.setAsMaster; ~libraryConsole.setReferenceTrack(~deck1.track) }, targetOut: { ~deck1.sync }, mode: \direct, active: { ~uShift });
//MidiButton([2, 12, ~mXone], BoolLangControllerTarget(~deck1, \userInducedGridOffsetSetpoint), mode: \direct); // TODO test and add for other decks ("adjust" button, next to sync); change to LangLangTarget
//tempo
MidiCC([36, 12, ~mXone], ContinuousLangTarget(~deck1, \tempo, clip: false), mode: \relative);
//beatjump
MidiButton([2, 12, ~mXone], {~deck1.beatJumpNow(-1)}, mode: \direct, active: { ~uShift.not }, spacingTime: 0.4);
MidiButton([12, 12, ~mXone], {~deck1.beatJumpNow(1)}, mode: \direct, active: { ~uShift.not });
MidiButton([3, 12, ~mXone], {~deck1.beatJumpNow(-32)}, mode: \direct, active: { ~uShift.not }); 
MidiButton([13, 12, ~mXone], {~deck1.beatJumpNow(32)}, mode: \direct, active: { ~uShift.not });
MidiButton([2, 12, ~mXone], {~deck1.beatJumpShifted(-1)}, mode: \direct, active: { ~uShift }, spacingTime: 0.4);
MidiButton([12, 12, ~mXone], {~deck1.beatJumpShifted(1)}, mode: \direct, active: { ~uShift });
MidiButton([3, 12, ~mXone], {~deck1.beatJumpShifted(-32)}, mode: \direct, active: { ~uShift }); 
MidiButton([13, 12, ~mXone], {~deck1.beatJumpShifted(32)}, mode: \direct, active: { ~uShift });

//loop
MidiButton([1, 12, ~mXone], BoolLangLangTarget(~deck1, \loop), mode: \toggle);
MidiButton([1, 12, ~mXone], ContinuousLangTarget(~deck1, \loopTableIndex, clip: false), mode: \direct, feedbackMode: false, buttonValue: 9, active: { ~uShift });
MidiCC([35, 12, ~mXone], ContinuousLangTarget(~deck1, \loopTableIndex, clip: false), mode: \relativeRound);

// deck2
// loadTrack
MidiButton([22, 13, ~mXone],{ ~deck2.loadCopy(~prelistenDeck).if{ ~musicLibrary.playlists.at("$ROOT".asSymbol, \Special, \History).addTrack(~prelistenDeck.track); MidiHidSystem.findByTarget(~sChannel2, \gain).resetInitial; MidiHidSystem.findByTarget(~sChannel2, \pan).resetInitial; MidiHidSystem.findByTarget(~sChannel2, \push).resetInitial; ~prelistenDeck.pause; ~libraryConsole.reset;  } }, mode: \direct);
//play
MidiButton([19, 13, ~mXone], BoolLangLangTarget(~deck2, \playPause), mode: \toggle);
//que
MidiButton([20, 13, ~mXone], { ~deck2.que }, mode: \direct, active: { ~uShift.not });
MidiButton([20, 13, ~mXone], { ~deck2.queShift }, mode: \direct, active: { ~uShift });
//jogwheel
MidiCC([38, 13, ~mXone], ContinuousLangTarget(~deck2, \scratch, clip: false), mode: \forwardBackwardButton, active: { ~uShift.not });
MidiCC([38, 13, ~mXone], ContinuousLangTarget(~deck2, \pitchbend, clip: false), mode: \forwardBackwardButton, active: { ~uShift.not });
MidiCC([38, 13, ~mXone], ContinuousLangTarget(~deck2, \needledropping), mode: \relative, sensitivity: 0.2, active: { ~uShift });
MidiCC([31, 13, ~mXone], ContinuousLangTarget(~deck2, \needledropping), mode: \plcFeedbackOnly);
//sync
MidiButton([7, 13, ~mXone], BoolLangLangTarget(~deck2, \sync), mode: \toggle, active: { ~uShift.not });
MidiButton([7, 13, ~mXone], { ~deck2.setAsMaster; ~libraryConsole.setReferenceTrack(~deck2.track) }, targetOut: { ~deck2.sync }, mode: \direct, active: { ~uShift });
//tempo
MidiCC([36, 13, ~mXone], ContinuousLangTarget(~deck2, \tempo, clip: false), mode: \relative);
//beatjump
MidiButton([2, 13, ~mXone], {~deck2.beatJumpNow(-1)}, mode: \direct, active: { ~uShift.not }, spacingTime: 0.4);
MidiButton([12, 13, ~mXone], {~deck2.beatJumpNow(1)}, mode: \direct, active: { ~uShift.not });
MidiButton([3, 13, ~mXone], {~deck2.beatJumpNow(-32)}, mode: \direct, active: { ~uShift.not }); 
MidiButton([13, 13, ~mXone], {~deck2.beatJumpNow(32)}, mode: \direct, active: { ~uShift.not });
MidiButton([2, 13, ~mXone], {~deck2.beatJumpShifted(-1)}, mode: \direct, active: { ~uShift }, spacingTime: 0.4);
MidiButton([12, 13, ~mXone], {~deck2.beatJumpShifted(1)}, mode: \direct, active: { ~uShift });
MidiButton([3, 13, ~mXone], {~deck2.beatJumpShifted(-32)}, mode: \direct, active: { ~uShift }); 
MidiButton([13, 13, ~mXone], {~deck2.beatJumpShifted(32)}, mode: \direct, active: { ~uShift });

//loop
MidiButton([1, 13, ~mXone], BoolLangLangTarget(~deck2, \loop), mode: \toggle);
MidiButton([1, 13, ~mXone], ContinuousLangTarget(~deck2, \loopTableIndex, clip: false), mode: \direct, feedbackMode: false, buttonValue: 9, active: { ~uShift });
MidiCC([35, 13, ~mXone], ContinuousLangTarget(~deck2, \loopTableIndex, clip: false), mode: \relativeRound);

// deck 3
// loadTrack
MidiButton([22, 14, ~mXone],{ ~deck3.loadCopy(~prelistenDeck).if{ ~musicLibrary.playlists.at("$ROOT".asSymbol, \Special, \History).addTrack(~prelistenDeck.track); MidiHidSystem.findByTarget(~sChannel3, \gain).resetInitial; MidiHidSystem.findByTarget(~sChannel3, \pan).resetInitial; MidiHidSystem.findByTarget(~sChannel3, \push).resetInitial; ~prelistenDeck.pause; ~libraryConsole.reset;  } }, mode: \direct);
//play
MidiButton([19, 14, ~mXone], BoolLangLangTarget(~deck3, \playPause), mode: \toggle);
//que
MidiButton([20, 14, ~mXone], { ~deck3.que }, mode: \direct, active: { ~uShift.not });
MidiButton([20, 14, ~mXone], { ~deck3.queShift }, mode: \direct, active: { ~uShift });
//jogwheel
MidiCC([38, 14, ~mXone], ContinuousLangTarget(~deck3, \scratch, clip: false), mode: \forwardBackwardButton, active: { ~uShift.not });
MidiCC([38, 14, ~mXone], ContinuousLangTarget(~deck3, \pitchbend, clip: false), mode: \forwardBackwardButton, active: { ~uShift.not });
MidiCC([38, 14, ~mXone], ContinuousLangTarget(~deck3, \needledropping), mode: \relative, sensitivity: 0.2, active: { ~uShift });
MidiCC([31, 14, ~mXone], ContinuousLangTarget(~deck3, \needledropping), mode: \plcFeedbackOnly);
//sync
MidiButton([7, 14, ~mXone], BoolLangLangTarget(~deck3, \sync), mode: \toggle, active: { ~uShift.not });
MidiButton([7, 14, ~mXone], { ~deck3.setAsMaster; ~libraryConsole.setReferenceTrack(~deck3.track) }, targetOut: { ~deck3.sync }, mode: \direct, active: { ~uShift });
//tempo
MidiCC([36, 14, ~mXone], ContinuousLangTarget(~deck3, \tempo, clip: false), mode: \relative);
//beatjump
MidiButton([2, 14, ~mXone], {~deck3.beatJumpNow(-1)}, mode: \direct, active: { ~uShift.not }, spacingTime: 0.4);
MidiButton([12, 14, ~mXone], {~deck3.beatJumpNow(1)}, mode: \direct, active: { ~uShift.not });
MidiButton([3, 14, ~mXone], {~deck3.beatJumpNow(-32)}, mode: \direct, active: { ~uShift.not }); 
MidiButton([13, 14, ~mXone], {~deck3.beatJumpNow(32)}, mode: \direct, active: { ~uShift.not });
MidiButton([2, 14, ~mXone], {~deck3.beatJumpShifted(-1)}, mode: \direct, active: { ~uShift }, spacingTime: 0.4);
MidiButton([12, 14, ~mXone], {~deck3.beatJumpShifted(1)}, mode: \direct, active: { ~uShift });
MidiButton([3, 14, ~mXone], {~deck3.beatJumpShifted(-32)}, mode: \direct, active: { ~uShift }); 
MidiButton([13, 14, ~mXone], {~deck3.beatJumpShifted(32)}, mode: \direct, active: { ~uShift });

//loop
MidiButton([1, 14, ~mXone], BoolLangLangTarget(~deck3, \loop), mode: \toggle);
MidiButton([1, 14, ~mXone], ContinuousLangTarget(~deck3, \loopTableIndex, clip: false), mode: \direct, feedbackMode: false, buttonValue: 9, active: { ~uShift });
MidiCC([35, 14, ~mXone], ContinuousLangTarget(~deck3, \loopTableIndex, clip: false), mode: \relativeRound);

// deck 4
// loadTrack
MidiButton([22, 15, ~mXone],{ ~deck4.loadCopy(~prelistenDeck).if{ ~musicLibrary.playlists.at("$ROOT".asSymbol, \Special, \History).addTrack(~prelistenDeck.track); MidiHidSystem.findByTarget(~sChannel4, \gain).resetInitial; MidiHidSystem.findByTarget(~sChannel4, \pan).resetInitial; MidiHidSystem.findByTarget(~sChannel4, \push).resetInitial; ~prelistenDeck.pause; ~libraryConsole.reset;  } }, mode: \direct);
//play
MidiButton([19, 15, ~mXone], BoolLangLangTarget(~deck4, \playPause), mode: \toggle);
//que
MidiButton([20, 15, ~mXone], { ~deck4.que }, mode: \direct, active: { ~uShift.not });
MidiButton([20, 15, ~mXone], { ~deck4.queShift }, mode: \direct, active: { ~uShift });
//jogwheel
MidiCC([38, 15, ~mXone], ContinuousLangTarget(~deck4, \scratch, clip: false), mode: \forwardBackwardButton, active: { ~uShift.not });
MidiCC([38, 15, ~mXone], ContinuousLangTarget(~deck4, \pitchbend, clip: false), mode: \forwardBackwardButton, active: { ~uShift.not });
MidiCC([38, 15, ~mXone], ContinuousLangTarget(~deck4, \needledropping), mode: \relative, sensitivity: 0.2, active: { ~uShift });
MidiCC([31, 15, ~mXone], ContinuousLangTarget(~deck4, \needledropping), mode: \plcFeedbackOnly);
//sync
MidiButton([7, 15, ~mXone], BoolLangLangTarget(~deck4, \sync), mode: \toggle, active: { ~uShift.not });
MidiButton([7, 15, ~mXone], { ~deck4.setAsMaster; ~libraryConsole.setReferenceTrack(~deck4.track) }, targetOut: { ~deck4.sync }, mode: \direct, active: { ~uShift });
//tempo
MidiCC([36, 15, ~mXone], ContinuousLangTarget(~deck4, \tempo, clip: false), mode: \relative);
//beatjump
MidiButton([2, 15, ~mXone], {~deck4.beatJumpNow(-1)}, mode: \direct, active: { ~uShift.not }, spacingTime: 0.4);
MidiButton([12, 15, ~mXone], {~deck4.beatJumpNow(1)}, mode: \direct, active: { ~uShift.not });
MidiButton([3, 15, ~mXone], {~deck4.beatJumpNow(-32)}, mode: \direct, active: { ~uShift.not }); 
MidiButton([13, 15, ~mXone], {~deck4.beatJumpNow(32)}, mode: \direct, active: { ~uShift.not });
MidiButton([2, 15, ~mXone], {~deck4.beatJumpShifted(-1)}, mode: \direct, active: { ~uShift }, spacingTime: 0.4);
MidiButton([12, 15, ~mXone], {~deck4.beatJumpShifted(1)}, mode: \direct, active: { ~uShift });
MidiButton([3, 15, ~mXone], {~deck4.beatJumpShifted(-32)}, mode: \direct, active: { ~uShift }); 
MidiButton([13, 15, ~mXone], {~deck4.beatJumpShifted(32)}, mode: \direct, active: { ~uShift });

//loop
MidiButton([1, 15, ~mXone], BoolLangLangTarget(~deck4, \loop), mode: \toggle);
MidiButton([1, 15, ~mXone], ContinuousLangTarget(~deck4, \loopTableIndex, clip: false), mode: \direct, feedbackMode: false, buttonValue: 9, active: { ~uShift });
MidiCC([35, 15, ~mXone], ContinuousLangTarget(~deck4, \loopTableIndex, clip: false), mode: \relativeRound);

MidiCC([22, 11, ~mXone], ServerTarget(~sOutputs, \gainPrelisten), mode: \absolute);

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
~hidList.selectKeys({ |item| item.productName =="HID POS" })[0] !? {|hidID| // if we can find the a hid device with a corresponding name, then open this device and set it up
    ~hBarcodeScanner = HID.openAt(hidID); // we find and open the hid Pos device, assuming there is only one, and it is the barcode scanner
    ~barcodeSource = HidSource(4,~hBarcodeScanner);
    HidValRaw(~barcodeSource, {|valRaw| 
        var valRawString, playlist;
        valRawString = valRaw.asString;
        // we check whether the barcode refers to a playlist (meaning the first digit is 1)
        if(valRawString[0].digit == 1){
            playlist = ~musicLibrary.barcodeDictionary.at(valRawString.copyRange(1, 10).asSymbol);
            ~libraryConsole.loadPlaylist(playlist);
            "playlist % loaded to libraryConsole by barcode".format(playlist.name).log(HidValRaw);
        };
    }, { ~uShift.not }); 

    HidValRaw(~barcodeSource, {|valRaw| 
        var valRawString, playlist;
        valRawString = valRaw.asString;
        // we check whether the barcode refers to a playlist (meaning the first digit is 1)
        if(valRawString[0].digit == 1){
            playlist = ~musicLibrary.barcodeDictionary.at(valRawString.copyRange(1, 10).asSymbol);
            playlist.addTrack(~deck1.track);
            "track % loaded from deck 1 to playlist %".format(~deck1.track.title, playlist.name).log(HidValRaw);
        };
    }, { ~uS1 }); 

    HidValRaw(~barcodeSource, {|valRaw| 
        var valRawString, playlist;
        valRawString = valRaw.asString;
        // we check whether the barcode refers to a playlist (meaning the first digit is 1)
        if(valRawString[0].digit == 1){
            playlist = ~musicLibrary.barcodeDictionary.at(valRawString.copyRange(1, 10).asSymbol);
            playlist.addTrack(~deck2.track);
            "track % loaded from deck 2 to playlist %".format(~deck2.track.title, playlist.name).log(HidValRaw);
        };
    }, { ~uS2 }); 

    HidValRaw(~barcodeSource, {|valRaw| 
        var valRawString, playlist;
        valRawString = valRaw.asString;
        // we check whether the barcode refers to a playlist (meaning the first digit is 1)
        if(valRawString[0].digit == 1){
            playlist = ~musicLibrary.barcodeDictionary.at(valRawString.copyRange(1, 10).asSymbol);
            playlist.addTrack(~deck3.track);
            "track % loaded from deck 3 to playlist %".format(~deck3.track.title, playlist.name).log(HidValRaw);
        };
    }, { ~uS3 }); 

    HidValRaw(~barcodeSource, {|valRaw| 
        var valRawString, playlist;
        valRawString = valRaw.asString;
        // we check whether the barcode refers to a playlist (meaning the first digit is 1)
        if(valRawString[0].digit == 1){
            playlist = ~musicLibrary.barcodeDictionary.at(valRawString.copyRange(1, 10).asSymbol);
            playlist.addTrack(~deck4.track);
            "track % loaded from deck 4 to playlist %".format(~deck4.track.title, playlist.name).log(HidValRaw);
        };
    }, { ~uS4 }); 
} ?? {
    " barcode scanner not found".log(HidValRaw);
};


//launchpad
MidiButton([81, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \tempoFilter), mode: \direct, buttonValue: 0);
MidiButton([82, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \tempoFilter), mode: \direct, buttonValue: 1);
MidiButton([83, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \tempoFilter), mode: \direct, buttonValue: 2);
MidiButton([84, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \tempoFilter), mode: \direct, buttonValue: 3);
MidiButton([85, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \tempoFilter), mode: \direct, buttonValue: 4);
MidiButton([86, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \tempoFilter), mode: \direct, buttonValue: 5);
//MidiButton([71, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \tempoMultiplier), mode: \direct, buttonValue: 0.5);
//MidiButton([72, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \tempoMultiplier), mode: \direct, buttonValue: 1);
//MidiButton([73, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \tempoMultiplier), mode: \direct, buttonValue: 2);
MidiButton([71, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \keyFilter), mode: \direct, buttonValue: 0);
MidiButton([72, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \keyFilter), mode: \direct, buttonValue: 1);
MidiButton([73, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \keyFilter), mode: \direct, buttonValue: 2);
MidiButton([74, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \keyFilter), mode: \direct, buttonValue: 3);
MidiButton([76, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \minorMajorFilterCoefficient), mode: \direct, buttonValue: 0);
MidiButton([77, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \minorMajorFilterCoefficient), mode: \direct, buttonValue: 1);
MidiButton([78, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \minorMajorFilterCoefficient), mode: \direct, buttonValue: 2);
MidiButton([61, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \energyFilterCoefficient), mode: \direct, buttonValue: 0);
MidiButton([62, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \energyFilterCoefficient), mode: \direct, buttonValue: 1);
MidiButton([63, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \energyFilterCoefficient), mode: \direct, buttonValue: 2);
MidiButton([64, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \energyFilterCoefficient), mode: \direct, buttonValue: 3);
MidiButton([65, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \energyFilterCoefficient), mode: \direct, buttonValue: 4);
MidiButton([66, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \energyFilterCoefficient), mode: \direct, buttonValue: 5);
MidiButton([51, 0, ~mLaunchPad.customLighting([7,55])], BoolLangLangTarget(~libraryConsole, \numberOfTracks), mode: \feedbackOnly, buttonValue: 1);
MidiButton([52, 0, ~mLaunchPad.customLighting([7,55])], BoolLangLangTarget(~libraryConsole, \numberOfTracks), mode: \feedbackOnly, buttonValue: 2);
MidiButton([53, 0, ~mLaunchPad.customLighting([7,55])], BoolLangLangTarget(~libraryConsole, \numberOfTracks), mode: \feedbackOnly, buttonValue: 4);
MidiButton([54, 0, ~mLaunchPad.customLighting([7,55])], BoolLangLangTarget(~libraryConsole, \numberOfTracks), mode: \feedbackOnly, buttonValue: 8);
MidiButton([55, 0, ~mLaunchPad.customLighting([7,55])], BoolLangLangTarget(~libraryConsole, \numberOfTracks), mode: \feedbackOnly, buttonValue: 16);
MidiButton([56, 0, ~mLaunchPad.customLighting([7,55])], BoolLangLangTarget(~libraryConsole, \numberOfTracks), mode: \feedbackOnly, buttonValue: 32);
MidiButton([57, 0, ~mLaunchPad.customLighting([7,55])], BoolLangLangTarget(~libraryConsole, \numberOfTracks), mode: \feedbackOnly, buttonValue: 64);
MidiButton([58, 0, ~mLaunchPad.customLighting([7,55])], BoolLangLangTarget(~libraryConsole, \numberOfTracks), mode: \feedbackOnly, buttonValue: 128);
MidiButton([41, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \order), mode: \direct, buttonValue: 0);
MidiButton([42, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \order), mode: \direct, buttonValue: 1);
MidiButton([43, 0, ~mLaunchPad], BoolLangLangTarget(~libraryConsole, \order), mode: \direct, buttonValue: 2);


//ThrustMaster
~hidList.selectKeys({ |item| item.productName =="T.Flight Stick X" })[0] !? {|hidID| // if we can find the a hid device with a corresponding name, then open this device and set it up
    ~hThrustMaster = HID.openAt(hidID); // we find and open the hid Pos device, assuming there is only one, and it is the barcode scanner
    HidCC([1,~hThrustMaster], ServerTarget(~sChannel6, \faderVolume), invert: true);
    HidCC([3,~hThrustMaster], ServerTarget(~sThrustMaster, \ud));
    HidCC([4,~hThrustMaster], ServerTarget(~sThrustMaster, \lr));
};

// we turn off automatic midi feedback
MidiHidSystem.enabled_(false);