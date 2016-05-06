//
//  CQUserInfo.m
//  Teshehui
//
//  Created by ChengQian on 13-11-16.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYUserInfo.h"

@implementation HYUserInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (NSString *)portrait
{
    return self.userLogo.defaultURL;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{@"memberCardNumber": @"number",
                                 @"policy": @"insurancePolicy"}];
}

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    
    self = [super initWithDictionary:dict error:err];
    
    if (self)
    {
        if (!self.mobilePhone)
        {
            self.mobilePhone = GETOBJECTFORKEY(dict, @"mobilephone", [NSString class]);
        }
        if (self.gender) {
            self.localSex = hyGetSexFromJavaSex(self.gender.integerValue);
        }
        else if (self.sex) {
            self.localSex = hyGetSexFromJavaSex(self.sex.integerValue);
        }
    }
    
    return self;
}


- (id)initWithCoder:(NSCoder *) coder
{
    NSDictionary *userinfo = [coder decodeObjectForKey:@"userInfo"];
    if (userinfo)
    {
        self = [super initWithDictionary:userinfo error:nil];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    NSDictionary *userinfo = [self toDictionary];
    if (userinfo)
    {
        [encoder encodeObject:userinfo  forKey:@"userInfo"];
    }
}

- (void)saveData
{
    NSData *date = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    if (date)
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([self.mobilePhone length] > 0)
        {
            [userDefault setObject:self.mobilePhone
                            forKey:kPhoneNumber];
        }
        
        if (self.token)
        {
            [userDefault setObject:self.token forKey:kToken];
        }
        
        [userDefault setBool:YES forKey:kIsLogin];
        [userDefault setObject:date forKey:kUserInfo];
        [userDefault synchronize];
    }
}

+ (HYUserInfo *)getUserInfo
{
    NSData *d = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
    if (d)
    {
        HYUserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithData:d];
        return user;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO
                                                forKey:kIsLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    return nil;
}

- (void)updateUserInfo
{
    HYUserInfo *cacheUser = [HYUserInfo getUserInfo];
    self.token = cacheUser.token;
    self.insurancePolicy = cacheUser.insurancePolicy;
    [self saveData];
}
@end
