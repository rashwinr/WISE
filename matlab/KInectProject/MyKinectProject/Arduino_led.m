a = arduino('com3', 'uno');     

% start the loop to blink led for 10 seconds

for i = 1:10

    writeDigitalPin(a, 'D13', 1);

    pause(0.5);

    writeDigitalPin(a, 'D13', 0);

    pause(0.5);

end

% end communication with arduino

clear a
