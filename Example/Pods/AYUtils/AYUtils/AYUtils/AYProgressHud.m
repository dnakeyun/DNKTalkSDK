//
//  AYProgressHud.m
//  AYUtils
//
//  Created by dnake_ay on 2019/9/26.
//  Copyright © 2019 dnake_ay. All rights reserved.
//

#import "AYProgressHud.h"
#import "MBProgressHud.h"

@interface AYProgressHud ()

@property(strong, nonatomic) MBProgressHUD *hud;

@end

@implementation AYProgressHud

+ (AYProgressHud *)sharedInstance;
{
    static AYProgressHud *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[AYProgressHud alloc] init];
    });
    return sharedClient;
}

+ (void)progressHudShowShortTimeMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(message, @"HUD message title");
    // Move to bottm center.
    [hud setOffset:CGPointMake(0, 0)];
    [hud hideAnimated:YES afterDelay:1.f];
    hud.label.numberOfLines = 0;
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor=[UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1];
    hud.contentColor=[UIColor whiteColor];//字的颜色
}

- (void)progressHudWithText:(NSString *)text
{

    self.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    self.hud.label.text = text;
    
    self.hud.label.numberOfLines = 2;
    // 黑色背景白字
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.bezelView.backgroundColor=[UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1];
    self.hud.contentColor=[UIColor whiteColor];//字的颜色
    
    if (text.length) {
        
        [self.hud hideAnimated:YES afterDelay:60];
        
    } else {
        
        [self.hud hideAnimated:YES afterDelay:15];
        
    }
    
}

- (void)progressHudWithShowText:(NSString *)showText showTime:(NSNumber *)showTime
{
    
    NSString *text = showText.length ? showText : @"";
    
    NSNumber *time = showTime.integerValue > 0 ? showTime : @(0);

    self.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    self.hud.label.text = text;
    
    self.hud.label.numberOfLines = 2;
    // 黑色背景白字
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.bezelView.backgroundColor=[UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1];
    self.hud.contentColor=[UIColor whiteColor];//字的颜色
    
    [self.hud hideAnimated:YES afterDelay:time.integerValue];
    
}


- (void)progressHudhide
{
    [self.hud hideAnimated:YES];
}

@end
