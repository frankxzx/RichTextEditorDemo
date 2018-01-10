//
//  QSArticleUploader.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/10.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

@import QiniuUpload;
#import "OrderedDictionary.h"

@interface QSArticleUploader : NSObject <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (assign, atomic) NSInteger maxConcurrentNumber;
@property (assign, atomic, readonly) Boolean isRunning;
@property (strong, atomic, readonly) MutableOrderedDictionary <NSString *, QiniuFile *>* _Nonnull files; // 上传文件的 file对象 和 hash 索引


+ (id _Nullable)sharedUploader;

/**
 *  start upload files to qiniu cloud storage.
 *  @param AccessToken Qiniu AccessToken from your sever
 *  @return Boolean if files were nil, it will return NO.
 */
- (Boolean)startUpload:(NSString * _Nonnull)theAccessToken
uploadOneFileSucceededHandler: (nullable void (^)(NSString *fileIndex, NSDictionary * _Nonnull info)) successHandler
uploadOneFileFailedHandler: (nullable void (^)(NSString *fileIndex, NSError * _Nullable error)) failHandler
uploadOneFileProgressHandler: (nullable void (^)(NSString *fileIndex, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend)) progressHandler
uploadAllFilesComplete: (nullable void (^)()) completHandler;

/**
 *  cancel uploading task at once.
 */
-(BOOL)cancelAllUploadTask;

-(void)cancelUploadWithFileIndex:(NSString *)fileIndex;

-(void)insertUploadWithFile:(QiniuFile *)file withFileIndex:(NSString *)fileIndex;

@end
