//
//  HYMallSearchGoodInfo.m
//  Teshehui
//
//  Created by ichina on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYProductListSummary.h"
#import "HYFlowerListSummary.h"
#import "HYHotelListSummary.h"
#import "HYFlightListSummary.h"

@implementation HYProductListSummary

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (id)initWithJsonData:(NSDictionary *)dict
{
    NSMutableDictionary *tempdec = [[NSMutableDictionary alloc]initWithDictionary:dict];
    NSDictionary *expand = [dict objectForKey:@"expandedResponse"];
    if ([expand count] > 0)
    {
        [tempdec addEntriesFromDictionary:expand];
        [tempdec removeObjectForKey:@"expandedResponse"];
    }
    
    if ([tempdec objectForKey:@"flowerLanguage"]) // 鲜花
    {
        self = (HYProductListSummary *)[[HYFlowerListSummary alloc] initWithDictionary:tempdec
                                                                                 error:nil];
    }
    else if ([tempdec objectForKey:@"hotelType"]) //酒店
    {
        self = (HYProductListSummary *)[[HYHotelListSummary alloc] initWithDictionary:tempdec
                                                                                 error:nil];
    }
    else if ([tempdec objectForKey:@"flightNo"]) //机票
    {
        self = (HYProductListSummary *)[[HYFlightListSummary alloc] initWithDictionary:tempdec
                                                                                error:nil];
    }
    else
    {
        self = [super initWithDictionary:tempdec
                                   error:nil];
    }
    return self;
}

- (NSString *)productPicUrl
{
    if (!_productPicUrl)
    {
        _productPicUrl = [self.productImage defaultURL];
    }
    
    return _productPicUrl;
}

@end
