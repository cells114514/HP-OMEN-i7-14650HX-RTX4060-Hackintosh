// SPDX-License-Identifier: GPL-2.0-or-later
#ifndef OMEN_EAP_DIAG_KERNEL_H
#define OMEN_EAP_DIAG_KERNEL_H
#ifdef AIRPORT_WCL
#include <sys/kpi_mbuf.h>
#include <IOKit/IOLib.h>
#include <libkern/OSAtomic.h>
#include "OmenEapDiag.h"

static inline int omenMbufRead(void *ctx, unsigned long offset, unsigned long length, unsigned char *out)
{
    return mbuf_copydata(static_cast<mbuf_t>(ctx), offset, length, out);
}

static inline unsigned long omenMbufLength(mbuf_t packet)
{
    if (!packet || mbuf_type(packet) == MBUF_TYPE_FREE)
        return 0;
    return (mbuf_flags(packet) & MBUF_PKTHDR) ? mbuf_pkthdr_len(packet) : mbuf_len(packet);
}

static inline void omenEapEmit(const char *tag, const OmenEapMeta &h,
                               int state, unsigned int flags, int a, int b)
{
    // Bound logging overhead during a malformed or unusually busy EAP exchange.
    // Each translation unit receives a fresh budget after the kext is reloaded.
    static volatile SInt32 budget = 0;
    if (OSIncrementAtomic(&budget) > 512)
        return;
    IOLog("itlwm: OMEN_EAPDIAG v3 tag=%s len=%lu ver=%u type=%u body=%u "
          "eap=%u code=%u id=%u eaplen=%u method_valid=%u method=%u "
          "state=%d flags=0x%x a=%d b=%d\n", tag, h.packetLength,
          h.version, h.type, h.bodyLength, h.hasEap, h.code, h.identifier,
          h.eapLength, h.hasMethod, h.method, state, flags, a, b);
}

static inline void omenEapTrace(const char *tag, mbuf_t packet, int state,
                                unsigned int flags, int a, int b)
{
    OmenEapMeta h = {};
    unsigned long length = omenMbufLength(packet);
    if (length && omenEapEthernet(omenMbufRead, packet, length, &h))
        omenEapEmit(tag, h, state, flags, a, b);
}
#endif
#endif
