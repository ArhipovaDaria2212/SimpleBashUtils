#ifndef PARSE_WITH_FLAGS_H
#define PARSE_WITH_FLAGS_H

#include <stdio.h>

#include "parse.h"

void printFile(char *fileName, flags flags);
void processingWithFlags(FILE *fp, flags flags);
void printNoPrintable(int ch);

#endif