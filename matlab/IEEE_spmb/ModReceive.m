function [Q] = ModReceive(ser,MODid,q)

Q = q;

qA = [1 0 0 0];
qB = [1 0 0 0];
qC = [1 0 0 0];
qD = [1 0 0 0];
qE = [1 0 0 0];

flg = 0;
i = 1;
datamodified = ["0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0";
                "0","0","0","0","0"];
bytes = ser.Bytesavailable;
while bytes<=100
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
    i = i + 1;
end            

switch MODid
    case 'a'
        Q = qA;
    case 'b'
        Q = qB;
    case 'c'
        Q = qC;
    case 'd'
        Q = qD;
    case 'e'
        Q = qE;
end

end