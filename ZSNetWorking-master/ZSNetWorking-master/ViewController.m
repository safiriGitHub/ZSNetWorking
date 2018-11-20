//
//  ViewController.m
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/13.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ViewController.h"
#import "ZSMobService.h"
#import "ZSCheFuService.h"
#import "ProjectMainServer.h"
#import "ShowImageVC.h"
#import "AFNetworking.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)click:(id)sender {
    
    ZSRequestModel *model = [[ZSRequestModel alloc] init];
    model.serviceClass = [ZSMobService class];
    model.methodURL = @"car/brand/query";
    model.requestParams = @{@"key":@"209bdde75fab1"};

    [ZSNetWorking GETRequestModel:model cancelControl:self completion:^(NSArray * _Nonnull resultArray, NSString * _Nonnull responseCode, NSString * _Nonnull responseMessage) {
        NSLog(@"responseMessage - %@",responseMessage);
        NSLog(@"resultArray - %@",resultArray);
    }];
}

- (IBAction)jsonPost:(id)sender {
    
    ZSRequestModel *model = [[ZSRequestModel alloc] init];
    model.serviceClass = [ProjectMainServer class];
    model.methodURL = @"userinfo/login";
    model.requestParams = @{@"":@""};
    model.requestSerializerType = AFJSONRequestSerializerType;
    
    [ZSNetWorking POSTRequestModel:model cancelControl:self completion:^(NSArray *resultArray, NSString *responseCode, NSString *responseMessage) {
        if (responseCode.integerValue == 200) {
            
        }else {
        }
    }];
}

- (IBAction)postRequestClick:(id)sender {
    ZSRequestModel *model = [[ZSRequestModel alloc] init];
    model.serviceClass = [ZSCheFuService class];
    model.methodURL = @"init.do";
    NSString *key = model.service.symmetricEnDecryptionKey;
    NSString *gIv = model.service.symmetricEnDecryptionIv;
    NSLog(@"key - %@",key);
    NSLog(@"gIv - %@",gIv);
    
    //...
    //通过一系列配置、加密、签名，得到下面的请求参数
    NSString *reqDataString = @"FdFirR5KVtVMufFUbocoVB5IFb3MT03OV6KiIPzpwLQ0tTpQgqqep1k4pwKRb702fSQ8xUcbDDvddwdgZ9QMAKi702jvzZMYBuieW5M41u64uxxElMGIj2/SjBtEgKohzzaCoaT8I0lwPplIjc7b32aNXd6fFFppQ7hEuDJf/FHyYSQDQUT1TFo5c6hxHGrbwRn+vHKjgIEY6wWgBfhvN8BrHctW1q/L2ko39ZXkHWnnCE5g304eroU6jJtyaizIVJktoshjxC37aKZUilU+qtwXYQ706st4wOksnG6Y0ewH2BFW7t+WZpeL6ZK+IAOtpx8dy0Q+9v88rVNv+HPYTe3Rl1kJqzdPf//qnNjmiAAObeTvOjwUKyCXUozHLriD";
    model.requestParams = @{@"reqData":reqDataString,
                              @"siteCode":@"11",
                              @"serviceName":@"com.cf.app.sign",
                              @"signature":@"f75cf3a2d6a55ff0429dce283e133039",
                              @"charset":@"UTF-8",
                              @"version":@"8.2",
                              @"deviceType":@"ios"
                              };
    
    [ZSNetWorking POSTRequestModel:model cancelControl:self completion:^(NSArray * _Nonnull resultArray, NSString * _Nonnull responseCode, NSString * _Nonnull responseMessage) {
        NSLog(@"responseMessage - %@",responseMessage);
        NSLog(@"resultArray - %@",resultArray);
    }];
    
}

- (IBAction)downloadRequestClick:(id)sender {
    ZSRequestModel *model = [[ZSRequestModel alloc] init];
    model.requestFullURL = @"http://cn.bing.com/az/hprichbg/rb/WindmillLighthouse_ZH-CN12870536851_1920x1080.jpg";
    [ZSNetWorking DownloadRequestModel:model progress:^(NSProgress *taskProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressView setProgress:taskProgress.fractionCompleted animated:YES];
        });
    } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error, NSData *resumeData) {
        if (filePath && !error) {
            NSLog(@"下载成功: %@",filePath.path);
            UIImage *image = [UIImage imageWithContentsOfFile:filePath.path];
            ShowImageVC *showVC = [[ShowImageVC alloc] init];
            showVC.image = image;
            [self.navigationController pushViewController:showVC animated:YES];
        }
        else if (resumeData) {
            //下载失败，有resumeData
        }
    }];
    
}

- (IBAction)uploadRequestClick:(id)sender {
    //暂无例子
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
