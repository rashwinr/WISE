#include <RFduinoGZLL.h>
device_t role = HOST;
char mydata;
String s[5] = {"0","0","0","0","0"};
void setup()
{
  Serial.begin(115200);
  RFduinoGZLL.begin(role);
}

void loop()
{
  
if(s[0]!="0")
{
Serial.println(s[0]);
//delayMicroseconds(500);
delay(20);
}
if(s[1]!="0")
{
Serial.println(s[1]);
//delayMicroseconds(500);
delay(20);
}
//Serial.println(s[1]);
if(s[2]!="0")
{
Serial.println(s[2]);
//delayMicroseconds(500);
delay(20);
}
//Serial.println(s[2]);
if(s[3]!="0")
{
Serial.println(s[3]);
//delayMicroseconds(500);
delay(20);
}
if(s[4]!="0")
{
Serial.println(s[4]);
//delayMicroseconds(500);
delay(20);
}

}

void RFduinoGZLL_onReceive(device_t device, int rssi, char *data, int len)
{
//  Serial.println(data);
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
    }
    
//  if(Serial.available())
//  {
//  if (device == DEVICE0 || device == DEVICE1 || device == DEVICE3)
//  {
//  String str(data);
//  Serial.print(str);
//  Serial.print(",");
//  }
//  if(device == DEVICE2)
//  {
//  String str(data);
//  str = str;
//  Serial.println(str);
//  }
//if(Serial.read() == 'a')
//{
//  if(s[0] != "0")s
//  {
//  Serial.print(s[0]);
//  Serial.print(",");
//  }
//  if(s[1] != "0")
//  {
//  Serial.print(s[1]);
//    Serial.print(",");
//  }
//  if(s[2] != "0")
//  {
//  Serial.print(s[2]);
//    Serial.print(",");
//  }
//  if(s[3] != "0")
//  {
//  Serial.print(s[3]);
//    Serial.print(",");
//  }
//  if(s[4] != "0")
//  {
//  Serial.print(s[4]);
//    Serial.print(",");
//  } 
//  Serial.println("|");
//}
//if(Serial.read() =='b')
//{
//  Serial.print(17);
//}
  }
//  delay(10);
// Serial.clear();
