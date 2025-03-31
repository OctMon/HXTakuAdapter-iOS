#import <Foundation/Foundation.h>
#import "ATHXCustomCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATHXBiddingRequest : NSObject

@property(nonatomic, strong) id customObject; // hx广告对象

@property(nonatomic, strong) ATUnitGroupModel *unitGroup;

@property(nonatomic, strong) ATAdCustomEvent *customEvent; // hx custom event

@property(nonatomic, copy) NSString *unitID; // 广告源广告位id

@property(nonatomic, copy) NSString *placementID;

@property(nonatomic, copy) NSDictionary *extraInfo;

@property(nonatomic, copy) void(^bidCompletion)(ATBidInfo * _Nullable bidInfo, NSError * _Nullable error);

@property(nonatomic, assign) ATAdFormat adType;


@end

NS_ASSUME_NONNULL_END
