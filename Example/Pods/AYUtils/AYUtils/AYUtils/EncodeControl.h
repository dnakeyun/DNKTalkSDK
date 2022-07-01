//
//  Encode.h
//  Base64+rc4
//
//  Created by han on 2017/8/24.
//  Copyright © 2017年 han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncodeControl : NSObject
+ (NSString *)encode:(NSString *)data key:(NSString *)key isBase64:(BOOL)isBase64;
+ (NSString *)decode:(NSString *)data key:(NSString *)key isBase64:(BOOL)isBase64;
@end

