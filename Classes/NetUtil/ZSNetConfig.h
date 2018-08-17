//
//  ZSNetConfig.h
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/13.
//  Copyright © 2018年 safiri. All rights reserved.
//

#ifndef ZSNetConfig_h
#define ZSNetConfig_h

#if (defined(DEBUG) || defined(ADHOC) || !defined ZS_BUILD_FOR_RELEASE)
#define ZSNETLog(format, ...) NSLog((@"FUNC:%s\n" "LINE:%d\n" format),__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ZSNETLog(format, ...)
#endif


/**
 请求类型

 - ZSNetRequestTypePost: Post请求
 - ZSNetRequestTypePost: Get请求
 - ZSNetRequestTypePost: Upload上传
 - ZSNetRequestTypePost: Download下载
 */
typedef NS_ENUM (NSUInteger, ZSNetRequestType){
    ZSNetRequestTypePost,
    ZSNetRequestTypeGet,
    ZSNetRequestTypeUpload,
    ZSNetRequestTypeDownload
};

/**
 常见链接服务器失败码枚举

 - ErrorCode1001: 连接超时
 - ErrorCode1004: 连接失败
 - ErrorCode1005: The operation couldn’t be completed.
 - ErrorCode1009: The Internet connection appears to be offline.
 - ErrorCode1011: Request failed: not found (404)
 - ErrorCodeOther: 其他原因
 */
typedef NS_ENUM(NSUInteger, ZSNetConnectServiceErrorCode) {
    ErrorCode1001 = -1001,
    ErrorCode1004 = -1004,
    ErrorCode1005 = -1005,
    ErrorCode1009 = -1009,
    ErrorCode1011 = -1011,
    ErrorCodeOther = NSNotFound
};

/**
 目前提供的加解密方式

 - EnDecryptNone: 不加密解密
 - EnDecryptDES: DES
 - EnDecrypt3DES: 3DES
 - EnDecryptAES128: AES128
 */
typedef NS_ENUM(NSUInteger, ZSRequestEnDecryptType) {
    EnDecryptNone,
    EnDecryptDES,
    EnDecrypt3DES,
    EnDecryptAES128
};

typedef void (^ZSNetProgressBlock)(NSProgress *taskProgress);

/**
 POST/GET/Upload 请求并自定义解析成功回调

 @param resultArray 解析业务数据
 @param responseCode 请求返回值
 @param responseMessage 请求返回提示信息
 */
typedef void (^ZSNetWorkingResponseCompletion)(NSArray *resultArray, NSString *responseCode, NSString *responseMessage);

/**
 下载任务有结果回调
 
 @param response NSURLResponse
 @param filePath NSURL
 @param error 下载失败error
 @param resumeData 出现下载失败error时的下载缓存数据
 */
typedef void(^ZSDownloadCompletionHandler)(NSURLResponse *response, NSURL *filePath, NSError *error, NSData *resumeData);

@class ZSRequestModel;
@protocol ZSServiceProtocol <NSObject>

@required

@property (nonatomic, strong, readonly) NSString *apiBaseUrl;

- (void)parseResult:(id)jsonResult requestModel:(ZSRequestModel *)requestModel parseCompletionHandler:(ZSNetWorkingResponseCompletion)completionHandler;

@optional
/**
 自定义指定对称加密方式
 */
@property (nonatomic, assign) ZSRequestEnDecryptType enDecryptType;

/**
 自定义对称加密秘钥
 */
@property (nonatomic, strong) NSString *symmetricEnDecryptionKey;

/**
 自定义对称加密偏移量
 */
@property (nonatomic, strong) NSString *symmetricEnDecryptionIv;

@end

#endif /* ZSNetConfig_h */
