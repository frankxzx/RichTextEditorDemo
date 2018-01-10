//
//  QSArticleUploader.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/10.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

@import QiniuUpload;
#import "OrderedDictionary.h"

typedef void (^UploadOneFileSucceededHandler)(NSString *fileIndex, NSDictionary * _Nonnull info);
typedef void (^UploadOneFileFailedHandler)(NSString *fileIndex, NSError * _Nullable error);
typedef void (^UploadOneFileProgressHandler)(NSString *fileIndex, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);
typedef void (^UploadAllFilesCompleteHandler)(void);

@interface QSArticleUploader : NSObject <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (assign, atomic) NSInteger maxConcurrentNumber;
@property (assign, atomic, readonly) Boolean isRunning;
@property (strong, atomic, readonly) MutableOrderedDictionary <NSString *, QiniuFile *>* _Nonnull files; // 上传文件的 file对象 和 hash 索引
@property(nonatomic, copy) UploadOneFileSucceededHandler oneSucceededHandler;
@property(nonatomic, copy) UploadOneFileFailedHandler oneFailedHandler;
@property(nonatomic, copy) UploadOneFileProgressHandler oneProgressHandler;
@property(nonatomic, copy) UploadAllFilesCompleteHandler allCompleteHandler;
@property(nonatomic, copy) NSString *accessToken;

+ (QSArticleUploader *)sharedUploader;

/**
 *  cancel uploading task at once.
 */
-(BOOL)cancelAllUploadTask;

-(void)cancelUploadWithFileIndex:(NSString *)fileIndex;

-(void)insertUploadWithFile:(QiniuFile *)file withFileIndex:(NSString *)fileIndex;

- (Boolean)startUpload;

@end
