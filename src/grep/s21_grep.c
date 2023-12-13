#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "parse.h"

int getRegex(lines patterns, regex_t* regex, flags flags);
void processing(char* filename, int filesCount, flags flags, regex_t* regex,
                int regexLength);
int countMatches(regex_t* regex, int regexLength, char* str, flags flags,
                 int filesCount, char* filename, int stringNum);
void printFile(FILE* fp, char* filename, int filesCount, flags flags,
               regex_t* regex, int regexLength);
void printStringWithFlags(flags flags, char* string, int matchesNum,
                          int filesCount, char* filename, int stringNum,
                          int flag);
void printC(int filesCount, char* filename, int count, flags flags);
void printSubstring(flags flags, int filesCount, char* filename, int stringNum,
                    char* str, int flag);

#define SHORT_OPTIONS "e:ivclnhsf:o"

int main(int argc, char* argv[]) {
  flags flags = {0};
  lines patterns;
  lines files;
  regex_t* regex = NULL;

  if (argc > 1) {
    createLines(&patterns);
    createLines(&files);

    if (parseParams(argc, argv, SHORT_OPTIONS, &flags, &patterns, &files)) {
      if (files.length == 0) {
        fprintf(stderr, "usage: grep [-ivclnhso] [-e pattern] [-f file]\n");
        freeLines(&patterns);
        freeLines(&files);
        return 0;
      }
      regex = (regex_t*)malloc(sizeof(regex_t) * patterns.length);

      if (getRegex(patterns, regex, flags)) {
        for (int i = 0; i < files.length; i++) {
          processing(files.array[i], files.length, flags, regex,
                     patterns.length);
        }
      }
    }

    freeLines(&patterns);
    freeLines(&files);
    if (regex != NULL) {
      for (int i = 0; i < patterns.length; i++) {
        regfree(&regex[i]);
      }
      free(regex);
    }
  } else {
    fprintf(stderr, "usage: grep [-ivclnhso] [-e pattern] [-f file]\n");
  }

  return 0;
}

int getRegex(lines patterns, regex_t* regex, flags flags) {
  int error = 0, res = 0;

  for (int i = 0; i < patterns.length; i++) {
    if (flags.i) {
      res = regcomp(&regex[i], patterns.array[i], REG_ICASE);
    } else {
      res = regcomp(&regex[i], patterns.array[i], 0);
    }
    if (res) {
      error = 1;
      break;
    }
  }

  return !error;
}

void processing(char* filename, int filesCount, flags flags, regex_t* regex,
                int regexLength) {
  FILE* fp;

  if ((fp = fopen(filename, "r")) != NULL) {
    printFile(fp, filename, filesCount, flags, regex, regexLength);
    fclose(fp);
  } else {
    if (!flags.s)
      fprintf(stderr, "grep: %s: No such file or directory\n", filename);
  }
}

void printFile(FILE* fp, char* filename, int filesCount, flags flags,
               regex_t* regex, int regexLength) {
  int size = 256, k = 0, count = 0, flag = 0;
  int matches = 0, stringNum = 1;
  char* str = malloc(sizeof(char) * size);
  char ch;

  while ((ch = fgetc(fp)) != EOF) {
    str[k++] = ch;
    flag = 1;
    if (ch == '\n') {
      str[k++] = '\0';

      matches = countMatches(regex, regexLength, str, flags, filesCount,
                             filename, stringNum);
      if (matches > 0) count++;
      if (!flags.o && !flags.l && !flags.c) {
        printStringWithFlags(flags, str, matches, filesCount, filename,
                             stringNum, 0);
      }

      k = 0;
      str[0] = '\0';
      stringNum++;
    }
    if (k + 10 > size) {
      size += 50;
      str = realloc(str, sizeof(char) * size);
    }
  }
  if (flag) {
    str[k++] = '\n';
    str[k++] = '\0';

    matches = countMatches(regex, regexLength, str, flags, filesCount, filename,
                           stringNum);
    if (matches > 0) count++;

    if (!flags.o && !flags.l && !flags.c && flag)
      printStringWithFlags(flags, str, matches, filesCount, filename, stringNum,
                           0);
    if (flags.c && flags.l) {
      if (count > 0) {
        printC(filesCount, filename, 1, flags);
        printf("%s\n", filename);
      } else {
        printC(filesCount, filename, 0, flags);
      }
    } else {
      if (flags.c) printC(filesCount, filename, count, flags);
      if (flags.l && flag && count > 0) printf("%s\n", filename);
    }
  } else {
    if (flags.c) printC(filesCount, filename, 0, flags);
  }

  free(str);
}

void printStringWithFlags(flags flags, char* string, int countMatches,
                          int filesCount, char* filename, int stringNum,
                          int flag) {
  if (countMatches > 0) {
    if (filesCount > 1 && !flags.h && !flag) printf("%s:", filename);
    if (flags.n && !flag) printf("%d:", stringNum);
    printf("%s", string);
  }
}

int countMatches(regex_t* regex, int regexLength, char* str, flags flags,
                 int filesCount, char* filename, int stringNum) {
  int res;
  int k = 0, count = 0, flag = 0;

  if (flags.v) {
    for (int i = 0; i < regexLength; i++) {
      res = !regexec(&regex[i], str, 0, NULL, 0);
      if (!res) {
        k++;
      }
    }
    if (k == regexLength) count++;
  } else if (flags.o) {
    regmatch_t pmatch;
    char* temp = malloc(sizeof(char) * (strlen(str) + 1));
    char* str_p = malloc(sizeof(char) * (strlen(str) + 1));
    char* str_n = str_p;
    strcpy(str_p, str);

    for (int i = 0; i < regexLength; i++) {
      res = !regexec(&regex[i], str_n, 1, &pmatch, 0);

      while (res != 0) {
        strcpy(temp, str_n + pmatch.rm_so);
        temp[pmatch.rm_eo - pmatch.rm_so] = '\n';
        temp[pmatch.rm_eo - pmatch.rm_so + 1] = '\0';
        str_n = str_n + pmatch.rm_eo;

        printStringWithFlags(flags, temp, 1, filesCount, filename, stringNum,
                             flag);
        flag = 1;
        res = !regexec(&regex[i], str_n, 1, &pmatch, REG_NOTBOL);
      }
    }

    free(temp);
    free(str_p);
  } else {
    for (int i = 0; i < regexLength; i++) {
      res = !regexec(&regex[i], str, 0, NULL, 0);
      if (res) {
        count++;
      }
    }
  }

  return count;
}

void printC(int filesCount, char* filename, int count, flags flags) {
  if (filesCount > 1 && !flags.h) {
    printf("%s:%d\n", filename, count);
  } else {
    printf("%d\n", count);
  }
}