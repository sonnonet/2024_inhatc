int vo = A0;
int v_led = 2;

float vo_value=0;
float voltage = 0;
float dustDensity = 0;

void setup(){
  Serial.begin(9600);
  pinMode(2, OUTPUT);
  pinMode(A0, INPUT);
}

void loop(){
  digitalWrite(2, LOW);
  delayMicroseconds(280);
  vo_value = analogRead(A0);
  delayMicroseconds(40);
  digitalWrite(v_led,HIGH);
  delayMicroseconds(9680);

  voltage = vo_value*5.0 / 1023.0;
  dustDensity = (voltage - 0.5)/0.005;

  Serial.print("voltage: " );
  Serial.println(voltage);
  Serial.print("Dust Densiti: " );
  Serial.println(dustDensity);

  delay(1000);
}
