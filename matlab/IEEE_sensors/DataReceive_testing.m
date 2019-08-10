clc
clear all
close all

delete(instrfind({'Port'},{'COM15'}))
ser = serial('COM15','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);
pause(2)


%% fread testing
    tic
    
qA = [1,0,0,0];
qB = [1,0,0,0];
qC = [1,0,0,0];
qD = [1,0,0,0];
qE = [1,0,0,0];

flg = 0;
i = 1;
datamodified = ["0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0"];
bytes = ser.Bytesavailable;
while bytes<=250
bytes = ser.Bytesavailable;    
end
str = strsplit(convertCharsToStrings(char(fread(ser,bytes))),'\n');
str = fliplr(str(2:length(str)-1));
% length(str)
while i<=length(str)
    data = strsplit(str(i),',');
    if length(data)==5 && ~any(data(1)==datamodified(:,1)) 
       switch data(1)
           case 'a'
               datamodified(1,:) = data; 
               flg = flg +1;
               
               qA = qconvert(datamodified(1,:));
               qA = match_frame('a',qA);
               

           case 'b'
               datamodified(2,:) = data;
               flg = flg +1;
               qB = qconvert(datamodified(2,:));
               qB = match_frame('b',qB);
                    
           case 'c'
               datamodified(3,:) = data;
               flg = flg +1;
               qC = qconvert(datamodified(3,:));
               qC = match_frame('c',qC);
                    

           case 'd'
               datamodified(4,:) = data;
               flg = flg +1;
               qD = qconvert(datamodified(4,:));
               qD = match_frame('d',qD);
            

           case 'e'
               datamodified(5,:) = data;
               flg = flg +1;
               
               qE = qconvert(datamodified(5,:));
               qE = match_frame('e',qE);
% 
%                qZ = quatmultiply(qE,quatmultiply(qK,quatconj(qE)));
% 
%                qZ = [cos(thg/2),qZ(2)*sin(thg/2),qZ(3)*sin(thg/2),qZ(4)*sin(thg/2)];
%                qE = quatmultiply(qZ,qE);
%                
%                qY = quatmultiply(qE,quatmultiply(qJ,quatconj(qE)));
%                qY = [cos(thl/2),qY(2)*sin(thl/2),qY(3)*sin(thl/2),qY(4)*sin(thl/2)];
%                qE = quatmultiply(qY,qE);
       end
    end
    
    if flg == 5
        break
    end
    i = i + 1;
end   

    disp(toc);
    disp(qA);
    disp(qB);
    disp(qC);
    disp(qD);
    disp(qE);   
%% fscanf testing

    tic
    
qA = [1,0,0,0];
qB = [1,0,0,0];
qC = [1,0,0,0];
qD = [1,0,0,0];
qE = [1,0,0,0];    
flg = 0;
datamodified = ["0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0"];
    while true
        if ser.Bytesavailable
            line = fscanf(ser);
        end
    data = strsplit(string(line),',');
    if length(data)==5 && ~any(data(1)==datamodified(:,1)) 
       switch data(1)
           case 'a'
               datamodified(1,:) = data; 
               flg = flg +1;
               qA = qconvert(datamodified(1,:));

           case 'b'
               datamodified(2,:) = data;
               flg = flg +1;
               qB = qconvert(datamodified(2,:));
        
           case 'c'
               datamodified(3,:) = data;
               flg = flg +1;
               qC = qconvert(datamodified(3,:));

           case 'd'
               datamodified(4,:) = data;
               flg = flg +1;
               qD = qconvert(datamodified(4,:));

           case 'e'
               datamodified(5,:) = data;
               flg = flg +1;
               qE = qconvert(datamodified(5,:));
       end
    end
    if flg == 5
        break
    end
    end
    disp(toc);
    disp(qA);
    disp(qB);
    disp(qC);
    disp(qD);
    disp(qE);    

%% par for testing

qA = [1,0,0,0];
qB = [1,0,0,0];
qC = [1,0,0,0];
qD = [1,0,0,0];
qE = [1,0,0,0];
 ind = ["0","0","0","0","0","0","0","0","0","0"];
 tic;
parfor (i = 1:10,0)
      ind(1,i) = convertCharsToStrings(fscanf(ser));
end
        flushinput(ser);
for j=1:5
    data = strsplit(ind(1,j),',');
    if(length(data) == 5)
            switch data(1)
                case 'e'
                qE = qconvert(data);
                case 'a'
                qA = qconvert(data);
                case 'c'
                qC = qconvert(data);
                case 'd'
                qD = qconvert(data);
                case 'b'
                qB = qconvert(data);   
            end 
    end
    
end
disp(toc);
