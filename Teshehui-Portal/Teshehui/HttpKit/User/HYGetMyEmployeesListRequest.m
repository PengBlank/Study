//
//  HYGetMyEmployeesList.m
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetMyEmployeesListRequest.h"

@implementation HYGetMyEmployeesListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/users/my_employee_list"];
        self.httpMethod = @"POST";
        self.pageSize = 20;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.user_id length] > 0)
        {
            [newDic setObject:self.user_id forKey:@"user_id"];
        }
        
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.page]
                   forKey:@"page"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageSize]
                   forKey:@"pageSize"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetMyEmployeesListResponse *respose = [[HYGetMyEmployeesListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
