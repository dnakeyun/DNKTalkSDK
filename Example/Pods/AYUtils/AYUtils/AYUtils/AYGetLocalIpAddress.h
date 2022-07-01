//
//  AYGetLocalIpAddress.h
//  AYUtils
//
//  Created by dnake_ay on 2019/9/3.
//  Copyright © 2019 dnake_ay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AYGetLocalIpAddress : NSObject

+ (NSString *)getIPAddress:(BOOL)preferIPv4;
//获取连接的wifi名称
+ (NSString *)getWifiName;

@end

NS_ASSUME_NONNULL_END
