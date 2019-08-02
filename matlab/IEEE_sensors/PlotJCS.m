% print JCS angles

clear all, close all, clc
addpath('F:\github\wearable-jacket\matlab\IEEE_sensors');
instrreset
ser = serial('COM15','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);

telapsed = 0;
LF = [0,0,0];
LA = [0,0,0];

RF = [0,0,0];
RA = [0,0,0];
qLA = [1 0 0 0];
qRA = [1 0 0 0];
qLF = [1 0 0 0];
qRF = [1 0 0 0];
qB = [1 0 0 0];

figure(1)
set( figure(1) , 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
hold on
Tl = sgtitle('Left arm');
subplot(3,2,1)
hold on
title('Shoulder plane')
% text(0,2,'plane = ')
LApl = text(telapsed,LA(1),'0');
alplane = animatedline(telapsed,LA(1),'Color','r');

subplot(3,2,3)
hold on
title('Shoulder elevation')
% text(0,1,'Flex-ext. / adb.-add. = ')
LAel = text(telapsed,LA(2),'0');
alelev = animatedline(telapsed,LA(2),'Color','r');

subplot(3,2,5)
hold on
title('Shoulder Int.-ext. rot.')
% text(0,0,'int-ext = ')
LAie = text(telapsed,LA(3),'0');
alie = animatedline(telapsed,LA(3),'Color','r');

subplot(3,2,2)
hold on
title('LA Mounting offset')
% text(0,2,'mounting offset = ')
LFmo = text(telapsed,LF(1),'0');
almo = animatedline(telapsed,LF(1),'Color','r');

subplot(3,2,4)
hold on
title('Elbow Flex.-Ext.');
LFef = text(telapsed,LF(2),'0');
alef = animatedline(telapsed,LF(2),'Color','r');

subplot(3,2,6)
hold on
title('Elbow Pro.-sup.');
LFps = text(telapsed,LF(3),'0');
alps = animatedline(telapsed,LF(3),'Color','r');

figure(2)
set( figure(2) , 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
hold on
Tr = sgtitle('Right arm');
subplot(3,2,1)
hold on
title('Shoulder plane')
% text(0,2,'plane = ')
RApl = text(telapsed,RA(1),'0');
arplane = animatedline(telapsed,RA(1),'Color','b');

subplot(3,2,3)
hold on
title('Shoulder elevation')
% text(0,1,'Flex-ext. / adb.-add. = ')
RAel = text(telapsed,RA(2),'0');
arelev = animatedline(telapsed,RA(2),'Color','b');

subplot(3,2,5)
hold on
title('Shoulder Int.-ext. rot.')
% text(0,0,'int-ext = ')
RAie = text(telapsed,RA(3),'0');
arie = animatedline(telapsed,RA(3),'Color','b');

subplot(3,2,2)
hold on
title('RA Mounting offset')
% text(0,2,'mounting offset = ')
RFmo = text(telapsed,RF(1),'0');
armo = animatedline(telapsed,RF(1),'Color','b');

subplot(3,2,4)
hold on
title('Elbow Flex.-Ext.');
RFef = text(telapsed,RF(2),'0');
aref = animatedline(telapsed,RF(2),'Color','b');

subplot(3,2,6)
hold on
title('Elbow Pro.-sup.');
RFps = text(telapsed,RF(3),'0');
arps = animatedline(telapsed,RF(3),'Color','b');
k=[];


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
        LA = LA*180/pi;
        RA = RA*180/pi;
        LF = LF*180/pi;
        RF = RF*180/pi;        
    end
        figure(1)
        delete([LApl,LAel,LAie,LFmo,LFef,LFps,])
        
        subplot(3,2,1)
        LApl = text(telapsed+2,LA(1)+2,num2str(LA(1)));
        addpoints(alplane,telapsed,LA(1));
        drawnow;
        
        subplot(3,2,3)
        LAel = text(telapsed+2,LA(2)+2,num2str(LA(2)));
        addpoints(alelev,telapsed,LA(2));
        drawnow;
        
        subplot(3,2,5)
        LAie = text(telapsed+2,LA(3)+2,num2str(LA(3)));
        addpoints(alie,telapsed,LA(3));
        drawnow;
        
        subplot(3,2,2)
        LFmo = text(telapsed+2,LF(2)+2,num2str(LF(2)));
        addpoints(almo,telapsed,LF(2));
        drawnow;
        
        subplot(3,2,4)
        LFef = text(telapsed+2,LF(1)+2,num2str(LF(1)));
        addpoints(alef,telapsed,LF(1));
        drawnow;
        
        subplot(3,2,6)
        LFps = text(telapsed+2,LF(3)+2,num2str(LF(3)));
        addpoints(alps,telapsed,LF(3));
        drawnow;
        
        figure(2)
        
        delete([RApl,RAel,RAie,RFmo,RFef,RFps])
        
        subplot(3,2,1)
        RApl = text(telapsed+2,RA(1)+2,num2str(RA(1)));
        addpoints(arplane,telapsed,RA(1));
        drawnow;
        
        subplot(3,2,3)
        RAel = text(telapsed+2,RA(2)+2,num2str(RA(2)));
        addpoints(arelev,telapsed,RA(2));
        drawnow;

        subplot(3,2,5)
        RAie = text(telapsed+2,RA(3)+2,num2str(RA(3)));
        addpoints(arie,telapsed,RA(3));
        drawnow;
        
        subplot(3,2,2)
        RFmo = text(telapsed+2,RF(2)+2,num2str(RF(2)));
        addpoints(armo,telapsed,RF(2));
        drawnow;
        
        subplot(3,2,4)
        RFef = text(telapsed+2,RF(1)+2,num2str(RF(1)));
        addpoints(aref,telapsed,RF(1));
        drawnow;
        
        subplot(3,2,6)
        RFps = text(telapsed+2,RF(3)+2,num2str(RF(3)));
        addpoints(arps,telapsed,RF(3));
        drawnow;
    
       if ~isempty(k)
           if strcmp(k,'q') 
               k=[];
               break; 
           end
       end
    telapsed = toc+telapsed;
    pause(0.2);
end