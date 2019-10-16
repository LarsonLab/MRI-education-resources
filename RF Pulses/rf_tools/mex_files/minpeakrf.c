/*
 *  [zmin] = minpeakrf (z, flip, bsf)
 *
 *  Given the roots z, and a set of n of which to flip, do the following:
 *  For each combination of flips
 *     determine the polynomial b, normalize and scale by bsf, 
 *     calculate the rf pulse from b
 *     save which combination of zeros flips minimizes peak rf and return
 *     
 *
 *  Written by Adam Kerr, October 1992, 
 *  Adapted from John Pauly's code
 *  (c) Board of Trustees, Leland Stanford Junior University
 */

#include <math.h>
#include <stdio.h>
#include <mex.h>
#define MAXN 1024

#define max(a,b) ((a)>(b) ? (a) : (b))
#define min(a,b) ((a)<(b) ? (a) : (b))
#define mag(a,j) (hypot (a[(j)*2], a[(j)*2+1]))

/* driver for matlab call  */

#define Z prhs[0]		/* complex z roots */
#define FLIP prhs[1]		/* indices of roots to flip */
#define BSF prhs[2]		/* scaling factor for beta polynomial */

#define ZMIN plhs[0]		/* complex roots */

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
   double z[MAXN*2], z0[MAXN*2];
   double zmin[MAXN*2], *zpi, *zpr, *flp;
   int    sflip[MAXN];
   int    cflip[MAXN*2];
   int nflip, nroots;
   int nsflip, ncflip;
   double bsf;
   int i, j;
   int ncomb;
   double start_peakrf;
   double min_peakrf, peakrf;
   int min_index;
   int bittest;
   int r;
   int r1, r2;
   double z2peakrf();
   void b2a();

   if ((nrhs != 3) || (nlhs != 1))
      mexErrMsgTxt  ("Usage: [zmin] = minpeakrf (z, flip, bsf)");

   nroots = max (mxGetN(Z), mxGetM(Z));
   if (nroots+1 > MAXN) 
      mexErrMsgTxt ("z vector too long");

   nflip = mxGetM(FLIP);

   bsf = mxGetPr(BSF)[0];
   if ((bsf < 0) || (bsf > 1.0))
      mexErrMsgTxt ("bsf not in 0..1");

   /* copy z into c array */
   zpr = mxGetPr(Z);
   zpi = mxGetPi(Z);
   for (i=0; i<nroots; i++)
   {
      z[i*2] = zpr[i];
      z[i*2+1] = zpi[i];
   }

   /* copy flip into c arrays of single and conjugate flips  */
   ncflip=nsflip=0;
   flp = mxGetPr(FLIP);
   for (i=0; i<nflip; i++)
      if (flp[i+nflip] == 0) /* a single flip root */
	 sflip [nsflip++] = flp[i]-1;
      else			/* a conjugate root */
      {
	 cflip [ncflip*2] = flp[i]-1;
	 cflip [ncflip*2+1] = flp[i+nflip]-1;
	 ncflip++;
      }
   nflip = ncflip + nsflip;


   /* copy roots into z0 */
   for (i=0; i<nroots; i++)
   {
      z0[i*2] = z[i*2];
      z0[i*2+1] = z[i*2+1];
   }

   /* for conjugate roots make sure they are in symmetric conjugate 
      order at first by making sure they're on the same side
      of the unit circle... */
   for (i=0; i<ncflip; i++)
   {
      if ((mag(z, cflip[i*2]) - 1)/ (mag(z, cflip[i*2+1]) - 1) < 0)
	 flip_root (z0, z, cflip[i*2]);
   }

   /* copy roots into zmin */
   for (i=0; i<nroots; i++)
   {
      zmin[i*2] = z0[i*2];
      zmin[i*2+1] = z0[i*2+1];
   }

   /* for each flip combination now, determine the peak rf */
   ncomb = pow (2.0, (double) nflip);
   mexPrintf ("Number of iterations required: %d\n", ncomb);
   start_peakrf = z2peakrf (z0, nroots, bsf);
   min_peakrf = start_peakrf;
   min_index = 0;
   for (i=0; i<ncomb; i++)
   {
      bittest = 1;
      /* do single flip roots first */
      for (j=0; j<nsflip; j++)
      {
	 r = sflip[j];
	 if ((i & bittest) == 0)
	 {
	    zmin[r*2] = z0[r*2];		/* if bit=0 leave root */
	    zmin[r*2+1] = z0[r*2+1];
	 }
	 else
	 {
	    flip_root (zmin, z0, r);
	 }
	 bittest = bittest << 1;
      }
      /* now do conjugate roots */
      for (j=0; j<ncflip; j++)
      {
	 r1 = cflip[j*2];
	 r2 = cflip[j*2+1];
	 if ((i & bittest) == 0)
	 {
	    zmin[r1*2] = z0[r1*2];		/* if bit=0 leave 1st */
	    zmin[r1*2+1] = z0[r1*2+1];
	    flip_root (zmin, z0, r2);		/* flip second */
	 }
	 else
	 {
	    flip_root (zmin, z0, r1); 		/* else, flip first */
	    zmin[r2*2] = z0[r2*2];		/* and leave second */
	    zmin[r2*2+1] = z0[r2*2+1];
	 }
	 bittest = bittest << 1;
      }
      peakrf = z2peakrf (zmin, nroots, bsf);
      if (peakrf <= min_peakrf)
      {
	 min_peakrf = peakrf;
	 min_index = i;
      }

      if (i % 200 == 0) 
	 mexPrintf ("Iteration: %d;  Peak RF: %f; Minimum Peak RF: %f\n", 
		     i, peakrf, min_peakrf);
   }	 
   
   /* now pass back zmin of minimum peak rf pulse */
   bittest = 1;
   /* do single flip roots first */
   for (j=0; j<nsflip; j++)
   {
      r = sflip[j];
      if ((min_index & bittest) == 0)
      {
	 zmin[r*2] = z0[r*2];		/* if bit=0 leave root */
	 zmin[r*2+1] = z0[r*2+1];
      }
      else
      {
	 flip_root (zmin, z0, r);
      }
      bittest = bittest << 1;
   }
   /* now do conjugate roots */
   for (j=0; j<ncflip; j++)
   {
      r1 = cflip[j*2];
      r2 = cflip[j*2+1];
      if ((min_index & bittest) == 0)
      {
	 zmin[r1*2] = z0[r1*2];		/* if bit=0 leave 1st */
	 zmin[r1*2+1] = z0[r1*2+1];
	 flip_root (zmin, z0, r2);		/* flip second */
      }
      else
      {
	 flip_root (zmin, z0, r1); 		/* else, flip first */
	 zmin[r2*2] = z0[r2*2];		/* and leave second */
	 zmin[r2*2+1] = z0[r2*2+1];
      }
      bittest = bittest << 1;
   }

   peakrf = z2peakrf (zmin, nroots, bsf);
   mexPrintf ("At the end, peakrf: %f; Index: %d\n", peakrf, min_index);

   ZMIN = mxCreateDoubleMatrix (1, nroots, mxCOMPLEX);
   zpr = mxGetPr(ZMIN); zpi = mxGetPi(ZMIN);
   for (i=0; i<nroots; i++)
   {
      zpr[i] = zmin[i*2];
      zpi[i] = zmin[i*2+1];
   }
}

double z2peakrf (zmin, nroots, bsf)
double zmin[];
int nroots;
double bsf;
{
   double beta[MAXN*2];
   double rf[MAXN*2];
   double alpha[MAXN*2];
   int i, n;
   double peakrf;
   void b2a();

   n = nroots+1;

   /* get beta polynomial */
   npoly (zmin, nroots, beta);

   /* normalize by bsf */
   for (i=0; i<n; i++)
   {
      beta[i*2] *= bsf;
      beta[i*2+1] *= bsf;
   }
   
   /* now get alpha from beta */
   b2a (beta, n, alpha);

   /* now get rf from alpha, beta */
   cabc2rf (alpha, beta, n, rf);

   for (i=1, peakrf=mag(rf,0); i<n; i++)
      peakrf = max (mag(rf,i), peakrf);

   return (peakrf);
}

flip_root (zmin, z, r)
double zmin[];
double z[];
int r;
{
   double norm_r;
   
   norm_r = pow (z[r*2], 2.0) + pow(z[r*2+1], 2.0);
   zmin[r*2] = z[r*2] / norm_r;
   zmin[r*2+1] = z[r*2+1] / norm_r;
}

/*
 *  b2a (b, n, a)
 *  
 *  C program version of b2a.
 *
 *  Gets complex minimum phase a from complex polynomial b.
 *
 *
 *  Written by Adam Kerr, October 1992
 *  Modified from John Pauly's code.
 *  (c) Board of Trustees, Leland Stanford Junior University
 */

#include <math.h>

#define ZEROPAD (8)
#define MAXNP (1024 * ZEROPAD)
#define MP (0.0000001)

#define max(a,b) ((a)>(b) ? (a) : (b))
#define min(a,b) ((a)<(b) ? (a) : (b))
#define magsqr(a,j) (a[2*j]*a[2*j] + a[2*j+1]*a[2*j+1])
void four1(double bf[], int nnc, int fwd);
double bf[MAXNP*2], am[MAXNP*2], af[MAXNP*2];

void b2a(double *b, int n, double *a)
{
  double bmx, bm, p;
  int i, j, nn, nnc;

  /* next bigger power of 2 */
  nn = (int) (exp(log(2)*ceil(log((double)n)/log(2))))+1;

  /* size of arrays used for computation */
  nnc = nn*ZEROPAD;

  for (i=0; i<n; i++) {bf[i*2] = b[i*2]; bf[i*2+1] = b[i*2+1];}
  for (i=n; i<nnc; i++) {bf[i*2] = 0; bf[i*2+1] = 0.0;}
  four1(bf-1, nnc, 1);

  /* check to see (| Fourier (beta(x)) |) < 1 */

  for (i=0, bmx=0; i<nnc; i++)
  {
     bm = magsqr(bf,i);
     if (bm > bmx) 
	bmx = bm;
  }
  if (bmx >= 1.0)
     for (i=0; i<nnc; i++) 
     {
	bf[i*2] /= (sqrt(bmx)+MP);
	bf[i*2+1] /= (sqrt(bmx)+MP);
     }

  /* compute |alpha(x)| */
  for (i=0; i<nnc; i++) {
    am[i*2] = sqrt(1.0 - magsqr(bf,i));
  }

  /* compute the phase of alpha, mag and phase are HT pair */
  /* ABK - God, it took me forever to figure out what John did here...
     he wants the hilbert transform of the log magnitude, so what
     he does is to generate the analytic version of the signal knowing
     that the imaginary part will be the negative of the hilbert transform
     of the log magnitude....  this is why I took 261...
     */
  for (i=0; i<nnc; i++) {
    af[i*2] = log(am[i*2]); 
    af[i*2+1] = 0;
  }
  four1(af-1,nnc,1);
  for (i=1; i<(nnc/2)-1; i++) {	/* leave DC and halfway point untouched!! */
    af[i*2] *= 2.0;
    af[i*2+1] *= 2.0;
  }
  for (i=(nnc/2)+1; i<nnc; i++) {
    af[i*2] = 0.0;
    af[i*2+1] = 0.0;
  }
  four1(af-1,nnc,-1);
  for (i=0; i<nnc; i++) {
    af[i*2] /= nnc;
    af[i*2+1] /= nnc;
  }

  /* compute the minimum phase alpha */
  for (i=0; i<nnc; i++) {
    p = af[i*2+1];
    af[i*2] = am[i*2] * cos(-p);
    af[i*2+1] = am[i*2] * sin(-p);
  }

  /* compute the minimum phase alpha coefficients */
  four1(af-1, nnc, -1);
  for (i=0; i<n; i++)
  {
    j = n-i-1;
    a[j*2] = af[i*2]/nnc;
    a[j*2+1] = af[i*2+1]/nnc;
  }
}



#include <math.h>

#define SWAP(a,b) tempr=(a);(a)=(b);(b)=tempr

void four1(double data[], int nn, int isign)
{
	int n,mmax,m,j,istep,i;
	double wtemp,wr,wpr,wpi,wi,theta;
	double tempr,tempi;

	n=nn << 1;
	j=1;
	for (i=1;i<n;i+=2) {
		if (j > i) {
			SWAP(data[j],data[i]);
			SWAP(data[j+1],data[i+1]);
		}
		m=n >> 1;
		while (m >= 2 && j > m) {
			j -= m;
			m >>= 1;
		}
		j += m;
	}
	mmax=2;
	while (n > mmax) {
		istep=2*mmax;
		theta=6.28318530717959/(isign*mmax);
		wtemp=sin(0.5*theta);
		wpr = -2.0*wtemp*wtemp;
		wpi=sin(theta);
		wr=1.0;
		wi=0.0;
		for (m=1;m<mmax;m+=2) {
			for (i=m;i<=n;i+=istep) {
				j=i+mmax;
				tempr=wr*data[j]-wi*data[j+1];
				tempi=wr*data[j+1]+wi*data[j];
				data[j]=data[i]-tempr;
				data[j+1]=data[i+1]-tempi;
				data[i] += tempr;
				data[i+1] += tempi;
			}
			wr=(wtemp=wr)*wpr-wi*wpi+wr;
			wi=wi*wpr+wtemp*wpi+wi;
		}
		mmax=istep;
	}
}

#undef SWAP

/*
 *  npoly (z, n, b)
 *  
 *  C program version of npoly.
 *
 *  Gets polynomial b from roots z, then normalizes polynomial so
 *  max (abs (fft(b))) = 1.
 *
 *  Written by Adam Kerr, October 1992
 *  Modified from John Pauly's code.
 *  (c) Board of Trustees, Leland Stanford Junior University
 */

#include <math.h>

/*define MAXN (1024)*/

#define max(a,b) ((a)>(b) ? (a) : (b))
#define min(a,b) ((a)<(b) ? (a) : (b))
#define mag(a,j) (hypot (a[(j)*2], a[(j)*2+1]))
#define re_mult(a1,b1,a2,b2) ((a1)*(a2) - (b1)*(b2))
#define im_mult(a1,b1,a2,b2) ((a1)*(b2) + (a2)*(b1))

npoly (z, n, b)
double z[], b[];
int n;
{
   int i;
   int nn;
   double bf[MAXN*2];
   double bfmax, bfmag;

   b[0] = 1;	     	/* b[0] = 1 + i0 */
   b[1] = 0;
   for (i=0; i<n; i++)
      polymult (b, i, z+i*2);
   
   /* normalize polynomial now */

   /* next bigger power of 2 */
   nn = rint (exp(M_LN2*ceil(log((double)(n+1))/M_LN2)));
   for (i=0; i<2*(n+1);i++)
      bf[i] = b[i];
   for (i=2*(n+1); i<nn*2; i++)
      bf[i] = 0.0;
   four1 (bf-1, nn, 1);
   for (i=1, bfmax=mag(bf,0); i<nn; i++)
      bfmax = max (mag(bf,i), bfmax);

   for (i=0; i<2*(n+1); i++)
      b[i] /= bfmax;
}

polymult (p, order, root)
double p[];
int order;
double root[];
{
   double a, b;
   int i;

   a = -root[0];
   b = -root[1];
   p[(order+1)*2] = 0;
   p[(order+1)*2+1] = 0;
   for (i=order+1; i>0; i--)
   {
      p[(i*2)] += re_mult(p[(i-1)*2], p[(i-1)*2+1],a, b);
      p[(i*2)+1] += im_mult(p[(i-1)*2], p[(i-1)*2+1], a, b);
   }
}


/*
 *  cabc2rf (a, b, n, rf)
 *  
 *  C program version of cabc2rf.
 *
 *  Performs inverse SLR tranform on complex a,b to give complex rf pulse
 *
 *
 *  Written by Adam Kerr, October 1992
 *  Modified from John Pauly's code.
 *  (c) Board of Trustees, Leland Stanford Junior University
 */

#include <math.h>

/*define MAXN (1024)*/

#define max(a,b) ((a)>(b) ? (a) : (b))
#define min(a,b) ((a)<(b) ? (a) : (b))
#define mag(a,j) (sqrt (a[(j)*2]*a[(j)*2]+a[(j)*2+1]*a[(j)*2+1]))
#define re_div(a,i,b,j) ((a[i*2]*b[j*2] + a[i*2+1]*b[j*2+1])/(b[j*2]*b[j*2] + b[j*2+1]*b[j*2+1]))
#define im_div(a,i,b,j) ((a[i*2+1]*b[j*2] - a[i*2]*b[j*2+1])/(b[j*2]*b[j*2] + b[j*2+1]*b[j*2+1]))
double a2[MAXN*2], b2[MAXN*2];


void cabc2rf(double a[], double b[], int n, double rf[])
{
   int i, j;
   double sj[2], cj;
   double phi, theta;		/* use definitions from SLR paper, somewhat
				 different from those in John's abc2rf() */

   for (j=n-1; j>=0; j--)
   {
      /* get real cj and complex sj now */
      cj = sqrt (1 / (1 + (b[j*2]*b[j*2] + b[j*2+1]*b[j*2+1])/
		            (a[j*2]*a[j*2] + a[j*2+1]*a[j*2+1]) ));
      sj[0] = re_div (b,j,a,j) * cj;
      sj[1] = -im_div (b,j,a,j) * cj;

      /* get phi and theta now */
      phi = 2 * atan2 (mag(sj,0), cj);
      theta = atan2 (sj[1],sj[0]);

      /* get rf now from phi and theta */
      rf[j*2] = phi * cos (theta);
      rf[j*2+1] = phi * sin (theta);

      /* create new polynomials now */
      for (i=0; i<=j; i++)
      {
	 a2[i*2] = cj * a[i*2] + sj[0] * b[i*2] - sj[1] * b[i*2+1];
	 a2[i*2+1] = cj * a[i*2+1] + sj[0] * b[i*2+1] + sj[1] * b[i*2];
	 b2[i*2] = -sj[0] * a[i*2] - sj[1] * a[i*2+1] + cj * b[i*2];
	 b2[i*2+1] = -sj[0] * a[i*2+1] + sj[1] * a[i*2] + cj * b[i*2+1];
      }
      
      /* copy back into old polynomials now */
      /* try other way 
      for (i=0; i<=j-1; i++)
      {
	 a[i*2] = a2[i*2+2];
	 a[i*2+1] = a2[i*2+3];
	 b[i*2] = b2[i*2];
	 b[i*2+1] = b2[i*2+1];
      } */
      for (i=0; i<=2*j-1; i++)
      {
	 a[i] = a2[i+2];
	 b[i] = b2[i];
      }
   }
}

