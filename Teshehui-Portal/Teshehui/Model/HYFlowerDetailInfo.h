//
//  HYFlowerDetailInfo.h
//  Teshehui
//
//  Created by ichina on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYProductDetailSummary.h"
#import "HYProductSKU.h"

@interface HYFlowerDetailInfo : HYProductDetailSummary

@property (nonatomic, copy) NSString *flowerDescription;
@property (nonatomic, copy) NSString *flowerLanguage;
@property (nonatomic, copy) NSString *flowerPicUrl;
@property (nonatomic, copy) NSString *marketPrice;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *points;

@property (nonatomic, strong) HYProductSKU *currentsSUK;

@property (nonatomic, strong, readonly) NSArray *bigImgList;
@property (nonatomic, strong, readonly) NSArray *midImgList;
@property (nonatomic, strong, readonly) NSArray *smallImgList;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
