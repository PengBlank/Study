//
//  HYLuckyPrizeReq.m
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckyPrizeReq.h"

@implementation HYLuckyPrizeReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kShowHandBaseURL, @"lottery"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.version length] > 0)
        {
            [newDic setObject:self.version
                       forKey:@"version"];
        }
        if ([self.actType length] > 0)
        {
            [newDic setObject:self.actType
                       forKey:@"actType"];
        }
        if ([self.lotteryCode length] > 0)
        {
            [newDic setObject:self.lotteryCode
                       forKey:@"lotteryCode"];
        }
        if ([self.page length] > 0)
        {
            [newDic setObject:self.page
                       forKey:@"page"];
        }
        if ([self.pageSize length] > 0)
        {
            [newDic setObject:self.pageSize
                       forKey:@"pageSize"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYLuckyPrizeResp *respose = [[HYLuckyPrizeResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end

@implementation HYLuckyPrizeResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *items = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *array = GETOBJECTFORKEY(items, @"items", [NSArray class]);
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in array)
        {
            HYLuckyPrize *p = [[HYLuckyPrize alloc]initWithDictionary:obj
                                                                     error:nil];
            
            if (p)
            {
                [tempArr addObject:p];
            }
        }
        
        self.prizeList = tempArr;
    }
    
    return self;
}

@end
