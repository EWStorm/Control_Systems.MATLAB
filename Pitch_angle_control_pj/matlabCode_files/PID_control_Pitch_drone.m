% Arduino, drone, DSE. webinar code. 
%% Create Arduino Object with Pololu/LSM303 Add-On
global a
a = arduino('COM3', 'Mega2560', 'Libraries', 'Pololu/LSM303');

%% Read Data from LSM303 Device
% Create LSM303 device object for LSM303D accelerometer and magnetometer.
a = arduino('COM3', 'Mega2560','Libraries', {'SPI','Serial','I2C','Pololu/LSM303'});
%listArduinoLibraries;
%a = arduino("COM3","Mega2560","Libraries",{'SPI','Serial','I2C', 'Pololu/LSM303'})
%% create sensor object 
fs = 100; % Sample Rate in Hz   
imu=mma8652(a,'SampleRate',fs,'OutputFormat','matrix');

%compass = addon(a, 'Pololu/LSM303');

%% data acquisition 
acc = readAcceleration(compass);
fprintf('Acceleration: %+.3f(X) %+.3f(Y) %+.3f(Z) (m/s^2)\n', acc(1), acc(2), acc(3));

pitch=convertToPitch(acc) %make a function convertToPitch 
%% Live plotting 
figure
h=animatedline; 
ax=gca; 
ax.YGrid= 'on'; 
ax.YLim = [-100 100]; 

tic ; 
startTime= datetime('now') ; 

while toc<30
    % read current acceleration sensor value 
    acc=readAcceleration(compass);

    % convert to pitch 
    pitch=convertToPitch(acc); 
    % get current time 
    t= datetime('now')- startTime; 
    % add points to animation 
    addpoints(h, datenum(t),pitch)
    
    %Update axes 
    ax.XLim= datenum([t-seconds(15) t]); 
    datetick('x', 'keeplimits')
    drawnow   
end 
%% Extract the recorded data 
% Plot the recorded data
[timeLogs,pitchLogs] = getpoints(h);
timeSecs = (timeLogs-timeLogs(1))*24*3600;
figure
plot(timeSecs,pitchLogs)
xlabel('Elapsed time (sec)')
ylabel('Pitch')
hold on 


%%
% Save results to a file

T = table(timeSecs',pitchLogs','VariableNames',{'Time_sec','Pitch'});
filename = 'Pitch_Data.xlsx';
% Write table to file 
writetable(T,filename)
% Print confirmation to command line
fprintf('Results table with %g pitch measurements saved to file %s\n',...
    length(timeSecs),filename)
%%




