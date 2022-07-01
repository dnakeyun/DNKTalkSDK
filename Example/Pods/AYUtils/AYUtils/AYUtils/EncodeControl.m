//
//  Encode.m
//  Base64+rc4
//
//  Created by han on 2017/8/24.
//  Copyright © 2017年 han. All rights reserved.
//

#import "EncodeControl.h"
#include <stdio.h>
#include <string.h>
#include <unistd.h>

@implementation EncodeControl

+ (NSString *)encode:(NSString *)data key:(NSString *)key isBase64:(BOOL)isBase64 {
    
    unsigned long rc4_data_len = 0;
    int base64_data_len = 0;
    
    const char *pwd = [key UTF8String];
    
    const char * cData = [data UTF8String];
    rc4_data_len = (int)strlen(cData);
    char *outdata = (char*)calloc(rc4_data_len, 1);
    Transform(pwd, (int)key.length, outdata, cData, (int)rc4_data_len);
    
    if (isBase64) {
        
        base64_data_len = Base64encode_len((int)rc4_data_len);
        char *base64_data = (char*)malloc(base64_data_len);
        memset(base64_data, 0, base64_data_len);
        Base64encode(base64_data, outdata, (int)rc4_data_len);
        base64_data_len = (int)strlen(base64_data);
        
        NSString *str = [NSString stringWithCString:base64_data encoding:NSUTF8StringEncoding];
        return str;
    } else {
        NSData *adata = [[NSData alloc] initWithBytes:outdata length:strlen(outdata)];
        NSString *str = [self hexStringFromData:adata];
        
        return str;
    }
    
}

+ (NSString *)decode:(NSString *)data key:(NSString *)key isBase64:(BOOL)isBase64 {
    
    if (isBase64) {
        
        char *rc4_data = NULL;
        int rc4_data_len = 0;
        const char * base64_data = [data UTF8String];
        const char *pwd = [key UTF8String];

        rc4_data_len = Base64decode_len(base64_data);
        rc4_data_len = (int)strlen(base64_data);
        rc4_data = (char*)malloc(rc4_data_len);
        memset(rc4_data, 0, rc4_data_len);
        rc4_data_len = Base64decode(rc4_data, base64_data);
        char *outdata = (char*)calloc(rc4_data_len + 1, 1);

        Transform(pwd, (int)key.length, outdata, rc4_data, rc4_data_len);
        outdata[rc4_data_len] = 0;
        NSString *str = [NSString stringWithCString:outdata encoding:NSUTF8StringEncoding];
        
        return str;
        
    } else {
        
        NSData *tenData = [self convertHexStrToData:data];
    
        const char * rc4_data = [tenData bytes];
        const char *key_data = [key UTF8String];
        unsigned long  rc4_data_len = tenData.length;
        char *outdata = (char*)calloc(strlen(rc4_data) + 1, 1);
    
        Transform(key_data, (int)key.length, outdata, rc4_data, (int)rc4_data_len);
        outdata[rc4_data_len] = 0;
        NSString *str = [NSString stringWithCString:outdata encoding:NSUTF8StringEncoding];
    
        return str;
    }
    
}

//data转换为十六进制的string
+ (NSString *)hexStringFromData:(NSData *)myD{
    
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    NSLog(@"hex = %@",hexStr);
    
    return hexStr;
}

+ (NSData *)convertHexStrToData:(NSString *)str
{    if (!str || [str length] == 0) {        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];    NSRange range;    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }    for (NSInteger i = range.location; i < [str length]; i += 2) {        unsigned int anInt;        NSString *hexCharStr = [str substringWithRange:range];        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }    return hexData;
}

#pragma mark - base64

/* aaaack but it's fast and const should make it shared text page. */
static const unsigned char pr2six[256] =
{
    /* ASCII table */
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 62, 64, 64, 64, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 64, 64, 64, 64, 64, 64,
    64,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 64, 64, 64, 64, 64,
    64, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64
};

int Base64decode_len(const char *bufcoded)
{
    int nbytesdecoded;
    register const unsigned char *bufin;
    register int nprbytes;

    bufin = (const unsigned char *) bufcoded;
    while (pr2six[*(bufin++)] <= 63);

    nprbytes = (int)(bufin - (const unsigned char *) bufcoded) - 1;
    nbytesdecoded = ((nprbytes + 3) / 4) * 3;

    return nbytesdecoded + 1;
}

int Base64decode(char *bufplain, const char *bufcoded)
{
    int nbytesdecoded;
    register const unsigned char *bufin;
    register unsigned char *bufout;
    register int nprbytes;

    bufin = (const unsigned char *) bufcoded;
    while (pr2six[*(bufin++)] <= 63);
    nprbytes = (int)(bufin - (const unsigned char *) bufcoded) - 1;
    nbytesdecoded = ((nprbytes + 3) / 4) * 3;

    bufout = (unsigned char *) bufplain;
    bufin = (const unsigned char *) bufcoded;

    while (nprbytes > 4) {
    *(bufout++) =
        (unsigned char) (pr2six[*bufin] << 2 | pr2six[bufin[1]] >> 4);
    *(bufout++) =
        (unsigned char) (pr2six[bufin[1]] << 4 | pr2six[bufin[2]] >> 2);
    *(bufout++) =
        (unsigned char) (pr2six[bufin[2]] << 6 | pr2six[bufin[3]]);
    bufin += 4;
    nprbytes -= 4;
    }

    /* Note: (nprbytes == 1) would be an error, so just ingore that case */
    if (nprbytes > 1) {
    *(bufout++) =
        (unsigned char) (pr2six[*bufin] << 2 | pr2six[bufin[1]] >> 4);
    }
    if (nprbytes > 2) {
    *(bufout++) =
        (unsigned char) (pr2six[bufin[1]] << 4 | pr2six[bufin[2]] >> 2);
    }
    if (nprbytes > 3) {
    *(bufout++) =
        (unsigned char) (pr2six[bufin[2]] << 6 | pr2six[bufin[3]]);
    }

    *(bufout++) = '\0';
    nbytesdecoded -= (4 - nprbytes) & 3;
    return nbytesdecoded;
}

static const char basis_64[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

int Base64encode_len(int len)
{
    return ((len + 2) / 3 * 4) + 1;
}

int Base64encode(char *encoded, const char *string, int len)
{
    int i;
    char *p;

    p = encoded;
    for (i = 0; i < len - 2; i += 3) {
    *p++ = basis_64[(string[i] >> 2) & 0x3F];
    *p++ = basis_64[((string[i] & 0x3) << 4) |
                    ((int) (string[i + 1] & 0xF0) >> 4)];
    *p++ = basis_64[((string[i + 1] & 0xF) << 2) |
                    ((int) (string[i + 2] & 0xC0) >> 6)];
    *p++ = basis_64[string[i + 2] & 0x3F];
    }
    if (i < len) {
    *p++ = basis_64[(string[i] >> 2) & 0x3F];
    if (i == (len - 1)) {
        *p++ = basis_64[((string[i] & 0x3) << 4)];
        *p++ = '=';
    }
    else {
        *p++ = basis_64[((string[i] & 0x3) << 4) |
                        ((int) (string[i + 1] & 0xF0) >> 4)];
        *p++ = basis_64[((string[i + 1] & 0xF) << 2)];
    }
    *p++ = '=';
    }

    *p++ = '\0';
    return (int)(p - encoded);
}

#pragma mark - rc4Encode

#define swap(i, j) \
{ \
    char tmp = i; \
    i = j; \
    j = tmp; \
}


void Transform(const char *key, int keylen, char* output, const char* input, int len)
{
    // 设置密钥
    char key_[256];
    memset(key_, 0, 256);
    for (int i = 0; i < 256; i++)
    {
        key_[i] = i;
    }
    int j = 0;
    for (int i = 0; i < 256; i++)
    {
        j = (j + key_[i] + key[i%keylen]) & 0xff; // (j + key_[i] + key[i%keylen]) % 256;
        swap(key_[i], key_[j]);
    }
    // 加/解密
    int i = 0;
    j = 0;
    for (int k = 0; k < len; k++)
    {
        i = (i+1) & 0xff; // (i + 1) % 256;
        j = (j + key_[i]) & 0xff; // (j + key_[i]) % 256;
        swap(key_[i], key_[j]);
        unsigned char subkey = key_[(key_[i] + key_[j]) & 0xff]; // key_[(key_[i] + key_[j]) % 256];
        output[k] = subkey ^ input[k];
    }
    
    return;
}


@end

