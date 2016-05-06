//
//  HYVIPCradListRequestParam.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYVIPCardListRequestParam.h"

@implementation HYVIPCardListRequestParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_membership_card_lists"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.number.length > 0) {
            [newDic setObject:self.number forKey:@"number"];
        }
        if (self.promoters.length > 0) {
            [newDic setObject:self.promoters forKey:@"promoters"];
        }
        if (self.start_time.length > 0) {
            [newDic setObject:self.start_time forKey:@"start_time"];
        }
        if (self.end_time.length > 0) {
            [newDic setObject:self.end_time forKey:@"end_time"];
        }
        if (_status != 0) {
            [newDic setObject:[NSNumber numberWithInteger:_status] forKey:@"status"];
        }
    }
    
    return newDic;
}

- (HYRowDataResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYVIPCardListRespnse *respose = [[HYVIPCardListRespnse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
