#import "TaKuAdManager.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

#define kTaKuAppID @"a67e4101967c3e"
#define kTaKuAppKey @"ad480db597693a5b613e8a27c713166b4"

@implementation TaKuAdManager
+(instancetype) sharedManager {
    static TaKuAdManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[TaKuAdManager alloc] init];
        
    });
    return sharedManager;
}

-(void) initSDK {
    
    [ATAPI setLogEnabled:YES];
        
    [ATAPI integrationChecking];

    [[ATAPI sharedInstance] getUserLocationWithCallback:^(ATUserLocation location) {
        if (location == ATUserLocationInEU) {
            NSLog(@"----------ATUserLocationInEU");
            if ([ATAPI sharedInstance].dataConsentSet == ATDataConsentSetUnknown) {
                NSLog(@"----------ATDataConsentSetUnknown");
            }
        }else if (location == ATUserLocationOutOfEU){
            NSLog(@"----------ATUserLocationOutOfEU");
        }else{
            NSLog(@"----------ATUserLocationUnknown");
        }
    }];
                
    [[ATAPI sharedInstance] getAreaSuccess:^(NSString *areaCodeStr) {
        NSLog(@"getArea:%@",areaCodeStr);
    } failure:^(NSError *error) {
            NSLog(@"getArea:%@",error.domain);
    }];
    
    // 设置系统平台信息，默认设置IOS=1
//    ATSystemPlatformTypeIOS = 1,
//    ATSystemPlatformTypeUnity = 2,
//    ATSystemPlatformTypeCocos2dx = 3,
//    ATSystemPlatformTypeCocosCreator = 4,
//    ATSystemPlatformTypeReactNative = 5,
//    ATSystemPlatformTypeFlutter = 6,
//    ATSystemPlatformTypeAdobeAir = 7
    [[ATAPI sharedInstance] setSystemPlatformType:ATSystemPlatformTypeIOS];
        
    // init SDK
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            [[ATAPI sharedInstance] startWithAppID:kTaKuAppID appKey:kTaKuAppKey error:nil];
        }];
    } else {
        // Fallback on earlier versions
        [[ATAPI sharedInstance] startWithAppID:kTaKuAppID appKey:kTaKuAppKey error:nil];
    }
}

@end
