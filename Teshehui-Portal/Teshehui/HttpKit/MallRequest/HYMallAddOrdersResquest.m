//
//  HYMallAddOrdersResquest.m
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallAddOrdersResquest.h"

@implementation HYMallAddOrdersResquest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kMallRequestBaseURL, @"api/cart/add"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.spec_id length] > 0)
        {
            [newDic setObject:self.spec_id forKey:@"spec_id"];
        }
                
        [newDic setObject:[NSString stringWithFormat:@"%d", self.quantity]
                   forKey:@"quantity"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallAddOrdersResponse *respose = [[HYMallAddOrdersResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
