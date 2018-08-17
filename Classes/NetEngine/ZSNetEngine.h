//
//  ZSNetEngine.h
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/13.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZSRequestModel;
/**
 发起网络请求
 */
@interface ZSNetEngine : NSObject

+ (instancetype)sharedEngine;

/**
 发起网络异步请求

 @param requestModel 请求详细配置Model
 @return 网络请求任务的哈希值
 */
- (NSNumber *)netRequestWithModel:(ZSRequestModel *)requestModel;
//发起网络同步请求
//- (NSNumber *)netSynchronizationRequestWithModel:(ZSRequestModel *)requestModel;

/**
 根据请求任务ID取消网络请求
 不会取消下载任务
 @param requestID 请求任务ID
 */
- (void)netCancelRequestWithRequestID:(NSNumber *)requestID;

/**
 根据请求任务ID数组取消多个网络请求
 不不会取消下载任务

 @param requestIDList 请求任务ID数组
 */
- (void)netCancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList;

- (nullable NSURLSessionDownloadTask *)getDownloadTaskWithRequestID:(NSNumber *)requestID;

@end
