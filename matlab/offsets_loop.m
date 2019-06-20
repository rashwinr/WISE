clear all, close all, clc

delete(instrfind({'Port'},{'COM15'}))
s = serial('COM15','BaudRate',115200);
s.ReadAsyncMode = 'continuous';
p = -1; %y = m x + p where y(-1 1) x(0 999) from rfduino z(-2^14 2^14)
m = 2/999;

empty = [1,0,0,0];

qE = [1,0,0,0];
qfE = [1,0,0,0];
qOFFe = [0,0,0,0];

qC = [1,0,0,0];
qfC = [1,0,0,0];
qOFFc = [0,0,0,0];

qA = [1,0,0,0];
qfA = [1,0,0,0];
qOFFa = [0,0,0,0];

qB = [1,0,0,0];
qfB = [1,0,0,0];
qOFFb = [0,0,0,0];

qD = [1,0,0,0];
qfD = [1,0,0,0];
qOFFd = [0,0,0,0];

fopen(s);

while true  
    
    [qA,qB,qC,qD,qE] = DataReceive(s,qA,qB,qC,qD,qE);
            
        if all(qOFFa == qA) && all(qOFFb == qB) && all(qOFFc == qC) && all(qOFFd == qD) && all(qOFFe == qE) && all(qOFFa ~= empty) && all(qOFFb ~= empty) && all(qOFFc ~= empty) && all(qOFFd ~= empty) && all(qOFFe ~= empty) 
            qOFFa = quatmultiply(quatconj(qE),qA)
            qOFFb = quatmultiply(quatconj(qE),qB)
            qOFFc = quatmultiply(quatconj(qE),qC)
            qOFFd = quatmultiply(quatconj(qE),qD)
            break
        end  

        qOFFa = qA
        qOFFb = qB
        qOFFc = qC
        qOFFd = qD
        qOFFe = qE
end
    

