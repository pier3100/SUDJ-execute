~plugin_name = 'SGA1566';
~vst_plugin = VSTPluginController(~sEffect1);
~vst_plugin.open(~plugin_name);

~vstChannel1 = VSTPluginController.collect(~sChannel1);
~vstChannel1.do({|item| item.open("DD DJEQ") });

~vstChannel2 = VSTPluginController.collect(~sChannel2);
~vstChannel2.do({|item| item.open("DD DJEQ") });

~vstChannel3 = VSTPluginController.collect(~sChannel3);
~vstChannel3.do({|item| item.open("DD DJEQ") });

~vstChannel4 = VSTPluginController.collect(~sChannel4);
~vstChannel4.do({|item| item.open("DD DJEQ") });