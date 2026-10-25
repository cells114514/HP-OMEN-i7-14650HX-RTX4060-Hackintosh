// SPDX-License-Identifier: GPL-2.0-or-later
#include "../Sources/AirportItlwm/include/OmenEnterpriseTxPolicy.h"
#include "../Sources/AirportItlwm/include/OmenEnterpriseHandshake.h"
#include <cassert>
int main() {
    for (unsigned type=0; type<65536; ++type) {
        assert(omenEnterpriseTxAllowed(true,false,true,type)==(type==0x888e));
        assert(!omenEnterpriseTxAllowed(true,false,false,type));
        assert(omenEnterpriseTxAllowed(false,false,true,type));
        assert(omenEnterpriseTxAllowed(true,true,true,type));
    }
    int reports=0;
    for(unsigned bits=0; bits<128; ++bits) {
        bool allowed=omenEnterpriseHandshakeReportAllowed(bits&1,bits&2,bits&4,bits&8,bits&16,bits&32,bits&64);
        if(allowed){ ++reports; assert(bits==(1|8|16|32|64)); }
    }
    assert(reports==1);
    assert(!omenEnterpriseHandshakeReportAllowed(true,true,false,true,true,true,true));
}
