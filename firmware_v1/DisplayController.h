#ifndef __DISPLAY_CONTROLLER_H__
#define __DISPLAY_CONTROLLER_H__

#include "Arduino.h"
#include "BitVector.h"

class DisplayController {
public:
  DisplayController(uint8_t *segmentPins, 
                    uint8_t *digitPins, 
                    size_t numDigits);
  void setValue(int64_t value);
  void setBlankLeading(bool blank);

  void begin();
  void tick();

private:

  uint8_t* segmentPins;
  uint8_t* digitPins;
  size_t   numDigits;

  bool     blankLeading;
  
  // uint8_t  *segmentsVector;
  BitVector * segmentsVector;
  size_t   currentBit;
  
  void anodeHigh(uint8_t bit);
  void anodeLow(uint8_t bit);
  void cathodeHigh(uint8_t bit);
  void cathodeLow(uint8_t bit);

};


#endif