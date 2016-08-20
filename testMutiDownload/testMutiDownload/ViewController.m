//
//  ViewController.m
//  testMutiDownload
//
//  Created by Yanglixia on 16/8/18.
//  Copyright © 2016年 阳林霞. All rights reserved.
//

#import "ViewController.h"
#import "LDGifOrMp3Manager.h"
#import "LDGifOrMp3Model.h"

@interface ViewController ()<LDGifOrMp3ManagerDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIProgressView *musicProgress;

/** url */
@property (nonatomic, strong) NSArray *array;

@end

@implementation ViewController


- (NSArray *)array
{
    if (!_array) {
        _array = @[
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/3e141f8aceaf423cbf8bddef146d0592_640x480.gif",
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/b3c1217a42d645558e534dcf7b579c42_640x480.gif",
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/421473f9711d445aacb68a0bf5d2498f_640x480.gif",
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/c22b5b9daf4a42fe9b10f64d82f26777_640x480.gif",
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/03e4e8acfb88402c9cecaea93256c6b3_640x480.gif",
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/80415001c8344b7a886abfe3fdffc6e0_640x480.gif",
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/4a5382c1998349fc930bc93a8e2b0acc_640x480.gif",
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/9223b1dce1e347f1a58d15e4d14fa8d7_640x480.gif",
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/7802badc260841e6833625388757f0e4_640x480.gif",
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/df0bfb113847414ab610ed38bdec9da9_640x480.gif",
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/970ef65463f546c5b8ac449287cca6be_640x480.gif",
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/ea3ee686b0c94558b92ec51a7250859c_640x480.gif",
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/7da1b699363f4e2bb988b5fbfa45802b_640x480.gif",
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/f8fd8ee97d014d5fa7706154cda3d981_640x480.gif",
                   @"http://img2.liandan100.com/@/qimg/skinsteppartref/201608/0244914963664ba190549c6b6928337f_640x480.gif",
                   
                   //mp3
                   @"http://img2.liandan100.com/@/qimg/hardwarevoice/201608/b05ae2d63ec3466c8e5c606d3dd8d1ed.mp3",
                   @"http://img2.liandan100.com/@/qimg/hardwarevoice/201608/6838133bf3ad4a28923bdef0aadd4a50.mp3",
                   @"http://img2.liandan100.com/@/qimg/hardwarevoice/201608/6b3956d09ca74b979e4022dcadcb3e52.mp3",
                   @"http://img2.liandan100.com/@/qimg/hardwarevoice/201608/0cb0eb008ae44ebaa5e82fc21e6ae027.mp3",
                   @"http://img2.liandan100.com/@/qimg/hardwarevoice/201608/6fc9aaa0d2f1476f8fe5773c626faed4.mp3",
                   @"http://img2.liandan100.com/@/qimg/hardwarevoice/201608/d47191f90be84ec5bf97c8730cb7d176.mp3",
                   @"http://img2.liandan100.com/@/qimg/hardwarevoice/201608/ac4ca1aa5c1043e788cb250316976be0.mp3",
                   @"http://img2.liandan100.com/@/qimg/hardwarevoice/201608/6c26593155d742b289810854904ef8df.mp3",
                   @"http://img2.liandan100.com/@/qimg/hardwarevoice/201608/898c8155c4544f6ab0e46bcaccd888b4.mp3",
                   @"http://img2.liandan100.com/@/qimg/hardwarevoice/201608/1e4083339cae4c42a0bcc6c9a650c67f.mp3",
                   @"http://7u2qr2.com1.z0.glb.clouddn.com/Piano%20Solo.mp3",
                   
                   ];
    }
    return _array;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableArray *videoModels = [[NSMutableArray alloc] init];
    for (NSString *urlStr in self.array) {
        LDGifOrMp3Model *model = [[LDGifOrMp3Model alloc] init];
        model.downloanUrl = [NSString stringWithFormat:@"%@",
                          urlStr];
        [videoModels addObject:model];
        
        if ([model.downloanUrl isEqualToString:@"http://7u2qr2.com1.z0.glb.clouddn.com/Piano%20Solo.mp3"]) {
            // 这里监听背影音乐的下载进度
            model.onProgressChanged = ^(LDGifOrMp3Model *model){
                // 改变界面的进度
                self.musicProgress.progress = model.progress;
            };
        }
    }
    [LDGifOrMp3Manager shared].delegate = self;
    [[LDGifOrMp3Manager shared] addVideoModels:videoModels];
}

- (void)LDGifOrMp3ManagerDownloadCompeleted:(LDGifOrMp3Model *)model
{
//    NSLog(@"是否完成:%zd",model.status);//3完成
    
//    NSLog(@"%@",[NSThread currentThread]);//打印出来是在子线程
    /*
     LDGifOrMp3StatusNone = 0,       // 初始状态
     LDGifOrMp3StatusRunning = 1,    // 下载中
     LDGifOrMp3StatusSuspended = 2,  // 下载暂停
     LDGifOrMp3StatusCompleted = 3,  // 下载完成
     LDGifOrMp3StatusFailed  = 4,    // 下载失败
     LDGifOrMp3StatusWaiting = 5,    // 等待下载
     */
    
    NSLog(@"文件名:%@----文件下载状态:statu:%zd \n 下载状态:%.2f 下载进度:%@",[model.localPath lastPathComponent],model.status,model.progress,model.progressText);
    
    static NSInteger count = 0;
    // 文件不是已下载完成或文件已存在，则去下载(由于下载量大，有些文件下载过程中可能会暂停，因此暂停的文件，重新再开启下载)
    if (model.status != LDGifOrMp3StatusCompleted && model.status != LDGifOrMp3StatusFileIsExit) {
        [[LDGifOrMp3Manager shared] startWithVideoModel:model];
        return;
    }
    // 下载了一个，progressView走一步
    count ++;
    if (count == self.array.count) {
        
        NSLog(@"全部下载完毕");
        
    }
    // 这里是按每一个文件来算进行显示的，每下一个进度+1
    self.progressView.progress = count/(CGFloat)([LDGifOrMp3Manager shared].gifOrMp3Models.count);

}
- (IBAction)beginDownload:(id)sender {
    
    // 一次型开启所有下载
    for (LDGifOrMp3Model *model in [LDGifOrMp3Manager shared].gifOrMp3Models) {
        
        [[LDGifOrMp3Manager shared] startWithVideoModel:model];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
