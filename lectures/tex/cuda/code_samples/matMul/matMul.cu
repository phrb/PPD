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

void compareResults(float *C1, float *C2, int N) {
    float epsilon = 0.00001;
    for(int i = 0; i < N; i ++) {
        if (abs(C1[i] - C2[i]) > epsilon) {
            printf("Comparação de resultados falhou\n");
            exit(-1);
        }
    }
    printf("Comparação de resultados passou\n");
}

__global__ void matMul(float *A, float *B, float *C, int N) {
    int row = blockDim.x * blockIdx.x + threadIdx.x;
    int col = blockDim.y * blockIdx.y + threadIdx.y;

    if (row < N && col < N) {
        for(int i = 0; i < N; i++) {
            C[(row * N) + col] += A[(i * N) + col] * B[(row * N) + i];
        }
    }
}

void matMulCPU(float *A, float *B, float *C, int N) {
    for(int row = 0; row < N; row++) {
        for(int col = 0; col < N; col++) {
            for(int i = 0; i < N; i++) {
                C[(row * N) + col] += A[(i * N) + col] * B[(row * N) + i];
            }
        }
    }
}

int main(int argc, char **argv) {
    int maxBlockSize = 1024;
    int N = 256;
    int size = N * N * sizeof(float);

    int i, j;

    printf("Alocando vetores no host\n");

    float *h_A = (float *) malloc(size);
    float *h_B = (float *) malloc(size);
    float *h_C = (float *) malloc(size);

    if(h_A == NULL || h_B == NULL || h_C == NULL) {
        printf("Falha ao alocar memória\n");
    }

    for(i = 0; i < N; i++) {
        for(j = 0; j < N; j++) {
            h_A[(i * N) + j] = rand() / (float) (RAND_MAX);
            h_B[(i * N) + j] = rand() / (float) (RAND_MAX);
            h_C[(i * N) + j] = 0.0;
        }
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
      Precisamos de um número inteiro de  blocks, mesmo se "N" não for
      divisível por "maxBlockSize"
    */
    int blocksPerGrid = ((N * N) + maxBlockSize - 1) / maxBlockSize;

    dim3 cudaBlockSize(sqrt(maxBlockSize), sqrt(maxBlockSize), 1);
    dim3 cudaGridSize(sqrt(blocksPerGrid), sqrt(blocksPerGrid), 1);

    printf("Lançando um kernel com %d threads, com %d blocks de tamanho %d\n",
           blocksPerGrid * maxBlockSize,
           blocksPerGrid,
           maxBlockSize);

    matMul<<<cudaGridSize, cudaBlockSize>>>(d_A, d_B, d_C, N);

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

    matMulCPU(h_A, h_B, h_D, N);

    printf("Comparando resultados na CPU e na GPU\n");

    compareResults(h_C, h_D, N);

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
