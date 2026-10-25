// SPDX-License-Identifier: GPL-2.0-or-later
// Header-only EAPOL metadata decoder. Never reads identity or TLS/MSCHAP payload.
#ifndef OMEN_EAP_DIAG_H
#define OMEN_EAP_DIAG_H

typedef int (*OmenEapRead)(void *, unsigned long, unsigned long, unsigned char *);
struct OmenEapMeta {
    unsigned long packetLength;
    unsigned int version, type, bodyLength, code, identifier, eapLength, method;
    unsigned int hasEap, hasMethod;
};

static inline bool omenRead(OmenEapRead read, void *ctx, unsigned long total,
                            unsigned long offset, unsigned long length, unsigned char *out)
{
    return offset <= total && length <= total - offset && read(ctx, offset, length, out) == 0;
}

static inline bool omenEapBody(OmenEapRead read, void *ctx, unsigned long total,
                              unsigned long offset, OmenEapMeta *out)
{
    unsigned char h[4];
    if (!omenRead(read, ctx, total, offset, sizeof(h), h))
        return false;
    OmenEapMeta result = {};
    result.packetLength = total;
    result.version = h[0];
    result.type = h[1];
    result.bodyLength = (unsigned(h[2]) << 8) | h[3];
    offset += 4;
    if (result.bodyLength > total - offset)
        return false;
    if (result.type == 0) {
        if (result.bodyLength < 4 || !omenRead(read, ctx, total, offset, sizeof(h), h))
            return false;
        result.code = h[0];
        result.identifier = h[1];
        result.eapLength = (unsigned(h[2]) << 8) | h[3];
        if (result.eapLength < 4 || result.eapLength > result.bodyLength)
            return false;
        result.hasEap = 1;
        if (result.code == 1 || result.code == 2) {
            if (result.eapLength < 5 || !omenRead(read, ctx, total, offset + 4, 1, h))
                return false;
            result.method = h[0];
            result.hasMethod = 1;
        }
    }
    *out = result;
    return true;
}

static inline bool omenEapEthernet(OmenEapRead read, void *ctx, unsigned long total,
                                  OmenEapMeta *out)
{
    unsigned char type[2];
    if (!omenRead(read, ctx, total, 12, sizeof(type), type) || type[0] != 0x88 || type[1] != 0x8e)
        return false;
    return omenEapBody(read, ctx, total, 14, out);
}

static inline bool omenEapWifi(OmenEapRead read, void *ctx, unsigned long total,
                              OmenEapMeta *out)
{
    unsigned char fc[2], snap[8];
    if (!omenRead(read, ctx, total, 0, sizeof(fc), fc) || (fc[0] & 0x0c) != 0x08)
        return false;
    // Protected frames may contain encrypted payload or an inserted crypto header.
    if (fc[1] & 0x40)
        return false;
    unsigned long length = 24;
    if ((fc[1] & 3) == 3)
        length += 6;
    if (fc[0] & 0x80) {
        length += 2;
        if (fc[1] & 0x80)
            length += 4;
    }
    if (!omenRead(read, ctx, total, length, sizeof(snap), snap))
        return false;
    if (snap[0] != 0xaa || snap[1] != 0xaa || snap[2] != 3 || snap[3] ||
        snap[4] || snap[5] || snap[6] != 0x88 || snap[7] != 0x8e)
        return false;
    return omenEapBody(read, ctx, total, length + 8, out);
}
#endif
