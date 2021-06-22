#include <stdio.h>
#include <stdlib.h>

// Indireção: Essa função é um *Kernel*
void vecAdd(float *A, float *B, float *C, int i) {
    C[i] = A[i] + B[i];
}

int main(int argc, char **argv) {
    int n = 50000;
    int size = n * sizeof(float);

    float *A, *B, *C;

    A = malloc(size);
    B = malloc(size);
    C = malloc(size);

    if (A == NULL || B == NULL || C == NULL) {
        printf("Erro no malloc");
        exit(-1);
    }

    int i;

    for(i = 0; i < n; i++) {
        A[i] = rand() / (float) (RAND_MAX);
        B[i] = rand() / (float) (RAND_MAX);
    }

    // Faz sentido fazer fora da função?
    for(i = 0; i < n; i++) {
        vecAdd(A, B, C, i);
    }

    for(i = 0; i < n; i++) {
        printf("%f, ", C[i]);
    }

    return 0;
}
