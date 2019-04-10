       %%%%% Ploting 
            
figure
h = animatedline;
ax = gca;
ax.YGrid = 'on';
ax.YLim = [60 180];

stop = false;
startTime = datetime('now');
while true

    % Get current time
    t =  datetime('now') - startTime;
    % Add points to animation
    addpoints(h,datenum(t),rightWristAngle)
    % Update axes
    ax.XLim = datenum([t-seconds(15) t]);
    datetick('x','keeplimits')
    drawnow
    % Check stop condition
   % stop = validData;
end            
     

%% Plot the recorded data

[timeLogs,tempLogs] = getpoints(h);
timeSecs = (timeLogs-timeLogs(1))*24*3600;
figure
plot(timeSecs,tempLogs)
xlabel('Elapsed time (sec)')
ylabel('Temperature (\circF)')
