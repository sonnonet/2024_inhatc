int vo = A0;
int v_led = 12;

float vo_value=0;
float voltage = 0;
float dustDensity = 0;

void setup(){
  Serial.begin(9600);
  pinMode(v_led, OUTPUT);
  pinMode(vo, INPUT);
}

void loop(){
  digitalWrite(v_led, LOW);
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
