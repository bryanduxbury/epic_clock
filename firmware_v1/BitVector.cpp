#include "BitVector.h"

BitVector::BitVector(size_t nBits) {
  this->nBits = nBits;
  vector = new bool[nBits];
  for (int i = 0; i < nBits; i++) {
    vector[i] = false;
  }
}

size_t BitVector::length() {
  return nBits;
}

void BitVector::set(size_t bitIdx) {
  set(bitIdx, true);
}

void BitVector::unset(size_t bitIdx) {
  set(bitIdx, false);
}

void BitVector::set(size_t bitIdx, bool value) {
  vector[bitIdx] = value;
}

bool BitVector::isSet(size_t bitIdx) {
  return vector[bitIdx];
}

void BitVector::clear() {
  for (int i = 0; i < nBits; i++) {
    vector[i] = false;
  }
}