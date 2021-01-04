#include <stdio.h>
#include <pthread.h>


void* generate(void* arg){
	pthread_t t;
	
	t=pthread_self();
	printf("\t%li\n", t);
	
	return 0;
}



int main(){
	int i;
	pthread_t th[2]={0,1};
	
	printf("%li\n", th[0]);
	printf("%li\n\n\n", th[1]);
	
	for(i=0;i<10;i++){	
	pthread_create(th, 0, generate, (void*)0);
	printf("%li\n", th[0]);
	pthread_create(&th[1], 0, generate, (void*)0);
	printf("%li\n", th[1]);		
	pthread_join(th[0], 0);
	pthread_join(th[1], 0);
	printf("\n");
	}
	
	printf("%li\n", th[0]);
	printf("%li\n", th[1]);
	
	return 0;
}