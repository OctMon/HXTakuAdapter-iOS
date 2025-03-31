#import "ViewController.h"
#import <AnyThinkSplash/AnyThinkSplash.h>

@interface ViewController ()<ATSplashDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSplashAd];
    
}
- (IBAction)loadSplashAd {
    // 开屏广告底部自定义的containerView
    UILabel *label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(.0f, .0f,  UIScreen.mainScreen.bounds.size.width, 100.0f)];
    label.text = @"Container";
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    // 设置开屏广告中支持广告源设置加载超时时间，并不是整个广告位请求的时间
    [mutableDict setValue:@5.5 forKey:kATSplashExtraTolerateTimeoutKey];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:@"b67e41041152f4"
                                                 extra:mutableDict
                                              delegate:self
                                         containerView:label];
    
    // 从你们的Taku后台导出的兜底广告源进行设置
    //导出格式如：{\"unit_id\":1331013,\"nw_firm_id\":22,\"adapter_class\":\"ATBaiduSplashAdapter\",\"content\":\"{\\\"button_type\\\":\\\"0\\\",\\\"ad_place_id\\\":\\\"7852632\\\",\\\"app_id\\\":\\\"e232e8e6\\\"}\"}
    // [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:extra delegate:self containerView:label defaultAdSourceConfig:self.defaultAdSourceConfigStr];
}

// 由于系统的变动，提供两个获取 keyWindow的方法，选择一个适合来
- (UIWindow *)getKeyWindowMethodOne {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive)
            {
                for (UIWindow *window in windowScene.windows)
                {
                    if (window.isKeyWindow)
                    {
                        return window;
                    }
                }
            }
        }
    } else {
        // 添加到当前window上，并置顶到最上层
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        if (window) {
            return window;
        }
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}

// show展示开屏广告
- (void)showSplashAd {
    // 到达场景
//    [self entryAdScenario];

    if ([[ATAdManager sharedManager] splashReadyForPlacementID:@"b67e41041152f4"]) {
        // 根据实际情况选择获取到的keyWindow的方法 getKeyWindowMethodOne 和 getKeyWindowMethodTwo
        UIWindow *mainWindow = [self getKeyWindowMethodOne];
        // 自定义跳过按钮，注意需要在广告倒计时 splashCountdownTime: 回调中实现按钮文本的变化处理
    //    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.skipButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    //    self.skipButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80 - 20, 50, 80, 21);
    //    self.skipButton.layer.cornerRadius = 10.5;
    //    self.skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        
        /* 多数平台已经不支持自定义跳过按钮，目前支持更改自定义跳过按钮有穿山甲(TT)，直投、ADX、原生作开屏和游可盈，具体需要运行看实际效果
        // 自定义跳过按钮倒计时时长，毫秒单位
        [mutableDict setValue:@50000 forKey:kATSplashExtraCountdownKey];
        // 自定义跳过按钮
        [mutableDict setValue:self.skipButton forKey:kATSplashExtraCustomSkipButtonKey];
        // 自定义跳过按钮倒计时回调间隔
        [mutableDict setValue:@500 forKey:kATSplashExtraCountdownIntervalKey];
        */
        
        [[ATAdManager sharedManager] showSplashWithPlacementID:@"b67e41041152f4" scene:nil window:mainWindow extra:mutableDict delegate:self];
    }
}


// MARK:- splash delegate
#pragma mark - ATSplashDelegate
- (void)didStartLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--AD--开始--ATSplashViewController::didStartLoadingADSourceWithPlacementID:%@", placementID);
}

- (void)didFinishLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--AD--完成--ATSplashViewController::didFinishLoadingADSourceWithPlacementID:%@", placementID);
    [self showSplashAd];
}

- (void)didFailToLoadADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--AD--失败--ATSplashViewController::didFailToLoadADSourceWithPlacementID:%@---error:%@", placementID,error);
}

// bidding
- (void)didStartBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--bid--开始--ATSplashViewController::didStartBiddingADSourceWithPlacementID:%@", placementID);
}

- (void)didFinishBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--bid--完成--ATSplashViewController::didFinishBiddingADSourceWithPlacementID:%@", placementID);
}

- (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--bid--失败--ATSplashViewController::didFailBiddingADSourceWithPlacementID:%@--error:%@", placementID,error);
}

- (void)didFinishLoadingSplashADWithPlacementID:(NSString *)placementID isTimeout:(BOOL)isTimeout {
    NSLog(@"开屏成功:%@----是否超时:%d",placementID,isTimeout);
    NSLog(@"开屏didFinishLoadingSplashADWithPlacementID:");
    [self showLog:[NSString stringWithFormat:@"开屏成功:%@----是否超时:%d",placementID,isTimeout]];
}

- (void)didTimeoutLoadingSplashADWithPlacementID:(NSString *)placementID {
    NSLog(@"开屏超时:%@",placementID);
    NSLog(@"开屏didTimeoutLoadingSplashADWithPlacementID:");
    [self showLog:[NSString stringWithFormat:@"开屏超时:%@",placementID]];
}

- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"开屏ATSplashViewController:: didFailToLoadADWithPlacementID");
    [self showLog:[NSString stringWithFormat:@"开屏加载失败:%@--%@",placementID,error]];
}

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"开屏ATSplashViewController:: didFinishLoadingADWithPlacementID");
    [self showLog:[NSString stringWithFormat:@"开屏加载成功:%@",placementID]];
}

- (void)splashDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    NSLog(@"开屏ATSplashViewController:: splashDeepLinkOrJumpForPlacementID:placementID:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"splashDeepLinkOrJumpForPlacementID:placementID:%@ ", placementID]];
}

- (void)splashDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"开屏ATSplashViewController::splashDidClickForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidClickForPlacementID:%@",placementID]];
}

- (void)splashDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"开屏ATSplashViewController::splashDidCloseForPlacementID:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"splashDidCloseForPlacementID:%@ ",placementID]];
}

- (void)splashDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"开屏ATSplashViewController::splashDidShowForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidShowForPlacementID:%@ ",placementID]];
}

-(void)splashZoomOutViewDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *) extra {
    NSLog(@"开屏ATSplashViewController::splashZoomOutViewDidClickForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashZoomOutViewDidClickForPlacementID:%@ ",placementID]];
}

-(void)splashZoomOutViewDidCloseForPlacementID:(NSString*)placementID extra:(NSDictionary *) extra {
    NSLog(@"开屏ATSplashViewController::splashZoomOutViewDidCloseForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashZoomOutViewDidCloseForPlacementID:%@ ",placementID]];
}

- (void)splashDetailDidClosedForPlacementID:(NSString*)placementID extra:(NSDictionary *) extra {
    NSLog(@"ATSplashViewController::splashDetailDidClosedForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDetailDidClosedForPlacementID:%@ ",placementID]];
}

- (void)splashDidShowFailedForPlacementID:(NSString*)placementID error:(NSError *)error extra:(NSDictionary *) extra {
    NSLog(@"开屏ATSplashViewController::splashDidShowFailedForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidShowFailedForPlacementID:%@ error:%@ ",placementID,error]];
}

- (void)splashCountdownTime:(NSInteger)countdown forPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"开屏ATSplashViewController::splashCountdownTime:%ld forPlacementID:%@",countdown,placementID);
    [self showLog:[NSString stringWithFormat:@"splashCountdownTime:%ld forPlacementID:%@",countdown,placementID]];
    
    // 自定义倒计时回调，需要自行处理按钮文本显示
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *title = [NSString stringWithFormat:@"%lds | Skip",countdown/1000];
//        if (countdown/1000) {
//            [self.skipButton setTitle:title forState:UIControlStateNormal];
//        }
//    });
}

- (void)showLog:(NSString *)logStr {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *logS = self.textView.text;
        NSString *log = nil;
        if (![logS isEqualToString:@""]) {
            log = [NSString stringWithFormat:@"%@\n%@", logS, logStr];
        } else {
            log = [NSString stringWithFormat:@"%@", logStr];
        }
        self.textView.text = log;
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    });
}

@end
