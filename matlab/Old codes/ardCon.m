%% operation registers

Opr_Mode = hex2dec('3D');

AccMag_mode = bin2dec('0100');
Config_mode = bin2dec('0000');
NDOF_mode = bin2dec('1100');

unit_sel = hex2dec('3B');

%% data registers

LSB_Ax_r = hex2dec('08');
MSB_Ax_r = hex2dec('09');
LSB_Ay_r = hex2dec('0A');
MSB_Ay_r = hex2dec('0B');
LSB_Az_r = hex2dec('0C');
MSB_Az_r = hex2dec('0D');

LSB_Gx_r = hex2dec('2E');
MSB_Gx_r = hex2dec('2F');
LSB_Gy_r = hex2dec('30');
MSB_Gy_r = hex2dec('31');
LSB_Gz_r = hex2dec('32');
MSB_Gz_r = hex2dec('33');

LSB_q0_r = hex2dec('20');
MSB_q0_r = hex2dec('21');
LSB_q1_r = hex2dec('22');
MSB_q1_r = hex2dec('23');
LSB_q2_r = hex2dec('24');
MSB_q2_r = hex2dec('25');
LSB_q3_r = hex2dec('26');
MSB_q3_r = hex2dec('27');

Calib_r = hex2dec('35');

%% arduino setup 
a = arduino('COM10', 'Uno', 'Libraries', 'I2C');
% addrs = scanI2CBus(a);
bno = i2cdev(a, '0x28');

%% set opertation mode

writeRegister(bno, Opr_Mode, NDOF_mode,'int8');

%% getting calibration data

calib = readRegister(bno,Calib_r,'uint8');
c = double(bitget(calib,1:8));
sys_calib = c(8)*2 + c(7);
gyr_calib = c(6)*2 + c(5);
acc_calib = c(4)*2 + c(3);
mag_calib = c(2)*2 + c(1);

%% get acceleration data

LSBx = int16(readRegister(bno,LSB_Ax_r,'uint8'));
MSBx = int16(readRegister(bno,MSB_Ax_r,'uint8'));
MSBx = bitshift(MSBx,8);
X = double(bitor(MSBx,LSBx));
LSBy = int16(readRegister(bno,LSB_Ay_r,'uint8'));
MSBy = int16(readRegister(bno,MSB_Ay_r,'uint8'));
MSBy = bitshift(MSBy,8);
Y = double(bitor(MSBy,LSBy));
LSBz = int16(readRegister(bno,LSB_Az_r,'uint8'));
MSBz = int16(readRegister(bno,MSB_Az_r,'uint8'));
MSBz = bitshift(MSBz,8);
Z = double(bitor(MSBz,LSBz));

%% get gravity data

LSBx = int16(readRegister(bno,LSB_Gx_r,'uint8'));
MSBx = int16(readRegister(bno,MSB_Gx_r,'uint8'));
MSBx = bitshift(MSBx,8);
X = double(bitor(MSBx,LSBx));
LSBy = int16(readRegister(bno,LSB_Gy_r,'uint8'));
MSBy = int16(readRegister(bno,MSB_Gy_r,'uint8'));
MSBy = bitshift(MSBy,8);
Y = double(bitor(MSBy,LSBy));
LSBz = int16(readRegister(bno,LSB_Gz_r,'uint8'));
MSBz = int16(readRegister(bno,MSB_Gz_r,'uint8'));
MSBz = bitshift(MSBz,8);
Z = double(bitor(MSBz,LSBz));

%% get quaternion data

LSBq0 = int16(readRegister(bno,LSB_q0_r,'uint8'));
MSBq0 = int16(readRegister(bno,MSB_q0_r,'uint8'));
MSBq0 = bitshift(MSBq0,8);
Q0 = double(bitor(MSBq0,LSBq0));%*2^(-14);
LSBq1 = int16(readRegister(bno,LSB_q1_r,'uint8'));
MSBq1 = int16(readRegister(bno,MSB_q1_r,'uint8'));
MSBq1 = bitshift(MSBq1,8);
Q1 = double(bitor(MSBq1,LSBq1));%*2^(-14);
LSBq2 = int16(readRegister(bno,LSB_q2_r,'uint8'));
MSBq2 = int16(readRegister(bno,MSB_q2_r,'uint8'));
MSBq2 = bitshift(MSBq2,8);
Q2 = double(bitor(MSBq2,LSBq2));%*2^(-14);
LSBq3 = int16(readRegister(bno,LSB_q3_r,'uint8'));
MSBq3 = int16(readRegister(bno,MSB_q3_r,'uint8'));
MSBq3 = bitshift(MSBq3,8);
Q3 = double(bitor(MSBq3,LSBq3));%*2^(-14);
Q = Q0^2+Q1^2+Q2^2+Q3^2;