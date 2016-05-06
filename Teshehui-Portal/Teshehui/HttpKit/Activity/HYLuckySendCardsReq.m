//
//  HYLuckySendCardsReq.m
//  Teshehui
//
//  Created by HYZB on 15/3/5.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckySendCardsReq.h"

@implementation HYLuckySendCardsReq

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
        if ([self.userId length] > 0)
        {
            [newDic setObject:self.userId
                       forKey:@"userId"];
        }
        
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
        
        [newDic setObject:[NSNumber numberWithInteger:_cardCount]
                   forKey:@"cardCount"];
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYLuckySendCardsResp *respose = [[HYLuckySendCardsResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end

@implementation HYLuckySendCardsResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.userId = GETOBJECTFORKEY(data, @"userId", [NSString class]);
        self.userName = GETOBJECTFORKEY(data, @"userName", [NSString class]);
        self.userCode = GETOBJECTFORKEY(data, @"userCode", [NSString class]);
        self.takeCardTime = GETOBJECTFORKEY(data, @"takeCardTime", [NSString class]);
        self.currentRank = GETOBJECTFORKEY(data, @"currentRank", [NSString class]);
        self.cardRules = GETOBJECTFORKEY(data, @"cardRules", [NSString class]);
        self.lotteryCode = GETOBJECTFORKEY(data, @"lotteryCode", [NSString class]);
        self.lotteryTypeCode = GETOBJECTFORKEY(data, @"lotteryTypeCode", [NSString class]);
        
        NSDictionary *priz = GETOBJECTFORKEY(data, @"prizes", [NSString class]);
        self.prizes = [[HYLuckyPrize alloc] initWithDictionary:priz error:nil];
        
        NSArray *array = GETOBJECTFORKEY(data, @"cards", [NSArray class]);
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in array)
        {
            HYLuckyCards *result = [[HYLuckyCards alloc]initWithDictionary:obj
                                                                     error:nil];
            
            if (result)
            {
                [tempArr addObject:result];
            }
        }
        
        self.cardsList = (id)tempArr;
    }
    
    return self;
}

@end
