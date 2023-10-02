#include "main.h"

extern void test(void);

unsigned char result[8] = "FAILED";

void main(void) {
    test();
    TERMINATE_TEST;
}