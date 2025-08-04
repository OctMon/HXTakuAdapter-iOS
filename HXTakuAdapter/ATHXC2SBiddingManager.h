#import <Foundation/Foundation.h>
#import "ATHXCustomCommon.h"
#import "ATHXBiddingRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATHXC2SBiddingManager : NSObject

+ (instancetype)sharedInstance;

- (void)startWithRequestItem:(ATHXBiddingRequest *)request;

- (ATHXBiddingRequest *)getRequestItemWithUnitID:(NSString *)unitID;

- (void)removeRequestItmeWithUnitID:(NSString *)unitID;

@end

NS_ASSUME_NONNULL_END
