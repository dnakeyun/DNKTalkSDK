//
//  AppDelegate.m
//  DNKTalkSDKDemo
//
//  Created by 赖盛源 on 2019/7/4.
//  Copyright © 2019 dnake_ay. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "IncomingViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    
    //sip初始化
    [[DNKTalkManager sharedInstance] initSDK];
    
    //收到门口机呼叫消息
    [[DNKTalkManager sharedInstance] setReceiveCallingSuccessBlock:^(NSDictionary *responseData) {
        NSString *dataJSON = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseData
                                                                                            options:NSJSONWritingPrettyPrinted
                                                                                              error:nil] encoding:NSUTF8StringEncoding];
        NSLog(@"包含callID：%@", dataJSON);
        IncomingViewController *incomingVC = [IncomingViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:incomingVC];
        [[self getCurrentVC] presentViewController:nav animated:YES completion:nil];
        
    }];
    
    //收到门口机挂断消息
    [[DNKTalkManager sharedInstance] setTalkStopBlock:^{
        
        [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //关闭当前通话
    [[DNKTalkManager sharedInstance] talkStop];
    
    [[DNKTalkManager sharedInstance] stopAudio];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
