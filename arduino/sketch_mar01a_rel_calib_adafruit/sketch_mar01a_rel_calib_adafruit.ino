#include <RFduinoGZLL.h>
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>
device_t role = DEVICE4;
Adafruit_BNO055 bno = Adafruit_BNO055(1,0x28);
String final="";
void setup() {
  // put your setup code here, to run once:
  RFduinoGZLL.begin(role);
  RFduinoGZLL.txPowerLevel=4;
  Serial.begin(115200);
  pinMode(3,OUTPUT);
  if(!(bno.begin()))
  {
    /* There was a problem detecting the BNO055 ... check your connections */
//    Serial.print("Ooops, no BNO055_0 and 1 detected ... Check your wiring or I2C ADDR!");
    while(1);
  }
  delay(1000);
//  int8_t temp = bno.getTemp();
  bno.setExtCrystalUse(true);
}

void loop() {
digitalWrite(3,LOW);
imu::Quaternion quat = bno.getQuat();
int w = (int)((quat.w()*100)+100);
int x = (int)((quat.x()*100)+100);
int y = (int)((quat.y()*100)+100);
int z = (int)((quat.z()*100)+100);
final="";
final="c,"+String(w)+","+String(x)+","+String(y)+","+String(z)+"\n";
Serial.print(final);
char mydata[final.length()+1];
final.toCharArray(mydata,final.length());
//Serial.println(mydata);
RFduinoGZLL.sendToHost(mydata,final.length()+1);
displayCalStatus();
digitalWrite(3,HIGH);
delay(random(10,25));
}


void displayCalStatus(void)
{
  /* Get the four calibration values (0..3) */
  /* Any sensor data reporting 0 should be ignored, */
  /* 3 means 'fully calibrated" */
  uint8_t system, gyro, accel, mag;
  system = gyro = accel = mag = 0;
  bno.getCalibration(&system, &gyro, &accel, &mag);

  /* The data should be ignored until the system calibration is > 0 */
  Serial.print("\t");
  if (!system)
  {
    Serial.print("! ");
  }

  /* Display the individual values */
  Serial.print("Sys:");
  Serial.print(system, DEC);
  Serial.print(" G:");
  Serial.print(gyro, DEC);
  Serial.print(" A:");
  Serial.print(accel, DEC);
  Serial.print(" M:");
  Serial.println(mag, DEC);
}
