%
clc;
clear all;
close all;

fid = fopen('temp_sensors.csv', 'w') ;
s = daq.createSession('ni');
cnt=0;
start_time=clock 
s.addAnalogInputChannel('myDAQ1', 'ai0', 'Voltage');  %leaf
s.addAnalogInputChannel('myDAQ1', 'ai1', 'Voltage');   %air


s.Rate = 1;
s.Channels(1).Range = [-10 10];
s.Channels(2).Range = [-10 10];
s.DurationInSeconds = 5%*60*60;  %%%%%%*24*60*60

dataAvailable=s.Rate*s.DurationInSeconds;
%s.IsContinuous = true;

% generate a data available event after dataAvailable samples
%s.NotifyWhenDataAvailableExceeds = dataAvailable;

 lh = addlistener(s,'DataAvailable',@plotData)


 startBackground(s);
 % delete(lh)
  
 while s.IsRunning
    cnt = cnt + 1;
    pause(1);
%     fprintf('While loop: Scans acquired = %d\n', s.ScansAcquired) % sceen message
   disp(['Remaining time:' num2str(s.DurationInSeconds-cnt) ' sec'])
 end

 stop(s)
 delete(lh)
 save('start_time.mat','start_time');
 %data=0;
 %save('temp_sensors.mat','data'); 
  
function plotData(src,event)

  data=[event.Data, event.TimeStamps]
  %
  %dlmwrite('mydata.csv',data,'delimiter','\t','-append');
  
 
   figure (1)  
   plot(data(3),data(1), 'o')
   plot(data(3),data(2), 'x')
   hold on;
   xlabel('Time (Sec)'); 
   ylabel('Voltage (V)');
   
end  

