#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "parse.h"
#include "print_with_flags.h"

#define SHORT_OPTIONS "beEnstTv"

int main(int argc, char *argv[]) {
  flags flags = {0};
  int k = 1;

  while (k < argc && argv[k][0] == '-') k++;

  struct option long_options[] = {{"number-nonblank", no_argument, NULL, 'b'},
                                  {"number", no_argument, NULL, 'n'},
                                  {"squeeze-blank", no_argument, NULL, 's'}};

  if (getFlags(argc, argv, SHORT_OPTIONS, long_options, &flags) && argc >= 2) {
    for (int i = k; i < argc; i++) {
      printFile(argv[i], flags);
    }
  }

  return 0;
}
