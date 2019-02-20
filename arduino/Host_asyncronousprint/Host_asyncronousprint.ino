#include <RFduinoGZLL.h>
device_t role = HOST;
char mydata;
String Data;
void setup()
{
  Serial.begin(4800);
  RFduinoGZLL.begin(role);
}

void loop()
{

}
void RFduinoGZLL_onReceive(device_t device, int rssi, char *data, int len)
{
    switch(device)
    {
      case DEVICE0:
      Data = check(Data,String(data));
      break;

      case DEVICE1:
      Data = check(Data,String(data));
      break;
      
      case DEVICE2:
      Data = check(Data,String(data));
      break;

      case DEVICE3:
      Data = check(Data,String(data));
      break;

      case DEVICE4:
      Data = check(Data,String(data));
      break;
    }
        if(Data != "")
  {
  Serial.println(Data);
  }
//  delay(10);
  Data = "";
//  delay(5);
}


String check (String a, String b)
{
if(a != "")
      {
      a = a + ","+b;
      }
      else if(a == "")
      {
      a = b;
      }
      return a;
}
