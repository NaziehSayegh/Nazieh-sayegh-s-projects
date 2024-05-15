#include <stdio.h>
#include <stdlib.h>
#include <limits.h> 

#define SIZE 100

struct Data {
    int** the_data;
    int* lines_len;
    int num_of_lines;
};

int main(int argc, char* argv[]) {
    FILE* fb = fopen(argv[1], "r");
    if (fb == NULL) {
        printf("Failed to open the file.\n");
        exit(EXIT_FAILURE);
    }

    struct Data data;

    if (fscanf(fb, "%d", &data.num_of_lines) != 1) {
        printf("Error reading the number of lines from the file.\n");
        exit(EXIT_FAILURE);
    }

    if (data.num_of_lines <= 0) {
        printf("The file contains no data\n");
        exit(EXIT_FAILURE);
    }

    data.lines_len = (int*)malloc(data.num_of_lines * sizeof(int));
    data.the_data = (int**)malloc(data.num_of_lines * sizeof(int*));

    int rows = data.num_of_lines;

    
    for (int i = 0; i < rows; i++) {
        int col;
        if (fscanf(fb, "%d", &col) != 1) {
            printf("Error reading line length from the file.\n");
            exit(EXIT_FAILURE);
        }

        data.lines_len[i] = col;
        data.the_data[i] = (int*)malloc(col * sizeof(int));

        for (int j = 0; j < col; j++) {
            if (fscanf(fb, "%d", &data.the_data[i][j]) != 1) {
                printf("Error reading data from the file.\n");
                exit(EXIT_FAILURE);
            }
        }
    }
    fclose(fb);

    int all_same = 1;
    int max_index = 0;

    for (int i = 1; i < data.num_of_lines; i++) {
        for (int j = 0; j < data.lines_len[i] && j < data.lines_len[max_index]; j++) {
            if (data.the_data[i][j] > data.the_data[max_index][j]) {
                max_index = i;
            }
        }
    }
    
    for (int j = 0; j < data.lines_len[max_index]; j++) {
        int max_val = data.the_data[max_index][j]; 
        for (int i = 0; i < data.num_of_lines; i++) {
            if (i != max_index && j < data.lines_len[i] && data.the_data[i][j] > max_val) {
                all_same = 0;
                break;  
            }
        }
        if (!all_same) {
            break;  
        }
    }

    if (all_same) {
        printf("The row that has the maximum in all columns is %d\n", max_index);
        printf("\n");
    } else {
        printf("-1\n");
    }
    
    for (int i = 0; i < data.num_of_lines; i++) {
        free(data.the_data[i]);
    }
    free(data.the_data);
    free(data.lines_len);

    return 0;
}
