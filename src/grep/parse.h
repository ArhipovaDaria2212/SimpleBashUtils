#ifndef PARSE_H
#define PARSE_H

#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct {
  int e;
  int i;
  int v;
  int c;
  int l;
  int n;
  int h;
  int s;
  int f;
  int o;
} flags;

typedef struct {
  char **array;
  int length;
} lines;

lines *createLines(lines *array);
void freeLines(lines *array);
lines *addLine(char *line, lines *array);

int parseParams(int argc, char **argv, char *shortFlags, flags *flags,
                lines *patterns, lines *files);
void getFiles(int argc, char **argv, lines *files, flags flags);
int getPatternsFromFile(char *fileName, lines *patterns);

#endif