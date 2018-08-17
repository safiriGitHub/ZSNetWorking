//
//  ZSNetCancelStorage.m
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/14.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSNetCancelStorage.h"
#import "ZSNetRequest.h"
#import <objc/runtime.h>

@implementation NSObject (ZSAddNetCancelStorage)

- (ZSNetCancelStorage *)netCancelStorage {
    ZSNetCancelStorage *storage = objc_getAssociatedObject(self, _cmd);
    if (storage == nil) {
        storage = [[ZSNetCancelStorage alloc] init];
        objc_setAssociatedObject(self, _cmd, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return storage;
}

@end

@interface ZSNetCancelStorage ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *,ZSNetRequest *> *requestEngines;

@end

@implementation ZSNetCancelStorage

- (void)dealloc {
    //暂时无法实现自动调ZSNetRequest的dealloc
    [self.requestEngines enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, ZSNetRequest * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj cancelNetRequest];
    }];
    [self.requestEngines removeAllObjects];
    self.requestEngines = nil;
}

- (NSMutableDictionary<NSNumber *,ZSNetRequest *> *)requestEngines {
    if (_requestEngines == nil) {
        _requestEngines = [[NSMutableDictionary alloc]init];
    }
    return _requestEngines;
}

- (void)setNetRequest:(ZSNetRequest *)netRequest requestID:(NSNumber *)requestID {
    if (netRequest && requestID) {
        self.requestEngines[requestID] = netRequest;
    }
}

- (void)removeEngineWithRequestID:(NSNumber *)requestID {
    if (requestID) {
        [self.requestEngines removeObjectForKey:requestID];
    }
}

@end
