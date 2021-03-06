%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: F:\github\wearable-jacket\matlab\IEEE_sensors\data_matched\LA,LF,RA,RF\Y\final.csv
%
% Auto-generated by MATLAB on 26-Nov-2019 00:01:53

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 8);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Time_RA", "RA", "Time_RF", "RF", "Time_LA", "LA", "Time_LF", "LF"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable("F:\github\wearable-jacket\matlab\IEEE_sensors\data_matched\LA,LF,RA,RF\Y\final.csv", opts);

%% Convert to output type
Time_RA = tbl.Time_RA;
RA = tbl.RA;
Time_RF = tbl.Time_RF;
RF = tbl.RF;
Time_LA = tbl.Time_LA;
LA = tbl.LA;
Time_LF = tbl.Time_LF;
LF = tbl.LF;
LF = (LF-min(LF))/max(LF);
RF = (RF-min(RF))/max(RF);
LA = (LA-min(LA))/max(LA);
RA = (RA-min(RA))/max(RA);

%% Clear temporary variables
clear opts tbl


LW = 2;
figure(1)
subplot(4,1,1)
lf = plot(Time_LF,LF,'Color','r','LineWidth',LW,'DisplayName','LF')
hold on
xlabel('Time [s]','FontSize',15)
ylabel('Angle [deg^o]','FontSize',15)
axis([0 300 -1 1])
subplot(4,1,2)
rf = plot(Time_RF,RF,'Color','g','LineWidth',LW,'DisplayName','RF')
hold on
axis([0 300 -1 1])
xlabel('Time [s]','FontSize',15)
ylabel('Angle [deg^o]','FontSize',15)
subplot(4,1,3)
la = plot(Time_LA,LA,'Color','b','LineWidth',LW,'DisplayName','LA')
hold on
xlabel('Time [s]','FontSize',15)
ylabel('Angle [deg^o]','FontSize',15)
axis([0 300 -1 1])
subplot(4,1,4)
ra = plot(Time_RA,RA,'Color','k','LineWidth',LW,'DisplayName','RA')
hold on
xlabel('Time [s]','FontSize',15)
ylabel('Angle [deg^o]','FontSize',15)
axis([0 300 -1 1])
lgd = legend([lf,rf,la,ra],'FontSize',15)
lgd.Orientation = 'horizontal'