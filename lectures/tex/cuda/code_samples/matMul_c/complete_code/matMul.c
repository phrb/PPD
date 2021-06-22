#include <stdio.h>
#include <stdlib.h>

void matMul(float *A, float *B, float *C, int N, int row, int col) {
    for(int i = 0; i < N; i++) {
        C[(row * N) + col] += A[(i * N) + col] * B[(row * N) + i];
    }
}

void printMat(float *A, int N){
    for(int i = 0; i < N; i++) {
        for(int j = 0; j < N; j++) {
            printf("%f ", A[(i * N) + j]);
        }
        printf("\n");
    }
    printf("\n");
}

void printCoord(int i, int j, int N) {
    printf("coord: (%d, %d), element: %d\n",
           i, j, (i * N) + j);
}

int main(int argc, char **argv) {
    int N = 3;
    int i, j;
    int size = N * N * sizeof(float);

    float *A = (float *) malloc(size);
    float *B = (float *) malloc(size);
    float *C = (float *) malloc(size);

    if(A == NULL || B == NULL || C == NULL) {
        printf("Falha ao alocar memória\n");
    }

    for(i = 0; i < N; i++) {
        for(j = 0; j < N; j++) {
            printCoord(i, j, N);

            // Usando inicialização aleatória
            // A[(i * N) + j] = rand() / (float) (RAND_MAX);
            // B[(i * N) + j] = rand() / (float) (RAND_MAX);

            A[(i * N) + j] = 2.0;
            B[(i * N) + j] = 5.0;
            C[(i * N) + j] = 0.0;
        }
    }

    printMat(A, N);
    printMat(B, N);
    printMat(C, N);

    for(i = 0; i < N; i++) {
        for(j = 0; j < N; j++) {
            matMul(A, B, C, N, i, j);
        }
    }

    printMat(C, N);

    return 0;
}
