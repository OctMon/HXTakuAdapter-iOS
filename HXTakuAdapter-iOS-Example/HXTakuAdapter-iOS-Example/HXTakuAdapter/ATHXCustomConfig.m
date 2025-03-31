#import "ATHXCustomConfig.h"
#import "ATHXCustomCommon.h"

@implementation ATHXCustomConfig
+ (void)initAdNetworkWithServerInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo completion:(void (^)(NSError * _Nullable))completion {
    AdnLog(@"[ADN]: %s", __func__);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // TODO: 用户隐私配置，开发者选配
        /*
        [HXPrivacyConfig sharedInstance].userId = @"User ID";
        [HXPrivacyConfig sharedInstance].canUseDeviceId = YES;
         ...其他配置项
        */
        
        NSString *appId = serverInfo[kATHXConfigKey_AppID];
        [HXSDK initWithAppIdWithAppId:appId?[NSString stringWithFormat:@"%@", appId]:nil];
    });
    if (completion) {
        completion(nil);
    }
}
@end
