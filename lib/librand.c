#include <stdint.h>
#include <stdlib.h>
#include <math.h>

#define TWOTOM63 pow(2., -63.)
#define ROL32(x, c)\
	(x)<<(c) | (x)>>(32-c)

typedef struct{
	uint64_t s[2];
} rand_workspace;

rand_workspace *RandAlloc(){
	return malloc(sizeof(rand_workspace));
}

void SetRandomSeed(rand_workspace *w){
	uint32_t t;
	uint64_t a;
	
	asm volatile(
		"rdtsc\n"
		:"=a" (t)
		:
		:"%rdx"
	);
	a = (uint64_t)t;
	a = a<<32;
	t = ROL32(t, 8);
	a |= t;
	w->s[0] = a;

	t = ROL32(t, 8);
	a = (uint64_t)t;
	a = a<<32;
	t = ROL32(t, 8);
        a |= t;
        w->s[1] = a;

	return;	
}

double RSUnif(rand_workspace *w, double a, double b){
	uint64_t x = w->s[0];
	uint64_t const y=w->s[1];
	uint64_t pres;
	w->s[0] = y;
	x ^= x<<23;
	pres = x^y^(x>>17)^(y>>26);
	w->s[1] = pres;
	
	return (double)((pres+y)>>1)*TWOTOM63*(b-a) + a;
}

double RSGauss(rand_workspace *w, double m, double s){
	double U1 = RSUnif(w, 0, 1);
	double U2 = RSUnif(w, 0, 1);
	
	return sqrt(-2*log(U1))*cos(2*M_PI*U2);
}

double RSExpo(rand_workspace *w, double lambda){
	return -lambda*log(RSUnif(w, 0, 1));
}

double RSCauchy(rand_workspace *w, double mean, double gamma){
	double x = tan(RSUnif(w, -M_PI/2, M_PI/2));
	return gamma*x/2 + mean;
}



