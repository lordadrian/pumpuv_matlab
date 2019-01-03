%% NI-daq device discovery / session setting
% Initiated by 'setfile'(handle of pushbutton)

function UVdevdis(mode)

if mode == 0 % Actaul mode
s = daq.createSession('ni') %create session
device = daq.getDevices %discover device
device(1)
s.Rate = 25000; %MAX data scanning rate! scanning rate matters!
addAnalogOutputChannel(s, 'cDAQ3Mod1', 1:5, 'Voltage'); %only channel 1~5 is currently being used. Channels can be adjusted accordingly when differnet NI DAQ's channels are used 

else %emulation mode
    s = 0;
end

assignin('base', 's', s); %save s to workspace

end