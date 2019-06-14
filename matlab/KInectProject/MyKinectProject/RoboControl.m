%% THIS IS THE MAIN CONTROL FOR THE ROBOT ARM.
% This script is responsible for getting 3D data from the Kinect, where we
% have used the MATLAB interface for Kinect 2.0 by Terven Juan and
% Cordova-Esparza Diana.

%% BEGIN
%%Clearing all the variables used and delete any Serial Port Objects
clear
clc
close all
% Add path to the kinect 2.0 interface by Juan and Diana
addpath('D:\MatLab\Kin2')
addpath('D:\MatLab\Kin2\Mex');
%% THE CODE BELOW IS ADAPTED FROM JUAN AND DIANA's Example
% Create Kinect 2 object and initialize it
% Available sources: 'color', 'depth', 'infrared', 'body_index', 'body',
% 'face' and 'HDface'
k2 = Kin2('color','depth','body');
[bodies, fcp, timeStamp] = k2.getBodies('Quat');
%[bodies, fcp, timeStamp] = k2.getBodies('Euler'); 
% images sizes
d_width = 512; d_height = 424; outOfRange = 4000;
c_width = 1920; c_height = 1080;
COL_SCALE = 1.0;
color = zeros(c_height*COL_SCALE,c_width*COL_SCALE,3,'uint8');
 numBodies = size(bodies,2);
 disp(['Bodies Detected: ' num2str(numBodies)])

% color stream figure
c.h = figure;
c.ax = axes;
c.im = imshow(color,[]);
title('Color Source (press q to exit)');
set(gcf,'keypress','k=get(gcf,''currentchar'');'); % listen keypress


 We will not begin our main program until we have received a signal from
% the Kinect, and the while loop below is responsible for that.
begin = false;
while (~begin)
    validData = k2.updateData;
    if(validData)
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
        if numBodies > 0
            disp('Initial hand detected');
            %Write the Code for angle detection
             disp(bodies(1).RightHandState)
            
             disp('Right Elbow Orientation') % see Kin2.m constants
             disp(bodies(1).Orientation(:,k2.JointType_ElbowRight)); 
             
             
             begin = true;
            pause(1);
        end
    end
end

%% INTIALIZING CONNECTION
arduino=serial('COM4');
% set(arduino,'Terminator','CR');
% set(arduino,'DataBits',8);
% set(arduino,'StopBits',1);
% set(arduino,'Parity','none');
set(arduino,'BaudRate',250000);

fopen(arduino); % initiate arduino communication
fprintf(arduino,'*IDN?')         
