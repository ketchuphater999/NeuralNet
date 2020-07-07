#include "netmath.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>
#include <float.h>

#define NMAX 10000000

double sigmoid(double x)
{
     double exp_value;
     double return_value;

     /*** Exponential calculation ***/
     exp_value = exp((double) -x);

     /*** Final sigmoid value ***/
     return_value = 1 / (1 + exp_value);

     return return_value;
}

double gaussRand(double mu, double sigma)
{
    static const double epsilon = DBL_MIN;
    static const double two_pi = 2.0*3.14159265358979323846;

    double z0;
    double u1, u2;
    
    do
    {
        u1 = rand() * (1.0 / RAND_MAX);
        u2 = rand() * (1.0 / RAND_MAX);
    }
    while (u1 <= epsilon);

    z0 = sqrt(-2.0 * log(u1)) * cos(two_pi * u2);

    return z0 * sigma + mu;
}
