//
//  CQFilghtSearchRequest.m
//  ComeHere
//
//  Created by ChengQian on 13-11-17.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtSearchRequest.h"
#import "CQFilghtSearchResponse.h"

@implementation CQFilghtSearchRequest

/*
 PID 2088901528382185
 Key zu34ntk6tje8yptdtgtm1os3vzomrcjo
 */
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = @"http://app.bnx6688.com/airflight/";
        self.httpMethod = @"GET";
        
        //固定值
        self.Uid = @"bnxapp";
        self.Key = @"8g92f8e0-65b9-45aa-a2d2-1c4b9e2bd587";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.Uid length] > 0)
        {
            [newDic setObject:self.Uid
                       forKey:@"Uid"];
        }
        
        if ([self.Key length] > 0)
        {
            [newDic setObject:self.Key
                       forKey:@"Key"];
        }
        
        if ([self.OrgCity length] > 0)
        {
            [newDic setObject:self.OrgCity
                       forKey:@"OrgCity"];
        }
        
        if ([self.DstCity length] > 0)
        {
            [newDic setObject:self.DstCity
                       forKey:@"DstCity"];
        }
        
        if ([self.OffDate length] > 0)
        {
            [newDic setObject:self.OffDate
                       forKey:@"OffDate"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    CQFilghtSearchResponse *respose = [[CQFilghtSearchResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
