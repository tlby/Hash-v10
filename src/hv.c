#include <EXTERN.h>
#include <perl.h>

#include "hv.h"

struct Hash {
    HV   *hv;
    Hrel  release_cb;
    void *release_dt;
};

static int vtbl_svt_free(pTHX_ SV *sv, MAGIC *mg) {
    Hash h = (Hash)mg->mg_ptr;
    if(h->release_cb && SvOK(sv))
        h->release_cb(INT2PTR(Hval, SvIV(sv)), h->release_dt);
    return 0;
}

static MGVTBL default_vtbl = { 0, 0, 0, 0, vtbl_svt_free };

static PerlInterpreter *my_perl;

static void hash_init() {
    int ac = 3;
    char *av[3] = { "", "-e", "0" };

    if(my_perl)
        return;
#if 0 && defined(PERL_SYS_INIT3) && !defined(MYMALLOC)
    {
        char *ev[1] = { NULL };
        struct sigaction prev;

        /* PERL_SYS_INIT3 overrides the SIGFPE handler!?!? */
        sigaction(SIGFPE, NULL, &prev);
        PERL_SYS_INIT3(&ac, (char ***)&av, (char ***)&ev);
        sigaction(SIGFPE, &prev, NULL);
    }
#endif
    my_perl = perl_alloc();
    perl_construct(my_perl);
    PL_exit_flags |= PERL_EXIT_DESTRUCT_END;
    perl_parse(my_perl, NULL, ac, av, NULL);
}

Hash hash_new(Hrel release_cb, void *release_dt) {
    Hash h;

    hash_init();
    SAVETMPS;
    h = (Hash)malloc(sizeof(struct Hash));
    h->hv = newHV();
    h->release_cb = release_cb;
    h->release_dt = release_dt;
    FREETMPS;
    return h;
}

void hash_free(Hash h) {
    SAVETMPS;
    /* do_sv_dump(0, Perl_debug_log, (SV *)h->hv, 0, 4, 0, 0); */
    SvREFCNT_dec(h->hv);
    free(h);
    FREETMPS;
}

Hval hash_fetch(Hash h, Hkey k) {
    Hval rv;
    SV **sv;

    SAVETMPS;
    sv = hv_fetch(h->hv, k->str, k->len, 0);
    rv = sv ? INT2PTR(Hval, SvIV(*sv)) : NULL;
    FREETMPS;
    return rv;
}

void hash_store(Hash h, Hkey k, Hval v) {
    SV *sv;

    SAVETMPS;
    sv = newSViv(PTR2IV(v));
    sv_magicext(sv, 0, PERL_MAGIC_ext, &default_vtbl, (char *)h, 0);
    if(!hv_store(h->hv, k->str, k->len, sv, 0))
        sv_2mortal(sv);
    FREETMPS;
}

int hash_exists(Hash h, Hkey k) {
    return hv_exists(h->hv, k->str, k->len);
}

Hval hash_delete(Hash h, Hkey k) {
    SV *sv;
    Hval rv;

    SAVETMPS;
    sv = hv_delete(h->hv, k->str, k->len, 0);
    rv = sv ? INT2PTR(Hval, SvIV(sv)) : NULL;
    FREETMPS;
    return rv;
}

void hash_clear(Hash h) {
    SAVETMPS;
    hv_clear(h->hv);
    FREETMPS;
}

Hkey hash_scalar(Hash h) {
    static char buf[32];
    static struct Hkey k;
    SV *sv;

    SAVETMPS;
    sv = hv_scalar(h->hv);
    k.str = buf;
    k.len = snprintf(buf, 32, "%s", SvPV_nolen(sv));
    FREETMPS;
    return &k;
}

Hkey hash_firstkey(Hash h) {
    hv_iterinit(h->hv);
    return hash_nextkey(h);
}

Hkey hash_nextkey(Hash h) {
    static struct Hkey k;
    HE *he;
    
    he = hv_iternext(h->hv);
    if(!he)
	return NULL;
    k.str = HePV(he, k.len);
    return &k;
}
