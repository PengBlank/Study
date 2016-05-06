//
//  NSString+Addition.m
//  Putao
//
//  Created by 程 谦 on 12-6-18.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

#import "NSString+Addition.h"
#import "NSData+Addition.h"

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"
#include "NumberInfoAction.h"

NSString *Ai = nil;

@implementation NSString (Addition)

- (BOOL)checkPhoneNumberValid
{
	if (!self)
	{
		return NO;
	}
    //移动号码
	NSString *regex_CMCC = @"^(134|135|136|137|138|139|147|150|151|152|154|157|158|159|182|183|184|187|188|178)[0-9]{8}";
    NSPredicate *pred_CMCC = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_CMCC];
    
    if ([pred_CMCC evaluateWithObject:self])
    {
        return YES;
    }
	//联通号码
	NSString *regex_Unicom = @"^(130|131|132|145|185|186|156|155|170|176)[0-9]{8}";
	NSPredicate *pred_Unicom = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_Unicom];
    
	if ([pred_Unicom evaluateWithObject:self])
    {
        return YES;
    }
    
	//电信号码段(电信新增号段181)
	NSString *regex_Telecom = @"^(133|153|180|181|189|177)[0-9]{8}";
	NSPredicate *pred_Telecom = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_Telecom];
    
    if ([pred_Telecom evaluateWithObject:self]) {
        return YES;
    }
	
    return NO;
}

- (Carrier)checkPhoneNumberCarrier
{
    //移动号码
    NSString *regex_CMCC = @"^(134|135|136|137|138|139|147|150|151|152|154|157|158|159|182|183|184|187|188|178)[0-9]{8}";
    NSPredicate *pred_CMCC = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_CMCC];
    
    if ([pred_CMCC evaluateWithObject:self])
    {
        return CHINA_CMCC;
    }
    //联通号码
    NSString *regex_Unicom = @"^(130|131|132|145|185|186|156|155|170|176)[0-9]{8}";
    NSPredicate *pred_Unicom = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_Unicom];
    
    if ([pred_Unicom evaluateWithObject:self])
    {
        return CHINA_Unicom;
    }
    
    //电信号码段(电信新增号段181)
    NSString *regex_Telecom = @"^(133|153|180|181|189|177)[0-9]{8}";
    NSPredicate *pred_Telecom = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_Telecom];
    
    if ([pred_Telecom evaluateWithObject:self]) {
        return CHINA_Telecom;
    }
    
    return UnknownCarrier;
}

- (NSString *)getPhoneNumberAttribution
{
    if (self && [self checkPhoneNumberValid])
    {
        NSString *subStr = [self substringToIndex:7];
        int subMobile = [subStr intValue];

        NumberInfoAction *action = new NumberInfoAction;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mobileinfo_326881"
                                                            ofType:@"dat"];
        const char * cFilePath = [filePath cStringUsingEncoding:NSUTF8StringEncoding];
        char *name = action->GetCityNameByNumber(cFilePath, subMobile);
        delete action;
        if (name != NULL)
        {
            return [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        }
    }
    
    return @"未知";
}

- (NSString *)URLEncodedString
{
	return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}


- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                              NULL,
                                                              (__bridge CFStringRef)[self mutableCopy],
                                                              NULL,
                                                              CFSTR("!*'();:@&=+$,/?%#[]"),
                                                              encoding));
}

- (NSString *)MD5EncodedString
{
	return [[self dataUsingEncoding:NSUTF8StringEncoding] MD5EncodedString];
}

- (NSData *)HMACSHA1EncodedDataWithKey:(NSString *)key
{
	return [[self dataUsingEncoding:NSUTF8StringEncoding] HMACSHA1EncodedDataWithKey:key];
}

- (NSString *) base64EncodedString
{
	return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
}

- (NSString *)base64DecodedString
{
    NSData *data = [GTMBase64 decodeString:self];
    NSString *str = nil;
    if (data)
    {
        str = [[NSString alloc] initWithData:data
                                    encoding:NSUTF8StringEncoding];
    }
    
    return str;
}

- (NSData *)AES256EncryptWithKey:(NSString *)key
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [[self dataUsingEncoding:NSUTF8StringEncoding] bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

+ (NSString *)GUIDString
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return CFBridgingRelease(string);
}

- (NSString*)filterInvalidStringToMobile
{
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:[self length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO)
    {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer])
        {
            [strippedString appendString:buffer];
        }
        else
        {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    //过滤掉大陆的号码区号码86
    if ([strippedString length] == 13)
    {
        [strippedString deleteCharactersInRange:NSMakeRange(0, 2)];
    }
    
    return strippedString;
}

+ (BOOL)validateIDCardNumber:(NSString *)value
{
    //转换大小写
    value = [value uppercaseString];
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    Ai = [[NSString alloc]init];
    if([self matchesLenght:value] &&
       [self matchesNum:value] &&
       [self matchesBirth:value] &&
       [self matchesAreaCode:value] &&
       [self matchesEndNum:value])
    {
        return YES;
    }
    else
    {
        return NO;
    }
    /*
    int length = 0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length != 15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch > 0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }else {
                
                //^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$
                //^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch > 0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)]; // 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
    return NO;
     */
}

+ (NSString *)sexStrFromIdentityCard:(NSString *)numberStr
{
    
    BOOL isAllNumber = YES;
    
    if([numberStr length]<17)
        return @"F";
    
    //**截取第17为性别识别符
    NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(16, 1)];
    
    //**检测是否是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }
    
    if(!isAllNumber)
        return @"F";
    
    NSInteger sexNumber = [fontNumer integerValue];
    if(sexNumber%2==1)
        return @"M";
    ///result = @"M";
    else if (sexNumber%2==0)
        return @"F";
    //result = @"F";
    
    return @"F";
}

+(BOOL)matchesLenght:(NSString*)str{
    if ( str != nil && (str.length == 15 || str.length == 18)) {
        return YES;
    }
    return NO;
}
+(BOOL)matchesNum:(NSString*)str{
    if (str.length == 18) {
        NSRange range;
        range.location = 0;
        range.length = 17;
        Ai = [str substringWithRange:range];
    } else if (str.length == 15){
        NSRange range1;
        range1.location = 0;
        range1.length = 6;
        NSString* str1 = [str substringWithRange:range1];
        
        NSRange range2;
        range2.location = 6;
        range2.length = 9;
        NSString* str2 = [str substringWithRange:range2];
        Ai = [NSString stringWithFormat:@"%@19%@",str1,str2];
    }
    return [self isNumeric:Ai];
}

+(BOOL)matchesBirth:(NSString*)str
{
    BOOL isIdCard = NO;
    NSRange range1;
    range1.location = 6;
    range1.length = 4;
    NSString* strYear = [Ai substringWithRange:range1];// 年份
    
    NSRange range2;
    range2.location = 10;
    range2.length = 2;
    NSString* strMonth = [Ai substringWithRange:range2];// 月份
    
    NSRange range3;
    range3.location = 12;
    range3.length = 2;
    NSString* strDay = [Ai substringWithRange:range3];// 日
    
    if ([self isDate:([NSString stringWithFormat:@"%@-%@-%@",strYear,strMonth,strDay])])
    {
        isIdCard = NO;
    }
    else
    {
        isIdCard = YES;
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int inowyear = [[formatter stringFromDate:date] intValue];
    int iyear = [strYear intValue];
    if ((inowyear-iyear) > 150) {
        isIdCard = NO;
    }
    else{
        isIdCard = YES;
    }
    [formatter setDateFormat:@"yyyyMMdd"];
    long long inowtime = [[formatter stringFromDate:date] longLongValue];
    long long itime = [[NSString stringWithFormat:@"%@%@%@",strYear,strMonth,strDay] longLongValue];
    if ((inowtime - itime) < 0) {
        isIdCard = NO;
    }
    else{
        isIdCard = YES;
    }
    
    if ([strMonth intValue] > 12 || [strMonth intValue] == 0) {
        isIdCard = NO;
    } else {
        isIdCard = YES;
    }
    
    if ([strDay intValue] > 31 || [strDay intValue]== 0) {
        isIdCard = NO;
    } else {
        isIdCard = YES;
    }
    return isIdCard;
}

+(BOOL)matchesAreaCode:(NSString*)str{
    BOOL isIdCard = NO;
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc]init];
    [mdic setObject:@"北京" forKey:@"11"];
    [mdic setObject:@"天津" forKey:@"12"];
    [mdic setObject:@"河北" forKey:@"13"];
    [mdic setObject:@"山西" forKey:@"14"];
    [mdic setObject:@"内蒙古" forKey:@"15"];
    [mdic setObject:@"辽宁" forKey:@"21"];
    [mdic setObject:@"吉林" forKey:@"22"];
    [mdic setObject:@"黑龙江" forKey:@"23"];
    [mdic setObject:@"上海" forKey:@"31"];
    [mdic setObject:@"江苏" forKey:@"32"];
    [mdic setObject:@"浙江" forKey:@"33"];
    [mdic setObject:@"安徽" forKey:@"34"];
    [mdic setObject:@"福建" forKey:@"35"];
    [mdic setObject:@"江西" forKey:@"36"];
    [mdic setObject:@"山东" forKey:@"37"];
    [mdic setObject:@"河南" forKey:@"41"];
    [mdic setObject:@"湖北" forKey:@"42"];
    [mdic setObject:@"湖南" forKey:@"43"];
    [mdic setObject:@"广东" forKey:@"44"];
    [mdic setObject:@"广西" forKey:@"45"];
    [mdic setObject:@"海南" forKey:@"46"];
    [mdic setObject:@"重庆" forKey:@"50"];
    [mdic setObject:@"四川" forKey:@"51"];
    [mdic setObject:@"贵州" forKey:@"52"];
    [mdic setObject:@"云南" forKey:@"53"];
    [mdic setObject:@"西藏" forKey:@"54"];
    [mdic setObject:@"陕西" forKey:@"61"];
    [mdic setObject:@"甘肃" forKey:@"62"];
    [mdic setObject:@"青海" forKey:@"63"];
    [mdic setObject:@"宁夏" forKey:@"64"];
    [mdic setObject:@"新疆" forKey:@"65"];
    [mdic setObject:@"台湾" forKey:@"71"];
    [mdic setObject:@"香港" forKey:@"81"];
    [mdic setObject:@"澳门" forKey:@"82"];
    [mdic setObject:@"国外" forKey:@"91"];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString* strtemp = [Ai substringWithRange:range];//
    
    if ([mdic objectForKey:strtemp] == nil)
    {
        isIdCard = NO;
    }
    else
    {
        isIdCard = YES;
    }
    return isIdCard;
}

+(BOOL)matchesEndNum:(NSString*)str{
    NSArray* Wi = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6",@"3", @"7",@"9", @"10", @"5", @"8", @"4", @"2", nil ];
    NSArray* ValCodeArr = [NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5",@"4",@"3", @"2", nil];
    
    BOOL isIdCard = NO;
    int TotalmulAiWi = 0;
    for (int i = 0; i < 17; i++)
    {
        NSRange range;
        range.location = i;
        range.length = 1;
        NSString* strtemp = [Ai substringWithRange:range];//
        TotalmulAiWi = TotalmulAiWi + [strtemp intValue] * [[Wi objectAtIndex:i] intValue];
    }
    int modValue = TotalmulAiWi % 11;
    NSString* strVerifyCode = [ValCodeArr objectAtIndex:modValue];
    Ai = [NSString stringWithFormat:@"%@%@",Ai,strVerifyCode];
    
    if (str.length == 18)
    {
        if (![Ai isEqualToString:str])
        {
            isIdCard = NO;
        }
        else
        {
            isIdCard = YES;
        }
    }
    else
    {
        isIdCard = YES;
    }
    return isIdCard;
}

+(BOOL)isNumeric:(NSString*)str{
    
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:@"[0-9]*"
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:nil];// 测试出生日期的合法性
    
    NSUInteger numberofMatch = [regularExpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if (numberofMatch) {
        return YES;
    } else {
        return NO;
    }
}

+(BOOL)isDate:(NSString*)str{
    NSString *cd = @"^((\\d{2}(([02468][048])|([13579][26]))[\\-\\/"
    @"\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|"
    @"(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/"
    @"\\s]?((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579]"
    @"[01345789]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|"
    @"(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))"
    @"(\\s(((0?[0-9])|([1-2][0-3]))\\:([0-5]?[0-9])((\\s)|(\\:([0-5]?[0-9])))))?$";
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:cd
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:nil];// 测试出生日期的合法性
    
    NSUInteger numberofMatch = [regularExpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    
    
    if (numberofMatch>0)
    {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)encryptUseDESKey:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          [keyData bytes],
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [GTMBase64 stringByEncodingData:data];
    }
    return ciphertext;
}

- (NSString *)decryptUseDESKey:(NSString *)key
{
    NSString *plaintext = nil;
    NSData *cipherdata = [GTMBase64 decodeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          [keyData bytes],
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}

- (NSInteger)calculateCountWord
{
    NSInteger count = 0;
    for (int i = 0; i < self.length; i++)
    {
        int a = [self characterAtIndex:i];
//        if( a > 0x4e00 && a < 0x9fff)
        if ((int)(a) > 127)
        {
            count += 2;
        }
        else
        {
            count += 1;
        }
    }
    return count;
}

- (NSString *)substringWithChiniseCount:(NSInteger)count
{
    NSInteger cCount = 0;
    NSInteger j = 0;
    for (int i = 0; i < self.length && cCount < count; i++)
    {
        int a = [self characterAtIndex:i];
//        if( a > 0x4e00 && a < 0x9fff)
        if ((int)(a) > 127)
        {
            cCount += 2;
            j += 1;
        }
        else
        {
            cCount += 1;
            j += 1;
        }
    }
    return [self substringToIndex:j];
}

- (NSInteger)calculateUnicharCount
{
    NSInteger i,n=[self length],count = 0;
    
    unichar c;
    
    for(i=0;i<n;i++){
        c=[self characterAtIndex:i];
        if(isblank(c))
        {
            count++;
        }
        else if(isascii(c))
        {
            count++;
        }
        else
        {
            count += 2;
        }
    }
    
    return count;
}

- (NSString *)getBirthdayForIDCard
{
    NSString *birthday = nil;
    if ([NSString validateIDCardNumber:self])
    {
        NSRange range1;
        range1.location = 6;
        range1.length = 4;
        NSString* strYear = [Ai substringWithRange:range1];// 年份
        
        NSRange range2;
        range2.location = 10;
        range2.length = 2;
        NSString* strMonth = [Ai substringWithRange:range2];// 月份
        
        NSRange range3;
        range3.location = 12;
        range3.length = 2;
        NSString* strDay = [Ai substringWithRange:range3];// 日
        
        birthday = [NSString stringWithFormat:@"%@-%@-%@",strYear,strMonth,strDay];
    }
    
    return birthday;
}

- (NSDictionary *)urlParamToDic
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSArray *array = [self componentsSeparatedByString:@"&"];
    
    for (NSString *param in array)
    {
        NSArray *p = [param componentsSeparatedByString:@"="];
        
        if ([p count] >= 2)
        {
            NSString *key = [p objectAtIndex:0];
            NSString *value = [p objectAtIndex:1];
            
            [params setObject:value
                       forKey:key];
        }
    }
    
    return [params copy];
}

//判断输入邮箱的格式
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

- (NSString *)stringDecimalByAdding:(NSString *)numberValue
{
    if (self && numberValue)
    {
        NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber *taget = [NSDecimalNumber decimalNumberWithString:numberValue];
        
        return [[number decimalNumberByAdding:taget] stringValue];
    }
    
    return self;
}

- (NSString *)stringDecimalBySubtracting:(NSString *)numberValue
{
    if (self && numberValue)
    {
        NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber *taget = [NSDecimalNumber decimalNumberWithString:numberValue];
        
        return [[number decimalNumberBySubtracting:taget] stringValue];
    }
    
    return self;
}

- (NSString *)stringDecimalByMultiplyingBy:(NSString *)numberValue
{
    if (self && numberValue)
    {
        NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber *taget = [NSDecimalNumber decimalNumberWithString:numberValue];
        
        return [[number decimalNumberByMultiplyingBy:taget] stringValue];
    }
    
    return self;
}

- (NSString *)stringDecimalByDividingBy:(NSString *)numberValue
{
    if (self && numberValue.floatValue!=0)
    {
        NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber *taget = [NSDecimalNumber decimalNumberWithString:numberValue];
        
        return [[number decimalNumberByDividingBy:taget] stringValue];
    }
    
    return self;
}

@end
