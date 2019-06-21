clear all, close all, clc

%COM Port details

delete(instrfind({'Port'},{'COM15'}))

ser = serial('COM11','BaudRate',115200,'InputBufferSize',100);
ser.ReadAsyncMode = 'continuous';
fopen(ser);

while true
    if ser.BytesAvailable
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE);
       qE = match_frame('e',qE);
       qA = match_frame('a',qA);
       qC = match_frame('c',qC);
       qD = match_frame('d',qD);
       qB = match_frame('b',qB);
       
       lshoangle = get_Left_Arm(qE,qC);
       limuie = lshoangle(3);limubd = lshoangle(2);limuef = lshoangle(1); 
       
       rshoangle = get_Right_Arm(qE,qD);
       rimuie = rshoangle(3);rimubd = rshoangle(2);rimuef = rshoangle(1);
       
       lwriangle = get_Left_Wrist(qC,qA);
       limuelb = lwriangle(1);limuelb1 = lwriangle(2);
       
       rwriangle = getrightwrist(qD,qB);
       rimuelb = rwriangle(1);rimuelb1 = rwriangle(2);
    end
end
