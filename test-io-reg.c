#include <gb/gb.h>
#include <stdio.h>
#include <string.h>

#include "framework/main.h"

void test(void) {
  NR33_REG = 0x36;
  delay(100);
}