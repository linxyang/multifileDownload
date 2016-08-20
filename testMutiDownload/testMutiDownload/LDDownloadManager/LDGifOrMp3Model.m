//
//  LDGifOrMp3Model.m
//  testMutiDownload
//
//  Created by Yanglixia on 16/8/18.
//  Copyright © 2016年 阳林霞. All rights reserved.
//

#import "LDGifOrMp3Model.h"
#import "LDGifOrMp3Operation.h"


@implementation LDGifOrMp3Model

- (NSString *)localPath {
    NSString *pathName = [NSString stringWithFormat:@"%@",[self.downloanUrl lastPathComponent]];
    NSString *cachesPath =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [cachesPath stringByAppendingPathComponent:pathName];
    return filePath;
}


- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = progress;
        
        if (self.onProgressChanged) {
            // 实时返回进度变化，供界面显示当前文件进度
            self.onProgressChanged(self);
        } else {
//            NSLog(@"progress changed block is empty");
        }
    }
}

- (void)setStatus:(LDGifOrMp3Status)status {
    if (_status != status) {
        _status = status;
        // 实时返回状态，供界面显示当前文件下载状态
        if (self.onStatusChanged) {
            self.onStatusChanged(self);
        }
    }
}

- (NSString *)statusText {
    switch (self.status) {
        case LDGifOrMp3StatusNone: {
            return @"";
            break;
        }
        case LDGifOrMp3StatusRunning: {
            return @"下载中";
            break;
        }
        case LDGifOrMp3StatusSuspended: {
            return @"暂停下载";
            break;
        }
        case LDGifOrMp3StatusCompleted: {
            return @"下载完成";
            break;
        }
        case LDGifOrMp3StatusFailed: {
            return @"下载失败";
            break;
        }
        case LDGifOrMp3StatusWaiting: {
            return @"等待下载";
            break;
        }
        case LDGifOrMp3StatusFileIsExit:{
            return @"文件已存在";
            break;
        }
    }
}

- (BOOL)fileIsExits
{
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager fileExistsAtPath:self.localPath];
}


@end
