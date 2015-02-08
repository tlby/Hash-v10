
#include <stddef.h> /* for size_t */

/* opaque object implementation */
typedef struct Hash *Hash;

/* key type */
typedef struct Hkey {
    size_t len;
    char *str;
} *Hkey;

/* value type */
typedef void *Hval;

/* release func */
typedef void (*Hrel)(Hval, void *);

Hash hash_new     (Hrel, void *);
void hash_free    (Hash);
Hval hash_fetch   (Hash, Hkey);
void hash_store   (Hash, Hkey, Hval);
int  hash_exists  (Hash, Hkey);
Hval hash_delete  (Hash, Hkey);
void hash_clear   (Hash);
Hkey hash_scalar  (Hash);
Hkey hash_firstkey(Hash);
Hkey hash_nextkey (Hash);
