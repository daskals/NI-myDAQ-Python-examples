#######################################################
#     Author: Spyros Daskalakis                       #
#     Last Revision: 05/07/2021                       #
#     Python Version:  3.9                            #
#     Email: Daskalakispiros@gmail.com                #
#######################################################

import nidaqmx.system

with nidaqmx.Task() as task:
    task.ao_channels.add_ao_voltage_chan('myDAQ1/ao0')

    print('1 Channel 1 Sample Write: ')
    print(task.write(1.0))
    task.stop()

    print('1 Channel N Samples Write: ')
    print(task.write([1.1, 2.2, 3.3, 4.4, 5.5], auto_start=True))
    task.stop()
