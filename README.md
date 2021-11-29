This library is based on the XorShift128+ algorithm from George Marsaglia. See:

- https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwj4-7LH1Lv0AhVR-qQKHYvrB24QFnoECAMQAQ&url=https%3A%2F%2Fwww.jstatsoft.org%2Fv08%2Fi14%2Fpaper&usg=AOvVaw1xSWaplBRHJAI0j_kNoXGh
- https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwj4-7LH1Lv0AhVR-qQKHYvrB24QFnoECAQQAQ&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FXorshift&usg=AOvVaw39J8b0f91qCAuuZiK0VTSE
- https://vigna.di.unimi.it/ftp/papers/xorshiftplus.pdf
- https://vigna.di.unimi.it/xorshift/xorshift128plus.c

It uses a 128-bit state and returns 64-bit uniformly distributed numbers.


Structure of this library
-------------------------

The *rand_workspace* struct (typedef'd) is defined as follows:

`typedef struct{   
        uint64_t s[2];   
} rand_workspace;`

*s* is the seed of the RNG. 
The following functions are available:
- `rand_workspace *RandAlloc();`
	Allocates a *rand_workspace* using *malloc*.

- `void SetRandomSeed(rand_workspace *w);`
	Randomly set the seed based on current CPU clocks counter. It should give different enough values even if called two times consecutively.

- `double RSUnif(rand_workspace *w, double a, double b);`
	Generate one random number uniformely distributed between *a* and *b*. *a* is meant to be < *b* but the function works also in the opposite case.

- `double RSGauss(rand_workspace *w, double m, double s);`
	Generate one random number following a Gaussian distribution with mean *m* and standard deviation *s*. This function uses the Box-Mueller algorithm. Here *s* is not required to be positive (the absolute value is used).

- `double RSExpo(rand_workspace *w, double lambda);`
	Generate one random number following an exponential distribution with parameter *lambda*.

- `double RSCauchy(rand_workspace *w, double mean, double gamma);`
	Generate one random number following a Cauchy distribution with parameters *mean* and *gamma*. *gamma* can be also negative.


A simple example is provided in the `tests` folder.


Usage
-----

Before using the generator, allocates the workspace with *RandAlloc* or just instantiate one *rand_workspace* variable. This generator is thread-safe: allocate (or instantiate) one workspace for each thread. Apply *SetRandomSeed* to each one. At this point it is possible to generate numbers. If workspaces were allocated, remember to free memory before the end of your program (just use *free()*).

