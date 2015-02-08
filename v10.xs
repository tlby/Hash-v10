#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "const-c.inc"

#include "src/hv.h"

static void release(SV *sv, pTHX) {
    sv_2mortal(sv);
}

MODULE = Hash::v10		PACKAGE = Hash::v10		

INCLUDE: const-xs.inc

PROTOTYPES: DISABLE

Hash
TIEHASH(classname)
        SV *classname
    CODE:
        RETVAL = hash_new((void (*)(Hval, void *))release, (void *)aTHX);
    OUTPUT:
        RETVAL

SV *
FETCH(this, key)
        Hash this
        Hkey key
    CODE:
        RETVAL = SvREFCNT_inc(hash_fetch(this, key));
    OUTPUT:
        RETVAL

void
STORE(this, key, val)
        Hash this
        Hkey key
        SV *val
    CODE:
        hash_store(this, key, SvREFCNT_inc(val));

SV *
DELETE(this, key)
        Hash this
        Hkey key
    CODE:
        RETVAL = SvREFCNT_inc(hash_delete(this, key));
    OUTPUT:
        RETVAL

void
CLEAR(this)
        Hash this
    CODE:
        hash_clear(this);

int
EXISTS(this, key)
        Hash this
        Hkey key
    CODE:
        RETVAL = hash_exists(this, key);
    OUTPUT:
        RETVAL

Hkey
FIRSTKEY(this)
        Hash this
    CODE:
        RETVAL = hash_firstkey(this);
    OUTPUT:
        RETVAL

Hkey
NEXTKEY(this, lastkey)
        Hash this
        Hkey lastkey
    CODE:
        RETVAL = hash_nextkey(this);
    OUTPUT:
        RETVAL

Hkey
SCALAR(this)
        Hash this
    CODE:
        RETVAL = hash_scalar(this);
    OUTPUT:
        RETVAL

void
DESTROY(this)
        Hash this
    CODE:
        hash_free(this);
