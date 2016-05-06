//
//  HYLuckyList.m
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckyListReq.h"

//http://www.t.teshehui.com:18081
//http://search.teshehui.com:18082

@implementation HYLuckyListReq

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
        if ([self.lotteryTypeCode length] > 0)
        {
            [newDic setObject:self.lotteryTypeCode
                       forKey:@"lotteryTypeCode"];
        }
        if ([self.lotteryStatus length] > 0)
        {
            [newDic setObject:self.lotteryStatus
                       forKey:@"lotteryStatus"];
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
    HYLuckyListResp *respose = [[HYLuckyListResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end

@implementation HYLuckyListResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        NSArray *item = GETOBJECTFORKEY(data, @"items", [NSArray class]);
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in item)
        {
            HYLuckyInfo *p = [[HYLuckyInfo alloc] initWithDictionary:obj
                                                                error:nil];
            
            if (p)
            {
                [tempArr addObject:p];
            }
        }
        
        self.luckyList = tempArr;
    }
    
    return self;
}

@end
