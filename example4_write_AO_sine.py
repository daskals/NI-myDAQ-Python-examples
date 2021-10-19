#######################################################
#     Author: Spyros Daskalakis                       #
#     Last Revision: 17/10/2021                       #
#     Python Version:  3.9                            #
#     Email: Daskalakispiros@gmail.com                #
#######################################################
import nidaqmx.system
import numpy as np
import matplotlib.pyplot as plot
from nidaqmx import *
from nidaqmx.constants import AcquisitionType
# Produce sine wave

# sampling information
Fs = 200000 # sample rate
T = 1/Fs # sampling period
t = 0.1 # seconds of sampling
N = Fs*t # total points in signal

maxV=1.5
minV=0.3
daqV=maxV-minV



# signal information
freq = 30000 # in hertz, the desired natural frequency
omega = 2*np.pi*freq # angular frequency for sine waves
t_vec = np.arange(N)*T # time vector for plotting
print('Number of Samples:', len(t_vec))
signal = np.sin(omega*t_vec)

# normalise the packet to 0 - 1.5 V
#signal2 = daqV * (signal - np.amin(signal)) / (np.amax(signal) - np.amin(signal))+minV

fig = plot.figure()
# Plot a sine wave using time and amplitude obtained for the sine wave
plot.plot(t_vec,signal)
# Give a title for the sine wave plot
plot.title('Sine wave')
# Give x axis label for the sine wave plot
plot.xlabel('Time')
# Give y axis label for the sine wave plot
plot.ylabel('Amplitude = sin(time)')
plot.grid(True, which='both')
plot.axhline(y=0, color='k')
plot.show()


samps_per_chan=len(t_vec)
test_Task = nidaqmx.Task()
test_Task.ao_channels.add_ao_voltage_chan('myDAQ1/ao0', min_val=-2.0, max_val=2.0)
test_Task.timing.cfg_samp_clk_timing(rate=Fs, sample_mode=AcquisitionType.FINITE, samps_per_chan= samps_per_chan)
test_Writer = nidaqmx.stream_writers.AnalogSingleChannelWriter(test_Task.out_stream, auto_start=True)
test_Writer.write_many_sample(signal)
test_Task.wait_until_done()
test_Task.stop()
test_Task.close()
