/*  NAME:         Mask_Gen.c                                       */
/*  Derived from: Gauss_2D_FITS_sal.c                             */
/*  Description:     Generates a FITS file with Gaussian  random  */
/*                   numbers with a powerspectrum and geometry    */
/*                   from an ASCII  file. Data mean is non-zero.  */
/*                   CDELT1/2 and BMAJ/MIN are written in degree  */
/*                   A time based seed build in the program.      */
/*  Developer:    Prasun Dutta, IIT (BHU), Varanasi               */
/*  Contact:      pdutta.phy@itbhu.ac.in                          */
/*  InputFIle:    Example-----------------------------------------*/
/*
# ==================== GAUSS GEN PARAMEERS =================================
# VALUE --------------------  PARAM  --------TYP---- COMMENT ---------------
#
1024             1.E-3      : NGrid, dxy    [I, D]    [,deg]
1.6E-2		 1.5E-2	    : BMaj, BMin    [D, D]    [deg, deg]
1.                          : Tau0          [D]       
*/
/* =======================================================================*/
/* ISSUES:   Normalization along with PowFits2D_dbl                       */

# include <stdio.h>
# include <math.h>
# include <stdlib.h>
# include <nr.h>
# include <nrutil.h>
# include <unistd.h>
# include <string.h>
# include <fitsio.h>
# include <fftw3.h>
# include <sys/stat.h>

# define EXP_NARG 5
# define SMAX  (8388608)
# define MSQR(a) (a*a)
# define DTR (M_PI/180.)

double *data;

float RR;
int NN;

float BWF(float xv, float yv){

  float rval, val;
  rval = sqrt(xv*xv + yv*yv);
  val = 1./(1. + pow(rval/RR, NN));
  return val;
}

int Access(char *filename){
  struct stat   buffer;   
  return (stat (filename, &buffer) == 0);
}

int printerror(int status){
  if (status){
    fits_report_error(stderr, status); // Print error report
    exit(status );    // Terminate the program, returning error status
  }
}

int main(int argc, char *argv[]){

  int ii, jj, index, NGrid, delx, Ng;
  float xx, yy, Umax, dU
;
  FILE *fp;
  char INPFILE[128], OUTFITS[128], param[128];

  if(argc!=EXP_NARG){
    printf("\nUSAGE : %s <INPFILE> <OUTFITS> <RR> <NN>\n", argv[0]);
    printf("INPFILE: Input  file\n");
    printf("OUTFITS: Output FITS file\n");
    printf("RR     : Radius of the Mask in arc min\n");
    printf("NN     : Butterworth Order \n\n");
    printf("\n");
    return 1;
  }

  sscanf(argv[1], "%s", INPFILE);
  sscanf(argv[2], "%s", OUTFITS);
  
  RR = (float)atof(argv[3]);
  NN = (int)atof(argv[4]);

  printf("Inputs are read\n");

  if(Access(INPFILE)==0){
    printf("Input File %s does not  exists\n", INPFILE);
    return EXIT_FAILURE;
  }

  if(Access(OUTFITS)!=0){
    printf("Output File %s exists\n", OUTFITS);
    return EXIT_FAILURE;
  }
  
 //reading input parameter
  fp=fopen(INPFILE,"r");

  fgets(param,100, fp);
  
  fgets(param,100, fp);
  sscanf(param,"%f%*lf%f",&Umax, &dU);
 
  fclose(fp);

  Ng =(int) ceil(Umax/dU);
  NGrid = 2*Ng +2;           
 
  printf("NGrid = %d\n", NGrid);

  fitsfile *fptro;
  int status=0, anynul=0;
  float nulval=0.;
  double DL;
  long nel, naxis, *naxes;
  char comment[FLEN_COMMENT];

  DL = 3.434312458E-02;

  nel = NGrid*NGrid;
  data  = (double *)calloc(nel, sizeof(double));

  for (ii=0; ii<NGrid; ii++)
    for(jj=0; jj<NGrid; jj++){

      xx = (ii - NGrid/2 + 0.5)*DL;
      yy = (jj - NGrid/2 + 0.5)*DL;
      index = ii*NGrid + jj;
      data[index] = BWF(xx,yy);
    }
  status = 0;
  naxis  = 2;
  naxes = (long *)calloc(naxis, sizeof(long));
  naxes[0] = NGrid;
  naxes[1] = NGrid;

  sprintf(comment, "\\");
  if(fits_create_file(&fptro, OUTFITS, &status))
    printerror(status);
  if(fits_create_img(fptro,  DOUBLE_IMG, naxis, naxes, &status))
    printerror(status);
  if(fits_write_key(fptro, TDOUBLE, "CDELT1", &DL, comment, &status))
    printerror( status );
  if(fits_write_key(fptro, TDOUBLE, "CDELT2", &DL, comment, &status))
    printerror( status );

  if(fits_write_img(fptro, TDOUBLE, 1, nel,  data,  &status))
    printerror(status);
  printf("Data stored in datao\n");
  fits_close_file(fptro,&status);

  printf("OUTFILE = %s\n\n", OUTFITS);
  return 0;
}
