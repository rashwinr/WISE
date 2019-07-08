clear all; close all; clc;
delete(instrfind({'Port'},{'COM11'}))
%% test jcs
qC = [1,0,0,0];qD = [1,0,0,0];qA = [1,0,0,0];qB = [1,0,0,0];qE = [1,0,0,0];
delete(instrfind({'Port'},{'COM11'}))
ser = serial('COM11','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);

while true
    
if ser.BytesAvailable
        
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,0,0);
       [~,~,Rie] = JCS_Ra(qE,qD);
       [~,~,Lie] = JCS_La(qE,qC);
       disp(strcat('Lie = ',' ',num2str(Lie*180/pi),' Rie = ',' ',num2str(Rie*180/pi)))
end

pause(0.1)

end