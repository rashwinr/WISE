#include <RFduinoGZLL.h>
#include <Wire.h>
device_t role = DEVICE4;
byte BNO = 0x28; // BNO055 address
byte R_PWRmode = 0x3E;
byte R_OPRmode = 0x3D;
byte Sys_trig = 0x3F;
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
double Q;
String calib_status;
byte calib_acc, calib_gyr, calib_mag, calib_sys;
byte c,m,a,g,s;  

void setup() {
  // put your setup code here, to run once:
  RFduinoGZLL.begin(role);
  RFduinoGZLL.txPowerLevel=4;
  pinMode(3,OUTPUT);
  Wire.begin();
  Serial.begin(115200); 
  while (BNOmode(Config_mode)!=0){};
  while (BNOclock()!=0){};
  while (BNOmode(NDOF_mode)!=0){};
  }

void loop() {
  digitalWrite(3,LOW);
  // put your main code here, to run repeatedly: 
int16_t q0 = BNOgetQuat(R_q0);
int16_t q1 = BNOgetQuat(R_q1);
int16_t q2 = BNOgetQuat(R_q2);
int16_t q3 = BNOgetQuat(R_q3);
int w = map(q0,-16384,+16384,0,999);
int x = map(q1,-16384,+16384,0,999);
int y = map(q2,-16384,+16384,0,999);
int z = map(q3,-16384,+16384,0,999);
String final="d,"+String(w)+","+String(x)+","+String(y)+","+String(z)+"\n";
Serial.print(final);
char mydata[final.length()];
final.toCharArray(mydata,final.length());
//Serial.println(mydata);
RFduinoGZLL.sendToHost(mydata,final.length());
digitalWrite(3,HIGH);
delay(random(10,25));
}

void resetPWR()
{
  bool ok = 1;
  while (ok==1){
  Wire.beginTransmission(BNO);
  Wire.write(R_PWRmode);
  Wire.write(0x00);
  delay(10);
  ok = Wire.endTransmission();
  }
  return;
}


bool BNOmode(byte mode){
  byte exval;
  byte val;
  byte ok;
  byte flag = 0;
  while (flag <= 1){
  Wire.beginTransmission(BNO);
  Wire.write(R_OPRmode);
  delay(10);
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


int16_t BNOgetQuat(byte R_addr){
  byte MSB, LSB;
  bool flag = 0;
  int16_t q;
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
                            q = (int16_t(MSB)<<8)|int16_t(LSB);
                            flag = 1; }
  }
  return q;}



  bool BNOclock()
{
  bool ok = 1;
  while (ok==1){
  byte resetinfo = BNOread(Sys_trig);
  bitSet(resetinfo,7);
  Wire.beginTransmission(BNO);
  Wire.write(Sys_trig);
  Wire.write(resetinfo);
  ok = Wire.endTransmission();
 }
  return ok;
  }



//
//  bool BNOreset()
//{
//  bool ok = 1;
//  while (ok==1){
//  byte resetinfo = BNOread(Sys_trig);
//  bitSet(resetinfo,5);
//  Wire.beginTransmission(BNO);
//  Wire.write(Sys_trig);
//  Wire.write(resetinfo);
//  if (Wire.endTransmission()==0){
//        resetinfo = BNOread(Sys_trig);
//        bitClear(resetinfo,5);
//        Wire.beginTransmission(BNO);
//        Wire.write(Sys_trig);
//        Wire.write(resetinfo);
//        if (Wire.endTransmission()==0){
//              resetinfo = BNOread(Sys_trig);
//              bitSet(resetinfo,7);
//              Wire.beginTransmission(BNO);
//              Wire.write(Sys_trig);
//              Wire.write(resetinfo);
//              ok = Wire.endTransmission();}
//              }
//  }
//  return ok;}
