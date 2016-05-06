//
//  HYBusinessCardInfo.m
//  Teshehui
//
//  Created by HYZB on 14-10-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBusinessCardInfo.h"
#import "HYTelNumberInfo.h"
#import "HYUserInfo.h"
#import "NSString+Addition.h"

@interface HYBusinessCardInfo ()

@property (nonatomic, assign) BOOL hasCache;

@end

@implementation HYBusinessCardInfo


+ (instancetype)initWithDiskCache
{
    HYBusinessCardInfo *obj = [[HYBusinessCardInfo alloc] init];
    obj.hasCache = NO;
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    
    if (user.mobilePhone)
    {
        NSMutableArray *tempMobile = [[NSMutableArray alloc] init];
        HYTelNumberInfo *t = [[HYTelNumberInfo alloc] init];
        t.type = Phone;
        t.number = user.mobilePhone;
        [tempMobile addObject:t];
        
        obj.numberList = tempMobile;
    }
    else
    {
        obj.numberList = [[NSMutableArray alloc] init];
    }
    
    obj.name = user.realName;
    obj.email = user.email;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *path = [basePath stringByAppendingPathComponent:@"userinfo"];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:path])
    {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *cardInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
     
        obj.name = [cardInfo objectForKey:NAME];
        obj.title = [cardInfo objectForKey:TITLE];
        obj.email = [cardInfo objectForKey:EMAIL];
        obj.address = [cardInfo objectForKey:ADD];
        obj.org = [cardInfo objectForKey:ORG];
        obj.hasCache = YES;
        
        NSMutableArray *tempMobile = [[NSMutableArray alloc] init];
        NSArray *mobile = [cardInfo objectForKey:TEL];
        for (NSDictionary *obj in mobile)
        {
            HYTelNumberInfo *t = [[HYTelNumberInfo alloc] init];
            NSNumber *pType = [obj.allKeys lastObject];
            t.type = [pType intValue];
            t.number = [obj.allValues lastObject];
            [tempMobile addObject:t];
        }
        
        //本地缓存的肯定包含了用户登录的手机号
        obj.numberList = [tempMobile mutableCopy];
    }
    return obj;
}

+ (void)cleanCache
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *path = [basePath stringByAppendingPathComponent:@"userinfo"];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:path])
    {
        [manager removeItemAtPath:path error:nil];
    }
}


- (void)saveToDisk:(NSError **)error
{
    *error = [NSError errorWithDomain:@"信息不能为空"
                                 code:100000
                             userInfo:nil];
    
    NSMutableDictionary *cardInfo = [[NSMutableDictionary alloc] init];

    if ([self.title length] > 0)
    {
        *error = nil;
        [cardInfo setObject:self.title forKey:TITLE];
    }
    if ([self.email length] > 0)
    {
        *error = nil;
        [cardInfo setObject:self.email forKey:EMAIL];
    }
    if ([self.address length] > 0)
    {
        *error = nil;
        [cardInfo setObject:self.address forKey:ADD];
    }
    if ([self.org length] > 0)
    {
        *error = nil;
        [cardInfo setObject:self.org forKey:ORG];
    }
    
    //mobile
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (HYTelNumberInfo *t in self.numberList)
    {
        if ([t.number length] > 0)
        {
            NSDictionary *d = [[NSDictionary alloc] initWithObjectsAndKeys:
                               t.number, [NSNumber numberWithInt:t.type],
                               nil];
            
            [array addObject:d];
        }
    }
    
    if ([array count] > 0)
    {
        *error = nil;
        [cardInfo setObject:array forKey:TEL];
    }
    
    if ([self.name length] > 0)
    {
        *error = nil;
        [cardInfo setObject:self.name forKey:NAME];
    }
    else
    {
        *error = [NSError errorWithDomain:@"姓名不能为空"
                                     code:100000
                                 userInfo:nil];
    }
    
    if (!*error)
    {
        self.hasCache = YES;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        NSString *path = [basePath stringByAppendingPathComponent:@"userinfo"];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cardInfo];

        if (![data writeToFile:path atomically:YES])
        {
            DebugNSLog(@"保存名片信息失败");
        }
    }
}

- (NSString *)QRDesctription
{
    NSMutableString *qrStr = [NSMutableString stringWithString:@"BEGIN:VCARD\r\nVERSION:2.1\r\n"];
    
    //去掉空格
    self.name = [self.name stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([self.name length] > 0)
    {
        [qrStr appendFormat:@"N:%@\r\n", self.name];
    }
    
    if ([self.title length] > 0)
    {
        [qrStr appendFormat:@"TITLE:%@\r\n", self.title];
    }
    if ([self.email length] > 0)
    {
        [qrStr appendFormat:@"EMAIL:%@\r\n", self.email];
    }
    if ([self.address length] > 0)
    {
        [qrStr appendFormat:@"ADR:%@\r\n", self.address];
    }
    if ([self.org length] > 0)
    {
        [qrStr appendFormat:@"ORG:%@\r\n", self.org];
    }
    
    //mobile
    for (HYTelNumberInfo *t in self.numberList)
    {
        if ([t.number length] > 0)
        {
            [qrStr appendFormat:@"TEL;"];
            switch (t.type)
            {
                case Home:
                    [qrStr appendFormat:@"HOME:%@\r\n", t.number];
                    break;
                case Work:
                    [qrStr appendFormat:@"WORK:%@\r\n", t.number];
                    break;
                case Phone:
                    [qrStr appendFormat:@"CELL:%@\r\n", t.number];
                    break;
                case Fax:
                    [qrStr appendFormat:@"FAX:%@\r\n", t.number];
                    break;
                case Other:
                    [qrStr appendFormat:@"OTHER:%@\r\n", t.number];
                    break;
                default:
                    break;
            }
        }
    }
    
    [qrStr appendString:@"END:VCARD\r\n"];

    return qrStr;
    /*
    id<YOVcardGeneratorProtocol> generator = [YOVcardGenerator vcardGeneratorForVersion:YOVcardVersion2_1];
    [generator beginVcard];
    [generator beginLine];
    
    if ([self.name length] > 0)
    {
        [generator addAttributes:@{@"N":self.name}];
    }
    
    if ([self.title length] > 0)
    {
        [generator addAttributes:@{@"TITLE":self.title}];
    }
    if ([self.email length] > 0)
    {
        [generator addAttributes:@{@"EMAIL":self.email}];
    }
    if ([self.address length] > 0)
    {
        [generator addAttributes:@{@"ADR":self.address}];
    }
    if ([self.org length] > 0)
    {
        [generator addAttributes:@{@"ORG":self.org}];
    }
    
    //mobile
    for (HYTelNumberInfo *t in self.numberList)
    {
        if ([t.number length] > 0)
        {
            [generator addType:@"TEL"];
            switch (t.type)
            {
                case Home:
                    [generator addType:@"HOME"];
                    break;
                case Work:
                    [generator addType:@"WORK"];
                    break;
                case Phone:
                    [generator addType:@"IPHONE"];
                    break;
                case Fax:
                    [generator addType:@"WORKFAX"];
                    break;
                case Other:
                    [generator addType:@"OTHER"];
                    break;
                default:
                    break;
            }
            
            [generator setStringValue:t.number];
        }
    }

    [generator endLine];
    [generator endVcard];
    
    NSString *vcardString = [generator vcardRepresentation];
    
    return vcardString;
     */
}

- (BOOL)canAddNumber
{
    return ([self.numberList count]<5);
}
@end
