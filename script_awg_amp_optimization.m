clear;close all;

osa = Advantest_OSA(2,18);
awg = KeysightAWG();

ampVec = 0.49:0.002:0.52;

for idx = 1:length(ampVec)
    % set the amp of awg
    awg.SetAmp(1,ampVec(idx));
    % single for osa
    osa.Single();
    % read the cursor info
    cursorInfo = osa.Get_Cursor_Info();
    % save the delta lambda
    pr(idx) = cursorInfo.dlevel;
    % print the info to screen
    fprintf('amp = %fmV, power ratio = %fdB\n',ampVec(idx)*1000,pr(idx));
end

osa.delete();
awg.delete();
