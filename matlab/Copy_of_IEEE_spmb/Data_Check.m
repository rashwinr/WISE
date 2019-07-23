clear all, clc, instrreset
ser = serial('COM5','BaudRate',115200);
ser.ReadAsyncMode = 'continuous';
fopen(ser);
q1 = [1,0,0,0];q2 = [1,0,0,0];q3 = [1,0,0,0];q4 = [1,0,0,0];q5 = [1,0,0,0];
[q2,q3,q4,q5,q1] = DataRecieve_Relative(ser,q2,q3,q4,q5,q1)
instrreset