#import "ATHXSplashAdapter.h"
#import "ATHXCustomCommon.h"
#import "ATHXCustomConfig.h"
#import "ATHXSplashCustomEvent.h"
#import "ATHXC2SBiddingManager.h"

@interface ATHXSplashAdapter () <ATAdAdapter>
@property (nonatomic, strong) ATHXSplashCustomEvent *customEvent;
@property (nonatomic, strong) HXSplashAd *splashAd;
@end

@implementation ATHXSplashAdapter
- (instancetype)initWithNetworkCustomInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo {
    AdnLog(@"[!!!]: %s: server=%@, local=%@", __func__, serverInfo, localInfo);
    if (self = [super init]) {
        [ATHXCustomConfig initAdNetworkWithServerInfo:serverInfo localInfo:localInfo completion:^(NSError * _Nullable error) {
            AdnLog(@"[ADN] init completion");
        }];
    }
    return self;
}

- (void)loadADWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo
            completion:(void (^)(NSArray<NSDictionary *> * _Nonnull, NSError * _Nonnull))completion {
    AdnLog(@"!!!: %s: server=%@, local=%@", __func__, serverInfo, localInfo);
    NSDictionary *extra = localInfo;
    NSTimeInterval tolerateTimeout = 5.0;
    if ([localInfo.allKeys containsObject:kATSplashExtraTolerateTimeoutKey]) {
        tolerateTimeout = [localInfo[kATSplashExtraTolerateTimeoutKey] doubleValue];
    }
    NSString *placementId    = serverInfo[kATHXCustomInfoKey_SlotId];
    UIView *containerView    = localInfo[kATSplashExtraContainerViewKey];
    UIViewController *rootVC = localInfo[kATHXLocalInfoKey_RootViewController];

    NSDate *curDate = [NSDate date];
    if (tolerateTimeout > 0) {
        NSString *bidId = serverInfo[kATAdapterCustomInfoBuyeruIdKey];
        //如果有bidId,代表是header bidding广告源
        if (bidId) {
            // adn广告位id
            ATHXBiddingRequest *request = [[ATHXC2SBiddingManager sharedInstance] getRequestItemWithUnitID:placementId];
            if (request) {
                _customEvent = (ATHXSplashCustomEvent *)request.customEvent;
                _customEvent.requestCompletionBlock = completion;
                _customEvent.expireDate = [curDate dateByAddingTimeInterval:tolerateTimeout];
                _customEvent.containerView = (containerView && [containerView isKindOfClass:[UIView class]])?containerView:nil;
                _customEvent.rootViewController = rootVC;
                if (request.customObject != nil) { // load secced
                    self.splashAd = request.customObject;
                    //判断广告源是否已经loaded过
                    if (self.splashAd.isValid) {
                        [_customEvent trackSplashAdLoaded:self.splashAd];
                    } else {
                        NSError *error = [NSError errorWithDomain:kATHXAdapterErrorDomain code:kATHXAdapterErrorCode_OfferInvalid userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load bid splash.", NSLocalizedFailureReasonErrorKey:@"Splash ad invalid"}];
                        [_customEvent trackSplashAdLoadFailed:error];
                    }
                } else { // fail
                    NSError *error = [NSError errorWithDomain:kATHXAdapterErrorDomain code:kATHXAdapterErrorCode_OfferNotFound userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load bid splash.", NSLocalizedFailureReasonErrorKey:@"Empty splash object"}];
                    [_customEvent trackSplashAdLoadFailed:error];
                }
                [[ATHXC2SBiddingManager sharedInstance] removeRequestItmeWithUnitID:placementId];
            }
        } else {
            _customEvent = [[ATHXSplashCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
            _customEvent.requestCompletionBlock = completion;
            _customEvent.expireDate = [curDate dateByAddingTimeInterval:tolerateTimeout];
            _customEvent.containerView = (containerView && [containerView isKindOfClass:[UIView class]])?containerView:nil;
            _customEvent.rootViewController = rootVC;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.splashAd = [[HXSplashAd alloc] initWithPlacementId:(placementId?[NSString stringWithFormat:@"%@", placementId]:@"")];
                self.splashAd.delegate = self.customEvent;
                [self.splashAd loadAd];
            });
        }
    } else {
        if (completion) completion(nil, [NSError errorWithDomain:kATHXAdapterErrorDomain code:kATHXAdapterErrorCode_NotImportedProperly userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load splash.", NSLocalizedFailureReasonErrorKey:@"It took too long to load placement stragety."}]);
    }
}

+ (void)bidRequestWithPlacementModel:(ATPlacementModel*)placementModel unitGroupModel:(ATUnitGroupModel*)unitGroupModel info:(NSDictionary*)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {
    AdnLog(@"!!!: %s: server=%@", __func__, info);

    NSDictionary *serverInfo = info;
    NSDictionary *localInfo = info;
    if (NSClassFromString(@"HXSDK.HXSDK") == nil) {
        // 未接入HXSDK，则执行回调，传入error
        if (completion != nil) {
            completion(nil, [NSError errorWithDomain:kATHXAdapterErrorDomain code:kATHXAdapterErrorCode_SDKNotFound userInfo:@{NSLocalizedDescriptionKey:@"Bid request has failed", NSLocalizedFailureReasonErrorKey:@"HXSDK is not imported"}]);
        }
        return;
    }
    
    [ATHXCustomConfig initAdNetworkWithServerInfo:serverInfo localInfo:localInfo completion:^(NSError * _Nullable error) {
        AdnLog(@"[ADN] init completion");
    }];
    
    ATHXSplashCustomEvent *customEvent = [[ATHXSplashCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    customEvent.isC2SBiding = YES;
    // v5.7.06 及以上添加如下的方法
    UIView *containerView = serverInfo[kATSplashExtraContainerViewKey];
    if (containerView) {
        customEvent.containerView = ([containerView isKindOfClass:[UIView class]])?containerView:nil;
    } else {
        customEvent.containerView = nil;
    }
    
    // 创建一个TakuMerakBiddingRequest类用于保存请求所需要的信息
    ATHXBiddingRequest *request = [ATHXBiddingRequest new];
    request.unitGroup = unitGroupModel;
    request.placementID = placementModel.placementID;
    request.bidCompletion = completion;
    request.unitID = serverInfo[kATHXCustomInfoKey_SlotId]; // adn广告位id
    request.extraInfo = info;
    request.adType = ATAdFormatSplash;
    // 广告源回调到customEvent对象
    request.customEvent = customEvent;
    
    // 创建一个TakuMerakC2SBiddingManager类，用于保存request在内存当中
    ATHXC2SBiddingManager *biddingManage = [ATHXC2SBiddingManager sharedInstance];
    [biddingManage startWithRequestItem:request];
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary *)info {
    AdnLog(@"!!!: %s: server=%@", __func__, info);
    if ([customObject isKindOfClass:[HXSplashAd class]]) {
        HXSplashAd *splashAd = customObject;
        return [splashAd isValid];
    } else {
        return NO;
    }
}


+ (void)showSplash:(ATSplash *)splash localInfo:(NSDictionary*)localInfo delegate:(id<ATSplashDelegate>)delegate {
    AdnLog(@"!!!: %s: local=%@", __func__, localInfo);
    if ([splash.customObject isKindOfClass:[HXSplashAd class]]) {
        UIView *bottomView = nil;
        UIViewController *rootViewController = nil;
        HXSplashAd *splashAd = splash.customObject;
        if ([splash.customEvent isKindOfClass:[ATHXSplashCustomEvent class]]) {
            ATHXSplashCustomEvent *customEvent = (ATHXSplashCustomEvent *)splash.customEvent;
            bottomView         = customEvent.containerView;
            rootViewController = customEvent.rootViewController;
        }
        // 优先使用show时传入的rootVC
        UIViewController *localRootVC = localInfo[kATHXLocalInfoKey_RootViewController];
        if (localRootVC && [localRootVC isKindOfClass:[UIViewController class]]) {
            rootViewController = localRootVC;
        }
        if (splashAd) {
            UIWindow *window = localInfo[kATSplashExtraWindowKey];
            // !!!!: 落地页rootVC这里选用顺序：show时通过localInfo传入->load时通过localInfo传入->最后选用inViewController。开发者根据结合实际自主选用
            UIViewController *rootVC = localInfo[kATSplashExtraInViewControllerKey];
            if (rootViewController) {
                splashAd.rootViewController = rootViewController;
            } else {
                splashAd.rootViewController = rootVC;
            }
            [splashAd showAdToWindow:window bottomView:bottomView];
        }
    } else {
        AdnLog(@"!!!: It`s not HXSplashAd object");
    }
}

+ (void) sendWinnerNotifyWithCustomObject:(id)customObject secondPrice:(NSString*)price userInfo:(NSDictionary<NSString *, NSString *> *)userInfo {
    AdnLog(@"!!!: %s sec price = %@, info = %@", __func__, price, userInfo);
    /**
     sec price = 4410, info = {
         kATWinLossAdTypeKeyBidInfo = "<ATBidInfo: 0x109babaa0>";
         kATWinLossAdTypekeyWinPrice = 4410;
         kATWinLossAdWinnerNextUnitID = 7458877;
         kATWinLossAuthNetworkKey = 0;
         kATWinLossNativeMaterialTypeKey = 0;
     */
    if ([customObject isKindOfClass:[HXSplashAd class]]) {
        HXSplashAd *splashAd = (HXSplashAd *)customObject;
        @try {
            long secPrice = [price longLongValue];
            [splashAd sendWinNotice:secPrice];
        } @catch (NSException *exception) {
        }
    }
}

+ (void)sendLossNotifyWithCustomObject:(nonnull id)customObject lossType:(ATBiddingLossType)lossType winPrice:(nonnull NSString *)price userInfo:(NSDictionary *)userInfo {
    AdnLog(@"!!!: %s win price = %@, info = %@", __func__, price, userInfo);
    /**
     win price = 4410, info = {
         kATGDTLossUserInfoKeyTypeNetworkFirmID = 102427;
         kATWinLossAdTypeKeyBidInfo = "<ATBidInfo: 0x109bb8aa0>";
         kATWinLossAdWinnerNetworkFirmID = 102427;
         kATWinLossAuthNetworkKey = 0;
         kATWinLossNativeMaterialTypeKey = 0;
     }
     */
    if ([customObject isKindOfClass:[HXSplashAd class]]) {
        HXSplashAd *splashAd = (HXSplashAd *)customObject;
        @try {
            NSString *lossReason = mMerakLossReasonConvert(lossType);
            long winPrice = [price longLongValue];
            [splashAd sendLossNotice:@{
                KXBiddingLossType.kHXBiddingLossInfoKey_LossReason: lossReason,
                KXBiddingLossType.kHXBiddingLossInfoKey_WinPrice:@(winPrice)}
            ];
        } @catch (NSException *exception) {
            
        }
    }
}

- (void)dealloc {
    AdnLog(@"!!!: %s", __func__);
}
@end
