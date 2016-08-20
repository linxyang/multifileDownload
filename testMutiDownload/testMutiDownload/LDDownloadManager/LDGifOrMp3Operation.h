//
//  LDGifOrMp3Operation.h
//  testMutiDownload
//
//  Created by Yanglixia on 16/8/18.
//  Copyright © 2016年 阳林霞. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LDGifOrMp3Model;
/************************* 下载任务NSURLSessionTask的分类 ***********************************/
@interface NSURLSessionTask (LDGifOrMp3Model) //  下载任务的分类

// 为了更方便去获取，而不需要遍历，采用扩展的方式，可直接提取，提高效率
@property (nonatomic, weak) LDGifOrMp3Model *ld_gitOrMp3Model;// 为下载任务分类添加一个模型属性

@end




/************************* 下载操作 ***********************************/
@interface LDGifOrMp3Operation : NSOperation

- (instancetype)initWithModel:(LDGifOrMp3Model *)model session:(NSURLSession *)session;

@property (nonatomic, weak) LDGifOrMp3Model *model;
@property (nonatomic, strong, readonly) NSURLSessionDownloadTask *downloadTask;

- (void)suspend;
- (void)resume;
- (void)downloadFinished;

@end

