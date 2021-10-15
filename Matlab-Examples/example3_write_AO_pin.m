%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Spiros Daskalakis                               %
%     last Revision 28/7/2018                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; 
close all; 
clear all;


%% Generate Signals on NI devices that Output Voltage
%
% This example shows how to generate data using a National Instruments
% device available to MATLAB(R) using the Session based interface.

% Copyright 2010-2014 The MathWorks, Inc.

%% Discover Devices that can Output Voltage 
% To discover a device that supports analog output voltage subsystems,
% click the name of the device in the list in the Command window, or access
% the device in the array returned by |daq.getDevices| command. This
% example uses a National Instruments CompactDAQ device NI 9263 with ID
% 'cDAQ1Mod2' representing the module in slot 2 of Chassis 'cDAQ1'.
devices = daq.getDevices

%%
%devices(2)

%% Create a Session
% Use the |daq.createSession| function to create a session 
% associated with a vendor.
% The session contains information describing the hardware, scan rate, 
% duration, and other properties associated with the generation.  
% When you create a session, assign it to a variable.

s = daq.createSession('ni')

%% Add Analog Output Channels 
% Use the |addAnalogOutputChannel| function to add two analog output 
% channels from this device to the session.

addAnalogOutputChannel(s,'myDAQ1','ao1','Voltage');  
%addAnalogOutputChannel(s,'myDAQ1','ao1','Voltage');  

%% Set the Session Rate
% By default the session is configured for 1000 scans/second. 
% Change the scan rate to acquire at 8000 scans / second.
Fs =200e3; %100 kS/s 
s.Rate = 200000;

%% Generate a Single Scan
% Use the |outputSingleScan| function to generate a single scan. The data
% is a 1-by-N matrix where N corresponds to the number of output channels.
% Here you output 2V on each channel.

%outputSingleValue = 2;
%outputSingleScan(s,[outputSingleValue]);

%% Queue the Data
% Use the |queueOutputData| function to generate multiple scans. Data
% should be a M-by-N matrix where M is the number of scans you want and N
% is the number of channels in the session. Generate 2 test signals (a 1Hz
% sine wave and a 1Hz ramp) and output them on to the channels in this
% session. The plot depicts the data generated by both channels together.
% (Check if the device you are using supports simultaeneous sampling.)

% outputSignal1 = sin(linspace(0,pi*2,s.Rate)');
% outputSignal2 = linspace(-1,1,s.Rate)';
% plot(outputSignal1);
% hold on;
% plot(outputSignal2,'-g');
% xlabel('Time');
% ylabel('Voltage');
% legend('Analog Output 0', 'Analog Output 1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

symbol_time=100e-3; %100 ms

% Our signal is going to be a chirp frequency signal
% chirp start frequency 12 KHz
% chirp end frequency 22 KHZ
LEFT= 12000;
RIGHT=22000;
%Chirp BW
BW=RIGHT-LEFT;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Create ideal packet
inverse = 0;
num_samples = round(symbol_time*Fs);
x=symbol_time*BW; %# of samples per symbol
%make preamble symbols
preamble_symbol0 = LoRa_Modulation(x,BW,Fs,num_samples,0,inverse, LEFT);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%
packet=[zeros(1, num_samples), preamble_symbol0, zeros(1, num_samples)]';
packet =(packet-min(packet))/(max(packet)-min(packet));

figure(1);
title('FM LoRa Packet');
spectrogram(packet,512,500,512,Fs,'yaxis');


figure(2);
title('FM LoRa Packet');
plot(packet);


queueOutputData(s,packet);

%% Start the Session in Foreground
% Use the |startForeground| function to start the analog output 
% operation and block MATLAB execution until all data is generated. 

s.startForeground;

