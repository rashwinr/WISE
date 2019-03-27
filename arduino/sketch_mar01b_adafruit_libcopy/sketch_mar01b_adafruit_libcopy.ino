#include <Wire.h>

byte BNO055_QUATERNION_DATA_W_LSB_ADDR                       = 0X20;
byte BNO = 0x28; // BNO055 address
byte R_OPRmode = 0x3D;
byte NDOF_mode = B00001100;
byte Config_mode = B00000000;
uint16_t w,x,y,z;
double Q,W,X,Y,Z;

void setup() {
  // put your setup code here, to run once:
  Wire.begin();
  Serial.begin(115200); 
while (BNOmode(NDOF_mode)!=0){};
}

void loop() {
  // put your main code here, to run repeatedly:
getQuat();
delay(20);
const double scale = (1.0 / (1<<14));
W = w*scale;
X = x*scale;
Y = y*scale;
Z = z*scale;
Q = W*W+X*X+Y*Y+Z*Z;
Serial.print(w);Serial.print(", ");Serial.print(x);Serial.print(", ");Serial.print(y);Serial.print(", ");Serial.println(z);
Serial.print(W);Serial.print(", ");Serial.print(X);Serial.print(", ");Serial.print(Y);Serial.print(", ");Serial.print(Z);Serial.print(", ");Serial.println(Q);
}





void getQuat()
{
  uint8_t buffer[8];
//  memset (buffer, 0, 8);
  int16_t x, y, z, w;
  x = y = z = w = 0;
  /* Read quat data (8 bytes) */
  readLen(0x20, buffer, 8);
  w = (((uint16_t)buffer[1]) << 8) | ((uint16_t)buffer[0]);
  x = (((uint16_t)buffer[3]) << 8) | ((uint16_t)buffer[2]);
  y = (((uint16_t)buffer[5]) << 8) | ((uint16_t)buffer[4]);
  z = (((uint16_t)buffer[7]) << 8) | ((uint16_t)buffer[6]);

}


void readLen(uint8_t reg, byte * buffer, uint8_t len)
{
  Wire.beginTransmission(BNO);
  Wire.write((uint8_t)reg);
  Wire.endTransmission();
  Wire.requestFrom(BNO, (byte)len);

  for (uint8_t i = 0; i < len; i++)
  {
      buffer[i] = Wire.read();
  }

  /* ToDo: Check for errors! */
  return;
}



byte BNOmode(byte mode){
  byte exval;
  byte val;
  byte ok;
  byte flag = 0;
  while (flag <= 1){
  Wire.beginTransmission(BNO);
  Wire.write(R_OPRmode);
  Wire.endTransmission();
  Wire.requestFrom(BNO,1);
  if (Wire.available()==1)
  {
   exval = Wire.read();
   bitClear(exval,0);
   bitClear(exval,1);
   bitClear(exval,2);
   bitClear(exval,3);
   if (flag==0){val = Config_mode|exval;}
   else        {val = (mode|exval);}
   Wire.beginTransmission(BNO);
   Wire.write(R_OPRmode);
   Wire.write(val);
   ok = Wire.endTransmission();
   if (ok == 0){flag += 1;}
   }
    }

  return ok;}
