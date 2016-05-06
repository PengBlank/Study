//
//  HYHotelPrice.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-13.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelPrice.h"

static NSArray *__priceMapping = nil;
static CGFloat __lpriceMapping[7] = {-1,            0, 150, 301, 451, 600, 1000};
static CGFloat __hpriceMapping[7] = {CGFLOAT_MAX, 150, 300, 450, 600, 1000, CGFLOAT_MAX};

@implementation HYHotelPrice

- (void)setPriceLevel:(NSInteger)priceLevel
{
    if (_priceLevel != priceLevel && priceLevel > -1 && priceLevel < 7)
    {
        _priceLevel = priceLevel;
    }
}

- (NSString *)priceDesc
{
    return [[self class] priceMapping][_priceLevel];
}

- (CGFloat)hPrice
{
    return __hpriceMapping[_priceLevel];
}

- (CGFloat)lPrice
{
    return __lpriceMapping[_priceLevel];
}

+ (NSArray *)priceMapping
{
    if (!__priceMapping)
    {
        __priceMapping = @[@"不限", @"¥150以下", @"¥150-¥300", @"¥301-¥450", @"¥451-¥600", @"¥601-¥1000", @"¥1000以上"];
    }
    return __priceMapping;
}

+ (NSString *)priceDescWithLevel:(NSInteger)level
{
    if (level > -1 && level < 7)
    {
        return [self priceMapping][level];
    }
    return nil;
}

+ (instancetype)hotelPriceWithPriceLevel:(NSInteger)level
{
    HYHotelPrice *price = [[HYHotelPrice alloc] init];
    price.priceLevel = level;
    return price;
}


/*
 array = @[@"不限",
 @"￥150以下",
 @"￥150-￥300",
 @"￥301-￥450",
 @"￥451-￥600",
 @"￥600-￥1000",
 @"￥1000以上"];
 */
@end
