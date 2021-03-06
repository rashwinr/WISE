%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: F:\github\wearable-jacket\matlab\IEEE_sensors\WISE+time_11-21-2019 16-33.txt
%
% Auto-generated by MATLAB on 21-Nov-2019 18:16:48

%% Setup the Import Options
clc;clear all;close all;
opts = delimitedTextImportOptions("NumVariables", 16);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable("F:\github\wearable-jacket\matlab\IEEE_sensors\WISE+time_11-22-2019 20-47.txt", opts);

%% Convert to output type
Time = tbl.VarName1;
r1 = tbl.VarName2*180/pi;
p1 = tbl.VarName3*180/pi;
y1 = tbl.VarName4*180/pi;
r2 = tbl.VarName5*180/pi;
p2 = tbl.VarName6*180/pi;
y2 = tbl.VarName7*180/pi;
r3 = tbl.VarName8*180/pi;
p3 = tbl.VarName9*180/pi;
y3 = tbl.VarName10*180/pi;
r4 = tbl.VarName11*180/pi;
p4 = tbl.VarName12*180/pi;
y4 = tbl.VarName13*180/pi;
r5 = tbl.VarName14*180/pi;
p5 = tbl.VarName15*180/pi;
y5 = tbl.VarName16*180/pi;

%% Clear temporary variables
clear opts tbl
LW = 2;
figure(1)
subplot(4,1,1)
R = plot(Time,r2,'Color','r','LineWidth',LW,'DisplayName','Roll')
hold on
G = plot(Time,p2,'Color','g','LineWidth',LW,'DisplayName','Pitch')
B = plot(Time,y2,'Color','b','LineWidth',LW,'DisplayName','Yaw')
xlabel('Time [s]','FontSize',15)
ylabel('Angle [deg^o]','FontSize',15)

subplot(4,1,2)
plot(Time,r3,'Color','r','LineWidth',LW)
hold on
plot(Time,p3,'Color','g','LineWidth',LW)
plot(Time,y3,'Color','b','LineWidth',LW)
xlabel('Time [s]','FontSize',15)
ylabel('Angle [deg^o]','FontSize',15)

subplot(4,1,3)
plot(Time,r4,'Color','r','LineWidth',LW)
hold on
plot(Time,p4,'Color','g','LineWidth',LW)
plot(Time,y4,'Color','b','LineWidth',LW)
xlabel('Time [s]','FontSize',15)
ylabel('Angle [deg^o]','FontSize',15)

subplot(4,1,4)
plot(Time,r5,'Color','r','LineWidth',LW)
hold on
plot(Time,p5,'Color','g','LineWidth',LW)
plot(Time,y5,'Color','b','LineWidth',LW)
xlabel('Time [s]','FontSize',15)
ylabel('Angle [deg^o]','FontSize',15)

lgd = legend([R,G,B],'FontSize',15)
lgd.Orientation = 'horizontal'