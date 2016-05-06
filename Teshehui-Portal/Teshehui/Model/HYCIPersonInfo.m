//
//  HYCarOwnerInfo.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIPersonInfo.h"

@implementation HYCIPersonInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (void)setWithOwnerInfo:(HYCIOwnerInfo *)ownerInfo
{
    self.name = ownerInfo.ownerName;
    self.idCardNo = ownerInfo.ownerIdNo;
    self.mobilephone = ownerInfo.ownerMobilephone;
    self.email = ownerInfo.email;
}

- (void)clearInfo
{
    self.name = nil;
    self.idCardNo = nil;
    self.mobilephone = nil;
    self.email = nil;
}

-  (NSString *)checkErrorDomain
{
    NSString *err = nil;
    
    if (self.name.length == 0)
    {
        err = @"姓名";
    }
    else if (self.idCardNo.length == 0)
    {
        err = @"身份证号";
    }
    else if (self.mobilephone.length == 0)
    {
        err = @"手机号码";
    }
//    else if (self.email.length == 0)
//    {
//        err = @"电子邮箱";
//    }
    
    return err;
}

@end
