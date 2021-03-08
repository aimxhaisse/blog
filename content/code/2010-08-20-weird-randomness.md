---
categories:
- code
- news
date: "2010-08-20T00:00:00Z"
title: Weird Randomness
---

I've been struggling for a while with a strange bug that I'd like to
share. I had two web applications protected with an apache module
called mod-auth-openid, which provides an authentication using
openid. On the first web application, everything was running fine, but
on the second one, I had to wait between 1 and 10 minutes to have
access to the web application.

One was hosted under lenny (debian 5.0) and the other one under debian
etch (debian 4.0). As the module was not up to date on etch, I'd been
porting it because I was missing some features provided by newer
versions. At first sight, I wasn't expecting that the problem was
lying there, but several hours of deep inspection at other places led
me to the conclusion that it was something related to debian and
*mod-auth-openid*.

I then started to put debugs everywhere in the module to see what was
taking so long. It appeared that calls to the function `true_random()`
were blocking on etch, not on lenny.  There were about ten calls to
this function, between each call I had to wait about 10 seconds to 1
minute. Here is the function :

```c
/* true_random -- generate a crypto-quality random number. 
Taken from apr-util's getuuid.c file */
int true_random() {
#if APR_HAS_RANDOM
  unsigned char buf[2];
  if (apr_generate_random_bytes(buf, 2) == APR_SUCCESS) {
      return (buf[0] << 8) | buf[1];
  }
#endif
    apr_uint64_t time_now = apr_time_now();
    srand((unsigned int)(((time_now >> 32) ^ time_now) & 0xffffffff));
    return rand() & 0x0FFFF;
}
```

So why did it take so long on etch? Actually,
`apr_generate_random_bytes` (which resides in libapr) is using
_/dev/urandom_ on lenny, whereas on etch it uses _/dev/random_.

Reading in _/dev/random_ is slow, it may take a while before sending
random characters, depending on environmental noises. You can try this
funny behavior by doing the following :

```bash
$ cat /dev/random
Move your mouse to make noise!
```

The more you move your mouse, the more you read.  With _/dev/urandom_,
you don't have to wait (you can try to cat it if you are a real
warrior).  So the more the server was busy, the less the user had to
wait, not really common eh? This change appeared on lenny to fix some
issues with other modules.
