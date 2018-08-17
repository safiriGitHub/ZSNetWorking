//
//  ZSNetRequest.h
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/14.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSNetConfig.h"

@class ZSRequestModel;

@interface ZSNetRequest : NSObject

/**
 取消持有的网络请求
 */
- (void)cancelNetRequest;

+ (void)netRequestModel:(ZSRequestModel *)model
                   cancelControl:(id _Nullable)control;

+ (NSURLSessionDownloadTask *)netDownloadModel:(ZSRequestModel *)model;

@end
