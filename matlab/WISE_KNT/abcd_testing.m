close all, clear all, clc

delete(instrfind({'Port'},{'COM15'}))
ser = serial('COM15','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser)
% fopen(ser,'r','n','US-ASCII');

%%

ind = ["0","0","0","0","0","0","0","0","0","0"];%,"0","0","0","0","0","0","0","0","0","0"];
datamodified = ["0","0","0","0","0"];
% fread(ser,100);

tic
parfor (i = 1:10,0)
      ind(1,i) = convertCharsToStrings(fscanf(ser));
end
toc

get(ser)
for k=1:10
    
   data = strsplit(ind(1,k),',');
    if(length(data) == 5)
        
            switch data(1)
                case 'a'
                    datamodified(1) = ind(1,k);
                case 'b'
                    datamodified(2) = ind(1,k);
                case 'c'
                    datamodified(3) = ind(1,k);
                case 'd'
                    datamodified(4) = ind(1,k);
                case 'e'
                    datamodified(5) = ind(1,k);
            end
    end
end

disp('ind')
disp(ind)
disp('datamodified')
disp(datamodified)

%%

clc

flg = 0;
i = 1;
str = "";
datamodified = ["0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0"];
flushinput(ser);
pause(0.03);
tic
bytes = ser.Bytesavailable
% str = convertCharsToStrings(char(fread(ser,bytes)))
str = strsplit(convertCharsToStrings(char(fread(ser,bytes))),'\n');
str = fliplr(str(2:length(str)-1))

while i<=length(str)
    data = strsplit(str(i),',');
    if length(data)==5 && ~any(data(1)==datamodified(:,1)) 
       switch data(1)
           case 'a'
               datamodified(1,:) = data; 
               flg = flg +1;
           case 'b'
               datamodified(2,:) = data;
               flg = flg +1;
           case 'c'
               datamodified(3,:) = data;
               flg = flg +1;
           case 'd'
               datamodified(4,:) = data;
               flg = flg +1;
           case 'e'
               datamodified(5,:) = data;
               flg = flg +1;
       end
    end
    if flg == 5
        break
    end
    i = i + 1;
end
toc

%%
flushinput(ser);
ser.Bytesavailable
pause(0.1);
ser.Bytesavailable