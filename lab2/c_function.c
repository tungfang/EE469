// int add2(int a, int c) {
//     return a + 1;
// }

// int compare_and_add(int a, int b, int c) {
//     if (a != b) {
//         add2(a, c);
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

