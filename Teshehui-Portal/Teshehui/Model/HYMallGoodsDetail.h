//
//  HYMallGoodsDetail.h
//  Teshehui
//
//  Created by HYZB on 15/5/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductDetailSummary.h"

@interface HYMallGoodsDetail : HYProductDetailSummary

@property (nonatomic, copy) NSString* productDescription;
@property (nonatomic, copy) NSString* storeId;
@property (nonatomic, copy) NSString* storeName;
@property (nonatomic, copy) NSString* storeEnName;
@property (nonatomic, copy) NSString* storePhone;
@property (nonatomic, copy) NSString* brandId;
@property (nonatomic, copy) NSString* brandName;

@property (nonatomic, copy) NSString* categoryId;
@property (nonatomic, copy) NSString* categoryName;
@property (nonatomic, copy) NSString* categoryEnName;
@property (nonatomic, copy) NSString* builtPlaceId;
@property (nonatomic, copy) NSString* builtPlaceName;
@property (nonatomic, copy) NSString* builtPlaceEnName;
@property (nonatomic, copy) NSString* productOrderUrl;
@property (nonatomic, copy) NSString* discount;
@property (nonatomic, assign) BOOL isPraise;
@property (nonatomic, copy) NSString* praiseCount;
@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, copy) NSString* collectCount;
@property (nonatomic, copy) NSString* score;
@property (nonatomic, copy) NSString* commentCount;
@property (nonatomic, copy) NSString* saleCount;
@property (nonatomic, copy) NSString* viewCount;
@property (nonatomic, copy) NSString* productVideoUrl;
@property (nonatomic, copy) NSString* productVideoUrlThumbnail;
@property (nonatomic, copy) NSString* isSupportExpensive;
@property (nonatomic, copy) NSString* favorCount;

@property (nonatomic, strong) HYProductSKU *currentsSUK;

@property (nonatomic, assign) NSInteger selectAtt1Index;
@property (nonatomic, assign) NSInteger selectAtt2Index;

@property (nonatomic, assign, readonly) CGFloat attributeHeigth;
@property (nonatomic, strong, readonly) NSArray *bigImgList;
@property (nonatomic, strong, readonly) NSArray *midImgList;
@property (nonatomic, strong, readonly) NSArray *smallImgList;
@property (nonatomic, strong, readonly) NSArray *attribute1List;

// 海淘增加字段
// supplierType：01   普通类型    06    海淘类型（String）
@property (nonatomic, strong) NSString *supplierType;

- (NSArray *)attributeWithId:(NSString *)attributeId;
- (id)initWithDictionary:(NSDictionary *)dict;

- (NSString *)skuDesc;

- (void)setCurrentSKUWithSKUId:(NSString *)skuId;

@end


/*
 {
 "businessType":"01",
 "productId":"1166",
 "productCode":null,
 "productName":"手机精灵",
 "productEnName":"",
 "attributeName1":"",
 "attributeName2":"",
 "expandedResponse":{
 "productDescription":null,
 "storeId":"306",
 "storeName":"vanst智能家居",
 "storeEnName":null,
 "storePhone":null,
 "brandId":"",
 "brandName":"VANST",
 "brandEnName":"",
 "categoryId":"4419",
 "categoryName":"家电、家装	大家电	家电配件",
 "categoryEnName":null,
 "builtPlaceId":"",
 "builtPlaceName":"",
 "builtPlaceEnName":null,
 "productOrderUrl":null,
 "discount":null,
 "isPraise":null,
 "praiseCount":null,
 "isCollect":null,
 "collectCount":null,
 "score":null,
 "commentCount":0,
 "saleCount":0,
 "viewCount":568
 },
 "productSKUArray":[
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
 ]
 }
*/