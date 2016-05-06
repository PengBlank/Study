//
//  CQFilghtOrderQuery.m
//  ComeHere
//
//  Created by ChengQian on 13-11-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtOrderQuery.h"
#import "CQFilghtOrderQueryResponse.h"

@implementation CQFilghtOrderQuery

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = @"http://app.bnx6688.com/AirOrderList/?";
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
        
        [newDic setObject:[NSString stringWithFormat:@"%d", self.page]
                   forKey:@"page"];
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    CQFilghtOrderQueryResponse *respose = [[CQFilghtOrderQueryResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
