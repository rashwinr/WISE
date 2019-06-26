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
    flushinput(s);
    pause(0.01);
    line = fscanf(s);   % get data if there exists data in the next line
    data = strsplit(string(line),',');
    if(length(data) == 5 || length(data) == 6)
    switch data(1) 
        case 'e'
            qE(1) = str2double(data(2))*m+p;
            qE(2) = str2double(data(3))*m+p;
            qE(3) = str2double(data(4))*m+p;
            qE(4) = str2double(data(5))*m+p;
            qE = quatnormalize(qE); 
        case 'c'
            qC(1) = str2double(data(2))*m+p;
            qC(2) = str2double(data(3))*m+p;
            qC(3) = str2double(data(4))*m+p;
            qC(4) = str2double(data(5))*m+p;
            qC = quatnormalize(qC);
        case 'a'
            qA(1) = str2double(data(2))*m+p;
            qA(2) = str2double(data(3))*m+p;
            qA(3) = str2double(data(4))*m+p;
            qA(4) = str2double(data(5))*m+p;
            qA = quatnormalize(qA);
        case 'b'
            qB(1) = str2double(data(2))*m+p;
            qB(2) = str2double(data(3))*m+p;
            qB(3) = str2double(data(4))*m+p;
            qB(4) = str2double(data(5))*m+p;
            qB = quatnormalize(qB);
        case 'd'
            qD(1) = str2double(data(2))*m+p;
            qD(2) = str2double(data(3))*m+p;
            qD(3) = str2double(data(4))*m+p;
            qD(4) = str2double(data(5))*m+p;
            qD = quatnormalize(qD);
            
    end
            
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
    


end

