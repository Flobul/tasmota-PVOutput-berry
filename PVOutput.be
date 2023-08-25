import string
import json

def callPvOutput()
  var cl = webclient()
  key = "enter_your_pvoutput_key"
  sid = "enter_your_pvoutput_deviceid"
  var date=tasmota.strftime('%Y%m%d', tasmota.rtc()['local'])
  var time=tasmota.strftime('%H:%M', tasmota.rtc()['local'])
  var sensors = json.load(tasmota.read_sensors())
  var power = sensors["ENERGY"]["Power"]
  var energy = sensors["ENERGY"]["Total"]
  var voltage = sensors["ENERGY"]["Voltage"]
  var url = string.format("http://pvoutput.org/service/r2/addstatus.jsp?key=%s&sid=%s&d=%s&t=%s&v4=%s&v3=%s&v6=%s", key, sid, date, time, 
power, total, voltage)

  cl.begin(url)
  r = cl.GET()
  print(r)
  cl.close()

end

tasmota.add_cmd('pvoutput',callPvOutput)
