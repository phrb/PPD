#include <stdio.h>
#include <omp.h>

int main(int argc, char *argv[]){
    int nthreads, tid;

    tid = -1;

    #pragma omp parallel private(tid)
    {
        tid = omp_get_thread_num();
        printf("Hello World from thread = %d\n", tid);

        if(tid == 0){
            nthreads = omp_get_num_threads();
            printf("Number of threads = %d\n", nthreads);
        };
    };

    printf("Previous tid = %d\n", tid);
    return 0;
};
