#######################################################
#     Author: Spyros Daskalakis                       #
#     Last Revision: 05/07/2021                       #
#     Python Version:  3.9                            #
#     Email: Daskalakispiros@gmail.com                #
#######################################################

import time
import numpy as np
import nidaqmx.system

daq_fs = 200e3  # 200 kS/s maximum
daq_voltage_scale = 1.5  # volts

vout = np.arange(0, 0.7, 0.01)
counter = 0
v_reading = np.zeros((len(vout)))
i_reading = np.zeros((len(vout)))
Resistor = 51.5

while counter < len(vout):
    with nidaqmx.Task() as task:
        task.ao_channels.add_ao_voltage_chan('myDAQ1/ao0')
        value = vout[counter]
        task.write(value)
        task.wait_until_done()
    time.sleep(1)

    with nidaqmx.Task() as task:
        task.ai_channels.add_ai_voltage_chan("myDAQ1/ai0")
        task.ai_channels.add_ai_voltage_chan("myDAQ1/ai1")
        VOLT = task.read()
        print('AI0:',VOLT[0],' AI1:', VOLT[1])
        counter = counter + 1
