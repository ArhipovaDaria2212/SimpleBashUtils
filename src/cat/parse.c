#include "parse.h"

#include <stdio.h>

int getFlags(int argc, char **argv, char *shortFlags, struct option longFlags[],
             flags *flags) {
  int flag = 0, error = 0, i = 0, k = 1;

  while (k < argc && argv[k][0] == '-') k++;
  char *argvFlags[k];

  for (int i = 0; i < k; i++) {
    argvFlags[i] = argv[i];
  }

  while ((flag = getopt_long(k, argvFlags, shortFlags, longFlags, &i)) != -1) {
    switch (flag) {
      case 'b':
        flags->b = 1;
        break;
      case 'e':
        flags->e = 1;
        flags->v = 1;
        break;
      case 'E':
        flags->e = 1;
        break;
      case 'n':
        flags->n = 1;
        break;
      case 's':
        flags->s = 1;
        break;
      case 't':
        flags->t = 1;
        flags->v = 1;
        break;
      case 'T':
        flags->t = 1;
        break;
      case 'v':
        flags->v = 1;
        break;
      case '?':
        error = 1;
        break;
      default:
        error = 1;
        break;
    }
  }

  if (flags->b) {
    flags->n = 0;
  }

  return !error;
}