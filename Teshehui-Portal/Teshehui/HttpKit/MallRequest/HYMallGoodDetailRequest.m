//
//  HYMallGoodDetailRequest.m
//  Teshehui
//
//  Created by ichina on 14-2-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGoodDetailRequest.h"
#import "HYMallGoodDetailResponse.h"
#import "JSONKit_HY.h"

 NSString *const HYGoodsDetailBase      = @"01";
 NSString *const HYGoodsDetailDetail    = @"02";
 NSString *const HYGoodsDetailPhoto     = @"03";
 NSString *const HYGoodsDetailSKU       = @"04";

@implementation HYMallGoodDetailRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"product/getProductInfo.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
//        self.dataType = 2;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.productId length] > 0)
        {
            [newDic setObject:self.productId forKey:@"productId"];
        }
        
        if (self.userId)
        {
            [newDic setObject:self.userId forKey:@"userId"];
        }
        
        if (self.dataType.count > 0)
        {
            NSString *json = [_dataType JSONString];
            if (json.length > 0)
            {
                [newDic setObject:json forKey:@"dataType"];
            }
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallGoodDetailResponse *respose = [[HYMallGoodDetailResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
