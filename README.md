# ZSNetWorking
AFNetworking(TODO:YYCache)简单的二次封装，封装常见的GET、POST、文件上传/下载、网络状态监测。


# Introduction 介绍
---

### 1.主要类介绍：

- ZSNetWorking: 

	发起网络请求类，是对ZSNetRequest的简要封装，提供常用的方便的 `GET、POST、文件上传/下载` 类方法。

	适用于常用的一般请求。

- ZSNetRequest: 
	
	发起网络请求类，根据`ZSRequestModel`类实例中对请求的配置进行网络请求。

	类实例代表单个网络请求，并存储请求任务的hash值，可根据此取消网络请求任务。

	并利用runtime可将请求绑定到发起请求的对象实例`(id)cancelControl`,当对象实例`(id)cancelControl` dealloc时，自动取消绑定的网络请求，防止资源浪费及未知bug。

- ZSRequestModel:

	网络请求配置类，自定义配置所有网络请求任务。

	根据实际开发，仍需扩展及优化。

- ZSServiceProtocol:
	
	服务器配置协议，统一规定服务器的根URL、加密方式、加密秘钥、解析方式等配置，可能要扩展并优化。

	使用场景：不同项目的后台服务(或统一项目需要有不同的后台服务)中的URL、加密方式、秘钥、业务数据解析方法不同，可遵守协议后根据实际项目自定义服务器配置类，满足自定义需求。

	例子: 

	```

	@interface ZSMobService : NSObject <ZSServiceProtocol> 
		...
	@end

	@implementation ZSMobService

	- (NSString *)apiBaseUrl {
    	return ...;
	}
	- (void)parseResult:(id)jsonResult requestModel:(ZSRequestModel *)requestModel parseCompletionHandler:(ZSNetWorkingResponseCompletion)completionHandler {
	    NSMutableArray *resultArray = [NSMutableArray array];
	    NSString *responseCode = @"0";
	    NSString *responseMessage = @"";
	    
	    解析业务数据...

	    completionHandler(resultArray, responseCode, responseMessage);
	}

	@end
	
	```

- ZSNetEngine:

	网络请求引擎，主要封装 `AFNetworking` 的请求方法。

- ZSNetConnectMonitorUtil:

	监听网络连接状态工具
	当网络关闭时代理回调返回网络关闭提示。
	TODO:WiFi和流量切换监听


# Usage 使用方法

##### GET

``` 
	//ZSMobService 为自定义服务类
	ZSRequestModel *model = [[ZSRequestModel alloc] init];
    model.serviceClass = [ZSMobService class];
    model.methodURL = @"car/brand/query";
    model.paramDictionary = @{@"key":@"209bdde75fab1"};
    
    [ZSNetWorking GETRequestModel:model cancelControl:self completion:^(NSArray * _Nonnull resultArray, NSString * _Nonnull responseCode, NSString * _Nonnull responseMessage) {
        NSLog(@"responseMessage - %@",responseMessage);
        NSLog(@"resultArray - %@",resultArray);
    }];

```

##### POST

```
	//ZSCheFuService 为自定义服务类,提供根URL、秘钥、解析方法等自定义配置
	ZSRequestModel *model = [[ZSRequestModel alloc] init];
    model.serviceClass = [ZSCheFuService class];
    model.methodURL = @"init.do";
    NSString *key = model.service.symmetricEnDecryptionKey;
    NSString *gIv = model.service.symmetricEnDecryptionIv;
    NSLog(@"key - %@",key);
    NSLog(@"gIv - %@",gIv);
    
    //...
    //通过一系列配置、加密、签名，得到下面的请求参数
    NSString *reqDataString = @"...";
    model.paramDictionary = @{@"reqData":reqDataString,
                              @"serviceName":@"serviceName",
                              @"signature":@"f75cf3a2d6a55ff0429dce283e133039"
                              };
    
    [ZSNetWorking POSTRequestModel:model cancelControl:self completion:^(NSArray * _Nonnull resultArray, NSString * _Nonnull responseCode, NSString * _Nonnull responseMessage) {
        NSLog(@"responseMessage - %@",responseMessage);
        NSLog(@"resultArray - %@",resultArray);
    }];
```

##### Download

```
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

```

##### Upload

**更多例子请查看Demo工程**


# 更新记录

- 0.0.1：常用的GET、POST、文件上传/下载、网络状态监测功能；	
		 取消网络请求任务功能；
		 自定义服务器协议；


