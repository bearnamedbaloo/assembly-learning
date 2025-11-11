/*
 * main.c - C driver for sum_two assembly function
 *
 * This demonstrates how to call assembly functions from C
 * and showcases interoperability between C and assembly.
 */

#include <stdio.h>
#include <stdlib.h>

// External function declaration
// This tells the compiler that sum_two is defined elsewhere (in sum_two.asm)
extern int sum_two(int a, int b);

int main(int argc, char *argv[]) {
    int a, b, result;

    // Default values
    a = 5;
    b = 7;

    // Parse command-line arguments if provided
    if (argc >= 3) {
        a = atoi(argv[1]);
        b = atoi(argv[2]);
    }

    // Call the assembly function
    result = sum_two(a, b);

    // Print the result
    printf("%d + %d = %d\n", a, b, result);

    return 0;
}
