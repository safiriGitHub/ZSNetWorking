//
//  ZSUploadFileModel.h
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/14.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
/**
 上传类型
 
 - UploadFile: `Content-Disposition: file; filename=#{filename}; name=#{name}"` and `Content-Type: #{mimeType}`
 - UploadFormData: `Content-Disposition: form-data; name=#{name}"`
 - UploadHeadersBody: Appends HTTP headers, followed by the encoded data and the multipart form boundary.
 */
typedef NS_ENUM(NSUInteger, UploadType) {
    UploadFile,
    UploadFormData,
    UploadHeadersBody
};

@interface ZSUploadFileModel : NSObject

/**
 上传的数据类型
 */
@property (nonatomic ,assign) UploadType uploadType;

//MARK: - UploadFile
/**
 上传的文件data
 */
@property (nonatomic, strong) NSData *fileData;

/**
 上传的文件地址
 fileData 与 fileURL 若都设置只会上传一个，优先上传fileData
 */
@property (nonatomic, strong) NSURL *fileURL;

/**
 The file name to be used in the `Content-Disposition` header. This parameter must not be `nil`.
 例子：img.png
 */
@property (nonatomic, strong) NSString *fileName;

/**
 The declared MIME type of the file data. This parameter must not be `nil`.
 例子：image/png  image/jpeg
 */
@property (nonatomic, strong) NSString *mimeType;

//MARK: - UploadFormData

/**
 要编码并附加到表单数据的数据。
 The data to be encoded and appended to the form data.
 */
@property (nonatomic, strong) NSData *formData;

//MARK: - Public

/**
 The name to be associated with the specified data. This parameter must not be `nil`.
 例子：img
 */
@property (nonatomic, strong) NSString *name;

// MARK: - UploadHeadersBody

/**
  The HTTP headers to be appended to the form data.
 */
@property (nonatomic, strong, nullable) NSDictionary <NSString *, NSString *> *headers;

/**
 The data to be encoded and appended to the form data. This parameter must not be `nil`.
 */
@property (nonatomic, strong) NSData *bodyData;

@end
NS_ASSUME_NONNULL_END
