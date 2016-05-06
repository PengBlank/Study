//
//  HYAddVIPCardRequestParma.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAddVIPCardRequestParma.h"

@implementation HYAddVIPCardRequestParma

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_add_member_card"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.start_number length] > 0)
        {
            [newDic setObject:self.start_number forKey:@"start_number"];
        }
        
        if ([self.end_number length] > 0)
        {
            [newDic setObject:self.end_number forKey:@"end_number"];
        }
        
        if ([self.agency_id length] > 0) {
            
            [newDic setObject:self.agency_id forKey:@"agency_id"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAddVIPCardReponse *respose = [[HYAddVIPCardReponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
