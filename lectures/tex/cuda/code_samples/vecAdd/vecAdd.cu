#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>

void checkErrors(cudaError_t err, const char *msg) {
    if (err != cudaSuccess) {
        fprintf(stderr, msg);
        fprintf(stderr,
                " [Erro CUDA: %s]\n",
                cudaGetErrorString(err));
        exit(-1);
    }
}

void compareResults(float *C1, float *C2, int numElements) {
    float epsilon = 0.00001;
    for(int i = 0; i < numElements; i ++) {
        if (abs(C1[i] - C2[i]) > epsilon) {
            printf("Comparação de resultados falhou\n");
            exit(-1);
        }
    }
    printf("Comparação de resultados passou\n");
}

void vecAddCPU(float *A, float *B, float *C, int numElements) {
    for(int i = 0; i < numElements; i ++) {
        C[i] = A[i] + B[i];
    }
}

__global__ void vecAdd(float *A, float *B, float *C, int numElements) {
    int i = blockDim.x * blockIdx.x + threadIdx.x;

    if (i < numElements) {
        C[i] = A[i] + B[i];
    }
}

int main(int argc, char **argv) {
    int maxBlockSize = 1024;
    int numElements = 50000;
    int size = numElements * sizeof(float);

    printf("Alocando vetores no host\n");

    float *h_A = (float *) malloc(size);
    float *h_B = (float *) malloc(size);
    float *h_C = (float *) malloc(size);

    if (h_A == NULL || h_B == NULL || h_C == NULL) {
        fprintf(stderr, "Falha em alocar vetores no host\n");
        exit(-1);
    }

    printf("Inicializando vetores no host\n");

    for (int i = 0; i < numElements; ++i) {
        h_A[i] = rand() / (float) (RAND_MAX);
        h_B[i] = rand() / (float) (RAND_MAX);
    }

    float *d_A;
    float *d_B;
    float *d_C;

    printf("Alocando vetores no device\n");

    cudaMalloc(&d_A, size);
    cudaMalloc(&d_B, size);
    cudaMalloc(&d_C, size);

    checkErrors(cudaGetLastError(),
                "Malloc nos vetores do device");

    printf("Copiando memória do host para o device\n");

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    checkErrors(cudaGetLastError(),
                "Cópia para o device");

    /*
      Precisamos de um número inteiro de  blocks, mesmo se "numElements" não for
      divisível por "maxBlockSize"
    */
    int numBlocks = (numElements + maxBlockSize - 1) / maxBlockSize;

    printf("Lançando um kernel com %d threads, com %d blocks de tamanho %d\n",
           numBlocks * maxBlockSize,
           numBlocks,
           maxBlockSize);

    vecAdd<<<numBlocks, maxBlockSize>>>(d_A, d_B, d_C, numElements);

    checkErrors(cudaGetLastError(),
                "Lançamento do kernel");

    printf("Copiando memória do device para o host\n");

    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);

    checkErrors(cudaGetLastError(),
                "Cópia para o host");

    printf("Alocando vetor de teste no host\n");

    float *h_D = (float *) malloc(size);

    if (h_D == NULL) {
        fprintf(stderr, "Falha em alocar vetores no host\n");
        exit(-1);
    }

    printf("Lançando cálculo na CPU\n");

    vecAddCPU(h_A, h_B, h_D, numElements);

    printf("Comparando resultados na CPU e na GPU\n");

    compareResults(h_C, h_D, numElements);

    printf("Liberando memória\n");

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    free(h_A);
    free(h_B);
    free(h_C);
    free(h_D);

    printf("Fim\n");

    return 0;
}
