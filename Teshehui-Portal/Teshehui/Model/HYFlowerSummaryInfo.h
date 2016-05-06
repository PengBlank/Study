//
//  HYFlowerSummaryInfo.h
//  Teshehui
//
//  Created by HYZB on 15/5/14.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYFlowerSummaryInfo : JSONModel

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productPicUrl;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) CGFloat stock;

@property (nonatomic, copy) NSString* flowerLanguage;

@end
