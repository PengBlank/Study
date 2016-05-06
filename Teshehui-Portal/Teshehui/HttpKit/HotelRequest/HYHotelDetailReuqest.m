//
//  HYHotelDetailReuqest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelDetailReuqest.h"
#import "HYHotelDetailResponse.h"
#import "JSONKit_HY.h"

@implementation HYHotelDetailReuqest

- (id)init
{
    self = [super init];
    
    if (self)
    {
//        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kHotelRequestBaseURL, @"api/hotels/hotel_product_list"];
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"product/getProductInfo.action"];
        self.httpMethod = @"POST";
        self.businessType = @"03";
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
        
        //酒店详情相关的扩展请求参数
        NSMutableDictionary *expandedRequest = [NSMutableDictionary dictionary];
        
        [expandedRequest setObject:self.startDate forKey:@"startDate"];
        [expandedRequest setObject:self.endDate forKey:@"endDate"];
        
        if ([expandedRequest count] > 0)
        {
            NSString *expand = [expandedRequest JSONString];
            [newDic setObject:expand forKey:@"expandedRequest"];
        }
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"酒店详情请求缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYHotelDetailResponse *respose = [[HYHotelDetailResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
