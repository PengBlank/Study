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
- (Carrier)checkPhoneNumberCarrier; //获取运营商

- (NSString *)getPhoneNumberAttribution;  //获取手机号码归属地

//对字符串请进行UR编码(RFC 1738)
- (NSString *)URLEncodedString;
- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;

- (NSString *)MD5EncodedString;
- (NSData *)HMACSHA1EncodedDataWithKey:(NSString *)key;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;

//des加密，和服务器加密模式还iv参数有关
- (NSString *)encryptUseDESKey:(NSString *)key;
- (NSString *)decryptUseDESKey:(NSString *)key;

//aes加密
- (NSData *)AES256EncryptWithKey:(NSString *)key;

- (NSString*)filterInvalidStringToMobile;

- (NSString *)getBirthdayForIDCard;

+ (NSString *)GUIDString;

+ (BOOL)validateIDCardNumber:(NSString *)value;
+(NSString *)sexStrFromIdentityCard:(NSString *)numberStr;
- (NSInteger)calculateCountWord;  //汉子个数
- (NSInteger)calculateUnicharCount;   //字符数
- (NSString *)substringWithChiniseCount:(NSInteger)count;

- (NSDictionary *)urlParamToDic;

//精确计算俩个字符串加/减/乘/除结果
- (NSString *)stringDecimalByAdding:(NSString *)numberValue;
- (NSString *)stringDecimalBySubtracting:(NSString *)numberValue;
- (NSString *)stringDecimalByMultiplyingBy:(NSString *)numberValue;
- (NSString *)stringDecimalByDividingBy:(NSString *)numberValue;

@end
