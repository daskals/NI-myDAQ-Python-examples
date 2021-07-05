#######################################################
#     Author: Spyros Daskalakis                       #
#     Last Revision: 03/07/2021                       #
#     Python Version:  3.9                            #
#     Email: Daskalakispiros@gmail.com                #
#######################################################

import numpy as np
import matplotlib.pyplot as plt  # for plotting the data
import nidaqmx.system

daq_fs = 200e3  # 200 kS/s maximum
daq_voltage_scale = 1.5  # volts


def send_packet_to_MyDAq(daqV, packet):
    with nidaqmx.Task() as task:
        task.ao_channels.add_ao_voltage_chan('myDAQ1/ao0')
        task.timing.cfg_samp_clk_timing(daq_fs)
        # task.timing.cfg_samp_clk_timing(rate=params.Fs_tx_DAQ, samps_per_chan=packet.size)
        # normalise the packet to 0 - 1.5 V
        packet2 = daqV * (packet - np.amin(packet)) / (np.amax(packet) - np.amin(packet))
        task.write(packet2, auto_start=True)
        task.wait_until_done()
        task.stop()
        print("Packet sent to myDAQ hardware")


vout = np.arange(0, 0.7, 0.01)
counter = 0
v_reading=np.zeros(1,len(vout))
i_reading=np.zeros(1,len(vout))

while counter <= len(vout):
    with nidaqmx.Task() as task:
        task.ai_channels.add_ai_voltage_chan("myDAQ1/ai0")

        VOLT = task.read(number_of_samples_per_channel=1)
        v_reading[counter] = VOLT * 1000



    counter = counter + 1
