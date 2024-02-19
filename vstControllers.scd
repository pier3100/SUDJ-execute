~plugin_name = 'SGA1566';
~vst_plugin = VSTPluginController(~sEffect1);
~vst_plugin.open(~plugin_name, verbose: true);

~vstChannel1 = VSTPluginController(~sChannel1);
~vstChannel1.open("DD DJEQ", verbose: true);

~vstChannel2 = VSTPluginController(~sChannel2);
~vstChannel2.open("DD DJEQ", verbose: true);

~vstChannel3 = VSTPluginController(~sChannel3);
~vstChannel3.open("DD DJEQ", verbose: true);

~vstChannel4 = VSTPluginController(~sChannel4);
~vstChannel4.open("DD DJEQ", verbose: true);