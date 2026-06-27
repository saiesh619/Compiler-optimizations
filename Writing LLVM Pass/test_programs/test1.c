#include <stdio.h>

int main() {

    int a = 5;
    int b = 10;

    // Constant propagation
    int c = a + b;

    // Common subexpression
    int d = a + b;

    // Dead code
    int unused = 100;

    int sum = 0;

    // Loop invariant candidate
    for(int i = 0; i < 10; i++) {

        int x = a + b;

        sum += x;
    }

    printf("%d\n", sum);

    return 0;
}