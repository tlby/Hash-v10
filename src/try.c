#include <stdio.h>
#include <string.h>
#include "hv.h"

void release(Hval val, void *p) {
    return;
}

int main(int ac, char *av[], char *ev[]) {
    Hash h = hash_new(release, NULL);
    Hkey cur;
    int i;

    for(i = 1; i < ac; i++) {
        struct Hkey k;
        k.str = av[i];
        k.len = strlen(k.str);
        hash_store(h, &k, NULL);

    }

    for(cur = hash_firstkey(h); cur; cur = hash_nextkey(h)) {
        printf("%.*s\n", (int)cur->len, cur->str);
    }
    return 0;
}

