%% Acquire and analyze data from a temperature sensor

%% Connect to Arduino
% Use the arduino command to connect to an Arduino device.

a = arduino('com3', 'uno');  


v = readVoltage(a,'A0');

fprintf('VOltage Reading:\n  %d \n',v)

%% Record and plot 10 seconds of temperature data

ii = 0;
v = zeros(1e4,1);
t = zeros(1e4,1);

tic
while toc < 10
    ii = ii + 1;
    % Read current voltage value
    v = readVoltage(a,'A0');
    % Calculate temperature from voltage (based on data sheet)

    Res(ii) = v;
    % Get time since starting
    t(ii) = toc;
end

% Post-process and plot the data. First remove any excess zeros on the
% logging variables.
Res = Res(1:ii);
t = t(1:ii);
% Plot temperature versus time
figure
plot(t,Res,'-o')
xlabel('Elapsed time (sec)')
ylabel('Rsistance (\circF)')
title('Ten Seconds of Pot data ')
set(gca,'xlim',[t(1) t(ii)])

%% Compute acquisition rate

timeBetweenDataPoints = diff(t);
averageTimePerDataPoint = mean(timeBetweenDataPoints);
dataRateHz = 1/averageTimePerDataPoint;
fprintf('Acquired one data point per %.3f seconds (%.f Hz)\n',...
    averageTimePerDataPoint,dataRateHz)

%% Why is my data so choppy?

measurableIncrementV = 5/1023;
measurableIncrementC = measurableIncrementV*100;
measurableIncrementF = measurableIncrementC*9/5;
fprintf('The smallest measurable increment of this sensor by the Arduino is\n %-6.4f V\n %-6.2f°C\n %-6.2f°F\n',...
    measurableIncrementV,measurableIncrementC,measurableIncrementF);

%% Acquire and display live data

figure
h = animatedline;
ax = gca;
ax.YGrid = 'on';
ax.YLim = [2 8];

stop = false;
startTime = datetime('now');
while true
    % Read current voltage value
    v = readVoltage(a,'A0');
    % Calculate temperature from voltage (based on data sheet)
   
    Res = v; 
    % Get current time
    t =  datetime('now') - startTime;
    % Add points to animation
    addpoints(h,datenum(t),Res)
    % Update axes
    ax.XLim = datenum([t-seconds(15) t]);
    datetick('x','keeplimits')
    drawnow
    % Check stop condition
    stop = readDigitalPin(a,'D12');
end

%% Plot the recorded data

[timeLogs,tempLogs] = getpoints(h);
timeSecs = (timeLogs-timeLogs(1))*24*3600;
figure
plot(timeSecs,tempLogs)
xlabel('Elapsed time (sec)')
ylabel('Temperature (\circF)')

%% Smooth out readings with moving average filter

smoothedTemp = smooth(tempLogs,25);
tempMax = smoothedTemp + 2*9/5;
tempMin = smoothedTemp - 2*9/5;

figure
plot(timeSecs,tempLogs, timeSecs,tempMax,'r--',timeSecs,tempMin,'r--')
xlabel('Elapsed time (sec)')
ylabel('Temperature (\circF)')
hold on 

%%
% Plot the original and the smoothed temperature signal, and illustrate the
% uncertainty.

plot(timeSecs,smoothedTemp,'r')

%% Save results to a file

T = table(timeSecs',tempLogs','VariableNames',{'Time_sec','Temp_F'});
filename = 'Temperature_Data.xlsx';
% Write table to file 
writetable(T,filename)
% Print confirmation to command line
fprintf('Results table with %g temperature measurements saved to file %s\n',...
    length(timeSecs),filename)