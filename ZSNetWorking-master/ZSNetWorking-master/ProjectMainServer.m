//
//  ProjectMainServer.m
//  Fangxiaov
//
//  Created by safiri on 2017/4/3.
//  Copyright © 2017年 com.f. All rights reserved.
//

#import "ProjectMainServer.h"

//@Test 一定要注意用正式地址
static NSString *const MainServerRootUrl = @"http://125.73.45.21:6570/api/api/app/";//澎湃正式地址

@implementation ProjectMainServer

- (NSString *)apiBaseUrl {
    //@test
    //return MainServerRootUrl;
    return @"http://222.218.31.20:8765/api/api/app/";
}

- (ZSRequestEnDecryptType)enDecryptType {
    return EnDecryptNone;
}

#pragma mark 生成Model
+ (ZSRequestModel *)modelWithConfig:(NSString *)serviceName :(NSDictionary *)reqData {
    ZSRequestModel *model = [[ZSRequestModel alloc] init];
    model.serviceClass = [ProjectMainServer class];
    model.methodURL = serviceName;
    model.netRequestType = ZSNetRequestTypePost;
    
//    NSString *siteCode = @"11";
//    NSString *version = [[UIApplication sharedApplication] appBuildVersion];
//    NSString *devicetype = @"ios";
//    NSString *signature = [[NSString stringWithFormat:@"%@%@%@%@%@",paramJson,serviceName,siteCode,version,devicetype] md5String];
//    NSString *reqDataString = [ZSSecurityUtil encryptAES128ForString:paramJson key:model.service.symmetricEnDecryptionKey giv:model.service.symmetricEnDecryptionIv];
//
//    [reqParams setValue:reqDataString forKey:@"reqData"];
//    [reqParams setValue:siteCode forKey:@"siteCode"];
//    [reqParams setValue:serviceName forKey:@"serviceName"];
//    [reqParams setValue:signature forKey:@"signature"];
//    [reqParams setValue:@"UTF-8" forKey:@"charset"];
//    [reqParams setValue:version forKey:@"version"];
//    [reqParams setValue:devicetype forKey:@"deviceType"];
    model.requestParams = reqData;
    return model;
}

+ (ZSRequestModel *)modelWZPayWithConfig:(NSString *)serviceName :(NSDictionary *)reqData {
    ZSRequestModel *model = [self modelWithConfig:serviceName :reqData];
    model.methodURL = @"pay/wfpay.do";
    return model;
}

+ (ZSRequestModel *)modelCheckCarPayWithConfig:(NSString *)serviceName :(NSDictionary *)reqData {
    ZSRequestModel *model = [self modelWithConfig:serviceName :reqData];
    model.methodURL = @"alipay/createAppointmentOrder.do";
    return model;
}

#pragma mark 统一解析网络请求结果
- (void)parseResult:(id)jsonResult requestModel:(ZSRequestModel *)requestModel parseCompletionHandler:(ZSNetWorkingResponseCompletion)completionHandler {
    
    NSDictionary *jsonDataDictionary;
    NSMutableArray *jsonArray = [NSMutableArray array];
    NSString *responseCode = @"0";
    NSString *responseMessage = @"";
    
    if ([jsonResult isKindOfClass:[NSArray class]]) {
        jsonDataDictionary = [jsonResult firstObject];
    }else if ([jsonResult isKindOfClass:[NSDictionary class]]){
        jsonDataDictionary = (NSDictionary *)jsonResult;
    }
   
    //DELog(@"jsonDataDictionary = %@",jsonDataDictionary);
    
    if (jsonDataDictionary) {
        responseCode = [jsonDataDictionary objectForKey:@"code"];
        responseMessage = [jsonDataDictionary objectForKey:@"message"];
        //NSString *accessToken = [jsonDataDictionary objectForKey:@"accessToken"];
        NSString *userInfo = [jsonDataDictionary objectForKey:@"userInfo"];
        
       
        __autoreleasing NSError *jsonParseError = nil;
        id info = [NSJSONSerialization JSONObjectWithData:[userInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonParseError];
        if (jsonParseError) {
            [jsonArray addObject:userInfo];
        }else {
            if ([info isKindOfClass:[NSArray class]]) {
                [jsonArray addObjectsFromArray:info];
            }else if ([info isKindOfClass:[NSDictionary class]]){
                [jsonArray addObject:info];
            }else if(info){
                [jsonArray addObject:info];
            }
        }
        
    }
    if (requestModel.connectServiceErrorHintString) responseMessage = requestModel.connectServiceErrorHintString;
    if (responseMessage == nil) responseMessage = @"";
    
    if ([responseCode isEqualToString:@"ok"] || [responseCode isEqualToString:@"success"]) {
        responseCode = @"200";
    }else {
        responseCode = @"300";
    }
    
    completionHandler(jsonArray,responseCode,responseMessage);
}

@end
