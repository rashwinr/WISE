% print JCS angles

clear all, close all, clc

instrreset
ser = serial('COM11','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);

qA = [1 0 0 0];
qB = [1 0 0 0];
qC = [1 0 0 0];
qD = [1 0 0 0];
qE = [1 0 0 0];

figure(1)

subplot(2,2,1)
hold on
xlim([0 10])
ylim([-1 3])
title('left arm')
text(0,2,'abd-add = ')
text(0,1,'ext-flex = ')
text(0,0,'int-ext = ')

LAbd = text(5,2,'');
LAef = text(5,1,'');
LAie = text(5,0,'');

subplot(2,2,3)
hold on
xlim([0 10])
ylim([-1 3])
title('left forearm')
text(0,2,'mounting offset = ')
text(0,1,'ext-flex = ')
text(0,0,'pro-sup = ')

LFmo = text(5,2,'');
LFef = text(5,1,'');
LFps = text(5,0,'');

subplot(2,2,2)
hold on
xlim([0 10])
ylim([-1 3])
title('right arm')
text(0,2,'abd-add = ')
text(0,1,'ext-flex = ')
text(0,0,'int-ext = ')

RAbd = text(5,2,'');
RAef = text(5,1,'');
RAie = text(5,0,'');

subplot(2,2,4)
hold on
xlim([0 10])
ylim([-1 3])
title('right forearm')
text(0,2,'mounting offset = ')
text(0,1,'ext-flex = ')
text(0,0,'pro-sup = ')

RFmo = text(5,2,'');
RFef = text(5,1,'');
RFps = text(5,0,'');

%%

while true
    if ser.BytesAvailable
        [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE);
        LA = JCS('LA',qE,qC);
        LF = JCS('LF',qC,qA);
        RA = JCS('RA',qE,qD);
        RF = JCS('RF',qD,qB);
        
        figure(1)
        delete([LAbd,LAef,LAie,RAbd,RAef,RAie,LFmo,LFef,LFps,RFmo,RFef,RFps])
        
        subplot(2,2,1)
        LAbd = text(5,2,num2str(LA(1)*180/pi));
        LAef = text(5,1,num2str(LA(2)*180/pi));
        LAie = text(5,0,num2str(LA(3)*180/pi));
        
        subplot(2,2,3)
        LFmo = text(5,2,num2str(LF(2)*180/pi));
        LFef = text(5,1,num2str(LF(1)*180/pi));
        LFps = text(5,0,num2str(LF(3)*180/pi));
        
        subplot(2,2,2)
        RAbd = text(5,2,num2str(RA(1)*180/pi));
        RAef = text(5,1,num2str(RA(2)*180/pi));
        RAie = text(5,0,num2str(RA(3)*180/pi));
        
        subplot(2,2,4)
        RFmo = text(5,2,num2str(RF(2)*180/pi));
        RFef = text(5,1,num2str(RF(1)*180/pi));
        RFps = text(5,0,num2str(RF(3)*180/pi));
        
    end
end