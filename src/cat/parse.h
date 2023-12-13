#ifndef PARSE_H
#define PARSE_H

#include <getopt.h>
#include <string.h>

typedef struct {
  int b;
  int e;
  int n;
  int s;
  int t;
  int v;
} flags;

int getFlags(int argc, char **argv, char *shortFlags, struct option longFlags[],
             flags *flags);

#endif