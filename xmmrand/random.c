#include <stdio.h>
#include <stdint.h>
#include <time.h>
//#include <string.h>
#include <math.h>
//#include<sys/types.h>
//#include<sys/mman.h>
//#include <fcntl.h>
//#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>


#define N 1000000000

#define BUFSIZE 512*512 //65536
#define VECSIZE 2	//2 o 4
#define NT 1

typedef struct{
	pthread_t th[NT];
	double* w;
	double* r;
	unsigned char whichr;	//Quale sta leggendo
	sem_t state1;	//0->busy - 1->available
	sem_t state2;
	double* end;	//Fine, cambiare buffer
	uint64_t s[2*VECSIZE*NT];
	double V1[BUFSIZE];
	double V2[BUFSIZE];
} workspace_t;

#if VECSIZE==2
typedef double vsd __attribute__ ((vector_size(16)));
typedef uint64_t vsu __attribute__ ((vector_size(16)));
#endif
#if VECSIZE==4
typedef double vsd __attribute__ ((vector_size(32)));
typedef uint64_t vsu __attribute__ ((vector_size(32)));
#endif


double xorshift128plus(workspace_t* const work){
	uint64_t x=work->s[0];
	uint64_t const y=work->s[1];
	work->s[0]=y;
	x^=x<<23;
	work->s[1]=x^y^(x>>17)^(y>>26);
	
	return (double)((work->s[1]+y)>>1)*exp(-63*log(2));
}

vsd xorshift128plusvec(workspace_t* const work, const int T){
	vsu* const xp = (vsu*)(work->s + 2*VECSIZE*T);
	vsu* const yp = (vsu*)(work->s + VECSIZE + 2*VECSIZE*T);
	vsu x;
	vsu y;//const
	vsu pres;
	vsd res;
	int64_t *d;
	
	printf("s = %p\nxp= %p\nyp= %p\n", (void*)work->s, (void*)xp, (void*)yp);

	x = *xp;
	puts("1\n");
	y = *yp;

	*xp=y;
	x^= x<<23;
	*yp = x^y^(x>>17)^(y>>26);
	pres = (*yp+y)>>1;
	d = (int64_t*)&pres;
#if VECSIZE==2
	res[0]=(double)d[0]*exp(-63*log(2));
	res[1]=(double)d[1]*exp(-63*log(2));
#endif
#if VECSIZE==4
	res[0]=(double)d[0]*exp(-63*log(2));
	res[1]=(double)d[1]*exp(-63*log(2));
	res[2]=(double)d[2]*exp(-63*log(2));
	res[3]=(double)d[3]*exp(-63*log(2));
#endif
		
	return res;
}

void prepare(workspace_t* const work){
	int i;
	vsd *w1 = (vsd*)work->V1;//double
	vsd *w2 = (vsd*)work->V2;//double
	time_t secs = time(0);
	
#if VECSIZE==2
	for(i=0;i<NT;i++){
		work->s[4*i+0] = secs>>i | secs<<(60-i);
		work->s[4*i+1] = secs>>(4+i) | secs<<(60-i);
		work->s[4*i+2] = secs>>(8+i) | secs<<(56-i);
		work->s[4*i+3] = secs>>(12+i) | secs<<(52-i);
	}
#endif
//#if VECSIZE==4//ISPIRARSI ALL'ALTRO CASO
//	work->s[0] = 0x15ff2000dabb2a55;
//	work->s[1] = 0x300f2040da5b2b55;
//	work->s[2] = 0xff200015dabb2a55;
//	work->s[3] = 0x300f5b2b552040da;
//	work->s[4] = 0x1000dab5ff2b2a55;
//	work->s[5] = 0x300da5b2b0f20455;
//	work->s[6] = 0x15f0dabb2af20055;
//	work->s[7] = 0x3040da500f2b2b55;
//#endif
	printf("Preparazione\n");
	for(i=0;i<BUFSIZE/VECSIZE;i++){
		printf("i= %d\n", i);
		w1[i]=xorshift128plusvec(work, 0);
	}
	printf("Fatto uno\n");
	for(i=0;i<BUFSIZE/VECSIZE;i++){
		w2[i]=xorshift128plusvec(work, 1);
	}
	printf("Finito\n");
	for(i=0;i<NT;i++){
		work->th[i] = i;
	}
	
	work->w = work->V1;//V2 è già pieno
	work->r = work->V1;
	work->whichr = 0;//Da leggere V1
	//work->state1 = 1;//Available
	//work->state2 = 1;//Available
	work->end = work->V1 + BUFSIZE;
	
	sem_init(&work->state1, 0, 0);//Available
	sem_init(&work->state2, 0, 1);//Available
	
	return;
}

void* generate(void* woid){
	int i, j;
	workspace_t* work = (workspace_t*)woid;
	vsd* www = (vsd*)work->w;
	pthread_t t = pthread_self();
	
	printf("\tStart: generate.\n");
	//if(t!=work->th[0] && t!=work->th[1]){
	//	printf("\t%li	%li	%li\n", work->th[0], work->th[1], t);
	//}
	if(t==work->th[0]){//Thread 0
		for(i=0;i<BUFSIZE/(NT*VECSIZE);i++){//Prima parte
			www[i] = xorshift128plusvec(work, 0);
			//work->w[i] = xorshift128plus(work);
		}//work->w non è cambiato
		//printf("Thread %li:	1\n", t);
		//printf("\tEnded thr. 0 (%li)\n", work->th[0]);
		for(i=1;i<NT;i++){//Aspettare fine altri thread
			pthread_join(work->th[i], 0);
			//printf("\tJoined thr. %d (%li)\n", i, work->th[i]);
		}
		//printf("Thread %li:	2\n", t);
		if(work->w == work->V1){	//Appena scritto V1
			work->w =  work->V2;
			sem_post(&work->state1);
		}
		else{	//Appena scritto V2
			work->w =  work->V1;
			sem_post(&work->state2);
		}
	}
	else{//Altri threads
		for(j=1;j<NT;j++){//Ricerca numero thread (da 0 a NT-1) - pthread_self da un valore "tecnico"
			if(t==work->th[j])	break;
		}
		if(j==NT)	printf("PROBLEMA: j=%d\n", j);
		for(i=j*BUFSIZE/(NT*VECSIZE);i<(j+1)*BUFSIZE/(NT*VECSIZE);i++){
			www[i] = xorshift128plusvec(work, j);
			//work->w[i] = xorshift128plus(work);
		}//work->w non è cambiato
		//printf("Thread %li:	1\n", t);
	}
		
	
	return 0;
}

void swbuf(workspace_t* const work){
	
	if(work->whichr == 0){	//Ha letto V1
		work->r = work->V2;
		work->end = work->V2 + BUFSIZE;
		work->whichr = 1;
		//work->state1 = 0;//V1 vuoto
		//while(work->state2 == 0){}//Mettere semaforo
		sem_wait(&work->state2);
	}
	else{	//Ha letto V2
		work->r = work->V1;
		work->end = work->V1 + BUFSIZE;
		work->whichr = 0;
		//work->state2 = 0;//V2 vuoto
		//while(work->state1 == 0){}//Mettere semaforo
		sem_wait(&work->state1);
	}
	
	return;
}

int iget=0;
double get(workspace_t* const work){
	double res;
	
	if(work->r == work->end){
		iget++;
		//printf("End\n");
		swbuf(work);
		//for(i=0;i<NT;i++){
		//	status = pthread_create(work->th+i, 0, generate, (void*)work);	//thread//Riempie buffer appena svuotato
		//	if(status!=0)	printf("Errore\n");
		//}
		pthread_create(work->th, 0, generate, (void*)work);
		pthread_create(work->th+1, 0, generate, (void*)work);
		//printf("%li	%li	n=%d\n", work->th[0], work->th[1], iget);
		//generate((void*)work);
	}
	
	res = work->r[0];
	work->r++;
	
	return res;
}


int main(){
	int i, inside=0;
	double x[2];
	FILE *f;
	workspace_t w;
	
	f=fopen("rand.dat", "w");
	if(f==0)	return 0;
	
	prepare(&w);
	//printf("Prepto:	%li	%li\n", w.th[0], w.th[1]);
	for(i=0;i<N;i++){
		x[0]=get(&w);
		x[1]=get(&w);
		//x[0]=xorshift128plus(&w);
		//x[1]=xorshift128plus(&w);
		if((x[0]*x[0] + x[1]*x[1]) < 1)	inside++;
		//fprintf(f, "%.16le\n%.16le\n", x[0], x[1]);
	}
	
	printf("%.16le\n", 4*(double)inside/N);
	
	fclose(f);
	
	return 0;
}

/*
int main(){
int file, i=0;
double x;
//char val[20];
double* A;
workspace_t w;

file = open("rand.dat", O_RDWR | O_CREAT, S_IRWXU | S_IRWXG | S_IRWXO);
if(file == -1)	return 0;
if(ftruncate(file, N*sizeof(double)) == -1)	return 0;;

A = (double*)mmap(0, N*sizeof(double), PROT_WRITE | PROT_READ, MAP_SHARED, file, 0);
printf("%p\n", (void*)A);
if(A == (void*)-1)	return 0;

prepare(&w);
	
for(i=0;i<N;i++){
	x=get(&w);
	//snprintf(val, 20, "%1.5le", x);
	//printf("%s\n", val);
	//val[11]=0xa;
	//memcpy(A+i*12, val, 12);
	A[i] = x;
}

munmap(A, N*sizeof(double));
close(file);

return 0;
}*/




