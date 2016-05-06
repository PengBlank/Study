//
//  HYHotelCondition.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店的筛选条件
 */

#import <Foundation/Foundation.h>
#import "HYHotelCityInfo.h"
#import "HYHotelCommercialInfo.h"
#import "HYHotelDistrictInfo.h"
#import "HYHotelDistance.h"
#import "HYHotelPrice.h"
#import "HYHotelStar.h"

@class HYHotelCondition;
@protocol HYHotelConditionChangeDelegate <NSObject>

- (void)hotelConditionChanged:(HYHotelCondition *)condition;

@end

typedef enum _ConditionType
{
    HotelConditionCommercial =  1 << 0,
    HotelConditionDistrict  =   1 << 1,
    HotelConditionPrice =       1 << 2,
    HotelConditionStar      =   1 << 3,
    HotelConditionDistance  =   1 << 4,
    HotelConditionService   =   1 << 5
}ConditionType;

@interface HYHotelCondition : NSObject

@property (nonatomic, strong) HYHotelCityInfo *cityInfo;
@property (nonatomic, assign) NSInteger commercialIndex;
@property (nonatomic, assign) NSInteger districtIndex;

@property (nonatomic, copy) NSString *keyword;  // 搜索的关键字

@property (nonatomic, assign) BOOL searchNear;  //是否搜索附近酒店
@property (nonatomic, strong) NSNumber *DotX;  //点选的纬度
@property (nonatomic, strong) NSNumber *DotY;  //点选的经度

//左右、右边
- (NSArray *)getConditionListWithType:(ConditionType)cType;
- (NSArray *)getSubConditionListWithType:(ConditionType)subType;
//选择
- (void)selectConditionType:(ConditionType)ctype atIndex:(NSInteger)idx;


//获得已选的商业区、行政区
@property (nonatomic, strong) HYHotelCommercialInfo *commercialInfo;
@property (nonatomic, strong) HYHotelDistrictInfo *districtInfo;

/*
 * 星级和价格
 */
@property (nonatomic, strong) NSString *showPriceLevel; //价格显示
@property (nonatomic, strong) HYHotelPrice *hotelPrice;

@property (nonatomic, strong) NSString *showStarLevels;     //星级显示
@property (nonatomic, strong) NSMutableArray *hotelStars;   //星级

@property (nonatomic, strong) NSString *showPriceAndStar;   //一起显示。。。。

@property (nonatomic, strong) NSArray *hotelTypes;      //已选择的酒店类型，由星级决定

/*
 * 距离
 */
@property (nonatomic, strong) HYHotelDistance *distance;

/*
 * 清除地理位置信息
 */
- (void)clearLocationInfos;

@end
