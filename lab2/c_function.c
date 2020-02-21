// int add2(int a, int b) {
//     return a + b;
// }

// int compare_and_add(int a, int b) {
//     if (a > b) {
//         add2(a, b);
//     } 
//     return 0;
// }

// count the number of 1's in the binary representation of i
int popcount(int i) {
    int c = 0;
    int j;
    for (j = 0; j < 32; j++) {
        if (i & (1 << j))
            c++;
    }
    return c;
}

