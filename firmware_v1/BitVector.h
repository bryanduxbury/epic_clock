#ifndef __BIT_VECTOR_H__
#define __BIT_VECTOR_H__

#include "Arduino.h"

class BitVector {
public:
  BitVector(size_t nBits);
  size_t length();
  void set(size_t bitIdx, bool value);
  void set(size_t bitIdx);
  void unset(size_t bitIdx);
  bool isSet(size_t bitIdx);
  void clear();
  
private:
  size_t nBits;
  volatile bool *vector;
};

#endif