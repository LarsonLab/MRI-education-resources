/*
 *  [rf] = cabc2rf (a, b)
 *  
 *  C program version of cabc2rf.
 *
 *  Mex driver for subroutine.
 *  Performs inverse SLR tranform on complex a,b coefficients to give 
 *  complex rf pulse
 *
 *
 *  Written by Adam Kerr, October 1992
 *  Modified from John Pauly's code.
 *  (c) Board of Trustees, Leland Stanford Junior University
 */

#include <math.h>
#include <stdio.h>
#include "mex.h"

#define MAXN (4096)

#define max(a,b) ((a)>(b) ? (a) : (b))

/* driver for matlab call  */

#define A prhs[0]		/* alpha, beta polynomials */
#define B prhs[1]		

#define RF plhs[0]		/* RF out - complex */

void cabc2rf( double *a, double *b, int n, double *rf);

double a[MAXN*2], b[MAXN*2], rf[MAXN*2];


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

   double *ar, *ai, *br, *bi, *rfr, *rfi;

   int n;
   int i, j;

   if ((nrhs != 2) || (nlhs != 1))
      mexErrMsgTxt("Usage: [rf] = cabc2rf (a,b)");

   n = max (mxGetN(A), mxGetM(A));
   if (n > MAXN) 
      mexErrMsgTxt ("alpha polynomial too long");

   if (max (mxGetN(B), mxGetM(B)) != n)
       mexErrMsgTxt ("alpha, beta polynomials MUST be same length");

   /* copy a, b into arrays */
   ar = mxGetPr(A); ai = mxGetPi(A);
   br = mxGetPr(B); bi = mxGetPi(B);
   for (i=0; i<n; i++) {
      a[i*2] = ar[i];
      if (ai != NULL)
		a[i*2+1] =ai[i];
      else
		a[i*2+1] = 0.0;
      b[i*2] =br[i];
      if (bi != NULL)
		b[i*2+1] = bi[i];
      else
		b[i*2+1] = 0.0;
   }

   /* call routine c_abc2rf now */
   cabc2rf (a, b, n, rf);

   /* copy rf back into matlab matrix */
   RF = mxCreateDoubleMatrix (1, n, mxCOMPLEX);
   rfr = mxGetPr(RF); rfi = mxGetPi(RF);
   for (i=0; i<n; i++) {
      rfr[i] = rf[i*2];
      rfi[i] = rf[i*2+1];
   }
}

#undef MAXN
#include "cabc2rf.code.c"
#include "four1.c"

