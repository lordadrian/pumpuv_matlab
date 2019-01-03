%% To terminate MFCS connection.
% MUST BE DONE WHEN CLOSING MATLAB


function pumpclose(mode, HandleNumber)

if (HandleNumber ~= 0 && mode == 0)
    %actual mode
    mfcs_close(HandleNumber, 'CloseLib')
    
    Pclose = 1;
    HandleNumber = 0; %reset HandleNumber to terminate connection
    SerialNumber = 0;
    
    
    assignin('base', 'Pclose', Pclose);
    assignin('base', 'HandleNumber', HandleNumber); %bring HandleNumber to workspace
    assignin('base', 'SerialNumber', SerialNumber);
    
elseif (HandleNumber ~= 0 && mode == 1)
    % Mock MFCS connection termination
    disp('MFCS connection terminated')
    Pclose = 1;
    HandleNumber = 0; %reset HandleNumber to terminate connection
    SerialNumber = 0;
    
    
    assignin('base', 'Pclose', Pclose);
    assignin('base', 'HandleNumber', HandleNumber); %bring HandleNumber to workspace
    assignin('base', 'SerialNumber', SerialNumber);
    
else
    warndlg('Connection cannot be terminated: \n 1) no connection has ever been found \n 2) connections has already been terminated');
end

end