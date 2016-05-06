//
//  HYCheckAgencyInfoResponse.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYCheckAgencyInfoResponse.h"

@interface HYCheckAgencyInfoResponse ()

@property (nonatomic, copy) NSString *agencyID;  //代理商ID
@property (nonatomic, copy) NSString *real_name;  //会员真实姓名
@property (nonatomic, copy) NSString *phone_mob;  //会员电话
@property (nonatomic, copy) NSString *id_card;  //会员身份证
@property (nonatomic, copy) NSString *name;  //所属代理商名

@end

@implementation HYCheckAgencyInfoResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            self.agencyID = GETOBJECTFORKEY(self.jsonDic, @"id", [NSString class]);
            self.real_name = GETOBJECTFORKEY(self.jsonDic, @"real_name", [NSString class]);
            self.name = GETOBJECTFORKEY(self.jsonDic, @"clearing_receivable", [NSString class]);
            self.phone_mob = GETOBJECTFORKEY(self.jsonDic, @"phone_mob", [NSString class]);
            self.id_card = GETOBJECTFORKEY(self.jsonDic, @"id_card", [NSString class]);
        }
    }
    
    return self;
}

@end