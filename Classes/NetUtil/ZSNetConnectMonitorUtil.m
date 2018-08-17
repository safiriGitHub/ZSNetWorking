//
//  ZSNetConnectMonitorUtil.m
//  CheFu365
//
//  Created by safiri on 2017/10/9.
//  Copyright © 2017年 safiri. All rights reserved.
//

#import "ZSNetConnectMonitorUtil.h"
#import "AFNetworkReachabilityManager.h"

@interface ZSNetConnectMonitorUtil ()
@property (nonatomic ,assign) NSInteger notReachableHintCount;
@end

@implementation ZSNetConnectMonitorUtil
- (void)startMonitor {
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        BOOL enable = NO;
        NSString *hintStr = nil;
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                //无网络连接
                hintStr = [NSString stringWithFormat:@"连接网络权限可能被关闭,请在\"设置\"-\"%@\"-\"无线数据\"中开启或检查网络",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]];
            break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //移动蜂窝网络
                enable = YES;
            break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //wifi
                enable = YES;
            break;
            case AFNetworkReachabilityStatusUnknown:
                //无法获取网络状态
                hintStr = @"无法获取网络状态，请重试";
                break;
            default:
                break;
        }
        
        if ([self.delegate respondsToSelector:@selector(netConnectEnable:)]) {
            [self.delegate netConnectEnable:enable];
        }
        
        if (!enable) {
            if (self.notReachableHintCount%5 == 0) {
                self.notReachableHintCount++;
            }else {
                self.notReachableHintCount++;
                return;
            }
            //NSLog(@"tiaoshi%ld",(long)self.notReachableHintCount);
        }
        
        if ([self.delegate respondsToSelector:@selector(netConnectEnable:hint:)]) {
            [self.delegate netConnectEnable:enable hint:hintStr];
        }
    }];
    [mgr startMonitoring];
}
@end
