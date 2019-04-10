#include <RFduinoGZLL.h>
#include <Wire.h>
device_t role = DEVICE4;
byte BNO = 0x28; // BNO055 address
byte R_OPRmode = 0x3D;
byte R_PWRmode = 0x3E;
/* remember to mask out the first four bit of previous operation mode because
those four bits are reserved. This mask is done in the BNOmode function */
byte AccMag_mode = B00000100;
byte Config_mode = B00000000;
byte NDOF_mode = B00001100;
byte IMU_mode = B00001000;
byte Gyro_mode = B00000011;
byte resetregister = 0x3F;

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
int w, x, y, z;
double Q;
String calib_status;
byte calib_acc, calib_gyr, calib_mag, calib_sys;
byte c,m,a,g,s;  
byte dum;
String final="";
void setup() {
    Serial.begin(115200); 
  RFduinoGZLL.begin(role);
      Serial.print("Setup");
  RFduinoGZLL.txPowerLevel=4;
  Serial.print("flg1");
  pinMode(3,OUTPUT);
  Serial.print("flg1");
  // put your setup code here, to run once:
  while (BNOmode(Config_mode)!=0){    Serial.print("flg2");};  
      Serial.print("flg3");
delay(25);

  resetPWR();
    Serial.print("Power reset");
  delay(25);
  resetIMU();
      Serial.print("IMU reset");
  delay(25);
  Wire.begin();
  Serial.print("Setup");
  
while (BNOmode(NDOF_mode)!=0){};
Serial.print("NDOF ON");
  
}

void loop() {
  // put your main code here, to run repeatedly: 
int16_t q0 = BNOgetQuat(R_q0);
int16_t q1 = BNOgetQuat(R_q1);
int16_t q2 = BNOgetQuat(R_q2);
int16_t q3 = BNOgetQuat(R_q3);
//double w = double(q0)*pow(2,-14);
//double x = double(q1)*pow(2,-14);
//double y = double(q2)*pow(2,-14);
//double z = double(q3)*pow(2,-14);
//Q = w*w+x*x+y*y+z*z;
w = map(q0,-16384,16384,0,200);
x = map(q1,-16384,16384,0,200);
y = map(q2,-16384,16384,0,200);
z = map(q3,-16384,16384,0,200);
final="";
final="c,"+String(w)+","+String(x)+","+String(y)+","+String(z)+"\n";
Serial.print(final);
char mydata[final.length()+1];
final.toCharArray(mydata,final.length()+1);
RFduinoGZLL.sendToHost(mydata,final.length()+1);
digitalWrite(3,HIGH);
delay(random(10,25));
//Serial.print(w);Serial.print(", ");Serial.print(x);Serial.print(", ");Serial.print(y);Serial.print(", ");Serial.print(z);Serial.print(", ");Serial.println(Q);
//Serial.print(q0);Serial.print(", ");Serial.print(q1);Serial.print(", ");Serial.print(q2);Serial.print(", ");Serial.println(q3);

}

byte BNOmode(byte mode){
  
  byte exval;
  byte val;
  byte ok;
  byte flag = 0;
  bool flg=1;
  while (flag <= 1){
  Wire.beginTransmission(BNO);
  Wire.write(R_OPRmode);
  flg = Wire.endTransmission();
  if(flg==0){Serial.print("flg=0");}
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

  String BNOcalib()
  {
  byte c;
  String calib;
  byte a,m,g,s;
  bool flag = 0;
  while(flag == 0){
  Wire.beginTransmission(BNO);
  Wire.write(R_calib);
  delay(25);
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
  return calib;
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
