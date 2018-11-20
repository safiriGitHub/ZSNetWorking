//
//  ZSNetEngine.m
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/13.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSNetEngine.h"
#import "AFURLSessionManager.h"
#import "ZSRequestGenerator.h"
#import "ZSRequestModel.h"

@interface ZSNetEngine ()

@property (nonatomic, strong) AFURLSessionManager *sessionManager;

///根据 requestID，存放 Task 的表
@property (nonatomic, strong) NSMutableDictionary *dispatchTaskTable;

@end

@implementation ZSNetEngine

+ (instancetype)sharedEngine {
    static dispatch_once_t onceToken;
    static ZSNetEngine *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZSNetEngine alloc] init];
    });
    return sharedInstance;
}

- (NSNumber *)netRequestWithModel:(ZSRequestModel *)requestModel {
    
    NSNumber *requestID;
    if (requestModel.netRequestType == ZSNetRequestTypeGet || requestModel.netRequestType == ZSNetRequestTypePost || requestModel.netRequestType == ZSNetRequestTypeUpload) {
        NSURLSessionDataTask *task = [self createGetPostUploadTask:requestModel];
        requestID = [NSNumber numberWithUnsignedInteger:task.hash];
        [self.dispatchTaskTable setObject:task forKey:requestID];
        [task resume];
    }
    
    else if (requestModel.netRequestType == ZSNetRequestTypeDownload) {
        NSURLSessionDownloadTask *task = [self createDownloadTask:requestModel];
        requestID = [NSNumber numberWithUnsignedInteger:task.hash];
        [self.dispatchTaskTable setObject:task forKey:requestID];
        [task resume];
    }
   
    
    return requestID;
}

- (NSURLSessionDownloadTask *)getDownloadTaskWithRequestID:(NSNumber *)requestID {
    NSURLSessionDownloadTask *task = [self.dispatchTaskTable objectForKey:requestID];
    return task;
}

- (void)netCancelRequestWithRequestID:(NSNumber *)requestID {
    NSURLSessionDataTask *task = [self.dispatchTaskTable objectForKey:requestID];
    if (task && ![task respondsToSelector:@selector(cancelByProducingResumeData:)]) {
        [task cancel];
        [self.dispatchTaskTable removeObjectForKey:requestID];
    }
}
- (void)netCancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList {
    typeof(self) __weak weakSelf = self;
    [requestIDList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionDataTask *task = [weakSelf.dispatchTaskTable objectForKey:obj];
        if (task && ![task respondsToSelector:@selector(cancelByProducingResumeData:)]) {
            [task cancel];
        }
    }];
    [self.dispatchTaskTable removeObjectsForKeys:requestIDList];
}

#pragma mark - private
- (NSURLSessionDataTask *)createGetPostUploadTask:(ZSRequestModel *)requestModel {
    NSURLRequest *request = [[ZSRequestGenerator sharedGenerator] generateURLRequest:requestModel];
    typeof(self) __weak weakSelf = self;
    
    __block NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request uploadProgress:requestModel.uploadProgressBlock downloadProgress:requestModel.downloadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if ([response isKindOfClass:NSHTTPURLResponse.class]) {
            //获取服务返回的cookie保存并返回上层
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSDictionary *allHeaderFields = httpResponse.allHeaderFields;
            requestModel.responseHeaderFieldsDictionary = [allHeaderFields copy];
        }
        NSNumber *requestID = [NSNumber numberWithUnsignedInteger:task.hash];
        [weakSelf.dispatchTaskTable removeObjectForKey:requestID];
        //这里做completion解析处理
        //解析完成后通过调用requestModel.responseCompletion进行回调
        [self responseHandleWithRequestModel:requestModel urlResponse:response responseObject:responseObject error:error];
    }];
    return task;
}
- (NSURLSessionDownloadTask *)createDownloadTask:(ZSRequestModel *)requestModel {
    
    typeof(self) __weak weakSelf = self;
    __block NSURLSessionDownloadTask *task;
    if (requestModel.downloadResumeData) {
        task = [self.sessionManager downloadTaskWithResumeData:requestModel.downloadResumeData progress:requestModel.downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            if (requestModel.downloadDestinationFileURL) {
                return requestModel.downloadDestinationFileURL;
            }else {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            }
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSNumber *requestID = [NSNumber numberWithUnsignedInteger:task.hash];
            [weakSelf.dispatchTaskTable removeObjectForKey:requestID];
            
            NSData *resumeData;
            if (error) {
                //下载过程中，如果网络丢失，那么会进入到completionHandler。调用以下代码，我们依然可以获取当前的下载缓存数据，并得以在网络连通时实现断点续传
                NSDictionary *userInfo = error.userInfo;
                resumeData = [userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"];
            }
            if (requestModel.downloadCompletionHandler) {
                requestModel.downloadCompletionHandler(response, filePath, error, resumeData);
            }
        }];
    }else {
        if (requestModel.requestFullURL == nil) return nil;
        NSURLRequest *request = [[ZSRequestGenerator sharedGenerator] generateURLRequest:requestModel];
        
        task = [self.sessionManager downloadTaskWithRequest:request progress:requestModel.downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            if (requestModel.downloadDestinationFileURL) {
                return requestModel.downloadDestinationFileURL;
            }else {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            }
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSNumber *requestID = [NSNumber numberWithUnsignedInteger:task.hash];
            [weakSelf.dispatchTaskTable removeObjectForKey:requestID];
            NSData *resumeData;
            if (error) {
                //下载过程中，如果网络丢失，那么会进入到completionHandler。调用以下代码，我们依然可以获取当前的下载缓存数据，并得以在网络连通时实现断点续传
                NSDictionary *userInfo = error.userInfo;
                resumeData = [userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"];
            }
            if (requestModel.downloadCompletionHandler) {
                requestModel.downloadCompletionHandler(response, filePath, error, resumeData);
            }
        }];
    }
    
    return task;
}
- (void)responseHandleWithRequestModel:(ZSRequestModel *)requestModel
                           urlResponse:(NSURLResponse *)urlResponse
                        responseObject:(id)responseObject
                                 error:(NSError *)error {
    
    NSString *errorHintString = nil;
    id jsonResult = nil;
    if (error) {
        ZSNETLog(@"response error - %@",error);
        //统一链接服务器错误解析
        errorHintString = [requestModel.connectServiceErrorHintConfigs objectForKey:[NSNumber numberWithInteger:error.code]];
        if (errorHintString == nil) errorHintString = [requestModel.connectServiceErrorHintConfigs objectForKey:[NSNumber numberWithInteger:NSNotFound]];
    }else {
        //统一JSON解析
        NSData *resultJsonData = responseObject;
        NSError *jsonParseError;
        jsonResult = [NSJSONSerialization JSONObjectWithData:resultJsonData options:NSJSONReadingMutableContainers error:&jsonParseError];
    }
    requestModel.connectServiceErrorHintString = errorHintString;
    
    [requestModel.service parseResult:jsonResult requestModel:requestModel parseCompletionHandler:requestModel.responseCompletion];
}

#pragma mark - getters and setters

- (AFURLSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [self configHttpManager];
        
    }
    return _sessionManager;
}

- (NSMutableDictionary *)dispatchTaskTable {
    if (!_dispatchTaskTable) {
        _dispatchTaskTable = [NSMutableDictionary dictionary];
    }
    return _dispatchTaskTable;
}

- (AFURLSessionManager *)configHttpManager {
    
    //    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    //    [NSURLCache setSharedURLCache:URLCache];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForResource = 25;
    configuration.timeoutIntervalForRequest = 25;
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //自己解析json数据
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain" ,nil];
    sessionManager.responseSerializer = serializer;
    
    return sessionManager;
}

//- (void)configHttpsManager {
    //不安全的使用自签证书来访问HTTPS
    //AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//== [AFSecurityPolicy defaultPolicy]
    //AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //是否允许无效证书（也就是自建的证书），默认为NO
    //securityPolicy.allowInvalidCertificates = YES;
    //是否需要验证域名，默认为YES
    //securityPolicy.validatesDomainName = NO;
    //赋值安全配置
    //manager.securityPolicy = securityPolicy;
    
    //AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //securityPolicy.allowInvalidCertificates = YES;
    //securityPolicy.validatesDomainName = NO;
    //sessionManager.securityPolicy = securityPolicy;
    //使用默认的securityPolicy
//}

//- (NSNumber *)netRequestSynchronizationWithModel:(ZSRequestModel *)requestModel {
//    NSURLRequest *request = [[ZSRequestGenerator sharedGenerator] generateURLRequest:requestModel];
//    typeof(self) __weak weakSelf = self;
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);//创建信号量
//    
//    __block NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request uploadProgress:requestModel.uploadProgressBlock downloadProgress:requestModel.downloadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        
//        NSNumber *requestID = [NSNumber numberWithUnsignedInteger:task.hash];
//        [weakSelf.dispatchTaskTable removeObjectForKey:requestID];
//        [self responseHandleWithRequestModel:requestModel urlResponse:response responseObject:responseObject error:error];
//        dispatch_semaphore_signal(semaphore);//不管请求状态是什么，都得发送信号，否则会一直卡着进程
//    }];
//    [task resume];
//    NSNumber *requestID = [NSNumber numberWithUnsignedInteger:task.hash];
//    [self.dispatchTaskTable setObject:task forKey:requestID];
//    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);//等待
//    return requestID;
//}

@end
