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

subplot(2,2,1)
hold on
xlim([0 10])
ylim([-1 3])
title('left arm')
text(0,2,'plane = ')
text(0,1,'elevation = ')
text(0,0,'int-ext = ')

LApl = text(5,2,'');
LAel = text(5,1,'');
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
text(0,2,'plane = ')
text(0,1,'elevation = ')
text(0,0,'int-ext = ')

RApl = text(5,2,'');
RAel = text(5,1,'');
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
        [qLF,qRF,qLA,qRA,qB] = DataReceive(ser,qLF,qRF,qLA,qRA,qB);
        
        LA = JCS_isb('LA',qB,qLA);
        LA(3) = LA(1)+LA(3);
%         if LA(3)>pi
%             LA(3) = 2*pi-LA(3);
%         elseif LA(3)<-pi
%             LA(3) = 2*pi+LA(3);
%         end

        RA = JCS_isb('RA',qB,qRA);
        RA(3) = RA(1)+RA(3);
%         if RA(3)>pi
%             RA(3) = 2*pi-RA(3);
%         elseif RA(3)<-pi
%             RA(3) = 2*pi+RA(3);
%         end
        
        LF = JCS_isb('LF',qLA,qLF);
        
        RF = JCS_isb('RF',qRA,qRF);
        
        figure(1)
        delete([LApl,LAel,LAie,RApl,RAel,RAie,LFmo,LFef,LFps,RFmo,RFef,RFps])
        
        subplot(2,2,1)
        LApl = text(5,2,num2str(LA(1)*180/pi));
        LAel = text(5,1,num2str(LA(2)*180/pi));
        LAie = text(5,0,num2str(LA(3)*180/pi));
        
        subplot(2,2,3)
        LFmo = text(5,2,num2str(LF(2)*180/pi));
        LFef = text(5,1,num2str(LF(1)*180/pi));
        LFps = text(5,0,num2str(LF(3)*180/pi));
        
        subplot(2,2,2)
        RApl = text(5,2,num2str(RA(1)*180/pi));
        RAel = text(5,1,num2str(RA(2)*180/pi));
        RAie = text(5,0,num2str(RA(3)*180/pi));
        
        subplot(2,2,4)
        RFmo = text(5,2,num2str(RF(2)*180/pi));
        RFef = text(5,1,num2str(RF(1)*180/pi));
        RFps = text(5,0,num2str(RF(3)*180/pi));
        
    end
end