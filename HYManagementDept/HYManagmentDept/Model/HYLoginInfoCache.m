//
//  HYLoginInfoCache.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-21.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYLoginInfoCache.h"
#import "NSObject+PropertyListing.h"
#import "SFHFKeychainUtils.h"

#define LoginInfoCacheKey @"3akffsa8@=dffa"

@implementation HYLoginInfoCache

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSDictionary *dictionary = [self dictionValue];
    [aCoder encodeObject:dictionary forKey:LoginInfoCacheKey];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        NSDictionary *dictionary = [aDecoder decodeObjectForKey:LoginInfoCacheKey];
        [self setPropertysWithDictionary:dictionary];
    }
    return self;
}

+ (instancetype)cachedLoginInfo
{
    NSData *encodeData = [[NSUserDefaults standardUserDefaults] objectForKey:LoginInfoCacheKey];
    if (encodeData) {
        NSString *userName = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
        NSString *password = [SFHFKeychainUtils getPasswordForUsername:userName andServiceName:LoginCacheService error:nil];
        HYLoginInfoCache *cache = [[HYLoginInfoCache alloc] init];
        cache.userName = userName;
        cache.passWord = password;
        return cache;
    }
    return nil;
}

+ (instancetype)loginInfoWithName:(NSString *)name passWord:(NSString *)pass shouldCache:(BOOL)aBool
{
    HYLoginInfoCache *login = [[HYLoginInfoCache alloc] init];
    login.userName = name;
    login.passWord = pass;
    if (aBool) {
        NSData *userNameData = [name dataUsingEncoding:NSUTF8StringEncoding];
        [[NSUserDefaults standardUserDefaults] setObject:userNameData forKey:LoginInfoCacheKey];
        [SFHFKeychainUtils storeUsername:name andPassword:pass forServiceName:LoginCacheService updateExisting:YES error:nil];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return login;
}

+ (void)deleteCachedLoginInfo
{
    NSData *encodeData = [[NSUserDefaults standardUserDefaults] objectForKey:LoginInfoCacheKey];
    if (encodeData)
    {
        NSString *userName = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
        [SFHFKeychainUtils deleteItemForUsername:userName andServiceName:LoginCacheService error:nil];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LoginInfoCacheKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
