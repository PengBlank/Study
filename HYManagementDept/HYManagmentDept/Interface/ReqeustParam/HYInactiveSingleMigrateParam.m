//
//  HYInactiveSingleMigrateParam.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYInactiveSingleMigrateParam.h"

@implementation HYInactiveSingleMigrateParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/promoters_ajax_single_card"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.card_number length] > 0) {
            
            [newDic setObject:self.card_number forKey:@"card_number"];
        }
        if ([self.user_id length] > 0) {
            
            [newDic setObject:self.user_id forKey:@"user_id"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYInactiveSingleMigrateResponse *respose = [[HYInactiveSingleMigrateResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
