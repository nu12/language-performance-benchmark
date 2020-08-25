#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    FILE * input;
    FILE * output;
    char * line = NULL;
    char out[100];
    size_t len = 0;
    ssize_t read;

    float current_value = 0.0;
    float highest = 0.00;
    double sum = 0.00;
    int count = 0;
    input = fopen("db/database.dat", "r");
    output = fopen("outputs/c_a.csv", "a");

    while ((read = getline(&line, &len, input)) != -1) {
        current_value = atof(line);
        if (current_value > highest)
            highest = current_value;
        sum = sum + current_value;
        count = count + 1;
    }
    fclose(input);
    
    sprintf(out, "%.2f, %.2f, %d", highest, sum, count);
    fputs(out, output);
    fclose(output);
}