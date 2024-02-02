// load configuration
Library.addFromJSON("C:\\Users\\PierTabak\\Music\\SuperCollider\\Project_rev7\\config.JSON");

// load musicLibrary
~musicLibrary = MusicLibrary.loadFromTraktor(Library.at(\musicLibraryPath), Library.at(\traktorLibraryPath));

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
~speakerDegrees = [-30, 30, -90, 90, -150, 160];
~speakerDbsCorrection = [0, 0, 0, 4, 0, 4]; //In a free field - a doubling of the distance from a noise source reduces the sound pressure level with 6 decibel.
~matrixDecoderMain = FoaDecoderMatrix.newDiametric(~speakerDegrees.degrad, k: 'single')
~matrixDecoderHeads = FoaDecoderMatrix.newStereo;
~kernelEncoderStereo = FoaEncoderKernel.newSuper(2048);
~numberChannels = ~kernelEncoderStereo.numOutputs;

// calculate delay in seconds, and set server latency accordingly
s.latency = ((~encoder.kernelSize-1)/2 + ~encoder.kernelSize - s.options.blockSize) / s.sampleRate; // assuming that in a DJdeck BufRd is in sync with the clock (delayed by EncoderKernel), the output of a DJdeck will be in sync with patterns (delayed by server communication with latency parameter)