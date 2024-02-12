int IN1=26;
int IN2=27;
int IN3=28;
int IN4=29;
int IN5=30;
int IN6=31;
int IN7=32;
int IN8=33;
int EN1=24;
int EN2=25;
int F=40;
int B=47;

void setup() 
{
  Serial.begin(9600);
  pinMode(IN1,OUTPUT);
  pinMode(IN2,OUTPUT);
  pinMode(IN3,OUTPUT);
  pinMode(IN4,OUTPUT);
  pinMode(IN5,OUTPUT);
  pinMode(IN6,OUTPUT);
  pinMode(IN7,OUTPUT);
  pinMode(IN8,OUTPUT);
  pinMode(EN1,OUTPUT);
  pinMode(EN2,OUTPUT);
  pinMode(F,INPUT);
  pinMode(B,INPUT);
  digitalWrite(EN1,HIGH);
  digitalWrite(EN2,HIGH);
  /*digitalWrite(IN1,LOW);
  digitalWrite(IN2,LOW);
  digitalWrite(IN3,LOW);
  digitalWrite(IN4,LOW);
  digitalWrite(IN5,LOW);
  digitalWrite(IN6,LOW);
  digitalWrite(IN7,LOW);
  digitalWrite(IN8,LOW);*/

}
void loop() 
{
/*int F1=digitalRead(F);
int B1=digitalRead(B);*/

if(digitalRead(B)){
  Serial.print("back "+String(digitalRead(B)));
    digitalWrite(IN1,LOW);
    digitalWrite(IN2,HIGH);
    digitalWrite(IN3,LOW);
    digitalWrite(IN4,HIGH);
    digitalWrite(IN5,LOW);
    digitalWrite(IN6,HIGH);
    digitalWrite(IN7,LOW);
    digitalWrite(IN8,HIGH);
   }    //bot movement backward
else if(digitalRead(F)){
    Serial.print("front "+String(digitalRead(F)));
    digitalWrite(IN1,HIGH);
    digitalWrite(IN2,LOW);
    digitalWrite(IN3,HIGH);
    digitalWrite(IN4,LOW);
    digitalWrite(IN5,HIGH);
    digitalWrite(IN6,LOW);
    digitalWrite(IN7,HIGH);
    digitalWrite(IN8,LOW);
    }    //bot movement front
else
{
  Serial.print("none");
    digitalWrite(IN1,LOW);
    digitalWrite(IN2,LOW);
    digitalWrite(IN3,LOW);
    digitalWrite(IN4,LOW);
    digitalWrite(IN5,LOW);
    digitalWrite(IN6,LOW);
    digitalWrite(IN7,LOW);
    digitalWrite(IN8,LOW);
    }
  }
