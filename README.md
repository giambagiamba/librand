#Random number generator based on the XorShift128+ algorithm.

##Structure of this library

The *rand_workspace* struct (typedef'd) is defined as follows:

typedef struct{
        uint64_t s[2];
} rand\_workspace;

*s* is the seed of the RNG. 
The following functions are available:
- rand\_workspace \*RandAlloc();
	Allocates a *rand_workspace* using *malloc*.

- void SetRandomSeed(rand\_workspace \*w);
	Randomly set the seed based on current CPU clocks counter. It should give different enough values even if called two times consecutively.

- double RSUnif(rand\_workspace \*w, double a, double b);
	Generate one random number uniformely distributed between *a* and *b*. *a* is meant to be < *b* but the function works also in the opposite case.

- double RSGauss(rand\_workspace \*w, double m, double s);
	Generate one random number following a Gaussian distribution with mean *m* and standard deviation *s*. This function uses the Box-Mueller algorithm. Here *s* is not required to be positive (the absolute value is used).

- double RSExpo(rand\_workspace \*w, double lambda);
	Generate one random number following an exponential distribution with parameter *lambda*.

- double RSCauchy(rand\_workspace \*w, double mean, double gamma);
	Generate one random number following a Cauchy distribution with parameters *mean* and *gamma*. *gamma* can be also negative.

##Usage

Before using the generator, allocates the workspace with *RandAlloc* or just instantiate one *rand_workspace* variable. This generator is thread-safe: allocate (or instantiate) one workspace for each thread. Apply *SetRandomSeed* to each one. At this point it is possible to generate numbers. If workspaces were allocated, remember to free memory before the end of your program (just use *free()*).

