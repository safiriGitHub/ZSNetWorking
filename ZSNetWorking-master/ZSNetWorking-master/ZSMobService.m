//
//  ZSMobService.m
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/15.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSMobService.h"

@implementation ZSMobService

- (NSString *)apiBaseUrl {
    return @"http://apicloud.mob.com/";
}


- (void)parseResult:(id)jsonResult requestModel:(ZSRequestModel *)requestModel parseCompletionHandler:(ZSNetWorkingResponseCompletion)completionHandler {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSString *responseCode = @"0";
    NSString *responseMessage = @"";
    
    if (jsonResult && [jsonResult isKindOfClass:[NSDictionary class]]) {
        NSDictionary *resultDic = (NSDictionary *)jsonResult;
        responseCode = resultDic[@"retCode"];
        resultArray = resultDic[@"result"];
        responseMessage = resultDic[@"msg"];
    }
    completionHandler(resultArray, responseCode, responseMessage);
}

@end
