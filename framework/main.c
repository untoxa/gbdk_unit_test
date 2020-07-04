#include "main.h"

extern void test();

unsigned char result[8] = "FAILED";

void main(void) {
    test();
    TERMINATE_TEST;
}