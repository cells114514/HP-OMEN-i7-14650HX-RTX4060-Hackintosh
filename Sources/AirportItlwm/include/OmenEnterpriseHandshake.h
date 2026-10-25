#ifndef OMEN_ENTERPRISE_HANDSHAKE_H
#define OMEN_ENTERPRISE_HANDSHAKE_H
// This reports an already completed net80211 handshake. It cannot authorize one.
static inline bool omenEnterpriseHandshakeReportAllowed(bool up, bool wasAuthorized,
    bool stopping, bool enterprise, bool running, bool haveBss, bool peerPortValid)
{
    return up && !wasAuthorized && !stopping && enterprise && running && haveBss && peerPortValid;
}
#endif
