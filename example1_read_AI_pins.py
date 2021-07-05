#######################################################
#     Author: Spyros Daskalakis                       #
#     Last Revision: 05/07/2021                       #
#     Python Version:  3.9                            #
#     Email: Daskalakispiros@gmail.com                #
#######################################################

import numpy as np
import matplotlib.pyplot as plt  # for plotting the data
import nidaqmx.system


with nidaqmx.Task() as task:
    task.ai_channels.add_ai_voltage_chan("myDAQ1/ai0")

    print('1 Channel 1 Sample Read: ')
    data = task.read()
    print(data)

    data = task.read(number_of_samples_per_channel=1)
    print(data)

    print('1 Channel N Samples Read: ')
    data = task.read(number_of_samples_per_channel=8)
    print(data)

    task.ai_channels.add_ai_voltage_chan("myDAQ1/ai1:1")

    print('N Channel 1 Sample Read: ')
    data = task.read()
    print(data)

    print('N Channel N Samples Read: ')
    data = task.read(number_of_samples_per_channel=2)
    print(data)