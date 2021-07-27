---
categories:
- code
date: "2010-04-28T00:00:00Z"
title: Variadic Arguments in C Macros
---

It is possible to wrap a variadic function in C, using some facilities
provided by C99 (as supported by GCC and a couple of other
compilers). This may be helpful for instance if you need to customize
the way you are logging events.

## Example

We will try to define our own logger using vfprintf, adding the line
and file to the output, using the following macro:

```c
#define LOG(...)        log_print(__LINE__, __FILE__, __VA_ARGS__)
```

The list of argument used when calling LOG can be of an undefined
size, and will be textually replaced by the `__VA_ARGS__` macro. That
means the following lines produce the same result:

```c
LOG("the answer to life is %d", 42);
log_print(__LINE__, __FILE__, "the answer to life is %d", 42);
```

## Implementation

Let's implement the `log_print` function, a simple printf wrapper:

```c
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
 
int
log_print(int line, char *file, char *fmt, ...)
{
  va_list       ap;
 
  fprintf(stdout, "[%s - line %d] ", file, line);
  va_start(ap, fmt);
  vfprintf(stdout, fmt, ap);
  va_end(ap);
  fprintf(stdout, "\n");
 
  return 0;
}
```

## Result

Now we can log our debugs with informations about location of the
problem, as if we were using a standard printf call:

```c
#include <stdio.h>
#include <errno.h>
#include <string.h>
 
#define LOG(...)        log_print(__LINE__, __FILE__, __VA_ARGS__)
 
int
main(void)
{
    FILE *fh;
 
    if ((fh = fopen("bleh", "r")) == NULL)
        LOG("unable to open file [%s] : %s", bleh, strerror(errno));
    else
        fclose(fh);
 
    return (0);
}
```

An example of output:

```bash
$ ./a.out 
[test.c - line 35] unable to open file [/bleh] : No such file or directory
```
