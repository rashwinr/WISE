#include <RFduinoGZLL.h>
device_t role = HOST;
char mydata;
String s[5] = {"x","x","x","x","x"};
void setup()
{
  Serial.begin(115200);
  RFduinoGZLL.begin(role);
}

void loop()
{
if(s[0]!="x")
{
Serial.println(s[0]);
delay(20);
}
if(s[1]!="x")
{
Serial.println(s[1]);
delay(20);
}
if(s[2]!="x")
{
Serial.println(s[2]);
delay(20);
}
if(s[3]!="x")
{
Serial.println(s[3]);
delay(20);
}
if(s[4]!="x")
{
Serial.println(s[4]);
delay(20);
}
}
void RFduinoGZLL_onReceive(device_t device, int rssi, char *data, int len)
{
      switch(device)
    {
      case DEVICE0:
      s[0] = String(data);
      break;

      case DEVICE1:
      s[1] = String(data);
      break;
      
      case DEVICE2:
      s[2] = String(data);
      break;

      case DEVICE3:
      s[3] = String(data);
      break;

      case DEVICE4:
      s[4] = String(data);
      break;
    }}
