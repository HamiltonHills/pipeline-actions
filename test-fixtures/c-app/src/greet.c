#include "greet.h"

#include <stdio.h>

int greet(const char *name, char *buf, size_t len)
{
    int n = snprintf(buf, len, "Hello, %s!", name ? name : "world");
    if (n < 0 || (size_t)n >= len)
        return -1;
    return n;
}
