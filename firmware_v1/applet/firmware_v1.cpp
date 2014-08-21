#include "Arduino.h"

#include "DisplayController.h"


//                      a  b  c  d  e  f  g
const int segments[] = {3, 5, 6, 7, 8, 2, 4};

const uint8_t digit2segments[] = {
  0x3f,
  0x06,
  0x5b,
  0x4f,
  0x66,
  0x6d,
  0x7d,
  0x07,
  0x7f,
  0x67,
  0x77,
  0x7c,
  0x58,
  0x5e,
  0x79,
  0x71,
  0x0
};

void setup() {
  for (int i = 0; i < 7; i++) {
    pinMode(segments[i], OUTPUT);
    digitalWrite(segments[i], LOW);
  }
}

void displayDigit(int digit) {
  uint8_t segs = digit2segments[digit & 0x0f];
  for (int i = 0; i < 7; i++) {
    if ((segs & (1 << i)) != 0) {
      digitalWrite(segments[i], HIGH);
    } else {
      digitalWrite(segments[i], LOW);
    }
  }
}

void loop() {
  displayDigit(0);
  
//  for (int i = 0; i < 16; i++) {
//    displayDigit(i);
//    delay(500);
//  }
  
}