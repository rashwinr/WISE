function [Angle] = getAnglefromFC(ser)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
bytes = ser.Bytesavailable;
while bytes<=50
bytes = ser.Bytesavailable;    
end
str = strsplit(convertCharsToStrings(char(fread(ser,bytes))),'\n');
str = fliplr(str(2:length(str)-1));

while i<=length(str)
    data = strsplit(str(i),':');
    if (length(data)==2) 
        switch data(1)
           case 'Angle'
               Angle = data(2);
        end
    end
end

end