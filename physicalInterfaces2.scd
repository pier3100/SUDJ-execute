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
    "barcode scanner not found".log(HidValRaw);
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

~blink = Value.new(0);
~mainPLC.add({~blink.value_(~blink.value.not)});
MidiButton([18, 0, ~mLaunchPad.customLighting([7,55])], BoolLangLangTarget(~blink, \value), mode: \feedbackOnly, buttonValue: 0.5);

//ThrustMaster
~hidList.selectKeys({ |item| item.productName =="T.Flight Stick X" })[0] !? {|hidID| // if we can find the a hid device with a corresponding name, then open this device and set it up
    ~hThrustMaster = HID.openAt(hidID); // we find and open the hid Pos device, assuming there is only one, and it is the barcode scanner
    HidCC([1,~hThrustMaster], ServerTarget(~sChannel6, \faderVolume), invert: true);
    HidCC([3,~hThrustMaster], ServerTarget(~sThrustMaster, \ud));
    HidCC([4,~hThrustMaster], ServerTarget(~sThrustMaster, \lr));
}?? {
    "thrust master not found".log(HidValRaw);
};

// we turn off automatic midi feedback
MidiHidSystem.enabled_(false);