extern void test();

unsigned char result[8] = "FAILED";

void main(void) {
    test();
    __asm__("\tld\tb,b");
}