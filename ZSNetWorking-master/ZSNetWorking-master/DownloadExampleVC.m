//
//  DownloadExampleVC.m
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/16.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "DownloadExampleVC.h"
#import "ZSNetWorking.h"

@interface DownloadExampleVC ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginSuspendButton;

@property (nonatomic, strong) NSString *downloadUrlString;


@property (nonatomic, strong) NSURLSessionDownloadTask *task;

@property (nonatomic, assign) BOOL downloading;
@end

@implementation DownloadExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"暂停及断点下载";
}
- (void)firstStartDownload {
    self.downloadUrlString = @"http://dldir1.qq.com/qqfile/QQforMac/QQ_V6.5.0.dmg";
    NSString *filePath = [self getResumeDownloadPathWithURL:self.downloadUrlString];
    ZSRequestModel *model = [[ZSRequestModel alloc] init];
    model.requestFullURL = self.downloadUrlString;
    BOOL exit = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (exit) {
        NSData *resumeData = [NSData dataWithContentsOfFile:filePath];
        model.downloadResumeData = resumeData;
    }
    
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"QQ_V6.5.0.dmg"];
    model.downloadDestinationFileURL = [NSURL fileURLWithPath:path];
    self.downloading = YES;
    __weak typeof(self) weakSelf = self;
    self.task = [ZSNetWorking DownloadRequestModel:model progress:^(NSProgress *taskProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.progressView setProgress:taskProgress.fractionCompleted animated:YES];
            weakSelf.progressLabel.text = [[NSString stringWithFormat:@"当前下载进度%.2f",taskProgress.fractionCompleted*100] stringByAppendingString:@"%"];
        });
    } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error, NSData *resumeData) {
        if (filePath && !error) {
            NSLog(@"下载成功: %@",filePath.path);
        }
        
        else if (resumeData) {
            NSLog(@"下载失败或暂停，有resumeData");
            //将resumeData写入本地
            [weakSelf storageResumeData:resumeData url:model.requestFullURL];
        }
        weakSelf.downloading = NO;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)storageResumeData:(NSData *)resumeData url:(NSString *)urlString {

    BOOL success = [resumeData writeToFile:[self getResumeDownloadPathWithURL:urlString] atomically:YES];
    if (success) {
        NSLog(@"resume Data write success");
    }else {
        NSLog(@"resume Data write failed");
    }
    
}

- (NSString *)getResumeDownloadPathWithURL:(NSString *)urlString {
    
    NSString *downloadFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [downloadFolder stringByAppendingPathComponent:[self md5Url:urlString]];
    NSLog(@"path = %@",path);
    return path;
}
- (NSString *)md5Url:(NSString *)url {
    //这里以url的md5值作为文件名存储，假数据 qq_V6.5.0
    return @"QQ_V650";
}
- (IBAction)beginSuspendButtonClick:(id)sender {
   
    if (self.downloading) {
        if (self.task) {
            [self.task suspend];
        }
    }else {
        //begin
        [self firstStartDownload];
    }
}

- (void)setDownloading:(BOOL)downloading {
    _downloading = downloading;
    NSString *imageName = downloading ? @"downloadSuspend":@"downloadBegin";
    [self.beginSuspendButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
