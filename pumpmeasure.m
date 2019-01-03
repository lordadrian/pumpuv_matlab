function kpaspresmeasured = pumpmeasure(mode, chanMax, HandleNumber)

kpaspresmeasured = zeros(1, chanMax);

if (HandleNumber~=0 && chanMax~=0)
    if mode == 0 %actual mode
        for jj = 1:chanMax
            [pressureValue(jj) Chrono] = mfcs_read_chan(HandleNumber,jj); %  [PressureValue,MeasureTime] = mfcs_read_chan(HandleNumber,ChanNumber)
            pause(0.4)
            kpaspresmeasured(jj) = 10*pressureValue(jj);  %CHK edit; Purpose: unit conversion. mBar -> kpascal
        end
        assignin('base', 'kpaspresmeasured', kpaspresmeasured); %bring measured pressure value to workspace
    else %emulation
        for ii =1:chanMax
            kpaspresmeasured(ii) = 1000; 
        end
        assignin('base', 'kpaspresmeasured' , kpaspresmeasured);
    end
end
end

