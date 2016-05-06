//
//  HYHotelSearchReuqest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店搜索接口
 */

#import "CQBaseRequest.h"
#import "HYHotelCondition.h"

typedef enum _HotelOrderType
{
    DEFAULT = 1,
    Price_ASC,
    Price_DESC,
    Distance_ASC,
    Name
}HotelOrderType;


@interface HYHotelSearchReuqest : CQBaseRequest

//必须字段
@property (nonatomic, assign) NSInteger pageSize;  //单页请求条数，最大100
@property (nonatomic, assign) NSInteger pageNo;  //请求的页码

@property (nonatomic, copy) NSString *cityId;  //城市的ID
@property (nonatomic, copy) NSString *startDate;  //入住时间
@property (nonatomic, copy) NSString *endDate;  //离店时间

//可选字段
@property (nonatomic, copy) NSString *searchType;  //关键字类型（文本过滤查询类型（hotelAddress,hotelBrand,hotelName））
@property (nonatomic, copy) NSString *keyword;  //String	文本过滤内容（当此项不为空时，查询类型若未赋值则为名称）
@property (nonatomic, copy) NSString *districtId;  //String	行政区名称
@property (nonatomic, copy) NSString *commercialId;  //FLOAT	商业区名称
//@property (nonatomic, copy) NSString *hotelStar;  //酒店星级（多个数字用","分隔）
@property (nonatomic, copy) NSString *lowPrice;  //最低价格
@property (nonatomic, copy) NSString *highPrice;  //最高价格

@property (nonatomic, copy) NSString *orderBy; //排序字段(10:销量，11：价格，12：上架时间)
@property (nonatomic, assign) HotelOrderType orderType;  //STRING	升降顺序，ASC/DESC
@property (nonatomic, copy) NSString *order;  //STRING	排序字段, （recommend,priceAsc,priceDesc,distanceAsc）

@property (nonatomic, assign) double latitude;  //点选的纬度
@property (nonatomic, assign) double longitude;  //点选的经度
//@property (nonatomic, assign) float distance;  //点选的半径
//@property (nonatomic, copy) NSString *distanceUnit;  //STRING

@property (nonatomic, strong) HYHotelCondition *condition;

@end

