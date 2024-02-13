// dummy
"dummy".postln;

// default usage
// server settings
/* s = Server.local;
s.options.maxLogins_(2);
s.options.memSize_(8192*(2**2));
s.options.inDevice_("ASIO : JackRouter");
s.options.outDevice_("ASIO : JackRouter");
s.options.numInputBusChannels_(10);
s.options.numOutputBusChannels_(8); */
(
Routine.run {
	"initialization1.scd".loadRelative;
	s.sync;
	"initialization2.scd".loadRelative;
	s.sync;
	"busses.scd".loadRelative;
	s.sync;
	"synthDefs.scd".loadRelative;
	s.sync;
	"synths.scd".loadRelative;
	s.sync;
	"objects.scd".loadRelative;
	s.sync;
	"vstControllers.scd".loadRelative;
	s.sync;
	"physicalInterfaces.scd".loadRelative;
}
)
//closing
(
 ~musicLibrary.store(Library.at(\musicLibraryPath));
)