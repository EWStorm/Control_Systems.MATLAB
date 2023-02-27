%% PID 
%proportional control 

s = tf('s');
Pitch_TF=(8.914*s+5.959)/(s^3+0.4083*s^2+1.017*s+0.1075);

step(Pitch_TF)
%%
%% We can define a PID controller in MATLAB using a transfer function model directly, for example:
Kp=0.1894; 
Ki= 0.03787; 
Kd=0.1822; 
% s = tf('s');
 C = Kp + Ki/s + Kd*s
 

% %% Alternatively, we may use MATLAB's pid object to generate an equivalent continuous-time controller as follows:
C = pid(Kp,Ki,Kd)
%% proportional control only 
Kp = 0.0419;
C = pid(Kp)
T = feedback(C*Pitch_TF,1)

t = 0:0.01:2;
step(T,t)
stepinfo(T) % rise time, transient, settling 
GetEss(T) %SS error
%% integral PI
Kp=0.0748;
Ki= 0.0017
C = pid(Kp,Ki)
T = feedback(C*Pitch_TF,1)

t = 0:0.01:2;
step(T,t)

stepinfo(T) % rise time, transient, settling 
GetEss(T) %SS error
%% PID 
Kp=0.1894; 
Ki= 0.03787; 
Kd=0.1822; 

C = pid(Kp,Ki,Kd)
T = feedback(C*Pitch_TF,1);

t = 0:0.01:2;
step(T,t)
stepinfo(T) % rise time, transient, settling 
GetEss(T) %SS error


