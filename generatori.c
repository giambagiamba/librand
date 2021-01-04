#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include<math.h>
#define duepi 6.2831853071795864769252866


static uint64_t s[2]={0,0};
	
void seed(){
	uint32_t t;
	
	asm volatile(
		"rdtsc\n"
		:"=a" (t)
		:
		:"%rdx"
	);
	s[0]=(uint64_t)t;
	t=(t<<8)|(t>>24);
	s[0]|=t;
	t=(t<<8)|(t>>24);
	s[1]|=t;
	t=(t<<8)|(t>>24);
	s[1]|=t;
	
	return;	
}

double unif(double a, double b){//, uint64_t *s
	//static uint64_t s[2]={0x15ff2000dabb2a55,0x300f2040da5b2b55};
	uint64_t x=s[0];
	uint64_t const y=s[1];
	double r;
	s[0]=y;
	x^=x<<23;
	s[1]=x^y^(x>>17)^(y>>26);
	r=(double)(s[1]+y)/exp(64*log(2));
	return r*(b-a)+a;
}

double gauss(double m, double sigma){
	double r, phi, x;
	r=sqrt(-2*log(unif(0,1)));
	phi=duepi*unif(0,1);
	x=r*cos(phi);
	
	return x*sigma+m;
}

double expo(double lambda){
	return -lambda*log(unif(0,1));
}

double cauchy(double media, double gamma){
	double x=tan(unif(-duepi/4,duepi/4));
	return gamma*x/2+media;
}

int main(){
FILE *f;
int i;

seed();
f=fopen("a.dat","w");

for(i=0;i<1000000;i++){
	fprintf(f,"%.15le	%.15le\n",unif(1.,2.),unif(0.5,1.));
}

fclose(f);
return 0;
}