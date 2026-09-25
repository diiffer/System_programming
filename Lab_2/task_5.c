#include <stdio.h>

int main() {
    char num_str[] = "4693338485";
    int sum = 0;
    
    for (int i = 0; num_str[i] != '\0'; i++) {
        sum += num_str[i] - '0';
    }
    
    printf("%d\n", sum);
    
    return 0;
}