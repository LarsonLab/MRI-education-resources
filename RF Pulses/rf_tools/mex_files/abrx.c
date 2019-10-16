/*
 *
 *    Standard Bloch equation integration on 3-D, cayley-klein version
 *
 *    Version for 2-D gradients
 *
 *    .mex version of abr.c
 *
 *    Written by John Pauly, 1990
 *      jmp   7/7/93   translate to 4.0
 *    (c) Board of Trustees, Leland Stanford Junior University
 */

#include <stdio.h>
#include <math.h>
#include <ctype.h>
#include "mex.h"

#define RF	prhs[0]  /* complex rf */
#define GC 	prhs[1]  /* complex gradient */
#define X   prhs[2]  /* x samples */
#define Y   prhs[3]  /* y samples */

#define ALF	plhs[0]  /* 2D grid of alpha's */
#define BET	plhs[1]  /* 2D grid of alpha's */

#define max(a,b)  ((a)>(b) ? (a) : (b))
#define min(a,b)  ((a)<(b) ? (a) : (b))

double *rfi, *rfq, *gx, *gy, x, y, *alpr, *alpi, *btpr, *btpi, *xp, *yp;
int ns;
char s[80];
void abrot(double a[2], double b[2]);

void mexFunction(int nlhs,mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  int  nx, ny, ix, iy;
  double alf[2], bet[2];

  if ((nrhs < 3) || (nrhs > 4)  || (nlhs != 2))
    mexErrMsgTxt("Usage: [alpha, beta] = abrx(rf, g, x {, y})");
  
  ns = max(mxGetN(RF),mxGetM(RF));
  if (ns != max(mxGetN(GC),mxGetM(GC)))
    mexErrMsgTxt("rf and gradient vectors are of different lengths");

/*  mexErrMsgTxt(sprintf(s,"ns=%d",ns)); */
  
  gx = mxGetPr(GC); 
  if (nrhs==4) gy = mxGetPi(GC);
  rfi = mxGetPr(RF); rfq = mxGetPi(RF);

  nx = max(mxGetN(X),mxGetM(X));
  if (nrhs==4)
    ny = max(mxGetN(Y),mxGetM(Y));
  else
    ny = 1;

  ALF = mxCreateDoubleMatrix(nx,ny,mxCOMPLEX);
  alpr = mxGetPr(ALF);   alpi = mxGetPi(ALF);
  BET = mxCreateDoubleMatrix(nx,ny,mxCOMPLEX);
  btpr = mxGetPr(BET);   btpi = mxGetPi(BET);

  if (nrhs==4) yp = mxGetPr(Y);
  xp = mxGetPr(X);

  for (iy=0; iy<ny; iy++) {
    if (nrhs==4) y = yp[iy]; else y = 0;
    for (ix=0; ix<nx; ix++) {
      x = xp[ix];
      alf[0] = 1.0; alf[1] = 0.0; bet[0] = 0.0; bet[1] = 0.0;
      abrot(alf, bet);
      alpr[ix + iy*nx] = alf[0];
      alpi[ix + iy*nx] = alf[1];
      btpr[ix + iy*nx] = bet[0];
      btpi[ix + iy*nx] = bet[1];
    }
  }
}

void abrot(double a[2], double b[2])
{
    double phi, nx, ny, nz, snp, csp, cg, cpr, cpi, time;
    double al[2], be[2], ap[2], bp[2];
    int k;

    for (k=0; k<ns; k++) {
        cg = x*gx[k];
        if (gy != NULL) cg += y*gy[k];
        cpr = rfi[k];
        cpi = 0;
        if (rfq != NULL) cpi = rfq[k];
        phi = sqrt(cg*cg+cpr*cpr+cpi*cpi);
	if (phi>0.0) {
	    nx = cpr/phi; ny = cpi/phi; nz = cg/phi;
	} else {
	    nx = 0.0; ny = 0.0; nz = 1.0;   /* doesn't matter, phi=0*/
        }
        csp = cos(phi/2); snp = sin(phi/2);
        al[0] = csp; al[1] = nz*snp;
        be[0] = ny*snp; be[1] = nx*snp;

        bp[0] = al[0]*b[0]-al[1]*b[1]+be[0]*a[0]-be[1]*(-a[1]);
        bp[1] = al[0]*b[1]+al[1]*b[0]+be[1]*a[0]+be[0]*(-a[1]);

        ap[0] =   -(  be[0] *b[0]-(-be[1])*b[1]) 
                                        +   al[0] *a[0]-(-al[1])*(-a[1]);
        ap[1] = -(-(-(be[1])*b[0]+  be[0] *b[1]) 
                                        + (-al[1])*a[0]+  al[0] *(-a[1]));

        a[0] = ap[0]; a[1] = ap[1]; b[0] = bp[0]; b[1] = bp[1];
    }
    
    return;
}
