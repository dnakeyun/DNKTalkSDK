//  SDK版本：v1.0.5
//  DNKTalkManager.h
//  DNKTalkManager
//
//  Created by dnake_ay on 2019/4/3.
//  Copyright © 2019 dnake_ay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SipConfigEntity.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  收到门口机呼叫（门口机 --> App）
 */
typedef void(^DNKTalkManagerWithReceiveCallingSuccess)(void);
/**
 *  监视门口机（App --> 门口机）
 */
typedef void(^DNKTalkManagerWithMonitorResult)(NSNumber *);
/**
 *  终止通话
 */
typedef void(^DNKTalkManagerWithTalkStop)(void);
/**
 *  sipStatus:sip在线状态 1 在线 0 离线
 */
typedef void(^DNKTalkManagerWithSipStatus)(int);
/**
 *  返回视图（videoImage）赋值给自定义的imageView展示视频界面
 */
typedef void(^DNKTalkManagerWithVideoImage)(UIImage *);

/*---------------------------- 蓝牙开锁 ----------------------------*/

typedef enum : NSUInteger {
    BLE_CALLBACK_SCAN_FOUND,//扫描的周边蓝牙信号
    BLE_CALLBACK_CONNECT_FAIL,//连接失败,
    BLE_CALLBACK_CONNECT_SUCCESS,//连接成功
    BLE_CALLBACK_SCAN_SERVICE,//扫描服务
    BLE_CALLBACK_DIS_CONNECT,//断开连接
} BLE_CALLBACK;

/**
 *  蓝牙开锁 1:开锁成功，2:开锁失败
 */
typedef void(^DNKTalkManagerWithBleUnlock)(NSNumber *);
/**
 *  找不到蓝牙开锁设备
 */
typedef void(^DNKTalkManagerWithNotFoundBleDevice)(void);
/**
 *  手机蓝牙未开启
 */
typedef void(^DNKTalkManagerWithStatePoweredOff)(void);
/**
 *  连接外设log
 */
typedef void(^DNKTalkManagerWithConnectLog)(BLE_CALLBACK, NSString *, NSString *);

@interface DNKTalkManager : NSObject

//推送通知注册的deviceToken
@property (copy, nonatomic) NSString *deviceToken;

@property (strong, nonatomic) DNKTalkManagerWithReceiveCallingSuccess receiveCallingSuccessBlock;

@property (strong, nonatomic) DNKTalkManagerWithMonitorResult monitorResultBlock;

@property (strong, nonatomic) DNKTalkManagerWithTalkStop talkStopBlock;

@property (strong, nonatomic) DNKTalkManagerWithSipStatus sipStatusBlock;

@property (strong, nonatomic) DNKTalkManagerWithVideoImage videoImageBlock;

/*---------------------------- 蓝牙开锁 ----------------------------*/

@property (strong, nonatomic) DNKTalkManagerWithBleUnlock bleUnlockBlock;

@property (strong, nonatomic) DNKTalkManagerWithNotFoundBleDevice notFoundBleDeviceBlock;

@property (strong, nonatomic) DNKTalkManagerWithConnectLog connectLogBlock;

@property (strong, nonatomic) DNKTalkManagerWithStatePoweredOff stateOffBlock;

+ (DNKTalkManager *)sharedInstance;
/**
 *  初始化
 */
- (void)initSDK;
///**
// *退出
// */
//- (void)exitSDK;
/**
 *  Sip配置（注册）
 *  sipConfigEntity:sip配置实体，参数选择性配置,把需要配置的参数赋值给实体
 *  SipConfigEntity *sipConfigEntity = [SipConfigEntity new];
 *  sipConfigEntity.user = @"user";
 *  sipConfigEntity.passwd = @"passwd";
 *  ...
 *  [[DNKTalkManager sharedInstance] setSipConfigWithSipConfigEntity:sipConfigEntity];
 */
- (void)setSipConfigWithSipConfigEntity:(SipConfigEntity *)sipConfigEntity;
/**
 *  开始对讲
 */
- (void)talkStart;
/**
 *  关闭呼叫
 */
- (void)talkStop;
/**
 *  播放音频
 */
- (void)playAudio;
/**
 *  关闭音频
 */
- (void)stopAudio;
/**
 *  打开麦克风 (YES:打开 NO:关闭)
 */
- (void)openMic:(BOOL)isOpen;
/**
 *  打开对讲 (YES:打开 NO:关闭)
 */
- (void)openSpe:(BOOL)isOpen;
/**
 *  开锁（通话中）
 */
- (void)unLock;
/**
 *  开锁（不需要通话直接开锁，需要传目标设备sip号）
 *  sipAccount:设备的sip号
 */
- (void)unLockWithSipAccount:(NSString *)sipAccount;
/**
 *  主动监视
 *  sipAccount:设备的sip号
 */
- (void)monitorVideoWithSipAccount:(NSString *)sipAccount;

/*---------------------------- 蓝牙开锁 ----------------------------*/
/**
 *  蓝牙开锁
 *  macAddresses:mac地址集合
 */
- (void)bleUnlockWithMacAddresses:(NSArray *)macAddresses;

@end

NS_ASSUME_NONNULL_END
