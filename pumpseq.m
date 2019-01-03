%% MFCS sequencial action.
% Sequence : 1) Pressure applied for 'flowtime'
%            2) Pressure off for 'offtime = stoptime+exposuretime+holdtime'
function pumpseq(HandleNumber, AlphaValue, msFlowtime, msStoptime, msExposuretime, msHoldtime, kpaspressure, chanMax, mode)

%Unit conversion
pressure = kpaspressure/10; %unit: mBar
Flowtime = msFlowtime/1e3; %pressure on, UV off / unit:second
Stoptime = msStoptime/1e3; %pressure off, UV off / unit:second
Exposuretime = msExposuretime/1e3; %pressure off, UV on / unit:second
Holdtime = msHoldtime/1e3; %pressure off, UV off / unit:second
%

Offtime = Stoptime + Exposuretime + Holdtime; % pump turned off time

if mode==0
    if HandleNumber ~= 0
        
        %Pressure is applied for Flowtime
        flowtimestart = clock;
        
        while etime(clock, flowtimestart) < Flowtime
            for i=1:chanMax
                mfcs_set_auto(HandleNumber,pressure(i),i,AlphaValue);
                disp('Flowtime: mfcs_set_auto running', pressure)
                pflow = 1;
                assignin('base', 'pflow', pflow);
            end
        end
        pflow = 0;
        assignin('base', 'pflow', pflow);
        
        %Pressure off
        offtimestart = clock;
        
        while etime(clock, offtimestart) < Offtime
            mfcs_set_auto(HandleNumber,0,0,AlphaValue);
            disp('Stoptime: pressure off')
            poff = 1;
            assignin('base', 'poff', poff);
        end
        poff = 0;
        assignin('base', 'poff', poff);
    end
    
else
    if HandleNumber ~= 0
        disp('flowtime start')
        flowtimestart = clock;
        while etime(clock, flowtimestart) < Flowtime
            for i=1:chanMax
                pflow = 1;
                assignin('base', 'pflow', pflow);
            end
        end
        pflow = 0;
        assignin('base', 'pflow', pflow);
        
        %Pressure off
        disp('pressure off')
        offtimestart = clock;
        
        while etime(clock, offtimestart) < Offtime
            poff = 1;
            assignin('base', 'poff', poff);
        end
        poff = 0;
        assignin('base', 'poff', poff);
    end
end
end