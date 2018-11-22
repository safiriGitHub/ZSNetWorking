//
//  ZSNetWorking.m
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/14.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSNetWorking.h"

@implementation ZSNetWorking

+ (void)POSTRequestModel:(ZSRequestModel *)requestModel cancelControl:(NSObject *)control completion:(ZSNetWorkingResponseCompletion)responseCompletion {
    requestModel.netRequestType = ZSNetRequestTypePost;
    requestModel.responseCompletion = responseCompletion;
    [ZSNetRequest netRequestModel:requestModel cancelControl:control];
}

+ (void)GETRequestModel:(ZSRequestModel *)requestModel cancelControl:(NSObject *)control completion:(ZSNetWorkingResponseCompletion)responseCompletion {
    requestModel.netRequestType = ZSNetRequestTypeGet;
    requestModel.responseCompletion = responseCompletion;
    [ZSNetRequest netRequestModel:requestModel cancelControl:control];
}

+ (void)UploadRequestModel:(ZSRequestModel *)requestModel progress:(ZSNetProgressBlock)progress completion:(ZSNetWorkingResponseCompletion)responseCompletion {
    requestModel.netRequestType = ZSNetRequestTypeUpload;
    requestModel.responseCompletion = responseCompletion;
    requestModel.uploadProgressBlock = progress;
    [ZSNetRequest netRequestModel:requestModel cancelControl:nil];
}

+ (NSURLSessionDownloadTask *)DownloadRequestModel:(ZSRequestModel *)requestModel progress:(ZSNetProgressBlock)progress completion:(ZSDownloadCompletionHandler)downloadCompletion {
    requestModel.netRequestType = ZSNetRequestTypeDownload;
    requestModel.downloadProgressBlock = progress;
    requestModel.downloadCompletionHandler = downloadCompletion;
    return [ZSNetRequest netDownloadModel:requestModel];
}
@end
