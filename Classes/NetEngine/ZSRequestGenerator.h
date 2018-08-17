//
//  ZSRequestGenerator.h
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/13.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZSRequestModel;

/**
 URLRequest生产者
 */
@interface ZSRequestGenerator : NSObject

+ (instancetype)sharedGenerator;

- (NSURLRequest *)generateURLRequest:(ZSRequestModel *)requestModel;

@end
