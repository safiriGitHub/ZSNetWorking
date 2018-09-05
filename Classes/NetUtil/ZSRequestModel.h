//
//  ZSRequestModel.h
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/13.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSNetConfig.h"
#import "ZSUploadFileModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 请求详细信息Model
 */
@interface ZSRequestModel : NSObject

//MARK: request config
/**
 请求基地址,从serviceClass类获取
 */
@property (nonatomic, strong, readonly, nullable) NSString *baseURL;

/**
 请求站点地址
 可能接口设计关系，需要配置此参数。例如：init.do  pay.do...
 与baseURL进行拼接，生成完整URL
 */
@property (nonatomic, strong, nullable) NSString *methodURL;

/**
 请求完整的URL
 1.baseURL+methodURL 2.下载文件完整URL
 */
@property (nonatomic, strong, nullable) NSString *requestFullURL;

/**
 请求方式,默认ZSNetRequestTypePost
 */
@property (nonatomic, assign) ZSNetRequestType netRequestType;

//MARK: param

/**
 请求参数字典
 */
@property (nonatomic, strong, nullable) NSDictionary *paramDictionary;

/**
 请求头参数字典,默认为nil
 */
@property (nonatomic, strong, nullable) NSDictionary <NSString *, NSString *>*requestHeaderParamDictionary;

/**
 请求上传文件参数数组
 */
@property (nonatomic, strong) NSArray <ZSUploadFileModel *>*uploadFileModelArray;

/**
 下载文件写入到的目标文件地址URL
 若为nil，则在NSDocumentDirectory中自动生成文件并写入
 */
@property (nonatomic, strong) NSURL *downloadDestinationFileURL;

/**
 The data used to resume downloading.用于断点恢复下载的数据。
 设置后则进行断点下载
 */
@property (nonatomic, strong) NSData *downloadResumeData;


//MARK: service
/**
 自定义的服务器类 <ZSServiceProtocol>
 */
@property (nonatomic, strong) Class serviceClass;

/**
 自定义的服务器实例
 */
@property (nonatomic, strong, readonly) id <ZSServiceProtocol>service;

/**
 服务器返回数据是否是加密的
 默认NO:没有加密
 */
@property (nonatomic, assign) BOOL isServiceCipher;

/**
 请求服务器失败提示信息配置字典
 */
@property (nonatomic, strong) NSDictionary <NSNumber *, NSString *>*connectServiceErrorHintConfigs;

/**
 请求服务器失败提示信息
 */
@property (nonatomic, strong) NSString *connectServiceErrorHintString;


//MARK: block

/**
 上传进度回调block
 */
@property (nonatomic, copy) ZSNetProgressBlock uploadProgressBlock;

/**
 下载进度回调block
 */
@property (nonatomic, copy) ZSNetProgressBlock downloadProgressBlock;

/**
 ZSNetWorking 请求并解析数据成功回调block
 */
@property (nonatomic, copy) ZSNetWorkingResponseCompletion responseCompletion;

/**
 ZSNetWorking 下载任务完成回调
 */
@property (nonatomic, copy) ZSDownloadCompletionHandler downloadCompletionHandler;

@end

NS_ASSUME_NONNULL_END
