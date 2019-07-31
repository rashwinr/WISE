% print JCS angles

clear all, close all, clc
addpath('F:\github\wearable-jacket\matlab\IEEE_sensors');
instrreset
ser = serial('COM15','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);

qLA = [1 0 0 0];
qRA = [1 0 0 0];
qLF = [1 0 0 0];
qRF = [1 0 0 0];
qB = [1 0 0 0];

figure(1)

subplot(2,3,1)
hold on
title('Shoulder plane')
text(0,2,'plane = ')
LApl = text(5,2,'');


subplot(2,3,3)
hold on
title('Shoulder elevation')
text(0,1,'Flex-ext. / adb.-add. = ')
LAel = text(5,1,'');

subplot(2,3,5)
hold on
title('Shoulder Int.-ext. rot.')
text(0,0,'int-ext = ')
LAie = text(5,0,'');

subplot(2,3,2)
hold on
title('LA Mounting offset')
text(0,2,'mounting offset = ')
LFmo = text(5,2,'');

subplot(2,3,4)
hold on
title('Elbow Flex.-Ext.');
LFef = text(5,1,'');

subplot(2,3,6)
hold on
title('Elbow Pro.-sup.');
LFps = text(5,0,'');


figure(2)

subplot(2,3,1)
hold on
title('Shoulder plane')
text(0,2,'plane = ')
RApl = text(5,2,'0');

subplot(2,3,3)
hold on
title('Shoulder elevation')
text(0,1,'Flex-ext. / adb.-add. = ')
RAel = text(5,1,'0');

subplot(2,3,5)
hold on
title('Shoulder Int.-ext. rot.')
text(0,0,'int-ext = ')
RAie = text(5,0,'0');

subplot(2,3,2)
hold on
title('RA Mounting offset')
text(0,2,'mounting offset = ')
RFmo = text(5,2,'0');

subplot(2,3,4)
hold on
title('Elbow Flex.-Ext.');
RFef = text(5,1,'0');

subplot(2,3,6)
hold on
title('Elbow Pro.-sup.');
RFps = text(5,0,'0');


telapsed = 0;




%%

while true
    tic;
    if ser.BytesAvailable
        [qLF,qRF,qLA,qRA,qB] = DataReceive(ser,qLF,qRF,qLA,qRA,qB);
        LA = JCS_isb('LA',qB,qLA);
        LA(3) = LA(1)+LA(3);
        RA = JCS_isb('RA',qB,qRA);
        RA(3) = RA(1)+RA(3);
        LF = JCS_isb('LF',qLA,qLF);
        RF = JCS_isb('RF',qRA,qRF);
        
        figure(1)
        delete([LApl,LAel,LAie,LFmo,LFef,LFps,RFmo,RFef,RFps])
        
        subplot(2,3,1)
        LApl = text(5,2,num2str(LA(1)*180/pi));
        LAel = text(5,1,num2str(LA(2)*180/pi));
        LAie = text(5,0,num2str(LA(3)*180/pi));
        
        subplot(2,3,3)
        LFmo = text(5,2,num2str(LF(2)*180/pi));
        LFef = text(5,1,num2str(LF(1)*180/pi));
        LFps = text(5,0,num2str(LF(3)*180/pi));
        
        subplot(2,3,2)
        RApl = text(5,2,num2str(RA(1)*180/pi));
        RAel = text(5,1,num2str(RA(2)*180/pi));
        RAie = text(5,0,num2str(RA(3)*180/pi));
        
        subplot(2,3,4)
        RFmo = text(5,2,num2str(RF(2)*180/pi));
        RFef = text(5,1,num2str(RF(1)*180/pi));
        RFps = text(5,0,num2str(RF(3)*180/pi));
        
        
        
        RApl,RAel,RAie,
    end
    
    telapsed = toc+telapsed;
    
end