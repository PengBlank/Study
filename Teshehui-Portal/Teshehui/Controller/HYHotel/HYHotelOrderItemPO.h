//
//  HYHotelOrderItemPO.h
//  Teshehui
//
//  Created by Kris on 15/5/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol
HYHotelOrderItemPO
@end

@interface HYHotelOrderItemPO : JSONModel
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *gLon;
@property (nonatomic, copy) NSString *gLat;
@property (nonatomic, copy) NSString *gdLon;
@property (nonatomic, copy) NSString *gdLat;
@property (nonatomic, copy) NSString *ratePlanCategory;
@property (nonatomic, copy) NSString *guaranteeType;
@property (nonatomic, copy) NSString *businessType;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productSKUId;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *pictureSmallUrl;
@property (nonatomic, copy) NSString *hotelLogo;

@end
/*
{
    "cityId":0,
    "cityName":"",
    "roomName":"",
    "telephone":"",
    "address":"",
    "lon":"",
    "lat":"",
    "gLon":"",
    "gLat":"",
    "gdLon":"",
    "gdLat":"",
    "hotelLogo":"http://pavo.elongstatic.com/i/Mobile120_120/00008roA.jpg",
    "ratePlanCategory":"14",
    "guaranteeType":"",
    "businessType":"03",
    "productId":0,
    "productCode":"22003091",
    "productName":"深圳爱联好酒店",
    "productSKUId":0,
    "points":168,
    "quantity":0,
    "pictureBigUrl":"http://pavo.elongstatic.com/i/Mobile640_960/00008roA.jpg",
    "pictureSmallUrl":"http://pavo.elongstatic.com/i/Mobile120_120/00008roA.jpg",
    "pictureMiddleUrl":"http://pavo.elongstatic.com/i/API350_350/3a625ac7c8e47e9fadb8877f05ce0343.jpg"
}
*/