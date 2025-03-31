#import "ATHXC2SBiddingManager.h"
#import "ATHXBiddingRequest.h"
#import "ATHXSplashCustomEvent.h"

@interface ATHXC2SBiddingManager ()
@property (nonatomic, strong) NSMutableDictionary *bidingAdStorageAccessor;
@end

@implementation ATHXC2SBiddingManager

+ (instancetype)sharedInstance {
    static ATHXC2SBiddingManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ATHXC2SBiddingManager alloc] init];
        sharedInstance.bidingAdStorageAccessor = [NSMutableDictionary dictionary];
    });
    return sharedInstance;
}

- (ATHXBiddingRequest *)getRequestItemWithUnitID:(NSString *)unitID {
    if (!unitID || ![unitID isKindOfClass:[NSString class]]) return nil;
    @synchronized (self) {
        return [self.bidingAdStorageAccessor objectForKey:unitID];
    }
    
}

- (void)removeRequestItmeWithUnitID:(NSString *)unitID {
    if (!unitID || ![unitID isKindOfClass:[NSString class]]) return;
    @synchronized (self) {
        [self.bidingAdStorageAccessor removeObjectForKey:unitID];
    }
}

- (void)startWithRequestItem:(ATHXBiddingRequest *)request {
    AdnLog(@"!!!: c2s start request: %@", request.unitID);
    if (!request.unitID || ![request.unitID isKindOfClass:[NSString class]]) {
        if (request.bidCompletion) {
            request.bidCompletion(nil, [NSError errorWithDomain:kATHXAdapterErrorDomain code:kATHXAdapterErrorCode_PlacementIdEmpty userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load bid splash. request.unitID empty", NSLocalizedFailureReasonErrorKey:@"It took too long to load bid placement stragety."}]);
        }
        return;
    }
    [self.bidingAdStorageAccessor setObject:request forKey:request.unitID];
    switch (request.adType) {
        case ATAdFormatSplash: {
            dispatch_async(dispatch_get_main_queue(), ^{
                HXSplashAd * splashAd = [[HXSplashAd alloc] initWithPlacementId:request.unitID];
                ATHXSplashCustomEvent *customEvent = (ATHXSplashCustomEvent *)request.customEvent;
                splashAd.delegate = customEvent;
                request.customObject = splashAd;
                [splashAd loadAd];
            });
            break;
        }
        default:
            break;
    }
}
@end
