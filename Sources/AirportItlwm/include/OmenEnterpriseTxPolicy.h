// SPDX-License-Identifier: GPL-2.0-or-later
#ifndef OMEN_ENTERPRISE_TX_POLICY_H
#define OMEN_ENTERPRISE_TX_POLICY_H
// Preserve PSK/authorized data; permit only EAPOL through a closed enterprise port.
static inline bool omenEnterpriseTxAllowed(bool enterprise, bool authorized,
                                           bool completeEthernet, unsigned short etherType)
{
    return !enterprise || authorized || (completeEthernet && etherType == 0x888e);
}
#endif
