#include <RFduinoGZLL.h>
#include <Wire.h>
device_t role = DEVICE3;
byte BNO = 0x28; // BNO055 address

byte R_OPRmode = 0x3D;
byte R_PWRmode = 0x3E;
byte SYS_Trigger = 0x3F;
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
int16_t q0, q1, q2, q3;
unsigned int Q0, Q1, Q2, Q3;
byte c,m,a,g,s;  
bool flg = 0;

void setup() {
pinMode(3,OUTPUT);
  Wire.beginOnPins(5,6);
  Serial.begin(115200); 
while (BNOmode(Config_mode)!=0){};  
delay(25);
  resetPWR();
  resetIMU();
while (BNOmode(NDOF_mode)!=0){};
 RFduinoGZLL.begin(role);
 RFduinoGZLL.txPowerLevel=4;
}

void loop() {
  while (flg == 0)
  {
    while (m<3 ||a<3 ||g<3 ||s<3)
    {
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
        }
          String D3_cal = "cal,d,"+String(m)+","+String(a)+","+String(g)+","+String(s);
          char mydata_cal[D3_cal.length()+1];
          D3_cal.toCharArray(mydata_cal,D3_cal.length()+1);
          RFduinoGZLL.sendToHost(mydata_cal,D3_cal.length()+1);
          delay(random(10,25));
          } 
  flg = 1;
  }
q0 = BNOgetQuat(R_q0);
q1 = BNOgetQuat(R_q1);
q2 = BNOgetQuat(R_q2);
q3 = BNOgetQuat(R_q3);
Q0 = map(q0,-16384,16384,0,999);
Q1 = map(q1,-16384,16384,0,999);
Q2 = map(q2,-16384,16384,0,999);
Q3 = map(q3,-16384,16384,0,999);
String D3 = "d,"+String(Q0)+","+String(Q1)+","+String(Q2)+","+String(Q3);
char mydata[D3.length()+1];
D3.toCharArray(mydata,D3.length()+1);
RFduinoGZLL.sendToHost(mydata,D3.length()+1);
delay(random(10,25));
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
   delay(10);
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
  byte rst = BNOread(SYS_Trigger);
  bitSet(rst,5);
  Wire.beginTransmission(BNO);
  Wire.write(SYS_Trigger);
  delay(10);
  Wire.write(rst);
  Wire.endTransmission();
  delay(10);
  rst = BNOread(SYS_Trigger);
  bitSet(rst,7);
  Wire.beginTransmission(BNO);
  Wire.write(SYS_Trigger);
  delay(10);
  Wire.write(rst);
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
                          { 
                            LSB = Wire.read();
                            MSB = Wire.read();
                            q = (int16_t(MSB)<<8)|int16_t(LSB);
                            flag = 1; 
                            }
  }
  return q;
  }
