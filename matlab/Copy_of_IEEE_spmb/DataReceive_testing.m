delete(instrfind({'Port'},{'COM15'}))
ser = serial('COM15','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);
pause(2)
while true
    bytes = ser.Bytesavailable;
    if bytes>=200
            str = strsplit(convertCharsToStrings(char(fread(ser,bytes))),'\n');
            str = fliplr(str(2:length(str)-1));
    end
end