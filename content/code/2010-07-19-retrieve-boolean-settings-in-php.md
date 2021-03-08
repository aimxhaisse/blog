---
categories:
- code
- news
date: "2010-07-19T00:00:00Z"
title: PHP and boolean settings
---

Retrieving settings from PHP's configuration seems straightforward at
first sight:

```php
<?php

if (ini_get('safe_mode') == false) {
     echo "Safe mode disabled\n";
}
```

Sadly, it is not as easy as it should, because:

- If the setting is defined in _php.ini_, an empty string is returned when 
  disabled, _1_ is if enabled, simple, right?
- If the setting is defined somewhere else, say in _httpd.conf_,
  the exact string is returned, WTF?!

The correct way to do it becomes:

```php
<?php

function ini_get_boolean($setting)
{
       $my_boolean = ini_get($setting);
 
       if ( (int) $my_boolean > 0 )
             $my_boolean = true;
       else
       {
             $my_lowered_boolean = strtolower($my_boolean);
 
             if ($my_lowered_boolean === "true" ||
		 $my_lowered_boolean === "on" ||
		 $my_lowered_boolean === "yes") {
               $my_boolean = true;
             } else {
               $my_boolean = false;
	     }
       }
 
       return $my_boolean;
}
 
if (ini_get_boolean('safe_mode') === false) {
     echo "Safe mode disabled\n";
}
```

I can't remember how much time I wasted trying to debug code in some
external library because of this. See also:

- [PHP's documentation of ini\_get](http://fr.php.net/manual/en/function.ini-get.php)
- [PHP bug report](http://bugs.php.net/bug.php?id=52168)
