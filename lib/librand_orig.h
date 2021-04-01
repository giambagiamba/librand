
void *RandAlloc();
void RandFree(void *w);
void SetRandomSeed(void *w);
double RSUnif(void *w, double a, double b);
double RSGauss(void *w, double m, double s);
void RDGauss(void *w, double *x, double *m, double *s);
double RSExpo(void *w, double tau);
double RSCauchy(void *w, double x0, double gamma);

// void RVUnif(unsigned int nmezzi, double *v, double a, double b);

/*
Tutte le funzioni sono "thread-safe": possono essere eseguite in parallelo da thread multipli, a patto che abbiano spazi di lavoro differenti. Per la generazione dei numeri casuali l'algoritmo usato è lo "xorshift128+".
Lo spazio di lavoro è la zona puntata da w (workspace), dev'essere grande 128 bit; per allocare c'è la funzione RandAlloc(), che è wrapper di "malloc(16)".
Per liberare la memoria dallo spazio di lavoro c'è la funzione RandFree(), che è wrapper di "free(w)".
Dopo aver allocato lo spazio di lavoro bisogna lanciare SetRandomSeed(), che vi inserisce il seme; il seme è sorteggiato tramite rotazione della metà bassa del TSC: tenere presente che esso va in overflow circa ogni due secondi su un CPU a 2 GHz nominali; due chiamate consecutive alla funzione daranno probabilmente due semi diversi ma forse simili (non so quanti problemi possa creare questo).
RSUnif(): genera un numero uniformemente distribuito tra a e b, che sono rispettivamente estremo inferiore e superiore. Se a>b funziona ugualmente.
RSGauss(): genera un numero distribuito gaussianamente, con media m e sigma s. Il metodo usato è il Box-Muller classico.
RDGauss(): genera due numeri distribuiti gaussianamente con medie e sigma passate tramite i vettori m e s. Tutti i vettori devono essere capienti per 2 double. Il primo valore di m e s sarà quello attribuito al primo numero generato, che finirà in x[0]; analogamente il secondo. Questa funzione adopera fsincos per velocizzare il calcolo trigonometrico e utilizza lo stesso algoritmo della funzione precedente.
RSExpo(): genera un numero esponenziale con tau>0 dato.
RSCauchy(): genera un numero cauchy centrato in x0 e con gamma>0 data. 
*/