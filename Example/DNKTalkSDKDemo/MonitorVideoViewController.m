//
//  MonitorVideoViewController.m
//  DNKTalkSDKDemo
//
//  Created by 赖盛源 on 2019/7/9.
//  Copyright © 2019 dnake_ay. All rights reserved.
//

#import "MonitorVideoViewController.h"

@interface MonitorVideoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIButton *micButton;
@property (weak, nonatomic) IBOutlet UIButton *talkButton;
@property (weak, nonatomic) IBOutlet UIButton *hangupButton;
@property (weak, nonatomic) IBOutlet UIButton *unlockButton;

@end

@implementation MonitorVideoViewController

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[DNKTalkManager sharedInstance] stopAudio];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"App监视门口机";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStyleDone target:self action:@selector(popToVC)];
    
    //发送监视指令
    [[DNKTalkManager sharedInstance] monitorVideoWithSipAccount:self.deviceSipAccount];
    
    [[DNKTalkManager sharedInstance] setMonitorResultBlock:^(NSNumber * _Nonnull resultCode) {
        
        NSLog(@"setMonitorResultBlock - %@", resultCode);
        //大于400都是错误结果
        if (resultCode.integerValue > 400) return ;
        //1.监视连接成功，播放音频
        [[DNKTalkManager sharedInstance] playAudio];
        
    }];
    
    [[DNKTalkManager sharedInstance] setVideoImageBlock:^(UIImage * _Nonnull videoImage) {
        //2.连接成功播放视频
        self.videoImage.image = videoImage;
    }];
    
}

//终止通话
- (void)popToVC {
    
    [[DNKTalkManager sharedInstance] talkStop];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//麦克风
- (IBAction)micMethod:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [[DNKTalkManager sharedInstance] openMic:sender.selected];
    [self.micButton setImage:[UIImage imageNamed:sender.selected ? @"mic-select" : @"mic-close-select"] forState:UIControlStateNormal];
    
}
//对讲
- (IBAction)talkMethod:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [[DNKTalkManager sharedInstance] openSpe:sender.selected];
    [self.talkButton setImage:[UIImage imageNamed:sender.selected ? @"voice-select" : @"voice-close-select"] forState:UIControlStateNormal];
    
}

//挂断，关闭当前通话
- (IBAction)hangupMethod:(UIButton *)sender {
    
    [[DNKTalkManager sharedInstance] talkStop];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//开锁
- (IBAction)unlockMethod:(UIButton *)sender {
    
    [[DNKTalkManager sharedInstance] unLock];
    
}

@end
