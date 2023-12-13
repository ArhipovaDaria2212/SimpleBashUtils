#include "print_with_flags.h"

void printFile(char *fileName, flags flags) {
  FILE *fp;

  if ((fp = fopen(fileName, "r")) == NULL) {
    fprintf(stderr, "cat: %s: No such file or directory\n", fileName);
  } else {
    processingWithFlags(fp, flags);
    fclose(fp);
  }
}

void processingWithFlags(FILE *fp, flags flags) {
  int ch;
  int k = 1, start = 1, emptyString = 0;

  while ((ch = fgetc(fp)) != EOF) {
    if (flags.s && ch == '\n' && start) {
      if (emptyString)
        continue;
      else
        emptyString = 1;
    }
    if ((flags.n || (flags.b && ch != '\n')) && start) {
      printf("%6d\t", k);
      k++;
    }
    if (flags.e && ch == '\n') {
      printf("$");
    }

    if (ch == '\n')
      start = 1;
    else {
      emptyString = 0;
      if (start) start = 0;
    }

    if (flags.t && ch == '\t') {
      printf("^I");
      continue;
    }

    if (flags.v) {
      printNoPrintable(ch);
    } else {
      printf("%c", ch);
    }
  }
}

void printNoPrintable(int ch) {
  if (ch >= 0 && ch <= 31 && ch != 10 && ch != 9) {
    printf("^%c", ch + 64);
  } else if (ch == 127) {
    printf("^%c", 63);
  } else if (ch >= 128 && ch <= 159) {
    printf("M-^%c", ch - 64);
  } else {
    printf("%c", ch);
  }
}