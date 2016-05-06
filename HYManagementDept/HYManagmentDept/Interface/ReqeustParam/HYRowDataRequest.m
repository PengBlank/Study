//
//  HYRowDataRequest.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYRowDataRequest.h"
#import "HYRowDataResponse.h"

@implementation HYRowDataRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/enterprise_member_list"];
        self.httpMethod = @"POST";
        _num_per_page = 20;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:[NSString stringWithFormat:@"%ld", (long)self.num_per_page]
                   forKey:@"num_per_page"];
        [newDic setObject:[NSNumber numberWithInteger:_page]
                   forKey:@"page"];
        
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYRowDataResponse *respose = [[HYRowDataResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
