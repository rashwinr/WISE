clc
clear all
close all

delete(instrfind({'Port'},{'COM15'}))
ser = serial('COM15','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);


qA = [1,0,0,0];
qB = [1,0,0,0];
qC = [1,0,0,0];
qD = [1,0,0,0];
qE = [1,0,0,0];

pause(2)

%%
NUM = 100;
tel1 = zeros(1,NUM);
i = 0;
while i<NUM
    pause(0.2)
    i = i +1;
    tic
    [qA,qB,qC,qD,qE] = TransfDataReceive(ser,qA,qB,qC,qD,qE);
    tel1(1,i) = toc;
end
disp(mean(tel1))
%%
tel2 = zeros(1,NUM);
i = 0;
while i<NUM
    pause(0.2)
    i = i +1;
    tic
    [qA,qB,qC,qD,qE] = MatchDataReceive(ser,qA,qB,qC,qD,qE);
    tel2(1,i) = toc;
end
disp(mean(tel2))

%%
i = 0;
tel3 = zeros(1,NUM);
while i<NUM
    i = i +1;
    tic
    qA = match_frame('a',qA);
    tel3(1,i) = toc;
end
disp(mean(tel3))
%%
i = 0;
tel4 = zeros(1,NUM);
while i<NUM
    i = i +1;
    tic
    qA = box_transf('a',qA);
    tel4(1,i) = toc;
end
disp(mean(tel4))
