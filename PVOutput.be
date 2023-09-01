import string
import json

def callPvOutput()
    # Replace the values below with your own keys and ID
    key = "enter_your_pvoutput_key"
    sid = "enter_your_pvoutput_deviceid"
    
    # Declare webclient
    var cl = webclient()

    # Get the current date and time using Tasmota's RTC clock
    var rtc_data = tasmota.rtc()['local']
    var date = tasmota.strftime('%Y%m%d', rtc_data)
    var time = tasmota.strftime('%H:%M', rtc_data)
    
    # Get energy data from Tasmota sensors
    var sensors = json.load(tasmota.read_sensors())
    var power = sensors["ENERGY"]["Power"]
    var energy = sensors["ENERGY"]["Total"]
    var voltage = sensors["ENERGY"]["Voltage"]
    
    # Build the query URL with the obtained data
    var url = string.format("http://pvoutput.org/service/r2/addstatus.jsp?key=%s&sid=%s&d=%s&t=%s&v4=%s&v3=%s&v6=%s", key, sid, date, time, 
power, energy, voltage)

    # Perform the HTTP GET request to send data to PVOutput
    cl.begin(url)
    var response = cl.GET()

    if response
        print("Data sent successfully to PVOutput.")
    else
        print("Error sending data to PVOutput. HTTP Status:", response.status_code)
    end
    cl.close()

end

# Add the pvoutput command to Tasmota
tasmota.add_cmd('pvoutput', callPvOutput)
