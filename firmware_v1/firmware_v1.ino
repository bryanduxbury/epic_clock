#include "DisplayController.h"
#include "TimerOne.h"

//                    a  b  c  d  e  f  g
uint8_t segments[] = {4, 6, 7, 8, 9, 3, 5};
uint8_t digits[] =   {10, 11, 12, 13, A0, A1};

DisplayController display(segments, digits, 6);

void setup() {
  Serial.begin(115200);

  Timer1.initialize(5);
  Timer1.attachInterrupt(tickISR, 250);

  display.begin();
}

void loop() {
  for (int i = 0; i < 100; i++) {
    Serial.println(i);
    display.setValue(i);
    delay(500);
  }
}

void tickISR() {
  display.tick();
}
