clear all, close all, clc
addpath('F:\github\wearable-jacket\matlab\IEEE_sensors');
instrreset
ser = serial('COM15','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);
addpath('F:\github\wearable-jacket\matlab\IEEE_sensors\JCS_data\');

LF = [0,0,0];
LA = [0,0,0];
RF = [0,0,0];
RA = [0,0,0];

qLA = [1 0 0 0];
qRA = [1 0 0 0];
qLF = [1 0 0 0];
qRF = [1 0 0 0];
qB = [1 0 0 0];
res = 1;
ex = 'abd';
side = 'Right';
dtRef = 0.2;
oldel = 0;
dt = 0;
L = [1 1 1 1 0]; % PL IE FE PS
cost = 0;
telapsed = 0;
figure(1)
costL = animatedline(telapsed,cost,'Color','r');
%%
tic
while true
     if ser.BytesAvailable
        [qLF,qRF,qLA,qRA,qB] = DataReceive(ser,qLF,qRF,qLA,qRA,qB);
        dt = toc;
        telapsed = telapsed + dt;
        tic
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
        switch side
            case 'Left'
                ja = [LA,LF];
            case 'Right'
                ja = [RA,RF];
        end
        cost = GetCost(res,ex,oldel,ja,dt,dtRef,L);
        addpoints(costL,telapsed,cost);
     end
end

