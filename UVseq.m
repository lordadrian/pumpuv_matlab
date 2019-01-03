%% UV sequencial action.
% Sequence: 1) UV delay(off) for 'Delaytime = flowtime+stoptime'
%           2)Turn UV on (msec) for 'Exposuretime'
%           3) Turn UV off (set delay between UV and Pump)


function UVseq(mode, msFlowtime, msStoptime, msExposuretime, msHoldtime, s, output_data, output_data_off)

%Unit conversion
Flowtime = msFlowtime/1e3; %pressure on, UV off / unit:second
Stoptime = msStoptime/1e3; %pressure off, UV off / unit:second
Exposuretime = msExposuretime/1e3; %pressure off, UV on / unit:second
Holdtime = msHoldtime/1e3; %pressure off, UV off / unit:second

Delaytime = Flowtime + Stoptime; % UV not yet turned on time

if mode ==0 %Actaul mode
    %delay for UV (during flowtime & stoptime)
    delaystart = clock;
    while etime(clock, delaystart) < Delaytime
        UVdelay = 1;
        assignin('base', 'UVdelay', UVdelay);
        queueOutputData(s, [output_data_off, output_data_off, output_data_off, output_data_off, output_data_off]);
        s.startForeground();
    end
    UVdelay = 0;
    assignin('base', 'UVdelay', UVdelay);
    
    
    %output_data(5V) is output for 'Exposuretime'
    exposuretimestart = clock;
    while etime(clock, exposuretimestart) < Exposuretime
        UVexposure = 1;
        assignin('base', 'UVexposure', UVexposure);
        queueOutputData(s, [output_data, output_data, output_data, output_data, output_data]); %5V is output of NI DAQ channel 1~5
        s.startForeground();
    end
    UVexposure = 0;
    assignin('base', 'UVexposure', UVexposure);
    
    
    %output_data_off(0V) is output for 'Holdtime' (UV off)
    holdtimestart = clock;
    while etime(clock, holdtimestart) < Holdtime
        UVhold = 1;
        assignin('base', 'UVhold', UVhold);
        queueOutputData(s, [output_data_off, output_data_off, output_data_off, output_data_off, output_data_off]);
        s.startForeground();
    end
    UVhold = 0;
    assignin('base', 'UVhold', UVhold);
    
else %Emulation mode
    %delay for UV (during flowtime & stoptime)
    delaystart = clock;
    disp('UV off')
    while etime(clock, delaystart) < Delaytime
        UVdelay = 1;
        assignin('base', 'UVdelay', UVdelay);
    end
    UVdelay = 0;
    assignin('base', 'UVdelay', UVdelay);
    
    
    %output_data(5V) is output for 'Exposuretime'
    disp('Exposretime')
    exposuretimestart = clock;
    while etime(clock, exposuretimestart) < Exposuretime
        UVexposure = 1;
        assignin('base', 'UVexposure', UVexposure);
    end
    UVexposure = 0;
%     disp(UVexposure)
    assignin('base', 'UVexposure', UVexposure);
    
    
    %output_data_off(0V) is output for 'Holdtime' (UV off)
    disp('holdtime start')
    holdtimestart = clock;
    while etime(clock, holdtimestart) < Holdtime
        UVhold = 1;
        assignin('base', 'UVhold', UVhold);
    end
    UVhold = 0;
    assignin('base', 'UVhold', UVhold);
end
