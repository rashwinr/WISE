#include <Wire.h>
byte BNO = 0x28; // BNO055 address
// operation mode registers addresses and values
byte R_OPRmode = 0x3D;
/* remember to mask out the first four bit of previous operation mode because
those four bits are reserved. This mask is done in the BNOmode function */
byte AccMag_mode = B00000100;
byte Config_mode = B00000000;
byte NDOF_mode = B00001100;
byte IMU_mode = B00001000;
byte Gyro_mode = B00000011;

// data registers
/*these values are the register addresses of the least significant byte of
quaternion data, the address of the MSB always follows the LSB*/
byte R_q0 = 0x20;
byte R_q1 = 0x22;
byte R_q2 = 0x24;
byte R_q3 = 0x26;

/*calibration values register*/
byte R_calib = 0x35;
/*variables*/
int q0, q1, q2, q3;
double Q;
String calib_status;
byte calib_acc, calib_gyr, calib_mag, calib_sys;

byte dum;

void setup() {
  Wire.begin();
  Serial.begin(115200);
  while (BNOmode(NDOF_mode)!=0){};
}

void loop() {
  q0 = BNOgetQuat(R_q0);
  q1 = BNOgetQuat(R_q1);
  q2 = BNOgetQuat(R_q2);
  q3 = BNOgetQuat(R_q3);
    if(q0>16384)
  {
    q0= q0 - 65535; 
  }
    if(q1>16384)
  {
    q1= q1-65535; 
  }
    if(q2>16384)
  {
    q2 = q2-65535; 
  }
    if(q3>16384)
  {
    q3= q3 - 65535; 
  }
  Q = (q0*q0+q1*q1+q2*q2+q3*q3)*pow(2,-28);
  Serial.print("q0 = "); Serial.print(q0);
  Serial.print("| q1 = "); Serial.print(q1);
  Serial.print("| q2 = "); Serial.print(q2);
  Serial.print("| q3 = "); Serial.print(q3);
  Serial.print("| Norm = "); Serial.println(Q);
}

/*BNO055 functions*/

byte BNOread(byte R_addr){
  
  byte data;
  bool flag = 0;
  while(flag == 0){
  Wire.beginTransmission(BNO);
  Wire.write(R_addr);
  Wire.endTransmission();
  Wire.requestFrom(BNO,1);
  if (Wire.available()==1){data = Wire.read();
                           flag = 1;}
  }
  return data;
  
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

int BNOgetQuat(byte R_addr){
  
  byte MSB, LSB;
  bool flag = 0;
  double q;
  while(flag == 0)
  {
   Wire.beginTransmission(BNO);
   Wire.write(R_addr);
   Wire.write(R_addr+0x1);
   Wire.endTransmission();
   Wire.requestFrom(BNO,2);
   if (Wire.available()==2)
                          { LSB = Wire.read();
                            MSB = Wire.read();
                            q = (int(MSB)<<8)|int(LSB);;
                            flag = 1; }
                                        }

  return q;}

String BNOcalib(){
  
  byte c;
  String calib;
  byte a,m,g,s;
  bool flag = 0;
  while(flag == 0){
  Wire.beginTransmission(BNO);
  Wire.write(R_calib);
  Wire.endTransmission();
  Wire.requestFrom(BNO,1);
  if (Wire.available()==1)
  {c = Wire.read();
   m = bitRead(c,1); m = (m<<1)+bitRead(c,0);
   a = bitRead(c,3); a = (a<<1)+bitRead(c,2);
   g = bitRead(c,5); g = (g<<1)+bitRead(c,4);
   s = bitRead(c,7); s = (s<<1)+bitRead(c,6);
   calib = "acc "+String(a)+" mag "+String(m)+" gyr "+String(g)+" sys "+String(s);
   flag = 1;}
  }
  return calib;}
