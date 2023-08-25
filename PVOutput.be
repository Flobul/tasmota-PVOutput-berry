import json
from urequests import get  # Use urequests for HTTP requests instead of webclient if available

def callPvOutput():
    # Replace the values below with your own keys and ID
    key = "enter_your_pvoutput_key"
    sid = "enter_your_pvoutput_deviceid"
    
    # Get the current date and time using Tasmota's RTC clock
    rtc_data = tasmota.rtc()['local']
    date = tasmota.strftime('%Y%m%d', rtc_data)
    time = tasmota.strftime('%H:%M', rtc_data)
    
    # Get energy data from Tasmota sensors
    sensors = json.load(tasmota.read_sensors())
    power = sensors.get("ENERGY", {}).get("Power", 0)
    energy = sensors.get("ENERGY", {}).get("Total", 0)
    voltage = sensors.get("ENERGY", {}).get("Voltage", 0)
    
    # Build the query URL with the obtained data
    url = "http://pvoutput.org/service/r2/addstatus.jsp?key={}&sid={}&d={}&t={}&v4={}&v3={}&v6={}".format(
        key, sid, date, time, power, energy, voltage)
    
    try:
        # Perform the HTTP GET request to send data to PVOutput
        response = get(url)
        
        if response.status_code == 200:
            print("Data sent successfully to PVOutput.")
        else:
            print("Error sending data to PVOutput. HTTP Status:", response.status_code)
        
        response.close()
    
    except Exception as e:
        print("An error occurred while sending data to PVOutput:", str(e))

# Add the pvoutput command to Tasmota
tasmota.add_cmd('pvoutput', callPvOutput)
