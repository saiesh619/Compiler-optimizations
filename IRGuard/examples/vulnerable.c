#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int divide_by_zero(int x) {
    return x / 0;
}

int bad_shift(int x) {
    return x << 40;
}

short lossy_cast(long long value) {
    return (short)value;
}

void unsafe_copy(char *src) {
    char buffer[8];
    strcpy(buffer, src);
}

void unsafe_format(char *name) {
    char buffer[16];
    sprintf(buffer, "hello %s", name);
}

int null_dereference(void) {
    int *ptr = 0;
    return *ptr;
}

void dynamic_stack_allocation(int n) {
    for (int i = 0; i < n; i++) {
        char temp[n];
        temp[0] = 1;
    }
}

int main(int argc, char **argv) {
    if (argc > 1) {
        unsafe_copy(argv[1]);
        unsafe_format(argv[1]);
    }

    return lossy_cast(123456789123LL);
}
