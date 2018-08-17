//
//  ZSNetConnectMonitorUtil.h
//  CheFu365
//
//  Created by safiri on 2017/10/9.
//  Copyright © 2017年 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MonitorNetConnectDelegate <NSObject>

@optional
///含notReachableHintCount，降低调用频率
- (void)netConnectEnable:(BOOL)enable hint:(NSString *_Nullable)hintStr;
///与AF一样的调用频率
- (void)netConnectEnable:(BOOL)enable;
@end

///监听网络连接状态
@interface ZSNetConnectMonitorUtil : NSObject

@property (nonatomic ,weak ,nullable) id <MonitorNetConnectDelegate>  delegate;
- (void)startMonitor;

@end
