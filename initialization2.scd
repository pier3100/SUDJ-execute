// this content in split from the previous section because we need to wait for the server to load the kernel
Server.default.latency = ((~kernelEncoderSuperStereo.kernelSize - 1)/2 + ~kernelEncoderSuperStereo.kernelSize - Server.default.options.blockSize) / Server.default.sampleRate; // assuming that in a DJdeck BufRd is in sync with the clock (delayed by EncoderKernel), the output of a DJdeck w

// before shutting down
ShutDown.add({ Server.default.quit });
ServerQuit.add({ ~sOutputs.free }); // prevenst noise when shutting down the server
ServerQuit.add({ MidiHidSystem.enabled_(false) });
ServerQuit.add({ ~musicLibrary.store(Library.at(\musicLibraryPath)) });
ServerQuit.add({ "shutting down".log });
ServerQuit.add({ Library.at(\log).close });

//ableton link clock
c = LinkClock.new.latency_(Server.default.latency);

//plc functionality
~mainPLC = PLC.new(1000);