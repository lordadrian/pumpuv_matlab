%% MFCS(Pump) device discovery

function Pdevdis(mode) 

clear HandleNumber SerialNumber

if mode == 0 %Actual mode

    try
[HandleNumber SerialNumber] = mfcs_init; %initialize USB connection/ return: handle (0: no USB connection, null:no MFCS detected)
SerialNumber= mfcs_detect; %get serial number
    catch
        if isempty(HandleNumber)
        warndlg('Check the device connection');
        end
    end
    
else %Emulation mode 
    
HandleNumber = 1000;
SerialNumber = 2000;

end

assignin('base', 'HandleNumber', HandleNumber); %bring HandleNumber to workspace
assignin('base', 'SerialNumber', SerialNumber);

end