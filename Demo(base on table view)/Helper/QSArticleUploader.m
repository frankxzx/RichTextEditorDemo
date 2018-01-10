//
//  QSArticleUploader.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/10.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import "QSArticleUploader.h"

#define kQiniuUploadURL @"https://upload.qbox.me"
#define kQiniuTaskKey @"qiniuTaskKey"

@interface QSArticleUploader ()

@property(atomic, strong, readwrite) MutableOrderedDictionary <NSString *,QiniuFile *>* _Nonnull files;

@end

@implementation QSArticleUploader {
    NSMutableArray <NSString *>*fileQueue;
    MutableOrderedDictionary <NSString *, NSURLSessionTask *> *taskRefs;
    NSMutableDictionary *responsesData;
    __weak QSArticleUploader *weakSelf;
    NSURLSession *defaultSession;
}

- (id)init
{
    if (self = [super init]) {
        _files = [[MutableOrderedDictionary alloc] init];
        _isRunning = NO;
        _maxConcurrentNumber = 1;
        
        fileQueue = [[NSMutableArray alloc] init];
        taskRefs = [[MutableOrderedDictionary alloc] init];
        responsesData = [[NSMutableDictionary alloc] init];
        
        weakSelf = self;
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 15.0f;
        
        defaultSession = [NSURLSession sessionWithConfiguration:config delegate: self delegateQueue:nil];
        config = nil;
    }

    return self;
}

+(QSArticleUploader *)sharedUploader
{
    static QSArticleUploader *uploader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(uploader == nil)
            uploader = [[QSArticleUploader alloc] init];
    });
    return uploader;
}

- (Boolean)startUpload
{
    if (self.files.count == 0) {
        return false;
    }
    _isRunning = YES;
    if (fileQueue.count == 0) {
        [self createFileQueue];
        [self uploadQueue];
    } else {
        [self uploadFile:fileQueue.firstObject];
    }
    return true;
}

//初始化队列
- (void)createFileQueue {
    [fileQueue removeAllObjects];
    [self.files enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull fileIndex, QiniuFile * _Nonnull obj, BOOL * _Nonnull stop) {
        [fileQueue addObject:fileIndex];
    }];
}

//移出队列
- (NSString *)deFileQueue {
    @synchronized (fileQueue) {
        if (fileQueue.count == 0) {
            return nil;
        }
        NSString *fileIndex = [fileQueue firstObject];
        [fileQueue removeObjectAtIndex:0];
        return fileIndex;
    }
}

//开始从队列中上传
- (void)uploadQueue {
    
    NSInteger poolSize = fileQueue.count < self.maxConcurrentNumber ? fileQueue.count : self.maxConcurrentNumber;
    
    for (NSUInteger i = 0; i < poolSize; i++) {
        NSString *fileIndex = [weakSelf deFileQueue];
        [self uploadFile:fileIndex];
    }
}

- (void)uploadFile:(NSString *)fileIndex
{
    
    QiniuFile *file = [weakSelf.files objectForKey:fileIndex];
    
    QiniuInputStream *inputStream = [[QiniuInputStream alloc] init];
    if (file.key) {
        [inputStream addPartWithName:@"key" string:file.key];
    }
    
    [inputStream addPartWithName:@"token" string: self.accessToken ?: [[QiniuToken sharedQiniuToken] uploadToken]];
    
    if (file.path) {
        [inputStream addPartWithName:@"file" path: file.path];
    }
    
    if (file.rawData){
        [inputStream addPartWithName:@"file" data: file.rawData];
    }
    
#if TARGET_OS_IOS
    if (file.asset) {
        [inputStream addPartWithName:@"file" asset:file.asset];
    }
#endif
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kQiniuUploadURL]];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", [inputStream boundary]] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[inputStream length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBodyStream:inputStream];
    [request setHTTPMethod:@"POST"];
    NSURLSessionTask * uploadTask = [defaultSession dataTaskWithRequest:request];
    
    NSString *taskDescription = [NSString stringWithFormat:@"%@", fileIndex];
    
    @synchronized (taskRefs) {
        [taskRefs setObject:uploadTask forKey:taskDescription];
    }
    
    [uploadTask setTaskDescription:taskDescription];
    [uploadTask resume];
}

- (void)uploadComplete
{
    NSString *fileIndex = [weakSelf deFileQueue];
    if (fileQueue.count > 0) {
        [weakSelf uploadFile:fileIndex];
    } else {
        @synchronized (taskRefs) {
            if (taskRefs.count == 0 && self.allCompleteHandler) {
                
                [self.files removeAllObjects];
                [fileQueue removeAllObjects];
                [responsesData removeAllObjects];
                _isRunning = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.allCompleteHandler();
                    
                    self.oneSucceededHandler = nil;
                    self.oneFailedHandler = nil;
                    self.oneProgressHandler = nil;
                    self.allCompleteHandler = nil;
                });
            }
        }
    }
}

- (BOOL)cancelAllUploadTask
{
    [self stopUpload];
    return YES;
}

//停止队列中的所有上传操作
- (void)stopUpload
{
    @synchronized (taskRefs) {
        [taskRefs.allValues enumerateObjectsUsingBlock: ^(NSURLSessionTask *task, NSUInteger index, BOOL *stop)
         {
             [task suspend];
             [task cancel];
         }];
        [taskRefs removeAllObjects];
        [fileQueue removeAllObjects];
        [self.files removeAllObjects];
        _isRunning = NO;
    }
}

//向队列中插入上传操作
-(void)insertUploadWithFile:(QiniuFile *)file withFileIndex:(NSString *)fileIndex {
    @synchronized (self.files) {
        [self.files insertObject:file forKey:fileIndex atIndex:self.files.count];
        [fileQueue addObject:fileIndex];
    }
}

//移出队列传操作
-(void)cancelUploadWithFileIndex:(NSString *)fileIndex {
    @synchronized (taskRefs) {
        NSInteger index = [self.files indexOfKey:fileIndex];
        [self.files removeObjectForKey:fileIndex];
        [fileQueue removeObject:fileIndex];
        NSURLSessionTask *task = [taskRefs objectAtIndex:index];
        [task suspend];
        [task cancel];
        [taskRefs removeObjectForKey:fileIndex];
    }
}

#pragma NSURLSessionTaskDelegate
//上传片段回调
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    NSString *taskIndex = task.taskDescription;
    if (self.oneProgressHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.oneProgressHandler(taskIndex, bytesSent, totalBytesSent, totalBytesExpectedToSend);
        });
    }
}

//上传回调
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    if (data) {
        responsesData[dataTask.taskDescription] = data;
    }
}

//上传完成
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSString  *fileIndex =  task.taskDescription;
    if(error) {
        if (self.oneFailedHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.oneFailedHandler(fileIndex, error);
            });
        }
    } else {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSData *data = responsesData[task.taskDescription];
        if (httpResponse.statusCode == 200 && data) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            if (self.oneSucceededHandler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.oneSucceededHandler(fileIndex, response);
                });
            }
        } else {
            if (self.oneFailedHandler) {
                error = [NSError errorWithDomain:kQiniuUploadURL code:httpResponse.statusCode userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString([NSString stringWithUTF8String:[data bytes]], @"")}];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.oneFailedHandler(fileIndex, error);
                });
            }
        }
        
    }
    
    @synchronized (taskRefs) {
        [taskRefs removeObjectForKey: task.taskDescription];
    }
    [weakSelf uploadComplete];
}

@end
