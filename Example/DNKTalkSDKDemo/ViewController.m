//
//  ViewController.m
//  DNKTalkSDKDemo
//
//  Created by 赖盛源 on 2019/7/4.
//  Copyright © 2019 dnake_ay. All rights reserved.
//

#import "ViewController.h"
#import "IncomingViewController.h"
#import "MonitorVideoViewController.h"
#import "AYUtils.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *sipServiceTextField;
@property (weak, nonatomic) IBOutlet UITextField *sipAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *sipPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *deviceSipTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"DNKTalkSDK";
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [registerButton setTitle:@"sip注册(离线)" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor systemGrayColor] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerSipMethod) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:registerButton];
    
    self.sipServiceTextField.text = SIP_SERVICE;
    self.sipAccountTextField.text = SIP_ACCOUNT;
    self.sipPasswordTextField.text = SIP_PASSWORD;
    self.deviceSipTextField.text = SIP_DEVICE_CODE;
    //监听sip状态
    [[DNKTalkManager sharedInstance] setSipStatusBlock:^(int status) {
        
        [[AYProgressHud sharedInstance] progressHudhide];
        
        if (status == 1) {
            //在线
            [registerButton setTitle:@"sip注册(在线)" forState:UIControlStateNormal];
            [registerButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        } else {
            //离线
            [registerButton setTitle:@"sip注册(离线)" forState:UIControlStateNormal];
            [registerButton setTitleColor:[UIColor systemGrayColor] forState:UIControlStateNormal];
        }
        
        self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:registerButton];
    }];
    
    /*------------------------ 蓝牙开锁回调 ------------------------*/
    
    //蓝牙开锁回调
    [[DNKTalkManager sharedInstance] setBleUnlockBlock:^(NSNumber * _Nonnull unlockStatus) {
        
        [[AYProgressHud sharedInstance] progressHudhide];
        
        switch (unlockStatus.integerValue) {
            case 0:
            {
                //开锁失败
            }
                break;
            case 1:
            {
                //开锁成功
            }
                break;
                
            default:
                break;
        }
    }];
    //未找到开锁的蓝牙设备（搜索设备超时：3秒）
    [[DNKTalkManager sharedInstance] setNotFoundBleDeviceBlock:^{
        
        [[AYProgressHud sharedInstance] progressHudhide];
    }];
    //蓝牙未开启
    [[DNKTalkManager sharedInstance] setStateOffBlock:^{
        NSLog(@"蓝牙未开启");
    }];
    
    //连接蓝牙log（type：类型， name：蓝牙名称， errorDesc：是否有报错）
    [[DNKTalkManager sharedInstance] setConnectLogBlock:^(BLE_CALLBACK type, NSString * _Nonnull name, NSString * _Nonnull errorDesc) {
        
        NSLog(@"bleUnlockManager - %lu-%@-%@", (unsigned long)type, name, errorDesc);
        
        switch (type) {
            case BLE_CALLBACK_SCAN_FOUND:
            {
                
            }
                break;
            case BLE_CALLBACK_CONNECT_FAIL:
            {
                
            }
                break;
            case BLE_CALLBACK_CONNECT_SUCCESS:
            {
                
            }
                break;
            case BLE_CALLBACK_SCAN_SERVICE:
            {
                
            }
                break;
            case BLE_CALLBACK_DIS_CONNECT:
            {
                
            }
                break;
                
            default:
                break;
        }
    }];
    
}
//sip这册
- (void)registerSipMethod {
    
    SipConfigEntity *sipConfigEntity = [SipConfigEntity new];

    sipConfigEntity.node = self.sipServiceTextField.text;
    sipConfigEntity.user = self.sipAccountTextField.text;
    sipConfigEntity.passwd = self.sipPasswordTextField.text;
    
//    sipConfigEntity.server_talk = self.sipServiceTextField.text;
//    sipConfigEntity.user_talk = self.sipAccountTextField.text;
//    sipConfigEntity.passwd_talk = self.sipPasswordTextField.text;

    [[DNKTalkManager sharedInstance] setSipConfigWithSipConfigEntity:sipConfigEntity];
    
    [[AYProgressHud sharedInstance] progressHudWithText:@""];
    
}
//监视
- (IBAction)monitorVideoMethod {
    
    MonitorVideoViewController *monitorVideoVC = [MonitorVideoViewController new];
    
    monitorVideoVC.deviceSipAccount = self.deviceSipTextField.text.length ? self.deviceSipTextField.text : @"";
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:monitorVideoVC];
    
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:nav animated:YES completion:nil];
    
}
//开锁
- (IBAction)unLockMethod {
    
    [[DNKTalkManager sharedInstance] unLockWithSipAccount:self.deviceSipTextField.text.length ? self.deviceSipTextField.text : @""];
    
}
//蓝牙开锁
- (IBAction)bleUnlockMethod {
    
    NSArray *array = @[BLE_UNLOCK_MAC_ADDRESS1, BLE_UNLOCK_MAC_ADDRESS2];
    
    [[DNKTalkManager sharedInstance] bleUnlockWithMacAddresses:array];
    
    [[AYProgressHud sharedInstance] progressHudWithText:@""];
}

#pragma mark - 回收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}
//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}



@end
