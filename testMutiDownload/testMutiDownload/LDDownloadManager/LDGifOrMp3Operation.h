//
//  LDGifOrMp3Operation.h
//  testMutiDownload
//
//  Created by Yanglixia on 16/8/18.
//  Copyright © 2016年 阳林霞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLSessionTask+Download.h"
@class LDGifOrMp3Model;

/************************* 下载操作 ***********************************/
@interface LDGifOrMp3Operation : NSOperation

- (instancetype)initWithModel:(LDGifOrMp3Model *)model session:(NSURLSession *)session;

@property (nonatomic, weak) LDGifOrMp3Model *model;
@property (nonatomic, strong, readonly) NSURLSessionDownloadTask *downloadTask;

- (void)suspend;
- (void)resume;
- (void)downloadFinished;

@end

