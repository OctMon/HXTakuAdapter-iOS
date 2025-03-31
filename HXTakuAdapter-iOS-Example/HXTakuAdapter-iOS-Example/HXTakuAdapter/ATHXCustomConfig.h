#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATHXCustomConfig : NSObject

+ (void)initAdNetworkWithServerInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo completion:(void (^__nullable)(NSError *__nullable error))completion;

@end

NS_ASSUME_NONNULL_END
