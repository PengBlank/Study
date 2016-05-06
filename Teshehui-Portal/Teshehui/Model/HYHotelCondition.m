//
//  HYHotelCondition.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelCondition.h"
#import "HYHotelCommercialInfo.h"
#import "HYHotelDistrictInfo.h"
#import "HYHotelDistance.h"

//static ConditionType alltypes[] = {
//    HotelConditionCommercial,
//    HotelConditionDistrict,
//    HotelConditionPrice,
//    HotelConditionStar,
//    HotelConditionDistance,
//    HotelConditionService
//};

//static int all_types_count = 6;

@interface HYHotelCondition ()
{
}


@end

@implementation HYHotelCondition

- (id)init
{
    self = [super init];
    
    if (self)
    {
    }
    
    return self;
}

- (NSArray *)getConditionListWithType:(ConditionType)cType
{
    NSMutableArray *typeShow = [NSMutableArray array];
    if (cType & HotelConditionCommercial)
    {
        [typeShow addObject:@"商业区"];
    }
    if (cType & HotelConditionDistrict) {
        [typeShow addObject:@"行政区"];
    }
    if (cType & HotelConditionDistance) {
        [typeShow addObject:@"距离"];
    }
    if (cType & HotelConditionService) {
        [typeShow addObject:@"服务"];
    }
    if (cType & HotelConditionPrice) {
        [typeShow addObject:@"价格"];
    }
    if (cType & HotelConditionStar) {
        [typeShow addObject:@"星级"];
    }
    return typeShow;
}

- (NSArray *)getSubConditionListWithType:(ConditionType)subType
{
    NSArray *array = nil;
    switch (subType)
    {
        case HotelConditionPrice:
            array = [HYHotelPrice priceMapping];
            break;
        case HotelConditionStar:
            array = [HYHotelStar starShowMapping];
            break;
        case HotelConditionCommercial:  //商业区
        {
            //从缓存读取数据
            array = [self.cityInfo commercialList];
        }
            break;
        case HotelConditionDistrict:  //行政区
        {
            //从缓存读取数据
            array = [self.cityInfo districtList];
        }
            break;
        case HotelConditionDistance:  //距离
        {
            array = [HYHotelDistance hotelDistanceSource];
        }
            break;
        case HotelConditionService:  //配套服务
        {
            array = @[@"不限",
                      @"WIFI无线上网",
                      @"停车场"];
        }
            break;
        default:
            break;
    }
    
    return array;
}

- (void)selectConditionType:(ConditionType)ctype atIndex:(NSInteger)idx
{
    switch (ctype) {
        case HotelConditionCommercial:
        {
            if (idx < self.cityInfo.commercialList.count)
            {
                self.commercialIndex = idx;
                self.districtIndex = 0;
            }
            break;
        }
        case HotelConditionDistrict:
        {
            if (idx < self.cityInfo.districtList.count)
            {
                self.districtIndex = idx;
                self.commercialIndex = 0;
            }
            break;
        }
        case HotelConditionDistance:
            self.distance = [HYHotelDistance hotelDistanceWithIndex:idx];
            break;
        case HotelConditionPrice:
        {
            HYHotelPrice *price = [[HYHotelPrice alloc] init];
            price.priceLevel = idx;
            self.hotelPrice = price;
            break;
        }
        case HotelConditionStar:
            break;
        default:
            break;
    }
}

#pragma mark - 价格和星级


- (NSString *)showPriceLevel
{
    return self.hotelPrice.priceDesc;
}


/**
 *  @brief  显示星级，类似"二星及以下/经济、三星级/舒适"的方式显示
 *
 *  @return 
 */
- (NSString *)showStar
{
    if (self.hotelStars.count > 0)
    {
        NSMutableString *display = [NSMutableString string];
        for (HYHotelStar *hotelstar in self.hotelStars)
        {
            [display appendFormat:@"%@、", hotelstar.starDesc];
        }
        if (display.length > 0) {
            [display deleteCharactersInRange:NSMakeRange(display.length-1, 1)];
        }
        return display;
    }
    return nil;
}

- (NSString *)showPriceAndStar
{
    NSString *display = @"";
    if (self.hotelPrice && _hotelPrice.priceLevel > 0)
    {
        display = [self showPriceLevel];
    }
    if (self.hotelStars.count > 0)
    {
        if (display.length > 0) {
            display = [display stringByAppendingString:@"、"];
        }
        display = [display stringByAppendingFormat:@"%@", [self showStar]];
    }
    return display;
}
//星级对应的酒店种类
- (NSArray *)hotelTypes
{
    NSDictionary *hotelStarToTypeMap = @{@5:@[@"10", @"11"],
                                         @4:@[@"20", @"21"],
                                         @3:@[@"30", @"31"],
                                         @2:@[@"40", @"41"]};
    NSMutableArray *ret = [NSMutableArray array];
    for (HYHotelStar *hotelstar in self.hotelStars)
    {
        id types = [hotelStarToTypeMap objectForKey:@(hotelstar.star)];
        if (types)
        {
            [ret addObjectsFromArray:types];
        }
    }
    return ret;
}

- (HYHotelDistance *)distance
{
    if (!_distance)
    {
        _distance = [HYHotelDistance hotelDistanceWithIndex:3];
    }
    return _distance;
}

- (HYHotelCommercialInfo *)commercialInfo
{
    if (_cityInfo.commercialList.count > _commercialIndex && _commercialIndex != 0)
    {
        return [_cityInfo.commercialList objectAtIndex:_commercialIndex];
    }
    return nil;
}

- (HYHotelDistrictInfo *)districtInfo
{
    if (_cityInfo.districtList.count > _districtIndex && _districtIndex != 0)
    {
        return [_cityInfo.districtList objectAtIndex:_districtIndex];
    }
    return nil;
}

/**
 *  @brief  该条件是否是单选
 *
 *  @param cType
 *
 *  @return
 */
+ (BOOL)conditionIsSigleSelect:(ConditionType)cType
{
    BOOL ret = NO;
    switch (cType) {
        case HotelConditionPrice:
        case HotelConditionCommercial:
        case HotelConditionDistrict:
        case HotelConditionDistance:
            ret = YES;
            break;
        default:
            break;
    }
    return ret;
}

/************************/


/*
 self.prices =
 self.stars =
 */

- (void)clearLocationInfos
{
    self.distance = nil;
    self.commercialInfo = nil;
    self.districtInfo = nil;
}

@end
