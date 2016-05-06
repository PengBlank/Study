//
//  HYGetRechargeGoodsRequest.m
//  Teshehui
//
//  Created by Kris on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYGetRechargeGoodsRequest.h"
#import "HYGetRechargeGoodsResponse.h"
#import "JSONKit_HY.h"

@implementation HYGetRechargeGoodsRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"recharge/getRechargeGoods.action"];
        self.httpMethod = @"POST";
        self.businessType = @"50";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        if (self.typeId.length > 0)
        {
            [tempDict setObject:self.typeId forKey:@"typeId"];
        }
        if (self.catalogId.length > 0)
        {
            [tempDict setObject:self.catalogId forKey:@"catalogId"];
        }
        if (self.mobilePhone.length > 0)
        {
            [tempDict setObject:self.mobilePhone forKey:@"mobilePhone"];
        }
        if (tempDict)
        {
            NSString *data = [tempDict JSONString];
            if (data.length > 0)
            {
                [newDic setObject:data forKey:@"data"];
            }
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetRechargeGoodsResponse *respose = [[HYGetRechargeGoodsResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
