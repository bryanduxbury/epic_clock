#include "DisplayController.h"

#define ISSET(vector, bit) ((((vector)[(bit)/8] & (1 << ((bit) % 8)))) != 0)
#define SET(vector, bit) ((vector)[(bit)/8] |= (1 << ((bit) % 8)))
#define UNSET(vector, bit) ((vector)[(bit)] ^= (1 << ((bit) % 8)))

#define DEBUG(msg, val) Serial.print((msg)); Serial.println((val));

bool isset(uint8_t *vector, size_t idx) {
  return (vector[idx / 8] & (1 < (idx % 8))) != 0;
}

void set(uint8_t *vector, size_t idx) {
  vector[idx / 8] |= (1 < (idx % 8));
}

void unset(uint8_t *vector, size_t idx) {
  vector[idx / 8] &= ~(1 < (idx % 8));
}


const uint8_t digit2segs[16] = {
  0x3f, // 0
  0x06, // 1
  0x5b, // 2
  0x4f, // 3
  0x66, // 4
  0x6d, // 5
  0x7d, // 6
  0x07, // 7
  0x7f, // 8
  0x67, // 9
  0x77, // A
  0x7c, // B
  0x58, // C
  0x5e, // D
  0x79, // E
  0x71  // F
};

DisplayController::DisplayController(uint8_t *segmentPins, uint8_t *digitPins, size_t numDigits) {
  this->segmentPins = segmentPins;
  this->digitPins = digitPins;
  this->numDigits = numDigits;
  // segmentsVector = new uint8_t[numDigits * 7 / 8 + 1];
  segmentsVector = new BitVector(numDigits * 7);
}

void DisplayController::anodeHigh(uint8_t bit) {
  digitalWrite(digitPins[bit / 7], HIGH);
}

void DisplayController::anodeLow(uint8_t bit) {
  digitalWrite(digitPins[bit / 7], LOW);
}

void DisplayController::cathodeHigh(uint8_t bit) {
  digitalWrite(segmentPins[bit % 7], HIGH);
}

void DisplayController::cathodeLow(uint8_t bit) {
  digitalWrite(segmentPins[bit % 7], LOW);
}

void DisplayController::setValue(int64_t val) {
  for (int i = 0; i < numDigits; i++) {
    uint8_t segs = digit2segs[val%10];
    DEBUG("current digit", (int)(val%10));
    DEBUG("selected segments", segs);
    for (int j = 0; j < 7; j++) {
      if (segs & (1 << j)) {
        segmentsVector->set(i * 7 + j);
        // set(segmentsVector, i * 7 + j);
      } else {
        segmentsVector->unset(i * 7 + j);
        // unset(segmentsVector, i * 7 + j);
      }
    }

    val /= 10;
  }
}

void DisplayController::setBlankLeading(bool blank) {
  this->blankLeading = blank;
}

void DisplayController::begin() {
  for (int i = 0; i < 7; i ++) {
    pinMode(segmentPins[i], OUTPUT);
  }
  for (int i = 0; i < numDigits; i++) {
    pinMode(digitPins[i], OUTPUT);
  }
}

void DisplayController::tick() {
  anodeLow(currentBit);
  cathodeLow(currentBit);

  currentBit++;
  if (currentBit == numDigits * 7) {
    currentBit = 0;
  }

  // if (isset(segmentsVector, currentBit)) {
  if (segmentsVector->isSet(currentBit)) {
    anodeHigh(currentBit);
    cathodeHigh(currentBit);
  }
}