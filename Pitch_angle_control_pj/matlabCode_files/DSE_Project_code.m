% DSE. function,that drives the motor.
%function takes IMU sensor values, converted to pitch angle, if the value is more or less the reference angle,
%the function corrects it. 
%%
clear all;
global a ; 
MotorPin='D2'; 

%create Arduino object 
a = arduino('COM3', 'Mega2560','Libraries', 'I2C')
%listArduinoLibraries;

%changable variables 
count=0; 
prev_state=0; %for IR sensor 

%% create sensor object 
fs = 100; % Sample Rate in Hz   
imu=mma8652(a,'SampleRate',fs,'OutputFormat','matrix');

%% read aceleration 
%display methods 
methods(imu)

%read current acc. sensor values 
acc = readAcceleration(imu);
fprintf('Acceleration: %+.3f(X) %+.3f(Y) %+.3f(Z) (m/s^2)\n', acc(1), acc(2), acc(3));
% convert to pitch values 
pitch= convertToPitch(acc); % function 

%% start motor ans IR count 
writePWMDutyCycle(a,'D2',0.999);
PWM=0.99; %save for the table

%code for IR, convertion to motor's RMP 
IR_status = readDigitalPin(a, 'D6');
fprintf('IR status:  %d \n',readDigitalPin(a, 'D6'));
tic; 
while toc<10 %revolution in 10 seconds 
current_state=readDigitalPin(a, 'D6');
if prev_state~= current_state %if there is change in input
    count=count+1;  
end 
end 

rpm=count*6; % rpm per min 
fprintf('RPM is:  %d per min\n',rpm);

warning off 
%%
% %measure rpm per min 
% tic; 
% while toc<10 %revolution in 10 seconds 
% current_state=readDigitalPin(a, 'D6');
% if prev_state~= current_state %if there is change in input
%     count=count+1;  
% end 
% disp(count);
% end 
% 
% rpm=count*6; % rpm per min 
% fprintf('RPM is:  %d per min\n',rpm);
% 
% warning off 
%% Create a figure and graphics objects & plot data live 
% f1=figure; % ('units','normalized','outerposition',[0 0 1 1]) %full screen size figure 
% f1.Position=[200 100 700 600]; 
% 
% h1=animatedline('Color',  '#D95319','LineWidth',2); 
% h2= animatedline('Color', '#0072BD', 'LineWidth',2); 
% h3=animatedline('Color', '#4DBEEE', 'LineWidth',2); 
% ax = gca;
% ax.YGrid = 'on';
% ax.YLim = [-20 20];
%  title('Acceleration data live plot','Color','#0072BD', 'FontSize', 16);
%  ylabel('Acc. Values:','FontSize',14,'FontWeight','bold','Color',	'#D95319')
%  xlabel('Elapsed time (sec)','FontSize',14,'FontWeight','bold','Color',	'#D95319')
%  legend( {'acc_x', 'acc_y', 'acc_z'},'Location', 'northeast','Interpreter','latex',...
%    'Orientation','horizontal');
%  
%   % collect acceleration data for 20 sec and update plot live 
%  tic ;
% startTime= datetime('now') ; 
%  while toc< 20
     %get new data to plot 
%      acc=readAcceleration(imu); 
%      % convert to pitch 
%     pitch=convertToPitch(acc); 
%     % get current time 
%     t= datetime('now')- startTime;  
%      %add points to animation 
%      addpoints(h1, datenum(t),acc(1))
%      addpoints(h2, datenum(t), acc(2))
%      addpoints(h3, datenum(t), acc(3))
%      %Update axes 
%     ax.XLim = datenum([t-seconds(15) t]);
%     datetick('x','keeplimits')
%      drawnow  
%  end 
%  warning('off');
 
 %% converting to pith+ live plotting og pith data for 30 seconds 
 f2=figure; 
 f2.Position=[200 100 700 600]; 
 h=animatedline('Color', '#77AC30','LineWidth',2); 
ax=gca; 
ax.YGrid= 'on'; 
ax.YLim = [-180 180]; 
title('Pitch data live plot','Color','#0072BD', 'FontSize', 16);
 ylabel('Pitch angle Values:','FontSize',14,'FontWeight','bold','Color','#D95319')
 xlabel('Elapsed time (sec)','FontSize',14,'FontWeight','bold','Color',	'#D95319')
 legend( {'pitch'},'Location', 'northeast','Interpreter','latex',...
   'Orientation','horizontal');


%tic ; 
startTime1= datetime('now') ; 
time=200; %20 seconds

while time>0
    % read current acceleration sensor value 
    acc=readAcceleration(imu);
    % convert to pitch 
    pitch=convertToPitch(acc); 
    % get current time 
    t1= datetime('now')- startTime1; 
    % add points to animation 
    addpoints(h, datenum(t1),pitch)
    
    %Update axes 
    ax.XLim= datenum([t1-seconds(15) t1]); 
    datetick('x', 'keeplimits')
    drawnow   
time=time-1;
end 

warning off 
%% save values , plot
[timeLogs,pitchLogs] = getpoints(h);
timeSecs = (timeLogs-timeLogs(1))*24*3600;
f3=figure;
plot(timeSecs,pitchLogs)
title('Pitch data plot');
xlabel('Elapsed time (sec)')
ylabel('Pitch')
hold on 

%% save as a table 
T1 = table(timeSecs',pitchLogs','VariableNames',{'Time_sec','Pitch'});
filename = 'Pitch_Data_PWM_0.99.xlsx';

% Write table to file 
writetable(T1,filename)
% Print confirmation to command line
fprintf('Results table with %g pitch measurements and 0.99 PWM, rpm for the motor speed saved to file %s\n',...
    length(timeSecs),filename); 

%% save as matlab file 
 %save('Pitch_Data.mat', 'Time_sec');
 %save('Temp.text','TempC','TempF', 't')
 
%% find min and max value of pitch angle 
%convert to matrix 
MaxValue=max(table2array(T1(:,2))); %extract 2 column, max pitch value
MinValue=min(table2array(T1(:,2))); %extract 2 column, min pitch value 

T2 = table(PWM,rpm,MaxValue, MinValue,'VariableNames',{'PWM Duty cycle in %','Motor rpm'...
    'Pitch angle max value','Pitch angle min value'});
filename = 'IR_Data_pwm_0.99.xlsx';

% Write table to file 
writetable(T2,filename)
% Print confirmation to command line
fprintf('Results table with IR measurements saved to file %s\n',filename); 

 disp(T2); 
 
 %%
vector_pwm=[33 48.5 55 75 85 95 ]; %pwm values 
vectorPositiveAngle=[ 4.9 9.95 13.672 17.749 21.132 23.56 ]; % corresponding Angle values 
vectorNegativeAngle=[-2.8 -10.56 -14.012 -15.924 -18.57 -21.45 ];

figure
plot(vectorPositiveAngle, vector_pwm);
title('Positive Pitch angle relation to motor duty cycle in PWM %');
xlabel('+ pitch angle values')
ylabel('PWM %')
hold on 

figure 
plot(vectorNegativeAngle, vector_pwm);
title('Negative Pitch angle values per motor duty cycle in PWM %');
xlabel('(-) pitch angle values')
ylabel('PWM %')
hold on 







