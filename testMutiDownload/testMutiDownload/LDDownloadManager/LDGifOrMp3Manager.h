//
//  LDGifOrMp3Manager.h
//  testMutiDownload
//
//  Created by Yanglixia on 16/8/18.
//  Copyright © 2016年 阳林霞. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LDGifOrMp3Model;

@protocol LDGifOrMp3ManagerDelegate <NSObject>

- (void)LDGifOrMp3ManagerDownloadCompeleted:(LDGifOrMp3Model *)model;

@end

@interface LDGifOrMp3Manager : NSObject

@property (nonatomic, readonly, strong) NSArray *gifOrMp3Models;

+ (instancetype)shareManager;

- (void)addVideoModels:(NSArray<LDGifOrMp3Model *> *)gifOrMp3Models;
/// 开始下载
- (void)startWithVideoModel:(LDGifOrMp3Model *)gifOrMp3Model;
/// 暂停下载
- (void)suspendWithVideoModel:(LDGifOrMp3Model *)gifOrMp3Model;
/// 恢复下载
- (void)resumeWithVideoModel:(LDGifOrMp3Model *)gifOrMp3Model;
/// 停止下载
- (void)stopWiethVideoModel:(LDGifOrMp3Model *)gifOrMp3Model;

/** 代理 */
@property (nonatomic, strong) id<LDGifOrMp3ManagerDelegate> delegate;

@end
