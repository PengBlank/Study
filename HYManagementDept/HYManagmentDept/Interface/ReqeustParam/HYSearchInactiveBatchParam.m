//
//  HYSearchInactiveBatchParam.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSearchInactiveBatchParam.h"

@implementation HYSearchInactiveBatchParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/promoters_ajax_batch_search_card"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.start_number length] > 0) {
            
            [newDic setObject:self.start_number forKey:@"start_number"];
        }
        if ([self.end_number length] > 0) {
            
            [newDic setObject:self.end_number forKey:@"end_number"];
        }
        if (_type > 0)
        {
            [newDic setObject:[NSNumber numberWithInteger:_type] forKey:@"type"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYSearchInactiveBatchResponse *respose = [[HYSearchInactiveBatchResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
