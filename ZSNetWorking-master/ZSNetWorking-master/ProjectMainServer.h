//
//  ProjectMainServer.h
//  Fangxiaov
//
//  Created by safiri on 2017/4/3.
//  Copyright © 2017年 com.f. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSNetWorking.h"


@interface ProjectMainServer : NSObject<ZSServiceProtocol>

+ (ZSRequestModel *)modelWithConfig:(NSString *)serviceName :(NSDictionary *)reqData;
+ (ZSRequestModel *)modelWZPayWithConfig:(NSString *)serviceName :(NSDictionary *)reqData;
+ (ZSRequestModel *)modelCheckCarPayWithConfig:(NSString *)serviceName :(NSDictionary *)reqData;

@end
