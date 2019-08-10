function [Q] = ModsReceive(ser,MODids,q)

Mods = ['0','0','0','0','0'];
M = strsplit(MODids,',');
Nm = length(M);
Mods(1:Nm) = M;
Q = zeros(Nm,4);

for i=1:Nm
    Q(i,:) = q(i,:);
end

flg = 0;
i = 1;
datamodified = strings(Nm,5);

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
           case Mods(1)
               datamodified(1,:) = data; 
               flg = flg +1;
               Q(1,:) = qconvert(datamodified(1,:));
               
           case Mods(2)
               datamodified(2,:) = data;
               flg = flg +1;
               Q(2,:) = qconvert(datamodified(2,:));
                    
           case Mods(3)
               datamodified(3,:) = data;
               flg = flg +1;
               Q(3,:) = qconvert(datamodified(3,:));
               
           case Mods(4)
               datamodified(4,:) = data;
               flg = flg +1;
               Q(4,:) = qconvert(datamodified(4,:));
         
           case Mods(5)
               datamodified(5,:) = data;
               flg = flg +1;               
               Q(5,:) = qconvert(datamodified(5,:));
       end
    end
    
    if flg == Nm
        break
    end
    i = i + 1;
end            


end