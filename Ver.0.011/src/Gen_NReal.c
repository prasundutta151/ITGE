# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include <math.h>
# include <omp.h>
 
# define NARG (7)

int main(int argc, char *argv[]){

  int ii, nthreads, tid, NReal;
  float alp;
  char command[256], ITGE[128], script[128], prefix[128], VISFILE[128], MASKFILE[128];

  if(argc!=NARG){

    fprintf(stderr, "USAGE: ./argv[0] <script> <NReal> <NThreads> <ITGE> <VISFILE> <MASKFILE>\n", argv[0]);
    return EXIT_FAILURE;
  }

  sprintf(script, "%s", argv[1]); 
  NReal = (int)atoi(argv[2]);
  nthreads = (int)atoi(argv[3]);
  sprintf(ITGE, "%s", argv[4]);
  sprintf(VISFILE, "%s", argv[5]);
  sprintf(MASKFILE, "%s", argv[6]);

  omp_set_num_threads(nthreads);

#pragma omp parallel for private(tid, ii, command)
  for(ii=0; ii<NReal; ii++){

    tid = omp_get_thread_num();
    sprintf(command, "sh %s %s %s %d > ./log/log%d", script, ITGE, VISFILE, MASKFILE, ii);
    system(command);
  }

  return 0;
}
