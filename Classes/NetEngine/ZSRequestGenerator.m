//
//  ZSRequestGenerator.m
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/13.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSRequestGenerator.h"
#import "ZSRequestModel.h"
#import "ZSUploadFileModel.h"
#import "ZSNetConfig.h"

#import "AFURLRequestSerialization.h"

@interface ZSRequestGenerator()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation ZSRequestGenerator

+ (instancetype)sharedGenerator {
    static ZSRequestGenerator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZSRequestGenerator alloc]init];
    });
    return sharedInstance;
}

- (NSURLRequest *)generateURLRequest:(ZSRequestModel *)requestModel {
    
    NSString *requestUrl = requestModel.requestFullURL;
    id requestParams = requestModel.requestParams;
    __autoreleasing NSError *error;
    NSMutableURLRequest *request;
    
    //添加请求头参数
    if (requestModel.requestHeaderParamDictionary.count > 0) {
        [requestModel.requestHeaderParamDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [self.httpRequestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    if (requestModel.netRequestType == ZSNetRequestTypeGet) {
        request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:requestUrl parameters:requestParams error:&error];
    }
    
    else if (requestModel.netRequestType == ZSNetRequestTypePost) {
        request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:requestUrl parameters:requestParams error:&error];
    }
    
    else if (requestModel.netRequestType == ZSNetRequestTypeUpload) {
        request = [self.httpRequestSerializer multipartFormRequestWithMethod:@"POST" URLString:requestUrl parameters:requestParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            //config formData
            for (ZSUploadFileModel *model in requestModel.uploadFileModelArray) {
                NSAssert(model.name != nil, @"ZSUploadFileModel`s name must not be `nil`.");
                
                if (model.uploadType == UploadFile) {
                    NSAssert((model.fileData != nil || model.fileURL != nil), @"one of fileData and fileURL must not be `nil`.");
                    if (model.fileData) {
                        [formData appendPartWithFileData:model.fileData
                                                    name:model.name
                                                fileName:model.fileName
                                                mimeType:model.mimeType];
                    }else {
                        if (model.fileName && model.mimeType) {
                            [formData appendPartWithFileURL:model.fileURL
                                                       name:model.name
                                                   fileName:model.fileName
                                                   mimeType:model.mimeType
                                                      error:nil];
                        }else {
                            [formData appendPartWithFileURL:model.fileURL
                                                       name:model.name
                                                      error:nil];
                        }
                    }
                }
                
                else if (model.uploadType == UploadFormData) {
                    [formData appendPartWithFormData:model.formData name:model.name];
                }
                
                else if (model.uploadType == UploadHeadersBody) {
                    NSAssert(model.bodyData != nil, @"ZSUploadFileModel`s bodyData must not be `nil`.");
                    [formData appendPartWithHeaders:model.headers body:model.bodyData];
                }
            }
            
        } error:&error];
    }
    
    else if (requestModel.netRequestType == ZSNetRequestTypeDownload) {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    }
    
    if (error || request == nil) {
        ZSNETLog(@"NSMutableURLRequests生成失败：urlString:%@ ",requestUrl);
        return nil;
    }
    
    return request;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = 30.0f;
    }
    return _httpRequestSerializer;
}
@end
