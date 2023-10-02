#include <gb/gb.h>
#include <stdio.h>
#include <string.h>

#include "framework/main.h"

void test(void) {
    printf("hello, world!");
    strcpy(result, "PASSED"); 
    delay(100);
}