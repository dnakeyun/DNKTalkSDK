//
//  IncomingViewController.m
//  DNKTalkSDKDemo
//
//  Created by 赖盛源 on 2019/7/4.
//  Copyright © 2019 dnake_ay. All rights reserved.
//

#import "IncomingViewController.h"

@interface IncomingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIButton *micButton;
@property (weak, nonatomic) IBOutlet UIButton *talkButton;
@property (weak, nonatomic) IBOutlet UIButton *hangupButton;
@property (weak, nonatomic) IBOutlet UIButton *answerButton;
@property (weak, nonatomic) IBOutlet UIButton *unlockButton;

@end

@implementation IncomingViewController

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[DNKTalkManager sharedInstance] stopAudio];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"门口机呼叫App";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStyleDone target:self action:@selector(popToVC)];
    
    [[DNKTalkManager sharedInstance] setVideoImageBlock:^(UIImage * _Nonnull videoImage) {
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
//挂断
- (IBAction)hangupMethod:(UIButton *)sender {
    //关闭当前通话
    [[DNKTalkManager sharedInstance] talkStop];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//接听
- (IBAction)answerMethod:(UIButton *)sender {
    
    [[DNKTalkManager sharedInstance] talkStart];
    
    [[DNKTalkManager sharedInstance] playAudio];
    
    self.answerButton.hidden = YES;
}
//开锁
- (IBAction)unlockMethod:(UIButton *)sender {
    
    [[DNKTalkManager sharedInstance] unLock];
}


@end
