#ifndef GREET_H
#define GREET_H

#include <stddef.h>

/* Writes "Hello, <name>!" into buf. Returns the number of characters
 * written (excluding the terminator), or -1 if buf is too small. */
int greet(const char *name, char *buf, size_t len);

#endif
