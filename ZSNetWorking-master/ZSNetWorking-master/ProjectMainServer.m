//
//  ProjectMainServer.m
//  Fangxiaov
//
//  Created by safiri on 2017/4/3.
//  Copyright © 2017年 com.f. All rights reserved.
//

#import "ProjectMainServer.h"

//@Test 一定要注意用正式地址
static NSString *const MainServerRootUrl = @"http://125.73.45.21:6570";//澎湃正式地址

@implementation ProjectMainServer

- (NSString *)apiBaseUrl {
    //@test
    //return MainServerRootUrl;
    return @"http://222.218.31.20:8765";
}

- (ZSRequestEnDecryptType)enDecryptType {
    return EnDecryptNone;
}

#pragma mark 生成Model
+ (ZSRequestModel *)modelWithConfig:(NSString *)serviceName :(NSDictionary *)reqData {
    ZSRequestModel *model = [[ZSRequestModel alloc] init];
    model.serviceClass = [ProjectMainServer class];
    model.methodURL = serviceName;
    model.requestSerializerType = AFJSONRequestSerializerType;
    model.requestParams = reqData;
    return model;
}
+ (ZSRequestModel *)modelUploadWithConfig:(NSString *)serviceName :(NSArray <ZSUploadFileModel *>*)uploadFileModelArray {
    ZSRequestModel *model = [[ZSRequestModel alloc] init];
    model.serviceClass = [ProjectMainServer class];
    model.methodURL = serviceName;
    model.requestSerializerType = AFJSONRequestSerializerType;
    model.uploadFileModelArray = uploadFileModelArray;
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
    
    // 后台不同接口返回的JSON基本结构不一致。。。
    
    if (jsonDataDictionary) {
        NSString *code = [jsonDataDictionary objectForKey:@"code"];
        NSString *res = [jsonDataDictionary objectForKey:@"res"];
        NSString *message = [jsonDataDictionary objectForKey:@"message"];
        NSString *msg = [jsonDataDictionary objectForKey:@"msg"];
        if (code) {
            responseCode = ([code isEqualToString:@"ok"] || [code isEqualToString:@"success"]) ? @"200" : @"0";
        }
        if (res) {
            responseCode = [res isEqualToString:@"success"] ? @"200" : @"0";
        }
        if (message) responseMessage = message;
        if (msg) responseMessage = msg;
        
        [jsonArray addObject:jsonDataDictionary];
    }
    
    completionHandler(jsonArray,responseCode,responseMessage);
}


@end
