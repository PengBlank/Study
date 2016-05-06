//
//  HYLuckyCheckOtherReq.m
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckyCheckOtherReq.h"

@implementation HYLuckyCheckOtherReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kShowHandBaseURL, @"showHand"];;
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
        if (self.userId.length > 0)
        {
            [newDic setObject:self.userId forKey:@"userId"];
        }
        if (self.queryAll.length > 0)
        {
            [newDic setObject:self.queryAll forKey:@"queryAll"];
        }
        if (self.queryTime.length > 0)
        {
            [newDic setObject:self.queryTime forKey:@"queryTime"];
        }
        
        [newDic setObject:[NSNumber numberWithInteger:_ifSort]
                   forKey:@"ifSort"];
        [newDic setObject:[NSNumber numberWithInteger:_ifLotteryRank]
                   forKey:@"ifLotteryRank"];
        [newDic setObject:[NSNumber numberWithInteger:_page]
                   forKey:@"page"];
        [newDic setObject:[NSNumber numberWithInteger:_pageCount]
                   forKey:@"pageCount"];
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYLuckyCheckOtherResp *respose = [[HYLuckyCheckOtherResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end

@implementation HYLuckyCheckOtherResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        NSArray *array = GETOBJECTFORKEY(data, @"items", [NSArray class]);
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in array)
        {
            HYLuckyStatusInfo *result = [[HYLuckyStatusInfo alloc]initWithDictionary:obj
                                                                               error:nil];
            
            if (result)
            {
                [tempArr addObject:result];
            }
        }
        
        self.items = tempArr;
    }
    
    return self;
}

@end
