a = arduino('com3', 'uno');    
s = servo(a, 'D4');

%for angle = 0.2:0.2:1
        angle=.4; % 0 for opening and 1 (180 degree) for closing gripper
        writePosition(s, angle);
        current_pos = readPosition(s);
        current_pos = current_pos*180;
        fprintf('Current motor position is %d degrees\n', current_pos);
        pause(2);
%end

%clearing the Servo and the arduio object
clear s a

%% INTIALIZING CONNECTION
arduino=serial('COM4', 'uno');
% set(arduino,'Terminator','CR');
% set(arduino,'DataBits',8);
% set(arduino,'StopBits',1);
% set(arduino,'Parity','none');
set(arduino,'BaudRate',250000);


fopen(arduino); % initiate arduino communication
fprintf(arduino,'*IDN?');
 
for angle = 0.2:0.2:1
str =strcat(a1,a2,a3,m1,m2,m3);
 fprintf(arduino,'%s\n',str);
end   
clear s a