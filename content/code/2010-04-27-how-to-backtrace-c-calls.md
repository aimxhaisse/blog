---
categories:
- code
date: "2010-04-27T00:00:00Z"
title: Backtracing C function calls
---

The goal of this page is to show how to backtrace C function calls.
The code isn't portable, it was tested on a _i386_ computer, perhaps
it won't work on yours.

## Stack's behavior

By default (without *-fomit-frame-pointer*), assembly code generated
by GCC for a function includes a prolog/epilog, which can be summed up
to :

```nasm
func:

  push    ebp         ; save previous frame pointer
  mov     ebp, esp    ; set the new frame pointer

  ; ... stuff here

  mov     esp, ebp   ; restore position in the stack
  pop     ebp        ; restore previous frame pointer

  ret                ; jump back where we were before the call
```

This allows a function to have its own stack with an automatic release
of the allocated resources. So the following C code :

```c
void
func(void)
{
    int stuff, here;
}

int
main(int argc, char *argv[])
{
    int stuff, here;

    func();
    return 0;
}
```

Will lead to the following situation :

```text

  HIGH ADDRESSES (Top of the stack)

  > call main
    - return address
    - previous frame
    - local variables of main()

  > call fun
    - return address
    - previous frame
    - local variables of frame

  LOW ADDRESS
```

When a call to `func` is made, the return address is pushed on the
stack, then a jump to the label is performed, and the function is
executed.

## Back to C

What we have on the stack before each frame can be stored in the
following structure :

```c
struct frame
{
  void *                previous_frame;
  void *                return_addr;
} __attribute__((packed));
```

I don't know if the *packed* attribute is really relevant here, but I
prefer to be sure the compiler doesn't try to optimize this with
paddings.  This can be seen as a LIFO list, where we can navigate
between each return addresses, until we reach the main, and other
stuff generated by GCC.  Now, let's dump those addresses:

```c
void
backtrace(void)
{
  int                   count;
  struct frame *        current_frame;

  __asm__("movl %%ebp, %0"
          : "=r" (current_frame));

  count = 0;
  fprintf(stderr, "backtrace");
  while (current_frame->return_addr < (void *) &main)
    {
      fprintf(stderr, "%d\t- %p\n", count, current_frame->return_addr);
      current_frame = current_frame->previous;
      ++count;
    }
  fprintf(stderr, "end of backtrace (total=%d)\n", count);
  fflush(stderr);
}
```

I haven't found any nicer way to stop tracing than comparing with
main's adress, that's ugly but works well if there's no library (as
the code section of libraries may be located in higher
addresses). Something interesting is that there are other calls
performed before arriving to the main, if you are curious about them,
you know what to do :-) .

## Expected result

A call to *backtrace* will dump something like:

```bash
$ ./a.out
backtrace
0       - 0x1c00083c
1       - 0x1c000849
2       - 0x1c00085d
3       - 0x1c000876
end of backtrace (total=4)
```

## What's next?

Now to have a little diagnostic of what happened after a crash,
without launching any debugger, you can redirect the signal to that
function and use a tool which will print information about the return
address (see the manual page of `addr2line`). A cool usage of this is
made in [Varnish](http://varnish-cache.org/), which executes `nm` at
its to retrieve its symbol addresses.
