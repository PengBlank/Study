//
//  CQFilghtDynamic.m
//  ComeHere
//
//  Created by ChengQian on 13-11-12.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtDynamicRequest.h"
#import "CQFilghtDynamicResponse.h"

@implementation CQFilghtDynamicRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = @"http://dynamic.bnx6688.com/DynamicBook/";
        self.httpMethod = @"POST";
    }
    
    return self;
}


- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.UserID length] > 0)
        {
            [newDic setObject:self.UserID
                       forKey:@"UserID"];
        }
        
        if ([self.Mobile length] > 0)
        {
            [newDic setObject:self.Mobile
                       forKey:@"Mobile"];
        }
        
        if ([self.planDepartDt length] > 0)
        {
            [newDic setObject:self.planDepartDt
                       forKey:@"planDepartDt"];
        }
        
        if ([self.flightNo length] > 0)
        {
            [newDic setObject:self.flightNo
                       forKey:@"flightNo"];
        }
        
        if ([self.departCity length] > 0)
        {
            [newDic setObject:self.departCity
                       forKey:@"departCity"];
        }
        
        if ([self.arriveCity length] > 0)
        {
            [newDic setObject:self.arriveCity
                       forKey:@"arriveCity"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    CQFilghtDynamicResponse *respose = [[CQFilghtDynamicResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
