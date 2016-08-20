//
//  LDGifOrMp3Manager.m
//  testMutiDownload
//
//  Created by Yanglixia on 16/8/18.
//  Copyright © 2016年 阳林霞. All rights reserved.
//

#import "LDGifOrMp3Manager.h"
#import "LDGifOrMp3Operation.h"
#import "LDGifOrMp3Model.h"

static LDGifOrMp3Manager *_sg_gitOrMp3Manager = nil;

@interface LDGifOrMp3Manager () <NSURLSessionDownloadDelegate> {
    NSMutableArray *_gifOrMp3Models;
}

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSURLSession *session;

@end


@implementation LDGifOrMp3Manager


+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sg_gitOrMp3Manager = [[self alloc] init];
    });
    
    return _sg_gitOrMp3Manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _gifOrMp3Models = [[NSMutableArray alloc] init];
        self.queue = [[NSOperationQueue alloc] init];// 用来添加下载操作的
        self.queue.maxConcurrentOperationCount = 4;// 最大线程数
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        // 不能传self.queue
        self.session = [NSURLSession sessionWithConfiguration:config
                                                     delegate:self
                                                delegateQueue:nil];
    }
    return self;
}

- (NSArray *)gifOrMp3Models
{
    return _gifOrMp3Models;
}

/// 添加所有要下载的模型到下载集合中
- (void)addVideoModels:(NSArray<LDGifOrMp3Model *> *)gifOrMp3Models {
    if ([gifOrMp3Models isKindOfClass:[NSArray class]]) {
        [_gifOrMp3Models addObjectsFromArray:gifOrMp3Models];
    }
}

/// 开始下载
- (void)startWithVideoModel:(LDGifOrMp3Model *)gifOrMp3Model {
    
    // 加一层判断，文件是否下载
    if ([gifOrMp3Model fileIsExits]) {
        
        NSLog(@"%@文件已存在，无需下载",[gifOrMp3Model.localPath lastPathComponent]);
        gifOrMp3Model.status = LDGifOrMp3StatusFileIsExit;//返回文件已存在
        // 下载完,打印出下载地址
        if ([_delegate respondsToSelector:@selector(LDGifOrMp3ManagerDownloadCompeleted:)]) {
            [_delegate LDGifOrMp3ManagerDownloadCompeleted:gifOrMp3Model];
        }
        return;
    }
    
    
    if (gifOrMp3Model.status != LDGifOrMp3StatusCompleted) {
        gifOrMp3Model.status = LDGifOrMp3StatusRunning;
        
        if (gifOrMp3Model.operation == nil) {
            // 当前操作不存在，是新下载操作，则创建
            gifOrMp3Model.operation = [[LDGifOrMp3Operation alloc] initWithModel:gifOrMp3Model
                                                                    session:self.session];
            // 把要下载的操作添加到下载队列中
            [self.queue addOperation:gifOrMp3Model.operation];
            // 开始下载
            [gifOrMp3Model.operation start];
        } else {
            // 如果操作存在，则恢复下载即可
            [gifOrMp3Model.operation resume];
        }
    }
}

/// 暂停下载
- (void)suspendWithVideoModel:(LDGifOrMp3Model *)gifOrMp3Model {
    if (gifOrMp3Model.status != LDGifOrMp3StatusCompleted) {
        [gifOrMp3Model.operation suspend];
    }
}

/// 恢复下载
- (void)resumeWithVideoModel:(LDGifOrMp3Model *)gifOrMp3Model {
    if (gifOrMp3Model.status != LDGifOrMp3StatusCompleted) {
        [gifOrMp3Model.operation resume];
    }
}

/// 停止下载
- (void)stopWiethVideoModel:(LDGifOrMp3Model *)gifOrMp3Model {
    if (gifOrMp3Model.operation) {
        [gifOrMp3Model.operation cancel];
    }
}

#pragma mark - NSURLSessionTaskDelegate
/// (下载)任务完成的代理方法
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error == nil) {
            task.ld_gitOrMp3Model.status = LDGifOrMp3StatusCompleted;
            [task.ld_gitOrMp3Model.operation downloadFinished];
        } else if (task.ld_gitOrMp3Model.status == LDGifOrMp3StatusSuspended) {
            task.ld_gitOrMp3Model.status = LDGifOrMp3StatusSuspended;
        } else if ([error code] < 0) {
            // 网络异常
            task.ld_gitOrMp3Model.status = LDGifOrMp3StatusFailed;
        }
        // 下载完,打印出下载地址
        if ([_delegate respondsToSelector:@selector(LDGifOrMp3ManagerDownloadCompeleted:)]) {
            [_delegate LDGifOrMp3ManagerDownloadCompeleted:task.ld_gitOrMp3Model];
        }
    });
}

#pragma mark - NSURLSessionDownloadDelegate//继承自NSURLSessionTaskDelegate
// 下载
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    //本地的文件路径，使用fileURLWithPath:来创建
    if (downloadTask.ld_gitOrMp3Model.localPath) {
        NSURL *toURL = [NSURL fileURLWithPath:downloadTask.ld_gitOrMp3Model.localPath];
        NSFileManager *manager = [NSFileManager defaultManager];
        // 把下载下来的文件移动设置的localPath中
        [manager moveItemAtURL:location toURL:toURL error:nil];
    }
    
    [downloadTask.ld_gitOrMp3Model.operation downloadFinished];
    
//    NSLog(@"path = %@", downloadTask.ld_gitOrMp3Model.localPath);
}

// 下载进度代理方法
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    double byts =  totalBytesWritten * 1.0 / 1024 / 1024;
    double total = totalBytesExpectedToWrite * 1.0 / 1024 / 1024;
    NSString *text = [NSString stringWithFormat:@"%.1lfMB/%.1fMB",byts,total];
    CGFloat progress = totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        downloadTask.ld_gitOrMp3Model.progressText = text;
        downloadTask.ld_gitOrMp3Model.progress = progress;
    });
}

/// 恢复下载的代理方法
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    double byts =  fileOffset * 1.0 / 1024 / 1024;
    double total = expectedTotalBytes * 1.0 / 1024 / 1024;
    NSString *text = [NSString stringWithFormat:@"%.1lfMB/%.1fMB",byts,total];
    CGFloat progress = fileOffset / (CGFloat)expectedTotalBytes;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        downloadTask.ld_gitOrMp3Model.progressText = text;
        downloadTask.ld_gitOrMp3Model.progress = progress;
    });
}

@end
