#include <stdio.h>
#include <stdlib.h>
//#include <stdint.h>
//#include <math.h>
//#include<sys/types.h>
#include "../lib/librand.c"

//#define OPENMP_MODE
#ifdef OPENMP_MODE
  #include<omp.h>
  #define NTHREADS 6
#else
  #define NTHREADS 1
#endif


#define N (uint64_t)1E10


int main(){
	uint64_t i;
	rand_workspace w[NTHREADS];
	double y, z;
	uint64_t pi=0;

	for(i=0;i<NTHREADS;i++){
		SetRandomSeed(w+i);
	}

	#ifdef OPENMP_MODE
 	#pragma omp parallel for num_threads(NTHREADS)\
		private(i, y, z) reduction(+:pi)
	#endif
	for(i=0;i<N;i++){
		#ifdef OPENMP_MODE
		rand_workspace* W=w+omp_get_thread_num();
		#else
		rand_workspace* W=w;
		#endif
		//y = RSUnif(W, 0., 1.);
		//z = RSUnif(W, 0., 1.);
		y = RSExpo(W, 1.);
		z = RSExpo(W, 1.);
		if((y*y + z*z) < 1){
			pi++;
		}
	}
	printf("pi = %.16le\n", (double)pi*4/N);

	return 0;
}

