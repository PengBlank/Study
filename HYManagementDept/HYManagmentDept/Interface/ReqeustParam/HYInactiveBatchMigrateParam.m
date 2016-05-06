//
//  HYInactiveBatchMigrateParam.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYInactiveBatchMigrateParam.h"

@implementation HYInactiveBatchMigrateParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/promoters_ajax_batch_card"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.start length] > 0) {
            
            [newDic setObject:self.start forKey:@"start"];
        }
        if ([self.user_id length] > 0) {
            
            [newDic setObject:self.user_id forKey:@"user_id"];
        }
        if ([self.end length] > 0) {
            
            [newDic setObject:self.end forKey:@"end"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYInactiveBatchMigrateResponse *respose = [[HYInactiveBatchMigrateResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
