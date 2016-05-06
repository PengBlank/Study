//
//  HYHotelInfoBase.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYProductListSummary.h"

@interface HYHotelListSummary : HYProductListSummary

@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *hotelStar;
@property (nonatomic, copy) NSString *hotelType;
@property (nonatomic, copy) NSString *districtName;   //商业区ID
@property (nonatomic, copy) NSString *commercialName;   //商业区名称
@property (nonatomic, assign) NSInteger wifi;   //有值表示存在(>-1),false免费(0), true收费(1)
@property (nonatomic, assign) NSInteger park;    //有值表示存在(>-1),false免费(0), true收费(1)
@property (nonatomic, copy) NSString *score;   //酒店评分
@property (nonatomic, copy) NSString *bigLogoUrl;   //酒店的图
@property (nonatomic, copy) NSString *midLogoUrl;   //酒店的图
@property (nonatomic, copy) NSString *smallLogoUrl;   //酒店的图
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (nonatomic, copy) NSString *positionTypeCode;

@end

//{
//    "productId":"69035",
//    "productName":"深圳雅枫国际酒店",
//    "productPicUrl":null,
//    "currencyCode":null,
//    "price":500,
//    "points":null,
//    "expandedResponse":{
//        "cityId":"1451",
//        "address":"福田区景田东路图书馆大厦 近红荔西路",
//        "hotelStar":"四星级",
//        "hotelType":"豪华型",
//        "districtName":"福田区",
//        "commercialName":"会展中心、福田CBD",
//        "park":0,
//        "wifi":0,
//        "score":4.2,
//        "smallLogoUrl":"http://www.elongstatic.com/gp1/M00/89/57/pIYBAFIsJEaAI4CQAAAjDDBGkU0985.png?v=20121227142500",
//        "midLogoUrl":"http://www.elongstatic.com/gp1/M00/6D/61/pIYBAFIsJEaAOv2GAACY8lgj3_4723.jpg?v=20121227142500",
//        "bigLogoUrl":"http://www.elongstatic.com/gp1/M00/40/15/pYYBAFIsJEaAChWrAAH2xkFGALY034.png?v=20120712164136",
//        "latitude":22.550960195,
//        "longitude":114.046048075,
//        "positionTypeCode":1
//    }
/*
 "productId":"69035",
 "productName":"深圳雅枫国际酒店",
 "productPicUrl":"http://www.elongstatic.com/gp1/M00/6D/61/pIYBAFIsJEaAOv2GAACY8lgj3_4723.jpg?v=20121227142500",
 "currencyCode":null,
 "price":500,
 "points":null,
 "expandedResponse":{
 "cityId":"1451",
 "address":"福田区景田东路图书馆大厦 近红荔西路",
 "price":null,
 "hotelStar":"四星级",
 "hotelType":"豪华型",
 "districtName":"福田区",
 "commercialName":"会展中心、福田CBD",
 "park":0,
 "wifi":0,
 "score":4.199999809265137,
 "smallLogoUrl":"http://www.elongstatic.com/gp1/M00/89/57/pIYBAFIsJEaAI4CQAAAjDDBGkU0985.png?v=20121227142500",
 "midLogoUrl":"http://www.elongstatic.com/gp1/M00/6D/61/pIYBAFIsJEaAOv2GAACY8lgj3_4723.jpg?v=20121227142500",
 "bigLogoUrl":"http://www.elongstatic.com/gp1/M00/40/15/pYYBAFIsJEaAChWrAAH2xkFGALY034.png?v=20120712164136",
 "latitude":22.550960195,
 "longitude":114.046048075,
 "positionTypeCode":1
 }
 */