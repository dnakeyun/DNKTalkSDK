//
//  AYProgressHud.h
//  AYUtils
//
//  Created by dnake_ay on 2019/9/26.
//  Copyright © 2019 dnake_ay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AYProgressHud : NSObject

+ (AYProgressHud *)sharedInstance;

//message展示时长2s
+ (void)progressHudShowShortTimeMessage:(NSString *)message;
//设备入网、对码
- (void)progressHudWithText:(NSString *)text;
//默认不传为nil
- (void)progressHudWithShowText:(NSString *)showText showTime:(NSNumber *)showTime;
//隐藏
- (void)progressHudhide;

@end
