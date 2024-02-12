#include <Wire.h>
#include <I2Cdev.h>
#include <MPU6050.h>

MPU6050 mpu(0x68);
int IN4=4;
int IN3=5;
int IN2=6;
int IN1=7;


int16_t rx, ry, rz;                                             //r--right hand  l--left hand
int16_t g1x, g1y, g1z;        

/*pins2,3,A4,A5 are used
2--right
3--left
ADO of left hand is ground*/

void setup() 
{
  Wire.begin();
  Serial.begin(9600);
  Serial.println("Initialize MPU");
  mpu.initialize();
  pinMode(IN1,OUTPUT);
  pinMode(IN2,OUTPUT);
  pinMode(IN3,OUTPUT);
  pinMode(IN4,OUTPUT);
  Serial.println(mpu.testConnection() ? "1. Connected" : "1. Connection failed");
}
void loop() 
{
  mpu.getMotion6(&rx, &ry, &rz, &g1x, &g1y, &g1z);
  Serial.print("  rx=");
  Serial.print(rx);
  Serial.print("  ry=");
  Serial.print(ry);
  Serial.print("  rz=");
  Serial.println(rz);
if(rx>8000){
  Serial.print("back");
    digitalWrite(IN1,LOW);
    digitalWrite(IN2,HIGH);
    digitalWrite(IN3,LOW);
    digitalWrite(IN4,HIGH);
    while(rx>8000)
    mpu.getMotion6(&rx, &ry, &rz, &g1x, &g1y, &g1z); 
   }    //bot movement backward
if(rx<-7000){
    Serial.print("front");
    digitalWrite(IN1,HIGH);
    digitalWrite(IN2,LOW);
    digitalWrite(IN3,HIGH);
    digitalWrite(IN4,LOW);
    while(rx<-7000)
    mpu.getMotion6(&rx, &ry, &rz, &g1x, &g1y, &g1z); 
    }    //bot movement front
if(7000>rx>-7000){
    digitalWrite(IN1,LOW);
    digitalWrite(IN2,LOW);
    digitalWrite(IN3,LOW);
    digitalWrite(IN4,LOW);
    }
  }
