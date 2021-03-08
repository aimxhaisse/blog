---
categories:
- code
- news
date: "2009-11-30T00:00:00Z"
title: Void Casts in C++
---

Sometimes, casting a `void*` in C++ is necessary, unfortunately, this
is hard to achieve in an intuitive way and to remember the horrible
syntax. Here is the problem :

```c
#include <dlfcn.h>

int
main(int, char **)
{
  void          (*f)(void) = (void (*)(void)) dlsym(0, "SomeFunction");

  return 0;
}
```

Which results in the following warning:

```
ISO C++ forbids casting between pointer-to-function and pointer-to-object
```

An ugly trick to avoid this is to do it with a memcpy:

```c++
#include <dlsym.h>
#include <string.h>

int             main(int, char **)
{
  void          (*f)(void);
  void          *ptr = dlsym(0, "SomeFunction");

  memcpy(&f, &ptr, sizeof(void *));

  return 0;
}
```

Another trick that I've learned recently is to use a union which is
arguably a cleaner way to achieve the same goal:

```c++
#include <dlsym.h>

typedef union cast_u {
    void *ptr;
    void (*fptr)(void);
} cast_u;

int             main(int, char **)
{
    cast_u c;

    c.ptr = dlsym(0, "SomeFunction");
    (*c.fptr)();

    return 0;
}
```
