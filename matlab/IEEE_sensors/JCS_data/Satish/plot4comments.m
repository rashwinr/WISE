%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: F:\github\wearable-jacket\matlab\IEEE_sensors\JCS_data\Satish\Unknown_Subject_25_11_2019_13_54_23.txt
%
% Auto-generated by MATLAB on 25-Nov-2019 14:43:31

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 13);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["VarName1", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable("F:\github\wearable-jacket\matlab\IEEE_sensors\JCS_data\Satish\Unknown_Subject_25_11_2019_14_06_06.txt", opts);

%% Convert to output type
spr = tbl.VarName1;
ser = tbl.VarName22;
sier = tbl.VarName23;
efer = tbl.VarName24;
ecar = tbl.VarName25;
epsr = tbl.VarName26;
spl = tbl.VarName27;
sel = tbl.VarName28;
siel = tbl.VarName29;
efel = tbl.VarName30;
ecal = tbl.VarName31;
epsl = tbl.VarName32;
Time = tbl.VarName33;

spr(1:5000,1) = spr(68931:73930,1);
% spr = spr+160;
ser(1:5000,1) = ser(68931:73930,1);
sier(1:5000,1) = sier(68931:73930,1);
sier = sier+90;
efer(1:5000,1) = efer(68931:73930,1);
ecar(1:5000,1) = ecar(68931:73930,1);
epsr(1:5000,1) = epsr(68931:73930,1);
spl(1:5000,1) = spl(68931:73930,1);
spl = spl+160;
sel(1:5000,1) = sel(68931:73930,1);
siel(1:5000,1) = siel(68931:73930,1);
siel = siel-90;
efel(1:5000,1) = efel(68931:73930,1);
ecal(1:5000,1) = ecal(68931:73930,1);
epsl(1:5000,1) = epsl(68931:73930,1);
epsl = epsl+30;

%% Clear temporary variables
clear opts tbl
LW = 2;
figure(1)
subplot(2,2,1)
A = plot(Time,spl,'Color','r','LineWidth',LW,'DisplayName','Shoulder plane')
hold on
xlabel('Time [s]','FontSize',15)
title('Left shoulder','FontSize',15)
ylabel('Angle [deg^o]','FontSize',15)
B = plot(Time,sel,'Color','g','LineWidth',LW,'DisplayName','Shoulder elevation')
C = plot(Time,siel,'Color','b','LineWidth',LW,'DisplayName','Shoulder internal-external rotation')
hold off

subplot(2,2,2)
plot(Time,spr,'Color','r','LineWidth',LW)
hold on
xlabel('Time [s]','FontSize',15)
ylabel('Angle [deg^o]','FontSize',15)
title('Right shoulder','FontSize',15)
plot(Time,ser,'Color','g','LineWidth',LW)
plot(Time,sier,'Color','b','LineWidth',LW)
hold off

subplot(2,2,3)
D = plot(Time,efel,'Color','c','LineWidth',LW,'DisplayName','Elbow flexion-extension')
hold on
xlabel('Time [s]','FontSize',15)
ylabel('Angle [deg^o]','FontSize',15)
title('Left elbow','FontSize',15)
E = plot(Time,ecal,'Color','m','LineWidth',LW,'DisplayName','Carrying angle')
F = plot(Time,epsl,'Color','k','LineWidth',LW,'DisplayName','Forearm pronation-supination')
hold off

subplot(2,2,4)
plot(Time,efer,'Color','c','LineWidth',LW)
hold on
xlabel('Time [s]','FontSize',15)
ylabel('Angle [deg^o]','FontSize',15)
title('Right elbow','FontSize',15)
plot(Time,ecar,'Color','m','LineWidth',LW)
plot(Time,epsr,'Color','k','LineWidth',LW)
hold off

lgd = legend([A,B,C,D,E,F],'FontSize',15)
lgd.Orientation = 'vertical'