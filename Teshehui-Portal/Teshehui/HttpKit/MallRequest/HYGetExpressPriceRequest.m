//
//  HYGetExpressPrice.m
//  Teshehui
//
//  Created by HYZB on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetExpressPriceRequest.h"

@implementation HYGetExpressPriceRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/cart/get_express_list"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.address_id length] > 0)
        {
            [newDic setObject:self.address_id forKey:@"address_id"];
        }
        
        if ([self.shipping_id length] > 0)
        {
            [newDic setObject:self.shipping_id forKey:@"shipping_id"];
        }
        
        if ([self.store_id length] > 0)
        {
            [newDic setObject:self.store_id forKey:@"store_id"];
        }
        
        if ([self.goods_id length] > 0)
        {
            [newDic setObject:self.goods_id forKey:@"goods_id"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetExpressPriceResponse *respose = [[HYGetExpressPriceResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
