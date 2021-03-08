---
categories:
- code
- news
date: "2009-03-22T00:00:00Z"
title: how to create a PHP extension
---

There's an easy way to embed C code into PHP by creating extensions.
That's the way external libraries such as GD or CURL are available in
PHP. The first thing to do is to get PHP sources, so as to be able to
use some internal tools to make this task easier :

```bash
$ wget "http://www.php.net/get/php-5.2.9.tar.bz2/from/fr.php.net/mirror"
$ tar -xf php-5.2.9.tar.bz2
```

Now we are ready to play, let's have a look at a directory that might
interest us: `ext`, it already contains several extensions that are
bundled by default with PHP. If we look at the structure of one
extension, for instance GD, here is what we can see:

```bash
$ cd php-5.2.9/ext/
$ ls -l gd/
total 252
-rw-r--r-- 1 seb seb  16475 2007-07-03 19:25 config.m4
-rw-r--r-- 1 seb seb   2136 2007-04-17 17:31 config.w32
-rw-r--r-- 1 seb seb    118 2003-06-15 22:16 CREDITS
-rw-r--r-- 1 seb seb 141580 2009-01-31 16:28 gd.c
-rw-r--r-- 1 seb seb   4985 2005-01-09 22:05 gdcache.c
-rw-r--r-- 1 seb seb   2866 2003-12-28 22:08 gdcache.h
-rw-r--r-- 1 seb seb   4855 2008-12-31 12:17 gd_ctx.c
-rw-r--r-- 1 seb seb  15665 2005-04-10 21:07 gd.dsp
-rw-r--r-- 1 seb seb  23054 2005-01-09 22:05 gdttf.c
-rw-r--r-- 1 seb seb    461 2000-02-26 04:20 gdttf.h
drwxr-xr-x 2 seb seb   4096 2009-02-25 16:39 libgd
-rw-r--r-- 1 seb seb   6158 2008-12-31 12:17 php_gd.h
drwxr-xr-x 2 seb seb   4096 2009-02-25 16:39 tests
```

The files `config.m4` and `config.w32` are used to compile the
extension (`config.m4` is for unix systems, `config.w32` for
windows). The folder tests contains some tests, these are performed
during the `make test` operation, if you have time to waste, you can
try it just for fun like this:

```bash
$ pwd
/tmp/php-5.2.9
$ ./configure
$ make test
```

Let's go back to the `ext/gd` directory. The most important files here
are `php_gd.h` and `gd.c`, which tells PHP how to deal with C
functions. Internal functions are present in the libgd folder, they
can't be called directly by PHP, but they can be called by functions
from gd.c. This is an easy way to export an existing library to PHP,
you only have to register some wrappers without changing your library
code. To make easier the building of extensions, PHP provides a tool
to do the borring stuff: `ext_skel`, we can find it in the ext
folder, here is what happens when executing it:

```bash
$ ./ext_skel

./ext_skel --extname=module [--proto=file] [--stubs=file] [--xml[=file]]
           [--skel=dir] [--full-xml] [--no-help]

  --extname=module   module is the name of your extension
  --proto=file       file contains prototypes of functions to create
  --stubs=file       generate only function stubs in file
  --xml              generate xml documentation to be added to phpdoc-cvs
  --skel=dir         path to the skeleton directory
  --full-xml         generate xml documentation for a self-contained extension
                     (not yet implemented)
  --no-help          don't try to be nice and create comments in the code
                     and helper functions to test if the module compiled
$
```

As we are just hippies, we'll only create an extension containing one
function that prints a pyramid (yeah that's useless) :

```bash
$ ./ext_skel --extname=pyramid

Creating directory pyramid
Creating basic files: config.m4 config.w32 .cvsignore pyramid.c
php_pyramid.h CREDITS EXPERIMENTAL tests/001.phpt pyramid.php [done].
```

To use your new extension, you will have to execute the following steps:

```bash
$ cd ..
$ $EDITOR ext/pyramid/config.m4
$ ./buildconf
$ ./configure --[with|enable]-pyramid
$ make
$ ./php -f ext/pyramid/pyramid.php
$ $EDITOR ext/pyramid/pyramid.c
$ make
```

Then, start writing code and repeat the last two steps as often as
necessary.

```bash
$ cd pyramid
$ ls -l
total 32
-rw-r--r-- 1 seb seb 2071 2009-03-21 18:55 config.m4
-rw-r--r-- 1 seb seb  303 2009-03-21 18:55 config.w32
-rw-r--r-- 1 seb seb    7 2009-03-21 18:55 CREDITS
-rw-r--r-- 1 seb seb    0 2009-03-21 18:55 EXPERIMENTAL
-rw-r--r-- 1 seb seb 2743 2009-03-21 18:55 php_pyramid.h
-rw-r--r-- 1 seb seb 5264 2009-03-21 18:55 pyramid.c
-rw-r--r-- 1 seb seb  505 2009-03-21 18:55 pyramid.php
drwxr-xr-x 2 seb seb 4096 2009-03-21 18:55 tests
$
```

`ext_skel` has prepared everything for us, we only have to edit
pyramid.c and `php_pyramid.h` to be able to add our C code.

Let's open `php_pyramid.h`, it already contains a list of defines,
let's add to it our function :

```c
PHP_FUNCTION(pyramid);
```

Now in pyramid.c, we need to register our function in the global array
`zend_function_entry`, so that PHP can include it in its core:

```c
zend_function_entry pyramid_functions[] = {
    PHP_FE(confirm_pyramid_compiled,    NULL) /* For testing, remove later. */
    PHP_FE(pyramid, NULL)
    {NULL, NULL, NULL} /* Must be the last line in pyramid_functions[] */
}
```

That's it, last step, add our `pyramid()` function, but we must pay
attention to some rules:

- to return a value, we have to use `RETURN_XXXX` where `XXXX` is 
  the type of the value (BOOLEAN, STRING, ...)
- the function must be registered through the define `PHP_FUNCTION(x)`
  where x is the name of the function

Here is a first version that doesn't handle parameters :

```c
#include <stdio.h>

PHP_FUNCTION(pyramid)
{
    int         i;
    int         j;
    int         result;
    int         size;

    size = 10;
    result = 0;
    for (i = 1; i <= size; i++)
    {
        for (j = size; j > i; j--)
            result += printf(" ");
        for (j = 1; j < (i * 2); j++)
            result += printf("+");
        if (result)
            result += printf("\n");
    }
    RETURN_LONG(result);
}
```

It simply outputs a pyramid according to a size, and returns the
number of characters printed. Now we have to compile it with PHP, for
that we need to re-build the configure script so as to have the option
`--enable-pyramid`:

```bash
$ pwd
/tmp/php-5.2.9
$ ./buildconf --force
$ ./configure --prefix=/tmp/php-devel --enable-pyramid
```

Finally, we can build it:

```bash
$ make
$ make install
```

Now we have a PHP version with our extension, let's test it:

```bash
$ pwd
/tmp/php-devel/bin
$ cat test.php

var_dump(pyramid());
?>
$ ./php test.php
         +
        +++
       +++++
      +++++++
     +++++++++
    +++++++++++
   +++++++++++++
  +++++++++++++++
 +++++++++++++++++
+++++++++++++++++++
int(145)
```

Yaw!
