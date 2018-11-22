//
//  ZSNetWorking.h
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/14.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSRequestModel.h"
#import "ZSNetRequest.h"
#import "ZSNetConfig.h"
#import "ZSNetConnectMonitorUtil.h"


/**
 提供常用方便的请求方法
 调用ZSNetRequest的请求方法
 */
@interface ZSNetWorking : NSObject

/**
 POST请求

 @param requestModel 请求配置Model
 @param control 将请求绑定到的实例，若设置此实例销毁时自动取消已绑定的请求。设为nil则不会自动取消请求。
 @param responseCompletion 请求解析完成回调
 */
+ (void)POSTRequestModel:(ZSRequestModel *)requestModel cancelControl:(NSObject *)control completion:(ZSNetWorkingResponseCompletion)responseCompletion;

+ (void)GETRequestModel:(ZSRequestModel *)requestModel cancelControl:(NSObject *)control completion:(ZSNetWorkingResponseCompletion)responseCompletion;

+ (void)UploadRequestModel:(ZSRequestModel *)requestModel progress:(ZSNetProgressBlock)progress completion:(ZSNetWorkingResponseCompletion)responseCompletion;

/**
 Download请求
 可根据返回值 Task 调用 cancelByProducingResumeData: 来取消任务，获取resumeData

 @param requestModel 下载请求配置Model
 @param progress 下载任务进度回调
 @param downloadCompletion 下载请求完成回调
 @return 下载任务Task
 */
+ (NSURLSessionDownloadTask *)DownloadRequestModel:(ZSRequestModel *)requestModel progress:(ZSNetProgressBlock)progress completion:(ZSDownloadCompletionHandler)downloadCompletion;

@end
