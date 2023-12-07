#!/usr/bin/env python
# write by sonnonet 1.5Ver
# 2023-12-05
# CO2 Rev 2.4
# THL Rev 1.6 Extenstion
# PH Rev 1.0 
# Serial to Print

# Data Format
# CO2  Data0
# THL Temperature Data0, Humidity Data1, Illumination Data2, Battery Data3

import sys
import tos
import datetime
import threading
from influxdb import InfluxDBClient as influxdb
import requests, json
import time

AM_OSCILLOSCOPE = 0x93

class OscilloscopeMsg(tos.Packet):
    def __init__(self, packet = None):
        tos.Packet.__init__(self,
                            [('srcID',  'int', 2),
                             ('seqNo', 'int', 4),
                             ('type', 'int', 2),
                             ('Data0', 'int', 2),
                             ('Data1', 'int', 2),
                             ('Data2', 'int', 2),
                             ('Data3', 'int', 2),
                             ('Data4', 'int', 2),
                             ],
                            packet)
if '-h' in sys.argv:
    print ("Usage:", sys.argv[0], "serial@/dev/ttyUSB0:57600")
    sys.exit()

am = tos.AM()

while True:
    p = am.read()
    msg = OscilloscopeMsg(p.data)
    print(p)
	
####### THL Logic ############
    if msg.type == 2:
        battery = msg.Data3

        Illumi = int(msg.Data2)
        humi = -2.0468 + (0.0367*msg.Data1) + (-1.5955*0.000001)*msg.Data1*msg.Data1
        temp = -(39.6) + (msg.Data0 * 0.01)

        data = [{
            'measurement' : 'office',
            'tags':{
                'seochang' : '10',
            },
            'fields':{
                'Temperature' : temp,
                'humidity' : humi,
                'Lux' : Illumi,
                'battery' : battery,
            }
        }]
        client = None

        try:
            client = influxdb('localhost', 8086, 'root', 'root', 'THL')
        except Exception as e:
            print("Exception : " ,e)
        if client is not None:
            try:
                client.write_points(data)
                print("Influxdb insert OK")
            except Exception as e:
                print("Exception write_point ", e)
            finally:
                client.close()


	    
        print ("id:" , msg.srcID, " Count : ", msg.seqNo, \
                "Temperature: ",temp, "Humidity: ",humi, "Illumination: ",Illumi, "Battery : ", battery)


