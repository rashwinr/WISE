#include <RFduinoGZLL.h>
#include <Wire.h>
device_t role = DEVICE4;
byte BNO = 0x28; // BNO055 address
byte R_OPRmode = 0x3D;
byte R_PWRmode = 0x3E;
byte resetregister = 0x3F;
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
double q0, q1, q2, q3;
double Q;
String calib_status;
byte calib_acc, calib_gyr, calib_mag, calib_sys;
byte c,m,a,g,s;  
byte dum;

void setup() {
pinMode(3,OUTPUT);
  // put your setup code here, to run once:
  Wire.beginOnPins(5,6);
//  Serial.begin(115200); 
while (BNOmode(Config_mode)!=0){};  
delay(25);
  resetPWR();
  resetIMU();
while (BNOmode(NDOF_mode)!=0){};
 RFduinoGZLL.begin(role);
 RFduinoGZLL.txPowerLevel=4;
}

void loop() {
//  Serial.println("Shitting in loop");
  // put your main code here, to run repeatedly: 
//  digitalWrite(3,LOW);
  Wire.beginTransmission(BNO);
  Wire.write(R_calib);
  Wire.endTransmission();
  Wire.requestFrom(BNO,1);
  if (Wire.available()==1)
  {
   c = Wire.read();
   m = bitRead(c,1); m = (m<<1)+bitRead(c,0);
   a = bitRead(c,3); a = (a<<1)+bitRead(c,2);
   g = bitRead(c,5); g = (g<<1)+bitRead(c,4);
   s = bitRead(c,7); s = (s<<1)+bitRead(c,6);
String s2 = "f,"+String(s)+","+String(g)+","+String(a)+","+String(m);
char mydata1[s2.length()+1];
s2.toCharArray(mydata1,s2.length()+1);
RFduinoGZLL.sendToHost(mydata1,s2.length()+1);
Serial.println(mydata1);
delay(random(10,25));
   }
while(m==3 && g==3 && a==3 && s==3)
{
int q0 = BNOgetQuat(R_q0);
int q1 = BNOgetQuat(R_q1);
int q2 = BNOgetQuat(R_q2);
int q3 = BNOgetQuat(R_q3);
q0 = map(q0,0,65535,0,200);
q1 = map(q1,0,65535,0,200);
q2 = map(q2,0,65535,0,200);
q3 = map(q3,0,65535,0,200);
String s1 = "c,"+String(q0)+","+String(q1)+","+String(q2)+","+String(q3);
char mydata[s1.length()+1];
s1.toCharArray(mydata,s1.length()+1);
RFduinoGZLL.sendToHost(mydata,s1.length()+1);
Serial.println(s1);
digitalWrite(3,HIGH);
delay(random(10,25));
  Wire.beginTransmission(BNO);
  Wire.write(R_calib);
  Wire.endTransmission();
  Wire.requestFrom(BNO,1);
  if (Wire.available()==1)
  {
   c = Wire.read();
   m = bitRead(c,1); m = (m<<1)+bitRead(c,0);
   a = bitRead(c,3); a = (a<<1)+bitRead(c,2);
   g = bitRead(c,5); g = (g<<1)+bitRead(c,4);
   s = bitRead(c,7); s = (s<<1)+bitRead(c,6);
   digitalWrite(3,LOW);
  }
}
}

byte BNOmode(byte mode)
{
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
  return ok;
  }

void resetIMU()
{
  bool ok = 1;
  while (ok==1){
  byte resetinfo = BNOread(resetregister);
  bitClear(resetinfo,6);
  Wire.beginTransmission(BNO);
  Wire.write(resetinfo);
  delay(10);
  bitSet(resetinfo,6);
  bitSet(resetinfo,8);
  Wire.beginTransmission(BNO);
  Wire.write(resetinfo);
  delay(10);
  Wire.endTransmission();
  Wire.beginTransmission(BNO);
  Wire.write(resetregister);
  Wire.write(0x80);
    delay(10);
  ok = Wire.endTransmission();
  }
  return;
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


byte BNOread(byte R_addr)
{  
  byte data;
  bool flag = 0;
  while(flag == 0){
  Wire.beginTransmission(BNO);
  Wire.write(R_addr);
  Wire.endTransmission();
  Wire.requestFrom(BNO,1);
  if (Wire.available()==1)
  {
    data = Wire.read();
    flag = 1;
    }
  }
  return data;
}


//void setExternalCrystalUse(){
//while (BNOmode(Config_mode)!=0){}; 
//  delay(25);
//  Wire.beginTransmission(BNO);
//  Wire.write();
//  Wire.endTransmission();
//}




  int BNOgetQuat(byte R_addr)
  {
  byte MSB, LSB;
  bool flag = 0;
  int q;
  while(flag == 0)
  {
   Wire.beginTransmission(BNO);
   Wire.write(R_addr);
   Wire.write(R_addr+0x1);
   Wire.endTransmission();
   Wire.requestFrom(BNO,2);
   if (Wire.available()==2)
                          { 
                            LSB = Wire.read();
                            MSB = Wire.read();
                            q = (int(MSB)<<8)|int(LSB);
                            flag = 1; 
                            }
  }
  return q;
  }


//
//    String BNOcalib()
//  {
//  byte c;
//  String calib;
//  byte a,m,g,s;
//  bool flag = 0;
//  while(flag == 0){
//  Wire.beginTransmission(BNO);
//  Wire.write(R_calib);
//  Wire.endTransmission();
//  Wire.requestFrom(BNO,1);
//  if (Wire.available()==1)
//  {
//   c = Wire.read();
//   m = bitRead(c,1); m = (m<<1)+bitRead(c,0);
//   a = bitRead(c,3); a = (a<<1)+bitRead(c,2);
//   g = bitRead(c,5); g = (g<<1)+bitRead(c,4);
//   s = bitRead(c,7); s = (s<<1)+bitRead(c,6);
//   calib = "acc "+String(a)+" mag "+String(m)+" gyr "+String(g)+" sys "+String(s);
//   flag = 1;
//   }
//  }
//  return calib;
//  }

//while(m<3 || g<3 || a<3 || s<3)
//{
////   Serial.println("Inside while calib");
//     Wire.beginTransmission(BNO);
//  Wire.write(R_calib);
//  Wire.endTransmission();
//  Wire.requestFrom(BNO,1);
//  if (Wire.available()==1)
//  {
////    Serial.print("Wire is available");
//  Wire.beginTransmission(BNO);
//  Wire.write(R_calib);
//  Wire.endTransmission();
//  Wire.requestFrom(BNO,1);
//   c = Wire.read();
//   m = bitRead(c,1); m = (m<<1)+bitRead(c,0);
//   a = bitRead(c,3); a = (a<<1)+bitRead(c,2);
//   g = bitRead(c,5); g = (g<<1)+bitRead(c,4);
//   s = bitRead(c,7); s = (s<<1)+bitRead(c,6);
//   digitalWrite(3,LOW);
//String s2 = "f,"+String(s)+","+String(g)+","+String(a)+","+String(m);
//char mydata1[s2.length()+1];
//s2.toCharArray(mydata1,s2.length()+1);
//RFduinoGZLL.sendToHost(mydata1,s2.length()+1);
//Serial.println(mydata1);
//delay(random(10,25));
//   }
//      Serial.print("System calib: "+String(s));
//      Serial.print("\tGyroscope calib: " + String(g));
//      Serial.print("\tAcceleration calib: " + String(a));
//      Serial.println("\tMagnetometer calib: " + String(m)); 
//}
