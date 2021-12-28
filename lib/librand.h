#include <stdint.h>
#include <stdlib.h>
#include <math.h>

#define TWOTOM63 pow(2., -63.)
#define ROL32(x, c)\
        (x)<<(c) | (x)>>(32-c)

typedef struct{
	uint64_t s[2];
} rand_workspace;

rand_workspace *RandAlloc();
void SetRandomSeed(rand_workspace *w);
double RSUnif(rand_workspace *w, double a, double b);
double RSGauss(rand_workspace *w, double m, double s);
double RSExpo(rand_workspace *w, double lambda);
double RSCauchy(rand_workspace *w, double mean, double gamma);

