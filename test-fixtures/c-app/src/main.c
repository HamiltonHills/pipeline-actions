#include "greet.h"

#include <stdio.h>

int main(int argc, char **argv)
{
    char buf[128];
    if (greet(argc > 1 ? argv[1] : NULL, buf, sizeof buf) < 0) {
        fputs("name too long\n", stderr);
        return 1;
    }
    puts(buf);
    return 0;
}
