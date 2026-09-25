#include "greet.h"

#include <stdio.h>
#include <string.h>

static int failures = 0;

#define CHECK(cond)                                                  \
    do {                                                             \
        if (!(cond)) {                                               \
            fprintf(stderr, "%s:%d: FAILED: %s\n", __FILE__, __LINE__, #cond); \
            failures++;                                              \
        }                                                            \
    } while (0)

int main(void)
{
    char buf[32];

    CHECK(greet("Ada", buf, sizeof buf) == 11);
    CHECK(strcmp(buf, "Hello, Ada!") == 0);

    CHECK(greet(NULL, buf, sizeof buf) > 0);
    CHECK(strcmp(buf, "Hello, world!") == 0);

    char tiny[4];
    CHECK(greet("Ada", tiny, sizeof tiny) == -1);

    if (failures == 0)
        puts("all tests passed");
    return failures ? 1 : 0;
}
