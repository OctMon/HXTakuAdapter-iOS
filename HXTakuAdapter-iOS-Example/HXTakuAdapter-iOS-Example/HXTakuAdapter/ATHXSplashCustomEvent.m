#import "ATHXSplashCustomEvent.h"
#import "ATHXC2SBiddingManager.h"

@interface ATHXSplashCustomEvent ()
@end

@implementation ATHXSplashCustomEvent
- (NSString *)networkUnitId {
    AdnLog(@"[ADN] %s", __func__);
    return self.serverInfo[kATHXCustomInfoKey_SlotId];
}

- (void)removeCustomSplashAd {
    if (self.containerView) {
        [self.containerView removeFromSuperview];
    }
}
#pragma mark - ad delegate
/**
 *  广告请求成功，并且素材加载完成，在此选择调用showAd来展示广告
 */
- (void)hxSplashAdDidLoad:(HXSplashAd *)splashAd {
    AdnLog(@"[ADN] %s", __func__);
    if (self.isC2SBiding) {
        ATHXBiddingRequest *request = [[ATHXC2SBiddingManager sharedInstance] getRequestItemWithUnitID:splashAd.placementId];
        if (request) {
            AdnLog(@"[ADN] is c2s ad, will send bid completion");
            // 元=分/100.0
            NSString *price = @(splashAd.eCPM/100.0f).stringValue;
            ATBidInfo *info = [ATBidInfo bidInfoC2SWithPlacementID:request.placementID
                                                   unitGroupUnitID:request.unitGroup.unitID
                                                adapterClassString:request.unitGroup.adapterClassString
                                                             price:price
                                                      currencyType:ATBiddingCurrencyTypeCNY
                                                expirationInterval:request.unitGroup.networkTimeout
                                                      customObject:request.customObject];
            info.networkFirmID = request.unitGroup.networkFirmID;
            if (request.bidCompletion) {
                request.bidCompletion(info, nil);
            }
            self.isC2SBiding = NO;
        }
    } else {
        [self trackSplashAdLoaded:splashAd adExtra:nil];
    }
}

/**
 *  广告请求失败
 *  @param error 失败原因
 */
- (void)hxSplashAdFailedToLoad:(HXSplashAd *)splashAd withError:(NSError *)error {
    AdnLog(@"[ADN] %s", __func__);
    if (self.isC2SBiding) {
        // 需要进行callback，否则会超时
        ATHXBiddingRequest *request = [[ATHXC2SBiddingManager sharedInstance] getRequestItemWithUnitID:splashAd.placementId];
        if (request) {
            if (request.bidCompletion) {
                request.bidCompletion(nil, error);
            }
            self.isC2SBiding = NO;
        }
        [[ATHXC2SBiddingManager sharedInstance] removeRequestItmeWithUnitID:splashAd.placementId];
    } else {
        [self trackSplashAdLoadFailed:error];
    }
}

/**
 *  广告即将展示
 */
- (void)hxSplashAdWillShow:(HXSplashAd *)splashAd {
    AdnLog(@"[ADN] %s", __func__);
}

/**
 *  广告展示完毕
 */
- (void)hxSplashAdDidShow:(HXSplashAd *)splashAd {
    AdnLog(@"[ADN] %s", __func__);
    [self trackSplashAdShow];
}

/**
 *  广告展示失败，未能正确显示在屏幕上: 如调用showAd时，window不是keywindow
 *  @param error 失败原因
 */
- (void)hxSplashAdFailedToShow:(HXSplashAd *)splashAd withError:(NSError *)error {
    AdnLog(@"[ADN] %s", __func__);
    [self trackSplashAdShowFailed:error];
}

/**
 *  广告点击回调
 */
- (void)hxSplashAdDidClick:(HXSplashAd *)splashAd {
    AdnLog(@"[ADN] %s", __func__);
    [self trackSplashAdClick];
}

/**
 * 广告点击跳过的回调
 */
- (void)hxSplashAdDidClickSkip:(HXSplashAd *)splashAd {
    AdnLog(@"[ADN] %s", __func__);
}

/**
 *  广告关闭回调：跳过/倒计时结束/点击广告后广告view被移除
 */
- (void)hxSplashAdDidClose:(HXSplashAd *)splashAd {
    AdnLog(@"[ADN] %s", __func__);
    [self removeCustomSplashAd];
    [self trackSplashAdClosed:nil];
}

/**
 *  广告转化完成：关闭落地页或者跳转到其他应用
 */
- (void)hxSplashAdDidFinishConversion:(HXSplashAd *)splashAd interactionType:(HXAdInteractionType)interactionType {
    AdnLog(@"[ADN] %s", __func__);
    [self trackSplashAdDetailClosed];
}
@end
