#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#define duepi 6.2831853071795864769252866

typedef struct{
	uint64_t s[2];
}rand_t;
//static uint64_t s[2]={0x15ff2000dabb2a55,0x300f2040da5b2b55};

void *RandAlloc(){
	void *w;
	
	w=malloc(16);
	return w;
}

void SetRandomSeed(void *w){
	rand_t *ws=(rand_t*)w;
	uint32_t t;
	
	asm volatile(
		"rdtsc\n"
		:"=a" (t)
		:
		:"%rdx"
	);
	ws->s[0]=(uint64_t)t;
	t=(t<<8)|(t>>24);
	ws->s[0]|=t;
	t=(t<<8)|(t>>24);
	ws->s[1]|=t;
	t=(t<<8)|(t>>24);
	ws->s[1]|=t;
	
	return;	
}

double RSUnif(void *w, double a, double b){
	rand_t *ws=(rand_t*)w;
	uint64_t x=ws->s[0];
	uint64_t const y=ws->s[1];
	uint64_t pres;
	ws->s[0]=y;
	x^=x<<23;
	pres=x^y^(x>>17)^(y>>26);
	ws->s[1]=pres;
	
	return (double)((pres+y)>>1)*exp(-63*log(2))*(b-a)+a;
	
}
