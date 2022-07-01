//
//  AYAlertViewController.h
//  AYUtils
//
//  Created by dnake_ay on 2019/9/3.
//  Copyright © 2019 dnake_ay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AYAlertViewControllerStylePasswordNone,
    AYAlertViewControllerStylePasswordText,
    AYAlertViewControllerStyleNormalText
} AYAlertViewControllerStylePassword;

typedef void(^AYActionCompletionBlock)(int index);

typedef void(^AYAlertCompletionBlock)(UIAlertController *action, int index);

@interface AYAlertViewController : NSObject

/**
 action

 @param viewController current viewController
 @param title title
 @param message message
 @param actions action list
 @param alert block
 */
+ (void)actionSheetViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message actions:(NSArray *)actions actionSheet:(AYActionCompletionBlock)alert;

/**
 alert

 @param viewController current viewController
 @param title title
 @param message message
 @param cancel cancel = nil : not displayed
 @param confirm confirm = nil : not displayed
 @param style Whether to display the input password box
 @param alert block
 */
+ (void)alertViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel confirm:(NSString *)confirm style:(AYAlertViewControllerStylePassword)style alert:(AYAlertCompletionBlock)alert;

@end
