//
//  HYMallSearchGoodInfo.h
//  Teshehui
//
//  Created by ichina on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 商品搜索信息
 */

#import "JSONModel.h"
#import "HYImageInfo.h"

@interface HYProductListSummary : JSONModel

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productPicUrl;
@property (nonatomic, copy) NSString *productVideoUrl;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, copy) NSString *price;
// 原价
@property (nonatomic, copy) NSString *marketPrice;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) NSInteger stock;

// 新增返现字段
 @property (nonatomic, copy) NSString *returnAmount;

@property (nonatomic, strong) HYImageInfo *productImage;

- (id)initWithJsonData:(NSDictionary *)dict;

@end