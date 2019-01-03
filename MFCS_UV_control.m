%%
% This code contains GUIDE callbacks to control MFCS & UV 
%%
%% Version History
%% 3.7
%% 1. Remove Unused comments
%% 2. Issue: cannot update the variable value while running the function

function varargout = MFCS_UV_control(varargin)
% MFCS_UV_control MATLAB code for MFCS_UV_control.fig
%      MFCS_UV_control, by itself, creates topBorder new MFCS_UV_control or raises the existing
%      singleton*.
%
%      H = MFCS_UV_control returns the handle to topBorder new MFCS_UV_control or the handle to
%      the existing singleton*.
%
%      MFCS_UV_control('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MFCS_UV_control.M with the given input arguments.
%
%      MFCS_UV_control('Property','Value',...) creates topBorder new MFCS_UV_control or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MFCS_UV_control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MFCS_UV_control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MFCS_UV_control

% Last Modified by GUIDE v2.5 02-Jan-2019 22:27:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MFCS_UV_control_OpeningFcn, ...
    'gui_OutputFcn',  @MFCS_UV_control_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT


%% CHK edit start 2018.12.27
%Made changes: move states to the main function from each callback
%functions

% make string array 
%readchan1 ~ 8
a = cell(1, 8);
for ii = 1: 8
s = {['readChan' int2str(ii)]};
a(ii) = s;
end
str_readChan = string(a); %change to string array
assignin('base', 'str_readChan', str_readChan);
%setChan1 ~ 8
c = cell(1, 8);
for jj = 1: 8
d = {['setChan' int2str(jj)]};
c(jj) = d;
end
str_setChan = string(c); %change to string array
assignin('base', 'str_setChan', str_setChan);
% make string array end

%fixed value
output_data = 5; %UV turn on voltage, 5V
output_data_off = 0; %UV turn on voltage, 0V 


%call in setfile from Workspace 
%triggers functions
setfile = evalin('base', 'setfile');
seqon = evalin('base', 'seqon');
Break1 = evalin('base', 'Break');
% measure = evalin('base', 'measure');
close1 = evalin('base', 'close');

% <handle in workspace> = findobj('tag', '<GUI object name>');
%finds handles of objects that have specified property
%could not use 'handles.Name'. 'handles' is not a defined vairable in main function 
gh_statetext = findobj('tag', 'statetext'); %display of text in 'statetext' textbox
gh_serialText = findobj('tag', 'serialText');
gh_handleText = findobj('tag', 'handleText');
gh_closeButton = findobj('tag', 'closeButton');
gh_setButton = findobj('tag', 'setButton'); 
gh_measureButton = findobj('tag', 'measureButton');
gh_break = findobj('tag', 'Break');
gh_modeselect = findobj('tag', 'modeselect');
gh_setfile = findobj('tag', 'setfile'); 
gh_setflow = findobj('tag', 'setflow');
gh_setstop = findobj('tag', 'setstop');
gh_setexposure = findobj('tag', 'setexposure');
gh_sethold = findobj('tag', 'sethold');
gh_setalpha = findobj('tag', 'setalpha');
gh_iteration = findobj('tag', 'iteration');



%% Extract 'string' handle from edittext into double form
%1) get('variable', 'string')
% 2) strsplit('var', ',') %to split ' ' from string 
% 3)str2double(cell2mat(var)) %change into double form

%recieve flowtime in mili-second
strgh_setflow = num2str(get(gh_setflow, 'String'));
assignin('base', 'strgh_setflow', strgh_setflow);
cstr_setflow = strsplit(strgh_setflow, ',');
msFlowtime = str2double(cell2mat(cstr_setflow));
assignin('base', 'msFlowtime', msFlowtime);
%receive stoptime in mili-second
strgh_setstop = num2str(get(gh_setstop, 'String'));
cstr_setstop = strsplit(strgh_setstop, ',');
msStoptime = str2double(cell2mat(cstr_setstop));
assignin('base', 'msStoptime', msStoptime);
%receive exposuretime in mili-second
strgh_setexposure = num2str(get(gh_setexposure, 'String'));
cstr_setexposure = strsplit(strgh_setexposure, ',');
msExposuretime = str2double(cell2mat(cstr_setexposure));
assignin('base', 'msExposuretime', msExposuretime);
%receive holdtime in mili-second
strgh_sethold = num2str(get(gh_sethold, 'String'));
cstr_sethold = strsplit(strgh_sethold, ',');
msHoldtime = str2double(cell2mat(cstr_sethold));
assignin('base', 'msHoldtime', msHoldtime);
%receive alphavalue
strgh_setalpha = num2str(get(gh_setalpha, 'String'));
cstr_setalpha = strsplit(strgh_setalpha, ',');
AlphaValue = str2double(cell2mat(cstr_setalpha));
assignin('base', 'AlphaValue', AlphaValue);
%receive number of iteration
strgh_iteration = num2str(get(gh_iteration, 'String'));
cstr_iteration= strsplit(strgh_iteration, ',');
iterationval = str2double(cell2mat(cstr_iteration));
assignin('base', 'iterationval', iterationval);
%% Extract handles 'string' end


%% from 'setfile' call back 2018. 12. 27

% Begin init action by setting serialText and initButton disabled

set(gh_serialText,'Enable','off')
set(gh_closeButton,'Enable','off')
set(gh_setButton,'Enable','off')
set(gh_measureButton,'Enable','off')
set(gh_break,'Enable','off')


%only run when 'push first' is pushed
if setfile == 1

    %load MFCS, UV files
    loadPdevdis = fopen('Pdevdis.m');
    loadUVdevdis = fopen('UVdevdis.m');
    loadpumpseq = fopen('pumpseq_mock.m');
    loadUVseq = fopen('UVseq.m');
    loadpumpclose = fopen('pumpclose.m');
    loadpumpmeasure = fopen('pumpmeausre.m');  %CHK edit 2018.12.27
    
    %% Receive modeselect from popup menu
    % modeselect = 1 : actual
    % modeselect = 0 : emulation
    modeselect = get(gh_modeselect, 'Value');
    assignin('base', 'modeselect', modeselect);
    
    if modeselect == 1 %actual
        mode = 0;
    else %modeselect = 2 emualtion
        mode = 1;
    end
    
    %%
    
    Pdevdis(mode); % run MFCS device discovery
    UVdevdis(mode); % run UV device discovery and create session
    % exports to work space from Pdevdis & UVdevdis
    SerialNumber = evalin('base', 'SerialNumber');
    HandleNumber = evalin('base', 'HandleNumber');
           
    if modeselect == 1 %actual
        chanMax = mfcs_chan_number(HandleNumber); %get maximum channe number (8)
    else %modeselect = 2 emualtion
        chanMax = 8;
    end
    assignin('base', 'chanMax', chanMax);

    if isempty(loadPdevdis) && isempty(loadUVdevdis) && isempty(loadpumpseq) && isempty(loadUVseq) && isempty(loadpumpclose) &&isempty(loadpumpmeasure)
        set(gh_statetext, 'String', 'MFCS & UV file load fail. Check all the files are ready to load.')
    else
        set(gh_statetext, 'String', 'MFCS & UV file loaded')
    end

    set(gh_serialText, 'String', SerialNumber)
    set(gh_handleText, 'String', HandleNumber)

    %Enable all other switches
    set(gh_closeButton,'Enable','on')
    set(gh_setButton,'Enable','on')
    set(gh_measureButton,'Enable','on')
    set(gh_break,'Enable','on')
    seq_ready = 1;
else
   % Block from advancing to next step.
   seq_ready = 0;
end
% from setfile callback end


%% from 'setbutton' callback
if (seqon == 1 && seq_ready == 1)
    
    %set initial condition
    set(gh_setfile,'Enable','off')
        
    %% Setting variable : LOCK at Running
    
    % call in session 's' for UV control
    s = evalin('base', 's');
    PressureNotEmpty = 0;
    
    
    %lock the edittext
    set(gh_setflow, 'Enable', 'off')
    set(gh_setstop, 'Enable', 'off')
    set(gh_setalpha, 'Enable', 'off')
    set(gh_setexposure, 'Enable', 'off')
    set(gh_sethold, 'Enable', 'off')
    
    
    %preallocating for 'for loop'
    kpaspressure = zeros(1, chanMax);

    for ii=1:chanMax
        gh_setChan = findobj('tag', str_setChan(ii));
        kpaspressure(ii) = str2double(char(get(gh_setChan, 'String')));
        
        if isempty(kpaspressure(ii)) %verify numeric pressure value presence.
            warndlg('pressure input number must be non void and numeric');
        end
        PressureNotEmpty = 1;
    end
    assignin('base', 'kpaspressure', kpaspressure); % send user's input to workspace
    
    
    %recieve data from text edit
    %set pressure for channel 1~8
    
    if ((HandleNumber ~=0) && (PressureNotEmpty == 1))
        %Normal state
        % Main loop
        if Break1 == 0 && iterationval ~= 0
            for kk = 1:iterationval
                %test
                Break1 = get(gh_break, 'Value')
                kk
                drawnow % update Break1 to evaluate 'if' condition
                % to break out of loop
                if (seqon == 0) || (Break1 == 1)
                    set(gh_statetext, 'String', 'Sequence stopped by the user!')
                    break
                end
                %normal
                str = convertCharsToStrings(sprintf('%s_%d/%d','Sequence running:',kk,iterationval));
                set(gh_statetext, 'String', str)
                pumpseq(HandleNumber, AlphaValue, msFlowtime, msStoptime, msExposuretime, msHoldtime, kpaspressure, chanMax, mode)
                UVseq(mode, msFlowtime, msStoptime, msExposuretime, msHoldtime, s, output_data, output_data_off)
            end
            set(gh_statetext, 'String', 'End of sequence')
            %test: to fix the Break1 to 1 to avoid from going back into the
            %for loop
            disp('out from for loop')
            Break1 = 1
            seqon = 0
            refreshdata(seqon, 'base')
            %test end
        elseif Break1 == 0 && iterationval == 0
            while Break1 == 0
                Break1 = evalin('base', 'Break');
                set(gh_iteration, 'String', 'Infinite')
                set(gh_statetext, 'String', 'Sequence Start! ')
                pumpseq(HandleNumber, AlphaValue, msFlowtime, msStoptime, msExposuretime, msHoldtime, kpaspressure, chanMax, mode)
                UVseq(mode, msFlowtime, msStoptime, msExposuretime, msHoldtime, s, output_data, output_data_off)
                % to break out of while loop
                if Break1 == 1
                    Break1 = 1;
                    break
                end
            end
        else
%             return
        end
        % from 'setButton' callback end. CHK edit end
    elseif seqon == 1 && seq_ready == 0
        warndlg('Intialize First :)');
    else
        % nothing
    end
    %% end of 'setButton' callback
    
    %% PUMPMEASURE process start
    if HandleNumber ~= 0
        
        measure = get(gh_measureButton, 'Value');
        assignin('base', 'measure', measure);
        if (measure == 1) && (HandleNumber ~=0) && (Break1 == 0)
            while measure == 1
                pumpmeasure(mode, chanMax, HandleNumber); % receive measured value
                kpaspresmeasured = evalin('base', 'kpaspresmeasured'); %call back kpaspresmeasured from workspace
                set(gh_measureButton, 'String', 'Measuring');
                set(gh_statetext, 'String', 'MFCS pressure measuring');
                %call in all the handles from readChan edittext and extract the
                %'string'
                for ii = 1: chanMax
                    gh_readChan = findobj('tag', str_readChan(ii));
                    set(gh_readChan, 'String', kpaspresmeasured(ii)); %extract only the string
                end
                if Break1 == 1
                    break
                end
            end
        elseif measure == 1 && HandleNumber == 0
            warndlg('No HandlesNumber has been found. \n 1) Check device connection \n 2) Initialize again');
        else
            set(gh_measureButton,'String', 'Start Measure');
        end
    end
    %% pumpmeasure process end
    
    %% DEVICE CONNECTION CLOSE process start

    if (close1 == 1) && (HandleNumber ~= 0)
        %test to see if it come pass 'if'
        disp('works')
        %
        % disable all the buttons
        set(gh_setfile,'Enable','off')
        set(gh_setButton,'Enable','off')
        set(gh_closeButton,'Enable','off')
        set(gh_break,'Enable','off')
        set(gh_measureButton,'Enable','off','value',0,'String','Start Measure')
        %
        try
            pumpclose(mode, HandleNumber); %terminate pump connection
            set(gh_handleText,'Enable', 'Off', 'string','-')
            set(gh_serialText, 'Enable', 'Off','string','-')
            set(gh_measureButton,'Enable','off','value',0,'String','Start Measure')
        catch err
            errString = getReport(err,'basic','hyperlinks','off');
            warndlg(strcat('Error ocurred when closing MFCS connection : ', errString));
        end
        
        %check if the connection is terminatied or not
        if HandleNumber ~=0
            warndlg('Connection not terminated. Try it again.');
        else
            %nothing
        end
           
    end
end
%% device connection close process end



end % end of main function





%
% --- Executes just before MFCS_UV_control is made visible.
function MFCS_UV_control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in topBorder future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MFCS_UV_control (see VARARGIN)

% Define Initial GUI state
set(handles.serialText, 'Enable', 'Off');
set(handles.handleText, 'Enable', 'Off');
set(handles.serialText, 'String', '0');
set(handles.serialText, 'String', '0');

%initialize variables & update to workspace 
setfile = 0;
assignin('base', 'setfile', setfile);
seqon = 0;
assignin('base', 'seqon', seqon);
Break = 0;
assignin('base', 'Break', Break);
measure = 0;
assignin('base', 'measure', measure);
close = 0;
assignin('base', 'close', close);


% MFCS defined start
% Update handles structure
% Store handles to textfields in an array to access it in an easy way later
readChan(1) = handles.readChan1;
readChan(2) = handles.readChan2;
readChan(3) = handles.readChan3;
readChan(4) = handles.readChan4;
readChan(5) = handles.readChan5;
readChan(6) = handles.readChan6;
readChan(7) = handles.readChan7;
readChan(8) = handles.readChan8;
handles.readChan = readChan;
% MFCS defined end

% CHK defined start
% Recieving input in kpascal 
kpaspressure(1) = handles.setChan1;
kpaspressure(2) = handles.setChan2;
kpaspressure(3) = handles.setChan3;
kpaspressure(4) = handles.setChan4;
kpaspressure(5) = handles.setChan5;
kpaspressure(6) = handles.setChan6;
kpaspressure(7) = handles.setChan7;
kpaspressure(8) = handles.setChan8;
handles.setChan = kpaspressure;

%initialize setChan value
kpaspressure = zeros(1, 8);
for ii = 1:8
kpaspressure(ii) = str2double(char(get(handles.setChan(ii), 'String')));
end
assignin('base', 'kpaspressure', kpaspressure);
%

% CHK defined end



% Choose default command line output for MFCS_UV_control
handles.output = hObject;

%save handles structure
guidata(hObject, handles);% Update handles structure
%
% UIWAIT makes MFCS_UV_control wait for user response (see UIRESUME)
% uiwait(handles.figure1);
 
end



% --- Outputs from this function are returned to the command line.
function varargout = MFCS_UV_control_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in topBorder future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end



%% --- Executes on button press in setfile.
%% CHK edit 2018. 12. 19
%Purpose: open all related files Pump: device discovery, UV: device discovery, open session and
%output channel
%MUST be pressed first
function setfile_Callback(hObject, eventdata, handles)
% hObject    handle to setfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% setfile_local = 0;
% if get(hObject, 'Value')
% setfile_local =1;
% end
setfile = 1;
assignin('base', 'setfile', setfile);

end



% --- Executes on button press in setButton.
function setButton_Callback(hObject, eventdata, handles)
% hObject    handle to setButton (see GCBO)
% eventdata  reserved - to be defined in topBorder future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.Break, 'userdata', 0);
seqon = 1;
assignin('base', 'seqon', seqon);
% waitfor(handles.Break, 'value');
% seqon = 0;
% assignin('base', 'seqon', seqon);
% h = evalin('base', 'h');
% if h 
%     seqon = 0;
%     assignin('base', 'seqon', seqon);
% else
%     seqon = 1;
%     assignin('base', 'seqon', seqon);
% end
%bring in maximum channel value
% chanMax = evalin('base', 'chanMax');

% CHK defined end

%% Receieve user's requested pressureValue

% for ii = 1: chanMax
%     kpaspressure = get(handles.setChan(ii),'String');
%     
% end


% assignin('base', 'kpaspressure', kpaspressure);
end





%% CHK edit: Purpose: call in measure function from seperate file
%Last edit: 2018. 12. 27
% --- Executes on button press in measurebutton.
function measureButton_Callback(hObject, eventdata, handles)
% hObject    handle to measurebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end




% --- Executes on button press in closeButton.
function closeButton_Callback(hObject, eventdata, handles)
% hObject    handle to closeButton (see GCBO)
% eventdata  reserved - to be defined in topBorder future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close = 1;
assignin('base', 'close', close);

end





% % --- Executes when user attempts to close figure1.
% function figure1_CloseRequestFcn(hObject, eventdata, handles)
% % hObject    handle to figure1 (see GCBO)
% % eventdata  reserved - to be defined in topBorder future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% %
% try
%     set(handles.setButton,'Enable','off')
%     set(handles.closeButton,'Enable','off')
%     set(handles.measurebutton,'Enable','off','value',0,'String','Start Measure')
%     %
%     if (handles.HandleNumber~=0)
%         try
%             mfcs_close(handles.HandleNumber);
%             % Hint: delete(hObject) closes the figure
%             delete(hObject);
%         catch err % if error occured, display a warning box.
%             errString = getReport(err,'basic','hyperlinks','off');
%             warndlg(strcat('Error ocurred when initializing : ', errString));
%             %ensure giving the handle to the user in the comand window, before
%             %closing the window3
%             warning('MFCS_UV_control:ErrorWhenWindowClosure',...
%                 ['Error  occured when closing the Window!'...
%                 'Handle value of the unclosed MFCS connection : ' num2str(handles.HandleNumber)]);
%             delete(hObject);
%         end
%     else
%         % Hint: delete(hObject) closes the figure
%         delete(hObject);
%     end
% catch err % if error occured, display a warning box.
%     delete(hObject);
%     errString = getReport(err,'basic','hyperlinks','off');
%     warndlg(strcat('Error ocurred when initializing : ', errString));
%     %ensure giving the handle to the user in the comand window, before
%     %closing the window3
%     warning('MFCS_UV_control:ErrorWhenWindowClosure',...
%         ['Error  occured when closing the Window!'...
%         'Handle value of the unclosed MFCS connection : ' num2str(handles.HandleNumber)]);
% end
%
%
%


% --- Executes on button press in Break.
function Break_Callback(hObject, eventdata, handles)
% hObject    handle to Break (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
% Break = get(handles.Break, 'userdata');
% assignin('base', 'Break', Break);
% set(handles.Break, 'userdata', 1)
% h = get(hObject, 'userdata');
% seqon = 3;
% assignin('base', 'seqon', seqon);
% h = get(hObject, 'value');
% assignin('base', 'h', h);
% seqon = 0
% assignin('base', 'seqon', seqon);

end
