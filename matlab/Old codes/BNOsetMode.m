function BNOsetMode(bno,NewMode)
Opr_Mode = hex2dec('3D');
Config_mode = bin2dec('00000000');
read = readRegister(bno, Opr_Mode,'uint8');
read = bitset(read,1,0,'uint8');
read = bitset(read,2,0,'uint8');
read = bitset(read,3,0,'uint8');
read = bitset(read,4,0,'uint8');
mode = bitor(read,Config_mode,'uint8');
writeRegister(bno, Opr_Mode, mode,'uint8');

read = readRegister(bno, Opr_Mode,'uint8');
read = bitset(read,1,0,'uint8');
read = bitset(read,2,0,'uint8');
read = bitset(read,3,0,'uint8');
read = bitset(read,4,0,'uint8');
mode = bitor(read,NewMode,'uint8');
writeRegister(bno, Opr_Mode, mode,'uint8');
end