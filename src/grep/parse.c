#include "parse.h"

lines *addLine(char *string, lines *dest) {
  dest->length += 1;

  dest->array = realloc(dest->array, sizeof(char *) * dest->length);

  dest->array[dest->length - 1] = malloc(sizeof(char) * (strlen(string) + 1));
  strcpy(dest->array[dest->length - 1], string);

  return dest;
}

lines *createLines(lines *dest) {
  dest->array = malloc(sizeof(char *));
  dest->length = 0;
  return dest;
}

void freeLines(lines *dest) {
  for (int i = 0; i < dest->length; i++) {
    free(dest->array[i]);
  }
  free(dest->array);
}

int parseParams(int argc, char **argv, char *shortFlags, flags *flags,
                lines *patterns, lines *files) {
  int flag = 0, error = 0, i = 0;

  while ((flag = getopt_long(argc, argv, shortFlags, NULL, &i)) != -1) {
    switch (flag) {
      case 'e':
        flags->e = 1;
        addLine(optarg, patterns);
        break;
      case 'i':
        flags->i = 1;
        break;
      case 'v':
        flags->v = 1;
        break;
      case 'c':
        flags->c = 1;
        break;
      case 'l':
        flags->l = 1;
        break;
      case 'n':
        flags->n = 1;
        break;
      case 'h':
        flags->h = 1;
        break;
      case 's':
        flags->s = 1;
        break;
      case 'f':
        flags->f = 1;
        getPatternsFromFile(optarg, patterns);
        break;
      case 'o':
        flags->o = 1;
        break;
      case '?':
        error = 1;
        break;
      default:
        error = 1;
        break;
    }
  }

  if (argc > 2)
    if (!flags->e && !flags->f) {
      for (int i = 1; i < argc; i++) {
        if (argv[i][0] != '-') {
          addLine(argv[i], patterns);
          break;
        }
      }
    }

  if (flags->l) {
    flags->n = 0;
    flags->o = 0;
  }

  if (flags->c) {
    flags->n = 0;
    flags->o = 0;
  }

  if (flags->v) {
    flags->o = 0;
  }

  getFiles(argc, argv, files, *flags);

  return !error;
}

int getPatternsFromFile(char *fileName, lines *patterns) {
  FILE *fp;
  int error = 0, k = 0, size = 256;

  if ((fp = fopen(fileName, "r")) == NULL) {
    fprintf(stderr, "grep: %s: No such file or directory\n", fileName);
    error = 1;
  } else {
    char *temp = malloc(sizeof(char) * size);
    char ch;

    while ((ch = fgetc(fp)) != EOF) {
      if (ch == '\n') {
        temp[k++] = '\0';
        addLine(temp, patterns);
        k = 0;
        temp[0] = '\0';
        continue;
      }
      if (k + 10 > size) {
        size += 50;
        temp = realloc(temp, sizeof(char) * size);
      }

      temp[k++] = ch;
    }
    temp[k++] = '\0';
    addLine(temp, patterns);
    free(temp);
    fclose(fp);
  }

  return !error;
}

void getFiles(int argc, char **argv, lines *files, flags flags) {
  int is_regex = 0;
  if (!flags.e && !flags.f) {
    for (int i = 1; i < argc; i++) {
      if (argv[i][0] != '-') {
        if (is_regex)
          addLine(argv[i], files);
        else
          is_regex = 1;
      }
    }
  } else {
    for (int i = 1; i < argc; i++) {
      if (argv[i][0] == '-' && (argv[i][(int)strlen(argv[i]) - 1] == 'e' ||
                                argv[i][(int)strlen(argv[i]) - 1] == 'f')) {
        i++;
      } else {
        if (argv[i][0] != '-') {
          addLine(argv[i], files);
        }
      }
    }
  }
}