//
//  ZSNetRequest.m
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/14.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSNetRequest.h"
#import "ZSNetEngine.h"
#import "ZSNetCancelStorage.h"

@interface ZSNetRequest ()

@property (nonatomic, strong) NSNumber *requestID;

@end

@implementation ZSNetRequest

- (void)cancelNetRequest {
    [[ZSNetEngine sharedEngine] netCancelRequestWithRequestID:self.requestID];
}

+ (void)netRequestModel:(ZSRequestModel *)model
          cancelControl:(id)control {
    ZSNetRequest *netRequest = [[ZSNetRequest alloc] init];
    if (control) {
        NSNumber *requestID = [[ZSNetEngine sharedEngine] netRequestWithModel:model];
        netRequest.requestID = requestID;
        [((NSObject *)control).netCancelStorage setNetRequest:netRequest requestID:requestID];
    }else {
        [[ZSNetEngine sharedEngine] netRequestWithModel:model];
    }
}

+ (NSURLSessionDownloadTask *)netDownloadModel:(ZSRequestModel *)model {
    NSNumber *requestID = [[ZSNetEngine sharedEngine] netRequestWithModel:model];
    NSURLSessionDownloadTask *task = [[ZSNetEngine sharedEngine] getDownloadTaskWithRequestID:requestID];
    return task;
}
@end
