//
//  CQFilghtPolicyParam.m
//  ComeHere
//
//  Created by ChengQian on 13-11-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtPolicyParam.h"
#import "CQFilghtPolicyResponse.h"

@implementation CQFilghtPolicyParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = @"http://app.bnx6688.com/airpolicy/";
        self.httpMethod = @"GET";
    }
    
    return self;
}


- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.offDate length] > 0)
        {
            [newDic setObject:self.offDate
                       forKey:@"offDate"];
        }
        
        if ([self.orgCity length] > 0)
        {
            [newDic setObject:self.orgCity
                       forKey:@"orgCity"];
        }
        
        if ([self.dstCity length] > 0)
        {
            [newDic setObject:self.dstCity
                       forKey:@"dstCity"];
        }
        
        if ([self.routeType length] > 0)
        {
            [newDic setObject:self.routeType
                       forKey:@"routeType"];
        }
        if ([self.week length] > 0)
        {
            [newDic setObject:self.week
                       forKey:@"week"];
        }
        if ([self.airCom length] > 0)
        {
            [newDic setObject:self.airCom
                       forKey:@"airCom"];
        }
        if ([self.flightNo length] > 0)
        {
            [newDic setObject:self.flightNo
                       forKey:@"flightNo"];
        }
        if ([self.flightCab length] > 0)
        {
            [newDic setObject:self.flightCab
                       forKey:@"flightCab"];
        }
        
        if ([self.contype length] > 0)
        {
            [newDic setObject:self.contype
                       forKey:@"contype"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    CQFilghtPolicyResponse *respose = [[CQFilghtPolicyResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
