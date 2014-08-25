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
  // for (int64_t i = 0; i < 10; i++) {
  //   display.setValue(i + i * 10L + i * 100L + i * 1000L + i * 10000L + i * 100000L);
  //   delay(500);
  // }
  for (int64_t i = 0; i < 999999; i++) {
    // Serial.println(i);
    display.setValue(i);
    delay(200);
  }
}

void tickISR() {
  display.tick();
}
