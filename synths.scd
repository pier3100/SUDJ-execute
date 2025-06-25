~sInputs   = Synth.new(\inputs);
~gChannels = Group.new(~sInputs, \addAfter);
~gChannel1 = Group.new(~gChannels, \addToHead);
~gChannel2 = Group.new(~gChannels, \addToHead);
~gChannel3 = Group.new(~gChannels, \addToHead);
~gChannel4 = Group.new(~gChannels, \addToHead);
~gChannel5 = Group.new(~gChannels, \addToHead);
~gChannel6 = Group.new(~gChannels, \addToHead);
~gPreview = Group.new(~gChannels, \addToHead);
~prelistenDeck = DJdeck.new(~bPreview, ~gPreview, deckNr: "pre");
~deck1 = DJdeck.new(~bDeck1, ~gChannel1, deckNr: 1);
~deck2 = DJdeck.new(~bDeck2, ~gChannel2, deckNr: 2);
~deck3 = DJdeck.new(~bDeck3, ~gChannel3, deckNr: 3);
~deck4 = DJdeck.new(~bDeck4, ~gChannel4, deckNr: 4);
~sDrumMachine = DrumMachine.new(4, 16, c, Library.at(\rhythmsPath), ~bDrumMachine, ~gChannel5);
~sThrustMaster = Synth.head(~gChannel6, \riser1, [\bus, ~bThrustMaster]);
Synth.tail(~gPreview, \stereoToFoa, [\bus, ~bPreview]);
if(Library.at(\audioConfiguration) == "surroundByKernel"){
    Synth.tail(~gChannel1, \superStereoToFoa, [\bus, ~bDeck1]);
    Synth.tail(~gChannel2, \superStereoToFoa, [\bus, ~bDeck2]);
    Synth.tail(~gChannel3, \superStereoToFoa, [\bus, ~bDeck3]);
    Synth.tail(~gChannel4, \superStereoToFoa, [\bus, ~bDeck4]);
    Synth.tail(~gChannel5, \stereoToFoa, [\bus, ~bDrumMachine]);
    Synth.tail(~gChannel5, \stereoToFoa, [\bus, ~bThrustMaster]);
};
if(Library.at(\audioConfiguration) == "pureStereo"){
    Synth.tail(~gChannel1, \stereoToFoa, [\bus, ~bDeck1]);
    Synth.tail(~gChannel2, \stereoToFoa, [\bus, ~bDeck2]);
    Synth.tail(~gChannel3, \stereoToFoa, [\bus, ~bDeck3]);
    Synth.tail(~gChannel4, \stereoToFoa, [\bus, ~bDeck4]);
    Synth.tail(~gChannel5, \stereoToFoa, [\bus, ~bDrumMachine]);
    Synth.tail(~gChannel6, \stereoToFoa, [\bus, ~bThrustMaster]);
};
~sChannel1 = Synth.tail(~gChannel1, \channelMixer,[\inputBus, ~bDeck1]);
~sChannel2 = Synth.tail(~gChannel2, \channelMixer,[\inputBus, ~bDeck2]);
~sChannel3 = Synth.tail(~gChannel3, \channelMixer,[\inputBus, ~bDeck3]);
~sChannel4 = Synth.tail(~gChannel4, \channelMixer,[\inputBus, ~bDeck4]);
~sChannel5 = Synth.tail(~gChannel5, \channelMixer,[\inputBus, ~bDrumMachine]);
~sChannel6 = Synth.tail(~gChannel6, \channelMixer,[\inputBus, ~bThrustMaster]);
~gEffects  = Group.new(~gChannels, \addAfter);
~sEffect1  = Synth.head(~gEffects, \vst,[\bus, ~bSend1]);
~sEffect2  = Synth.head(~gEffects, \distortionLowpass, [\bus, ~bSend2]);
~sEffect3  = Synth.head(~gEffects, \convolution, [\bus, ~bSend3, \busSide, ~bSend3Side]);
~sMixer    = Synth.after(~gEffects, \mainMixer);
~sOutputs  = Synth.after(~s_mixer, \outputsSurround);

//macros
~sMacroLFO = Synth(\macroLFO).installMacro;
~sMacroLine = Synth(\macroLine).installMacro;