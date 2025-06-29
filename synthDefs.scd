//input and output from JACK (from: Traktor, to: soundcard)
SynthDef(\inputs, {
    //Out.ar(, FoaEncode.ar(In.ar(8,2), ~kernelEncoderStereo)); // make surround
    //Out.ar(, FoaEncode.ar(In.ar(10,2), ~kernelEncoderStereo)); // make surround
    //Out.ar(, FoaEncode.ar(In.ar(12,2), ~kernelEncoderStereo)); // make surround
    //Out.ar(, FoaEncode.ar(In.ar(14,2), ~kernelEncoderStereo)); // make surround
    //Out.ar(, FoaEncode.ar(In.ar(16,2), ~kernelEncoderStereo)); // make surround
}).add;

~outputChannelSelection = Array.series((s.options.numOutputBusChannels-2).clip(2,6));
SynthDef(\outputsSurround, {
	var inputMain, inputQue, outputMain, outputHeadsMain, outputHeadsQue, outputHeads, splitQue;
	inputMain = In.ar(~bOutMain,~numberChannels);
	outputMain =  FoaDecode.ar(inputMain, ~matrixDecoderMain);
	outputMain = MulAdd(outputMain,~speakerDbsCorrection.dbamp); // correct for speaker locations
	outputMain = ((outputMain * ServerControlLag.kr(\masterVolume, Library.at(\masterVolume)).dbamp)*(-10).dbamp).clip2(1); //(-10).dbamp) to make sure we have some headroom in order to gain uncompressed tracks a bit more
    Out.ar(0, outputMain[~outputChannelSelection]); // we only output as many channels as we have speakers
    inputQue = In.ar(~bQue,~bQue.numChannels);
    outputHeadsMain = FoaDecode.ar(inputMain, ~matrixDecoderHeads);
    outputHeadsQue = FoaDecode.ar(inputQue, ~matrixDecoderHeads);
    outputHeadsQue = outputHeadsQue * ServerControlLag.kr(\gainPrelisten, 0.5).linlin(0, 1, -25, 25).dbamp; // -6 to +6 gain
    splitQue = ServerControlLag.kr(\splitQue, 0);
    //splitQue = (ServerControlLag.kr(\splitQue, 0).asin*2/pi).asin*2/pi; // we correct for the fact that the output from xone for this knob is not symmetric EDIT, this trick does not work, because we have too poor resolution on the right side of the knob
    outputHeads = [XFade2.ar(outputHeadsMain[0], outputHeadsQue[0], splitQue.linlin(0.5,1,-1,1)), XFade2.ar(outputHeadsMain[1], outputHeadsQue[1], splitQue.linlin(0,0.5,-1,1))];
    outputHeads = ((outputHeads * ServerControlLag.kr(\headPhoneGainDb, Library.at(\headPhoneGainDb)).dbamp)*(-5).dbamp).clip2(1);
    Out.ar(~outputChannelSelection.size, outputHeads); // for example: if you have 6 channels, we assume last two are for headphone, first four are for speakers; so nSpeakers = 4; then busses 0,1,2,3 are for the speakers, and 4,5 are headphones, so headphone should start at 4 = nSpeakers
}).add;

//multichannel conversions
SynthDef(\superStereoToFoa, { |bus|
    // we replace the stereo input with a FOA ouput, we assume that the bus had sufficient channels 
    // this induces a lag, see documentation of kernelEncoder, we take this into account be letting the patterns (which use stereo) run later than the tracks (which use superStereo)
    var foa;
    foa = FoaEncode.ar(In.ar(bus, 2), ~kernelEncoderSuperStereo); // make surround
    ReplaceOut.ar(bus, [foa[0], foa[1], foa[2]]); //output, and ignore fourth empty channel
}).add;

SynthDef(\stereoToFoa, { |bus|
    // we replace the stereo input with a FOA ouput, we assume that the bus had sufficient channels 
    var foa;
    foa = FoaEncode.ar(In.ar(bus, 2), ~matrixEncoderStereo); // make surround
    ReplaceOut.ar(bus, [foa[0], foa[1], foa[2]]); //output, and ignore fourth empty channel
}).add;

//channelmixer
SynthDef(\channelMixer, { |inputBus, que = 0, crossfaderSelectorL = 0, crossfaderSelectorR = 0|
    var input, output, freqLow, freqHigh, lowGain, midGain, highGain, vst1, vst2, outputPostFader;
    input = In.ar(inputBus, ~numberChannels);
    output = input * ServerControlLag.kr(\gain, 0.5).linlin(0, 1, -25, 25).dbamp; // -6 to +6 gain
	output = FoaPushX.ar(output, ServerControlLag.kr(\push, 0.5).linlin(0,1,-pi/2,pi/2));
    output = FoaRotate.ar(output, angle: ServerControlLag.kr(\pan, 0.5).linlin(0,1,-pi,pi)); // surround panner
    
    // EQ
    freqLow = ServerControlLag.kr(\freqLow, Library.at(\EqFreqLow));
    freqHigh = ServerControlLag.kr(\freqHigh, Library.at(\EqFreqHigh));
    lowGain = ServerControlLag.kr(\lowGain, 0.5);
    midGain = ServerControlLag.kr(\midGain, 0.5);
    highGain = ServerControlLag.kr(\highGain, 0.5);
    vst1 = VSTPlugin.ar([output[0], output[1]], 2, params: [2, freqLow, 3, freqHigh, 4, lowGain, 5, midGain, 6, highGain], id: \eq3vst1);
    vst2 = VSTPlugin.ar(output[2], 1, params: [2, freqLow, 3, freqHigh, 4, lowGain, 5, midGain, 6, highGain], id: \eq3vst2);
    output = [vst1[0], vst1[1], vst2];
    output = DjFilter.ar(output, ServerControlLag.kr(\filter, 0.5));
    // Sends
    Out.ar(~bSend1,     output * VolumeFaderCurve.kr(ServerControlLag.kr(\send1Volume)));
    Out.ar(~bSend2,     output * VolumeFaderCurve.kr(ServerControlLag.kr(\send2Volume)));
    Out.ar(~bSend3,     output * VolumeFaderCurve.kr(ServerControlLag.kr(\send3Volume)));
    Out.ar(~bSend3Side, output * VolumeFaderCurve.kr(ServerControlLag.kr(\send3SideVolume)));
    outputPostFader = output * VolumeFaderCurve.kr(ServerControlLag.kr(\faderVolume));
    Out.ar(~bCrossL, outputPostFader * crossfaderSelectorL);
    Out.ar(~bCrossR, outputPostFader * crossfaderSelectorR);
    Out.ar(~bCrossBypass, outputPostFader * (1 - crossfaderSelectorL) * (1 - crossfaderSelectorR));
    Out.ar(~bQue, output * que);
}).add;

//mainmixer
SynthDef(\mainMixer, {
    var output;
    output = XFade2.ar(In.ar(~bCrossL, ~numberChannels), In.ar(~bCrossR, ~numberChannels), ServerControlLag.kr(\crossFader).linlin(0,1,-1,1)); // add crossfader outputs; outputs who bypass the crossfader have added allready
    output = output + In.ar(~bCrossBypass, ~numberChannels);
    output = output + In.ar(~bSend1, ~numberChannels) + In.ar(~bSend2, ~numberChannels) + In.ar(~bSend3, ~numberChannels);// add sends
    Out.ar(~bOutMain, output);//all seperate channels have allready been added, we only need to add the send
    Out.ar(~bQue, In.ar(~bPreview, ~numberChannels));
    //Out.ar(~bOutHeads, (1-splitQue)*FoaRotate.ar(FoaPushX.ar(In.ar(~bOutMain, ~numberChannels), splitQue.linlin(0,0.5,0,pi)), angle: splitQue.linlin(0,1,0,pi)) + splitQue*FoaRotate.ar(FoaPushX.ar(In.ar(~bQue, ~numberChannels), splitQue.linlin(0.5,1,pi,0)), angle: pi + splitQue.linlin(0,1,0,pi)));
}).add;

//vst
SynthDef(\vst, { |bus|
    ReplaceOut.ar(bus, VSTPlugin.ar(In.ar(bus, ~numberChannels), ~numberChannels));
}).add;

//lowpassed distortion
SynthDef(\distortionLowpass, { |bus, parameters = #[0, 0, 0, 0]|
    var input, output, drivegain, shelvingfreq, room, damp; //the '#' sign indicates to interpret the elements as literals, that means symbolically
    drivegain = parameters[0];
    shelvingfreq = parameters[1].linexp(0, 1, 600, 2400);
    room = parameters[2];
    damp = parameters[3];
    input = In.ar(bus, ~numberChannels);
    output = FreeVerb2.ar(input[0], input[1], mix: 0.33, room: room, damp: damp);
    output = AnalogVintageDistortion.ar(input, drivegain, bias: 0, lowgain: 0.1, highgain: 0.1, shelvingfreq: shelvingfreq, oversample: 0);
    ReplaceOut.ar(bus, output);
}).add;

SynthDef(\convolution, { |bus, busSide, framesize = 512|
    var mainBus, sideBus, out;
    mainBus = BBandPass.ar(In.ar(bus, ~numberChannels), freq: 1200.0, bw: 3.0);
    sideBus = BLowPass4.ar(In.ar(busSide, ~numberChannels), freq: 1000.0, rq: 1.0);
    out = Convolution.ar(mainBus,sideBus,framesize);
    out = Mix.new(out);
    out = NumChannels.ar(out, numChannels: 2, mixdown: true);
    ReplaceOut.ar(bus, out);
}).add;

//macros
SynthDef(\macroLFO,{ |macroBus|
	var output, amplitude, reference, modulator;
	modulator = SinOsc.kr(\freq.kr(0.1));
	modulator = LinXFade2.kr(-1,modulator,\crossfade.kr(0).linlin(0,1,-1,1));
	reference = \ref.kr(0);
	Out.kr(macroBus,[modulator, reference]);
}).add;

MySynthDef(\macroLine,{ |macroBus|
	var trig, rate, reference, modulator;
	rate = \rate.kr(0);
	trig = Changed.kr(rate);
	modulator = -1+(2*Sweep.kr(trig,rate));
	modulator = modulator.clip(-1,1);
	modulator = LinXFade2.kr(-1,modulator, \crossfade.kr(0).linlin(0,1,-1,1));
	reference = \ref.kr(0);
	Out.kr(macroBus, [modulator, reference]);
}).add.reset({ |synth, clockArg| var clock; clockArg ?? clock = TempoClock.default; synth.set(\rate, 1 / ((clock.nextBar + 16 - clock.beats) / clock.tempo)) });

SynthDef(\riser1,{ |bus|
	var freq, filterFreq, freqs, sin, out, klank, times, lr, ud,par1;
	lr = ServerControlLag.kr(\lr,0.5);
	ud = ServerControlLag.kr(\ud,0.5);
	freq = 440;
	filterFreq = ud.linexp(0,1,20000,440);
	freqs = [0.75, 0.89 ,1]*filterFreq;
	sin = SinOsc.ar(freq);
	out = Pan2.ar(sin);
	out = Hasher.ar(out);
	out =Slew.ar(out,1000,1000);
	klank = out * VolumeFaderCurve.kr(lr.linlin(0,0.5,0.2,0));
	par1 = (lr*ud*16).clip(0,1);
	par1 = Lag.kr(par1,6);
	times = [1,2,1] + ([10,8,6] * par1);
	klank = DynKlank.ar(`[freqs,[0.8, 1, 0.7], times], klank);
	out = out + klank;
	out = RLPF.ar(out,filterFreq,lr.linlin(0.6,1,1,0.02));
    out = out * 5.dbamp;
	Out.ar(bus,out);
}).add;