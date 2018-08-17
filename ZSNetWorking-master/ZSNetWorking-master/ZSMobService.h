//
//  ZSMobService.h
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/15.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSNetWorking.h"

@interface ZSMobService : NSObject <ZSServiceProtocol>

@property (nonatomic, strong, readonly) NSString *apiBaseUrl;

@end
