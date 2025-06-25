// load configuration
Library.addFromYAML("C:\\Users\\piert\\MakingMusic\\SuperCollider\\SUDJ-data\\config.YAML");

// verify configuration is legitimate
if(["pureStereo", "surroundByKernel"].includesEqual(Library.at(\audioConfiguration)).not){ Error("Not a valid audioConfiguration").throw };

// start logger
Log.new(Library.at(\logPath));

// music library
~reload = true;
~musicLibrary = MusicLibrary.loadFromTraktor(Library.at(\musicLibraryPath), Library.at(\musicLibraryCustomPartPath), Library.at(\traktorLibraryPath), forceLoad: ~reload); // reusing existing library is broken; but it is also redundant is reloading from scratch is considerably faster
if(~reload){
	Smartlist.new("All", { true }, "7375646A7375646A416C6C7375646A7375646A").addToLibrary;
	Smartlist.new("History", { false }, "f0f86c15c3a940e9a3c93b4a66d3f37d").addToLibrary;
	Smartlist.new("Session", { false }, "1e0f57a1b3d24d0cbd5e6ffb5e37359f").addToLibrary;
	~musicLibrary.barcodeDictionary_;
};
//~musicLibrary.addPseudoPlaylist("E1", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E1".asSymbol));
//~musicLibrary.addPseudoPlaylist("E2", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E2".asSymbol));
//~musicLibrary.addPseudoPlaylist("E3", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E3".asSymbol));
//~musicLibrary.addPseudoPlaylist("E4", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E4".asSymbol));
//~musicLibrary.addPseudoPlaylist("E5", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E5".asSymbol));
//~musicLibrary.playlists.put("$ROOT".asSymbol, \Special, \All, Playlist.new("All", Array.series(~musicLibrary.tracks.size, 0, 1)));
//~musicLibrary.barcodeDictionary_;

//buffer
b = Buffer.alloc(s,44100,1);

//recorder
r = Recorder(s);
r.prepareForRecord(numChannels:2);

/* // surround
~hoaOrder = 2;
~speakerDegrees = [-30, 30, -90, 90, -150, 160];
~speakerDbsCorrection = [0, 0, 0, 4, 0, 4]; //In a free field - a doubling of the distance from a noise source reduces the sound pressure level with 6 decibel.
~matrixDecoderMain = HoaMatrixDecoder.newModeMatch(~speakerDegrees.degrad, beamShape: 'basic', match: 'amp', order: ~hoaOrder);
~matrixDecoderHeads = HoaMatrixDecoder.newDirections([-30, 30].degrad, beamShape: 'basic', match: 'amp', order: ~hoaOrder);
~matrixEncoderStereo = HoaMatrixEncoder.newDirections([-30, 30].degrad, order: ~hoaOrder);
~ambiChannels = ~matrixEncoderStereo.numOutputs;
 */
//
~speakerDegrees = [-30, 30, -90]; // [-30, 30, -90, 90, -150, 160];
~speakerDbsCorrection = [0, 0, 0, 0, 0, 0]; //In a free field - a doubling of the distance from a noise source reduces the sound pressure level with 6 decibel.
if(Library.at(\audioConfiguration) == "surroundByKernel"){
    ~matrixDecoderMain = FoaDecoderMatrix.newDiametric(~speakerDegrees.degrad, k: 'single');
};
if(Library.at(\audioConfiguration) == "pureStereo"){
    ~matrixDecoderMain = FoaDecoderMatrix.newStereo;
};
~matrixDecoderHeads = FoaDecoderMatrix.newStereo;
~kernelEncoderSuperStereo = FoaEncoderKernel.newSuper(8192);
~matrixEncoderStereo = FoaEncoderMatrix.newStereo;
~numberChannels = ~kernelEncoderSuperStereo.numOutputs;

// calculate delay in seconds, and set server latency accordingly
//s.latency = ((~kernelEncoderStereo.kernelSize - 1)/2 + ~kernelEncoderStereo.kernelSize - s.options.blockSize) / s.sampleRate; // assuming that in a DJdeck BufRd is in sync with the clock (delayed by EncoderKernel), the output of a DJdeck will be in sync with patterns (delayed by server communication with latency parameter)