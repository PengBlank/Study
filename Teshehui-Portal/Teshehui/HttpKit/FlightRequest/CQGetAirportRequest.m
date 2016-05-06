//
//  CQGetAirportRequest.m
//  ComeHere
//
//  Created by ChengQian on 13-11-17.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQGetAirportRequest.h"
#import "CQGetAirportResponse.h"

@implementation CQGetAirportRequest


- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = @"http://app.bnx6688.com/airflight/";
        self.httpMethod = @"POST";
        
        self.Cmd = @"SearchPortName";
    }
    
    return self;
}


- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.Cmd length] > 0)
        {
            [newDic setObject:self.Cmd
                       forKey:@"Cmd"];
        }
        
        if ([self.PortCode length] > 0)
        {
            [newDic setObject:self.PortCode
                       forKey:@"PortCode"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    CQGetAirportResponse *respose = [[CQGetAirportResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
