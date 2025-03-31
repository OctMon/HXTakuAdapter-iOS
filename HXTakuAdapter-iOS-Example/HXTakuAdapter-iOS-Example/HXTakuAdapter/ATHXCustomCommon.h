#ifndef ATHXCustomCommon_h
#define ATHXCustomCommon_h

#include <Foundation/Foundation.h>

static NSString *const kATHXAdapterVersion  = @"1.0.0";

#define AdnLog(FORMAT, ...)   printf("%s [☘️]: %s\n", [NSDate date].description.UTF8String, [NSString stringWithFormat:FORMAT, ##__VA_ARGS__].UTF8String)
//#define AdnLog(FORMAT, ...)   NSLog(@"[☘️]: %@", [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])

static NSString *const kATHXAdapterErrorDomain  = @"com.hxsdk.error";
typedef NS_ENUM(NSInteger, kATHXAdapterErrorCode) {
    kATHXAdapterErrorCode_SDKNotFound           = -1999,  // 无sdk
    kATHXAdapterErrorCode_NotImportedProperly   = -1101,  // 未设置属性值
    kATHXAdapterErrorCode_PlacementIdEmpty      = -1102,  // 无广告位id
    kATHXAdapterErrorCode_OfferInvalid          = -1118,  // 广告已无效
    kATHXAdapterErrorCode_OfferNotFound         = -1119,  // 无广告对象
};


// 平台配置信息
#define kATHXConfigKey_AppID                     @"app_id"
#define kATHXCustomInfoKey_SlotId                @"unit_id"
#define kATHXCustomInfoKey_AdSize                @"ad_size"

// 本地配置信息
//#define kATHXCustomInfoKey_BottomView            @"bottomView"
#define kATHXLocalInfoKey_RootViewController     @"rootViewController"

#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AnyThinkSplash/AnyThinkSplash.h>
#import <HXSDK/HXSDK.h>

NSString *mMerakLossReasonConvert(ATBiddingLossType lossType);

#endif /* ATHXCustomCommon_h */
