//
//  HYComparePriceRequest.m
//  Teshehui
//
//  Created by Kris on 15/9/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYComparePriceRequest.h"
#import "HYComparePriceResponse.h"
#import "JSONKit_HY.h"

@implementation HYComparePriceRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"product/productSKUCompare.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([_productId length] > 0)
        {
            NSDictionary *dict = @{@"productId":_productId};
            NSString *data = [dict JSONString];
            if ([data length] > 0)
            {
                [newDic setObject:data forKey:@"data"];
            }
        }
    }
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYComparePriceResponse *respose = [[HYComparePriceResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
