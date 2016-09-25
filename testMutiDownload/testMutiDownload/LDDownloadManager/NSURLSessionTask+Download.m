//
//  NSURLSessionTask+Download.m
//  testMutiDownload
//
//  Created by Yanglixia on 16/9/25.
//  Copyright © 2016年 阳林霞. All rights reserved.
//

#import "NSURLSessionTask+Download.h"
#import <objc/runtime.h>
/************************* 下载任务NSURLSessionTask的分类 ***********************************/

static const void *s_ldGifOrMp3ModelKey = "s_ldGifOrMp3ModelKey";

@implementation NSURLSessionTask (Download)

- (void)setLd_gitOrMp3Model:(LDGifOrMp3Model *)ld_gitOrMp3Model
{
    objc_setAssociatedObject(self, s_ldGifOrMp3ModelKey, ld_gitOrMp3Model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LDGifOrMp3Model *)ld_gitOrMp3Model
{
    return objc_getAssociatedObject(self, s_ldGifOrMp3ModelKey);
}

@end
