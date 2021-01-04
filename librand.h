#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#define duepi 6.2831853071795864769252866

typedef struct{
	uint64_t s[2];
}rand_t;

void *RandAlloc();
void SetRandomSeed(void *w);
double RSUnif(void *w, double a, double b);
