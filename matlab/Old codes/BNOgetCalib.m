function out = BNOgetCalib(bno)
Calib_r = uint8(hex2dec('35'));
calib = readRegister(bno,Calib_r,'uint8');
c = double(bitget(calib,1:8));
sys = c(8)*2 + c(7);
gyr = c(6)*2 + c(5);
acc = c(4)*2 + c(3);
mag = c(2)*2 + c(1);
out = [sys gyr acc mag];
end