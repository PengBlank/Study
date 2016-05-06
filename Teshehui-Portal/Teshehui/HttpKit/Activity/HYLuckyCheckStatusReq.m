//
//  HYLuckyRuleReq.m
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckyCheckStatusReq.h"

@implementation HYLuckyCheckStatusReq

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
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYLuckyCheckStatusResp *respose = [[HYLuckyCheckStatusResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end

@implementation HYLuckyCheckStatusResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.userId = GETOBJECTFORKEY(data, @"userId", [NSString class]);
        self.userCode = GETOBJECTFORKEY(data, @"userCode", [NSString class]);
        self.usedNumber = GETOBJECTFORKEY(data, @"usedNumber", [NSString class]);
        self.lotteryNumber = GETOBJECTFORKEY(data, @"lotteryNumber", [NSString class]);
        self.lotteryCode = GETOBJECTFORKEY(data, @"lotteryCode", [NSString class]);
        self.lotteryTypeCode = GETOBJECTFORKEY(data, @"lotteryTypeCode", [NSString class]);
        NSArray *array = GETOBJECTFORKEY(data, @"userCardList", [NSArray class]);
        
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
        
        self.userCardList = tempArr;
    }
    
    return self;
}

@end
