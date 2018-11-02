//
//  ZSRequestModel.m
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/13.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSRequestModel.h"

@interface ZSRequestModel ()
@property (nonatomic, strong, readwrite) id <ZSServiceProtocol>service;
@end

@implementation ZSRequestModel

//MARK: URL
- (NSString *)baseURL {
    return self.service.apiBaseUrl;
}

- (NSString *)requestFullURL {
    if (!_requestFullURL) {
        _requestFullURL = [self URLStringWithBaseUrl:self.baseURL methodUrl:self.methodURL];
    }
    return _requestFullURL;
}

- (NSString *) URLStringWithBaseUrl:(NSString *)baseUrl methodUrl:(NSString *)path{
    NSURL *fullURL = [NSURL URLWithString:baseUrl];
    if (path) {
        fullURL = [NSURL URLWithString:path relativeToURL:fullURL];
    }
    if (fullURL == nil) {
        ZSNETLog(@"ZSRequestGenerator -- URL拼接错误:\n apiBaseUrl:%@ \n urlPath:%@",baseUrl,path);
        return nil;
    }
    return [fullURL absoluteString];
}

//MARK: service

- (id<ZSServiceProtocol>)service {
    if (!_service) {
        BOOL conform = [self.serviceClass conformsToProtocol:@protocol(ZSServiceProtocol)];
        NSAssert(conform, @"ZSRequestModel 中的 serviceClass 属性必须遵守 ZSBaseServiceProtocol 协议");
        _service = [[self.serviceClass alloc] init];
    }
    return _service;
}

- (NSDictionary<NSNumber *,NSString *> *)connectServiceErrorHintConfigs {
    if (_connectServiceErrorHintConfigs == nil) {
        _connectServiceErrorHintConfigs = @{@(ErrorCode1001):@"服务器连接超时",
                                            @(ErrorCode1004):@"服务器连接失败,请关注公告",
                                            @(ErrorCode1005):@"服务器开小差了,请重试",
                                            @(ErrorCode1009):@"网络无法链接，请检查您的网络",
                                            @(ErrorCode1011):@"服务器开小差了,请关注公告",
                                            @(ErrorCodeOther):@"服务器连接失败,请重试"
                                            };
    }
    return _connectServiceErrorHintConfigs;
}

@end
