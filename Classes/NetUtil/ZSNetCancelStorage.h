//
//  ZSNetCancelStorage.h
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/14.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZSNetCancelStorage;
@interface NSObject (ZSAddNetCancelStorage)

/**
 将netCancelStorage绑定到NSObject,当NSObject释放时netCancelStorage也会释放,当netCancelStorage 释放的时候，根据requestID取消没有返回的网络请求
 */
@property (nonatomic, strong, readonly) ZSNetCancelStorage *netCancelStorage;

@end

@class ZSNetRequest;
@interface ZSNetCancelStorage : NSObject

- (void)setNetRequest:(ZSNetRequest *)netRequest requestID:(NSNumber *)requestID;

- (void)removeEngineWithRequestID:(NSNumber *)requestID;

@end
