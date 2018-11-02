//
//  ZSCheFuService.m
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/15.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSCheFuService.h"

@implementation ZSCheFuService

- (NSString *)apiBaseUrl {
    return @"http://chefu.pengpaicar.net:8082/cf-apptest/";
}

- (ZSRequestEnDecryptType)enDecryptType {
    return EnDecryptAES128;
}

- (NSString *)symmetricEnDecryptionKey {
    return @"秘钥";//ex:symmetricEnDecry
}

- (NSString *)symmetricEnDecryptionIv {
    return @"偏移量";//ex:1098839223140366
}


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
    
    //ZSNETLog(@"jsonDataDictionary = %@",jsonDataDictionary);
    
    if (jsonDataDictionary) {
        responseCode = [jsonDataDictionary objectForKey:@"respCode"];
        //NSString *respDataCiphertext = [jsonDataDictionary objectForKey:@"respData"];
        //NSString *signature = [jsonDataDictionary objectForKey:@"signature"];
        responseMessage = [jsonDataDictionary objectForKey:@"respMsg"];
        
        //经过解密和验签操作后，得到数据
        NSString *respDataJsonString = @"{\"appsbh\":\"appsbh...\"}";
        ZSNETLog(@"解密后的respMsg= %@",respDataJsonString);
        __autoreleasing NSError *jsonParseError = nil;
        id info = [NSJSONSerialization JSONObjectWithData:[respDataJsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonParseError];
        if (jsonParseError) {
            [jsonArray addObject:respDataJsonString];
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
    
    responseMessage = requestModel.connectServiceErrorHintString;
    if (responseMessage == nil) responseMessage = @"";
    
    //后台错误code 更改下提示
    if (responseCode.integerValue == 102) {
        //serviceName未进行工厂设置！class org.springframework.beans.factory.NoSuchBeanDefinitionException
        responseMessage = @"请求出错，请重试或请联系客服解决";//正式环境应该不会出现
    }
    
    completionHandler(jsonArray,responseCode,responseMessage);
}

@end
