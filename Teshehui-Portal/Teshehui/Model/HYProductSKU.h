//
//  HYMallGoodsSKU.h
//  Teshehui
//
//  Created by HYZB on 15/5/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYImageInfo.h"

@protocol HYProductSKU @end

@interface HYProductSKU : JSONModel

@property (nonatomic, copy) NSString* productSKUId;
@property (nonatomic, copy) NSString* attributeValue1;
@property (nonatomic, copy) NSString* attributeValue2;
@property (nonatomic, copy) NSArray<HYImageInfo>* productSKUImagArray;
@property (nonatomic, assign) BOOL isMajor;
@property (nonatomic, copy) NSString* currencyCode;
@property (nonatomic, copy) NSString* marketPrice;
@property (nonatomic, copy) NSString* discountRate;
@property (nonatomic, copy) NSString* price;
@property (nonatomic, copy) NSString* points;

// 新增返现金额字段
@property (nonatomic, copy) NSString *returnAmount;

@property (nonatomic, copy) NSString* totalPrice;
@property (nonatomic, copy) NSString* totalPoint;
@property (nonatomic, copy) NSString *totalMarketPrice;
@property (nonatomic, copy) NSString* stock;

@property (nonatomic, assign) NSUInteger quantity;  //数量

- (void)sortSKUImagArray;

@end

/*
 {
 "productSKUId":"1664",
 "attributeValue1":"",
 "attributeValue2":"",
 "bigPicUrlArray":[
 
 ],
 "midPicUrlArray":[
 
 ],
 "smallPicUrlArray":[
 
 ],
 "isMajor":null,
 "currencyCode":"RMB",
 "marketPrice":"1438.00",
 "price":1320,
 "points":118,
 "stock":10000
 }
 */