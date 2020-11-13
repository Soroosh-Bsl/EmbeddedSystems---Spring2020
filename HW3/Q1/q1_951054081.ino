int led = 9;
float wave[3];
int scaledValue;
float readValue;
int sendFreq[4];
int sendVoltage[4];
float time;
float absTime;
float prevSamplingTime = 0.;
float diffSamplingTime = 0.;
float percentage;
float amp;
float offset = 2.5;
float minOutputScale = 0.0;
float maxOutputScale = 5.0;
const float pi = 3.14159;

void setup()
{
  wave[1] = 2.5;
  TCCR1B = TCCR1B & 0b11111000 | 1;
  pinMode(led, OUTPUT);
  Serial.begin(9600);
  delay(50);
  absTime = micros();
  prevSamplingTime = absTime;
  readValue = analogRead(A0);
  wave[0] = ((readValue*19.)/1024) + 1;
  sendInfo();
  
}

void loop()
{
  absTime = micros();
  time = micros() % 1000000;
  percentage = time / 1000000;
  diffSamplingTime = (prevSamplingTime-absTime)/1000000;
  if (diffSamplingTime <= -1 || diffSamplingTime >= 1){
    prevSamplingTime = absTime;
    readValue = analogRead(A0);
  	wave[0] = ((readValue*19.)/1024) + 1;
    sendInfo();
  }
  amp = sin(((percentage) * wave[0]) * 2 * pi);
  wave[2] = (amp * wave[1]) + offset;
  scaledValue = scale(wave[2], minOutputScale, maxOutputScale, 0, 255);
  analogWrite(led, scaledValue);
  
  delayMicroseconds(1);
}

long scale(float x, float in_min, float in_max, long out_min, long out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void sendInfo(){
  sendFreq[0] = ((int) wave[0]); 
  sendFreq[1] = ((int) (10*wave[0]) - 10*sendFreq[0]);
  sendFreq[2] = ((int) (100*wave[0]) - 100*sendFreq[0] - 10*sendFreq[1]);
  sendFreq[3] = ((int) (1000*wave[0]) - 1000*sendFreq[0] - 100*sendFreq[1] - 10*sendFreq[2]);
  Serial.write((char) sendFreq[0]);
  Serial.write((char) sendFreq[1]);
  Serial.write((char) sendFreq[2]);
  Serial.write((char) sendFreq[3]);
    
  sendVoltage[0] = ((int) (readValue*5./1024));
  sendVoltage[1] = ((int) (10*readValue*5./1024) - 10*sendVoltage[0]);
  sendVoltage[2] = ((int) (100*readValue*5./1024) - 100*sendVoltage[0] - 10*sendVoltage[1]);
  sendVoltage[3] = ((int) (1000*readValue*5./1024) - 1000*sendVoltage[0] - 100*sendVoltage[1] - 10*sendVoltage[2]);
  Serial.write((char) sendVoltage[0]);
  Serial.write((char) sendVoltage[1]);
  Serial.write((char) sendVoltage[2]);
  Serial.write((char) sendVoltage[3]);
}