#include <RFduinoGZLL.h>
device_t role = HOST;
char mydata;
int BaseTimer = 0;
int CurrTimer = 0;
String D[5];
void setup()
{
  Serial.begin(4800);
  RFduinoGZLL.begin(role);
  D[0] = "a,0,0,0,0";
  D[1] = "b,0,0,0,0";
  D[2] = "c,0,0,0,0";
  D[3] = "d,0,0,0,0";
  D[4] = "e,0,0,0,0";
}
void loop()
{
  if(BaseTimer == 0)
  {
    BaseTimer = millis();
  }
  CurrTimer = millis() - BaseTimer;
  if(CurrTimer > 5)
  {
    Serial.println(D[0]+","+D[1]+","+D[2]+","+D[3]+","+D[4]);
    BaseTimer = 0;
    CurrTimer = 0;
  }
}
void RFduinoGZLL_onReceive(device_t device, int rssi, char *data, int len)
{
    switch(device)
    {
      case DEVICE0:
      D[0] = data;
      break;
      case DEVICE1:
      D[1] = data;
      break;
      
      case DEVICE2:
      D[2] = data;
      break;
      case DEVICE3:
      D[3] = data;
      break;
      case DEVICE4:
      D[4] = data;
      break;
    }
}
