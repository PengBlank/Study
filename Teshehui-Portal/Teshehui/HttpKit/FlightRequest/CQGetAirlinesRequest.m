//
//  CQGetAirlinesRequest.m
//  ComeHere
//
//  Created by ChengQian on 13-11-17.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQGetAirlinesRequest.h"
#import "CQGetAirlinesResponse.h"

@implementation CQGetAirlinesRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = @"http://app.bnx6688.com/airport/";
        self.httpMethod = @"POST";
        
        self.Cmd = @"SearchAirlines";
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
        
        if ([self.Code length] > 0)
        {
            [newDic setObject:self.Code
                       forKey:@"Code"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    CQGetAirlinesResponse *respose = [[CQGetAirlinesResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
