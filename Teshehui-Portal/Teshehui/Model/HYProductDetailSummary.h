//
//  HYMallProductSummary.h
//  Teshehui
//
//  Created by HYZB on 15/5/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//


/*
 *产品的基础信息， 包括鲜花
 */

#import "JSONModel.h"
#import "HYProductSKU.h"
#import "HYHotelSKU.h"

@interface HYProductDetailSummary : JSONModel

@property (nonatomic, copy) NSString* businessType;
@property (nonatomic, copy) NSString* productId;
@property (nonatomic, copy) NSString* productCode;
@property (nonatomic, copy) NSString* productName;
@property (nonatomic, copy) NSString* productEnName;
@property (nonatomic, copy) NSString* attributeName1;
@property (nonatomic, copy) NSString* attributeName2;

@property (nonatomic, strong) NSArray<HYProductSKU> *productSKUArray;

@end
