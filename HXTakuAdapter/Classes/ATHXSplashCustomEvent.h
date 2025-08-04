#import <Foundation/Foundation.h>
#import "ATHXCustomCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATHXSplashCustomEvent : ATSplashCustomEvent <HXSplashAdDelegate>
@property (nonatomic, strong) NSDate *expireDate;
@property (nonatomic, weak  ) UIView *containerView;                 // bottomView
@property (nonatomic, weak  ) UIViewController *rootViewController;  // 广告rootVC
@end

NS_ASSUME_NONNULL_END
