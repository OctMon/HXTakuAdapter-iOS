#import "ATHXCustomCommon.h"

NSString *mMerakLossReasonConvert(ATBiddingLossType lossType) {
    NSString *lossReason = KXBiddingLossType.kHXBiddingLossReason_LowerPrice;
    switch (lossType) {
        case ATBiddingLossWithLowPriceInNormal:
        case ATBiddingLossWithLowPriceInHB: {
            lossReason = KXBiddingLossType.kHXBiddingLossReason_LowerPrice;
            break;
        }
        case ATBiddingLossWithBiddingTimeOut: {
            lossReason = KXBiddingLossType.kHXBiddingLossReason_Timeout;
            break;
        }
        case ATBiddingLossWithFloorFilter: {
            lossReason = KXBiddingLossType.kHXBiddingLossReason_LessThanFloor;
            break;
        }
        default: {
            lossReason = KXBiddingLossType.kHXBiddingLossReason_Other;
            break;
        }
    }
    return lossReason;
}
