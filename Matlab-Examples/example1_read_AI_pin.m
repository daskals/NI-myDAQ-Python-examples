%
clc;
clear all;
close all;

% Getting Started with NI myDAQ 
% Copyright 2013 The MathWorks, Inc.
% This example will help you get started with using the Session-based
% interface and National Instruments myDAQ hardware. 

%% Identify the myDAQ device
% The first step is to ensure that the device is detected by your computer.
% Issue the following command to have the toolbox detect connected data
% acquisition hardware

daq.getDevices;

%% Create a session

% Now you should see a list of devices, of which we will select the
% myDAQ device. The following command will allow you to create a
% data acquisition session with the myDAQ device

s = daq.createSession('ni');

%% Add an analog input Voltage channel
% Now, we can go ahead and add an analog input voltage channel to the
% session. We choose channel 'ai0' on the myDAQ device. Ensure that this
% channel is capturing data.  We connect our input channel to a 35 Hz,
% 750mV pp test sine wave.

ch = s.addAnalogInputChannel('myDAQ1', 'ai0', 'Voltage')


%% Set session and channel properties
% Set the sampling frequency and the range on the device

s.Rate = 2;
s.Channels.Range = [-2 2];
s.DurationInSeconds = 4;

%% Obtain a single sample
% Obtain on-demand voltage readings using inputSingleScan

[singleReading, triggerTime] = s.inputSingleScan;

[singleReading, triggerTime] = s.inputSingleScan;

%% Obtain timestamped data
% Start clocked foreground acquisition with startForeground

[data, timestamps, triggerTime] = s.startForeground



%% Display the results
% Plot the results

plot(timestamps, data , 'o'); 
xlabel('Time (Sec)'); 
ylabel('Voltage (V)');
title(['Clocked Data Triggered on: ' datestr(triggerTime)])