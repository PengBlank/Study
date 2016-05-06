//
//  HYForGetRequest.m
//  Teshehui
//
//  Created by ichina on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYForGetRequest.h"
#import "HYForGetResponse.h"

@implementation HYForGetRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/findPasswordFirst.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

//- (NSMutableDictionary *)getDataDictionary
//{
//    if ([self.phone_mob length] > 0)
//    {
//        NSMutableDictionary *data = [NSMutableDictionary dictionary];
//        [data setObject:_phone_mob forKey:@"mobile"];
//        return data;
//    }
//    else
//    {
//        return [super getDataDictionary];
//    }
//}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        
        if ([self.phone_mob length] > 0)
        {
            [newDic setObject:self.phone_mob forKey:@"mobile"];
        }
        
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYForGetResponse *respose = [[HYForGetResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
