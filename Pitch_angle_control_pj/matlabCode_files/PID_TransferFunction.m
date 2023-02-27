%% transfer function 

%% plot motor pwm signal to the pitch angle output 
vector_pwm=[33 48.5 55 75 85 95 ] %pwm values 
vectorPositiveAngle=[ 4.9 9.95 13.672 17.749 21.132 23.56 ]; % corresponding Angle values 
vectorNegativeAngle=[-2.8 -10.56 -14.012 -15.924 -18.57 -21.45 ];
vector_rpm=[1176 1218 1980 2150 2456 3210]

input=vector_pwm ; 
output= vector_rpm ;

%% converting to frequency domain 
FFT1=fft(vector_pwm);
FFT2=fft(vector_rpm);


%%motor speed input output plot 
figure 
plot(vector_pwm, vector_rpm)
title('Input, Output');
xlabel('PWM %')
ylabel('Motor RPM')

%xlim([0 25])
%ylim([0  1000])
grid on
hold on 



figure
plot(vectorPositiveAngle, vector_pwm);
title('Positive Pitch angle relation to motor duty cycle in PWM %');
xlabel('+ pitch angle values')
ylabel('PWM %')
legend ('Pitch angle')
xlim([0 25])
ylim([0  100])
grid on
hold on 

figure 
plot(vectorNegativeAngle, vector_pwm);
title('Negative Pitch angle values per motor duty cycle in PWM %');
xlabel('(-) pitch angle values')
ylabel('PWM %')
grid on
hold on 


%% We can define a PID controller in MATLAB using a transfer function model directly, for example:
% Kp = 1;
% Ki = 1;
% Kd = 1;
% 
% s = tf('s');
% C = Kp + Ki/s + Kd*s
% 
% 
% %% Alternatively, we may use MATLAB's pid object to generate an equivalent continuous-time controller as follows:
% C = pid(Kp,Ki,Kd)