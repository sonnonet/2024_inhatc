#!/usr/bin/env python
# write by sonnonet 1.2Ver
# CO2 Rev 2.4
# THL Rev 1.6 Extenstion
# PH Rev 1.0 
# Serial to Mysql 

# Data Format
# CO2  Data0
# THL Temperature Data0, Humidity Data1, Illumination Data2, Battery Data3

import sys
import tos
import datetime
import threading
import pymysql


AM_OSCILLOSCOPE = 0x93

conn = pymysql.connect(host='125.7.128.42', user='root', password='fxoo0880', db='test',charset='utf8')

sql = ""

class OscilloscopeMsg(tos.Packet):
    def __init__(self, packet = None):
        tos.Packet.__init__(self,
                            [('srcID',  'int', 2),
                             ('seqNo', 'int', 4),
                             ('type', 'int', 2),
                             ('Data0', 'int', 2),
                             ('Data1', 'int', 2),
                             ('Data2', 'int', 1),
                             ('Data3', 'int', 1),
                             ('Data4', 'int', 2),
                             ],
                            packet)
if '-h' in sys.argv:
    print "Usage:", sys.argv[0], "serial@/dev/ttyUSB0:57600"
    sys.exit()

am = tos.AM()

#def pbrNum_return(x):
#	return {100:5,
#		101:6,
#		102:7,
#		}.get(x,0) 

while True:
    p = am.read()
    msg = OscilloscopeMsg(p.data)
    print p
####### CO2 Logic ############
    if msg.type == 1:
#	pbr_Num = pbrNum_return(msg.srcID)
	pbr_Num = 3
	CO2 = msg.Data0
	CO2 = 1.5 * CO2 / 4096 * 2 * 1000
	### MySQL Insert ###
        try:
            with conn.cursor() as curs:
                Now = datetime.datetime.now()
                sql = """insert into JB_Sensor_CO2(NODE_ID,SEQ,CO2,PBR_NUM,REGDATE)
                        values(%s, %s, %s, %s, %s)"""
                curs.execute(sql,(msg.srcID,msg.seqNo,CO2,pbr_Num,Now))
                conn.commit()
        except:
            conn.close()
        print "ID:",msg.srcID, "seqNo:",msg.seqNo, "CO2:",CO2
####### THL Logic ############
    if msg.type == 2:
        battery = msg.Data4
 #       battery = 0

        Illumi = int(msg.Data2)+ int(msg.Data3*256) 
        Illumi = Illumi 
        humi = -2.0468 + (0.0367*msg.Data1) + (-1.5955*0.000001)*msg.Data1*msg.Data1
        temp = -(39.6) + (msg.Data0 * 0.01)
        try:
            with conn.cursor() as curs:
				Now = datetime.datetime.now()
				sql = """insert into JB_Sensor_THL(NODE_ID,SEQ,TEMPERATURE,HUMIDITY,ILLUMINATION,REGDATE) \
                                    values(%s, %s, %s, %s, %s, %s)"""
				curs.execute(sql,(msg.srcID,msg.seqNo,temp,humi,Illumi,Now))
				conn.commit()
        except all,e:
	    print e.args
	    conn.close()
        print "id:" , msg.srcID, " Count : ", msg.seqNo, \
                "Temperature: ",temp, "Humidity: ",humi, "Illumination: ",Illumi, "Battery : ", battery

####### PH Sensor Logic #############
    if msg.type == 3:
        #hex1 = hex(msg.Data2)
        #hex1 = hex1[:-1]
        #hex2 = hex(msg.Data2_1)
        #hex2 = hex2[:-1]
#        print "before : ", PH_str
#        print (int(hex1,0)), (int(hex2,0))
#        print hex(msg.Data2), hex(msg.Data2_1)
        
        PH = msg.Data0
        PH = ((float(PH) * 5)/4096)*3.5
        PH = PH - 1
        try:
            with conn.cursor() as curs:
                Now = datetime.datetime.now()
                sql = """insert into JB_Sensor_PH(NODE_ID,PH,PBR_NUM,REGDATE) \
                        values(%s, %s, %s, %s)"""
                curs.execute(sql,(msg.srcID,PH,3,Now))
                conn.commit()
        except all,e:
            print e.args
            conn.close()
        print "ID:",msg.srcID, "PH:",PH
#       print PH

