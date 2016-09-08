//
//  LDGifOrMp3Operation.m
//  testMutiDownload
//
//  Created by Yanglixia on 16/8/18.
//  Copyright © 2016年 阳林霞. All rights reserved.
//

#import "LDGifOrMp3Operation.h"
#import "LDGifOrMp3Model.h"
#import <objc/runtime.h>

// 手动触发KVO
#define kKVOBlock(KEYPATH, BLOCK) \
[self willChangeValueForKey:KEYPATH]; \
BLOCK(); \
[self didChangeValueForKey:KEYPATH];


/************************* 下载任务NSURLSessionTask的分类 ***********************************/

static const void *s_ldGifOrMp3ModelKey = "s_ldGifOrMp3ModelKey";

@implementation NSURLSessionTask (LDGifOrMp3Model)

- (void)setLd_gitOrMp3Model:(LDGifOrMp3Model *)ld_gitOrMp3Model
{
    objc_setAssociatedObject(self, s_ldGifOrMp3ModelKey, ld_gitOrMp3Model, OBJC_ASSOCIATION_ASSIGN);
}

- (LDGifOrMp3Model *)ld_gitOrMp3Model
{
    return objc_getAssociatedObject(self, s_ldGifOrMp3ModelKey);
}




@end


/************************* 下载操作 ***********************************/
static NSTimeInterval kTimeoutInterval = 60.0;// 下载超时时间

@interface LDGifOrMp3Operation () {
    BOOL _finished;
    BOOL _executing;
}

@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, weak) NSURLSession *session;

@end


@implementation LDGifOrMp3Operation

- (instancetype)initWithModel:(LDGifOrMp3Model *)model session:(NSURLSession *)session {
    if (self = [super init]) {
        self.model = model;
        self.session = session;
        [self statRequest];
    }
    return self;
}

- (void)dealloc {
    self.task = nil;
}

- (void)setTask:(NSURLSessionDownloadTask *)task {
    // 下载任务对象，移除监听状态kvo
    [_task removeObserver:self forKeyPath:@"state"];
    
    if (_task != task) {
        _task = task;
    }
    // 哪果任务不为空，添加kvo监听下载状态
    if (task != nil) {
        // 监听下载任务状态的改变
        /**
         NSURLSessionTaskStateRunning   = 0,
         NSURLSessionTaskStateSuspended = 1,
         NSURLSessionTaskStateCanceling = 2,
         NSURLSessionTaskStateCompleted = 3,
         */
        [task addObserver:self
               forKeyPath:@"state"
                  options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)configTask {
    // 下载任务分类所关联对象模型属性赋值
    self.task.ld_gitOrMp3Model = self.model;
}

/// 开始创建下载任务
- (void)statRequest {
    NSURL *url = [NSURL URLWithString:self.model.downloanUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:kTimeoutInterval];
    // 创建下载任务
    self.task = [self.session downloadTaskWithRequest:request];
    [self configTask];
}
// 操作开始
- (void)start {
    // 如果操作取消了，则触发完成KVO
    if (self.isCancelled) {
        kKVOBlock(@"isFinished", ^{
            _finished = YES;
        });
        return;
    }
    // 触发正在执行KVO
    [self willChangeValueForKey:@"isExecuting"];
    if (self.model.resumeData) {
        [self resume];
    } else {
        [self.task resume];
        self.model.status = LDGifOrMp3StatusRunning;
    }
    
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

/**** 这三个方法，都是NSOperation自带的(只读)，这里重写了，为方便KVO监听，前面的会手动触发它们改变 *********/
- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)suspend {
    if (self.task) {
        __weak __typeof(self) weakSelf = self;
        __block NSURLSessionDownloadTask *weakTask = self.task;
        [self willChangeValueForKey:@"isExecuting"];
        __block BOOL isExecuting = _executing;
        
        [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            weakSelf.model.resumeData = resumeData;
            weakTask = nil;
            isExecuting = NO;
            [weakSelf didChangeValueForKey:@"isExecuting"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.model.status = LDGifOrMp3StatusSuspended;
            });
        }];
        
        [self.task suspend];
    }
}

- (void)resume {
    if (self.model.status == LDGifOrMp3StatusCompleted) {
        return;
    }
    self.model.status = LDGifOrMp3StatusRunning;
    
    if (self.model.resumeData) {
        self.task = [self.session downloadTaskWithResumeData:self.model.resumeData];
        [self configTask];
    } else if (self.task == nil
               || (self.task.state == NSURLSessionTaskStateCompleted && self.model.progress < 1.0)) {
        [self statRequest];
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [self.task resume];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

// 对象属性--获取下载任务对象
- (NSURLSessionDownloadTask *)downloadTask {
    return self.task;
}

- (void)cancel {
    [self willChangeValueForKey:@"isCancelled"];
    [super cancel];
    [self.task cancel];
    self.task = nil;
    [self didChangeValueForKey:@"isCancelled"];
    
    [self completeOperation];
}

// 手动触发完成下载操作的KVO
- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (self.task.state) {
                case NSURLSessionTaskStateSuspended: {
                    self.model.status = LDGifOrMp3StatusSuspended;
                    break;
                }
                case NSURLSessionTaskStateCompleted:
                    if (self.model.progress >= 1.0) {
                        self.model.status = LDGifOrMp3StatusCompleted;
                    } else {
                        self.model.status = LDGifOrMp3StatusSuspended;
                    }
                default:
                    break;
            }
        });
    }
}

- (void)downloadFinished {
    [self completeOperation];
}

@end

