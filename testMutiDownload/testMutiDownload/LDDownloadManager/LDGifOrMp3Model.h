//
//  LDGifOrMp3Model.h
//  testMutiDownload
//
//  Created by Yanglixia on 16/8/18.
//  Copyright © 2016年 阳林霞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LDGifOrMp3Operation;
@class LDGifOrMp3Model;

typedef NS_ENUM(NSInteger, LDGifOrMp3Status) {
    LDGifOrMp3StatusNone = 0,       // 初始状态
    LDGifOrMp3StatusRunning = 1,    // 下载中
    LDGifOrMp3StatusSuspended = 2,  // 下载暂停
    LDGifOrMp3StatusCompleted = 3,  // 下载完成
    LDGifOrMp3StatusFailed  = 4,    // 下载失败
    LDGifOrMp3StatusWaiting = 5,    // 等待下载
    LDGifOrMp3StatusFileIsExit = 6, // 文件已存在
//    LDGifOrMp3StatusCancel = 6      // 取消下载
};

typedef void(^LDGifOrMp3ModelStatusChanged)(LDGifOrMp3Model *model);
typedef void(^LDGifOrMp3ModelProgressChanged)(LDGifOrMp3Model *model);

@interface LDGifOrMp3Model : NSObject
/// 要下载文件的链接
@property (nonatomic, copy) NSString *downloanUrl;

/// 恢复下载要用到的
@property (nonatomic, strong) NSData *resumeData;
/// 下载后存储位置
@property (nonatomic, copy) NSString *localPath;
/// 下载进度值显示:%.1lfMB/%.1fMB.前面为当前下载，后面为文件总大小
@property (nonatomic, copy) NSString *progressText;
/// 下载进度的百分比
@property (nonatomic, assign) CGFloat progress;
/// 当前文件下载进度
@property (nonatomic, assign) LDGifOrMp3Status status;
/// 下载这个文件的操作
@property (nonatomic, strong) LDGifOrMp3Operation *operation;

@property (nonatomic, copy) LDGifOrMp3ModelStatusChanged onStatusChanged;

@property (nonatomic, copy) LDGifOrMp3ModelProgressChanged onProgressChanged;

@property (nonatomic, readonly, copy) NSString *statusText;

- (BOOL)fileIsExits;
@end
