//
//  NSString+Addition.h
//  Putao
//
//  Created by 程 谦 on 12-6-18.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

/**
 * NSString对象的扩展方法
 */

#import <Foundation/Foundation.h>

@interface NSString (Addition)

/*
 * 运营商
 */
typedef enum _Carrier
{
    UnknownCarrier = 0,  //未知运营商
    CHINA_CMCC,   //中国移动
    CHINA_Unicom,   //中国联通
    CHINA_Telecom   //中国电信
}Carrier;

- (BOOL)checkPhoneNumberValid; //监测是否为电话号码

//对字符串请进行UR编码(RFC 1738)
- (NSString *)URLEncodedString;
- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;

- (NSString *)MD5EncodedString;
- (NSData *)HMACSHA1EncodedDataWithKey:(NSString *)key;
- (NSString *)base64EncodedString;

+ (NSString *)GUIDString;

+ (BOOL)validateIDCardNumber:(NSString *)value;
@end
