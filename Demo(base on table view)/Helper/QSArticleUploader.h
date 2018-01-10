//
//  QSArticleUploader.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/10.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

@import QiniuUpload;

@interface QSArticleUploader : NSObject <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (assign, atomic) NSInteger maxConcurrentNumber;
@property (assign, atomic, readonly) Boolean isRunning;
@property (retain, atomic) NSArray * _Nonnull files;


+ (id _Nullable)sharedUploader;

/**
 *  start upload files to qiniu cloud storage.
 *  @param AccessToken Qiniu AccessToken from your sever
 *  @return Boolean if files were nil, it will return NO.
 */
- (Boolean)startUpload:(NSString * _Nonnull)theAccessToken
uploadOneFileSucceededHandler: (nullable void (^)(NSInteger index, NSDictionary * _Nonnull info)) successHandler
uploadOneFileFailedHandler: (nullable void (^)(NSInteger index, NSError * _Nullable error)) failHandler
uploadOneFileProgressHandler: (nullable void (^)(NSInteger index, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend)) progressHandler
uploadAllFilesComplete: (nullable void (^)()) completHandler;

/**
 *  cancel uploading task at once.
 */
- (BOOL)cancelAllUploadTask;

-(void)cancelUploadAtIndex:(NSUInteger)index;

-(void)insertUploadAtIndex:(NSUInteger)index;

@end
