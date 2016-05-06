//
//  HYMallSearchGoodResponse.h
//  Teshehui
//
//  Created by HYZB on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYProductListSummary.h"
#import "HYMallCategoryInfo.h"
#import "HYBrandSummary.h"
#import "HYMallBrandStory.h"

@interface HYMallSearchGoodResponse : CQBaseResponse

@property (nonatomic, strong) NSArray *searchGoodArray;
@property (nonatomic, strong) NSArray *subCategroy;
@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, copy) NSString *priceRangDesc;
@property (nonatomic, strong) HYMallCategoryInfo *parentCategroy;
@property (nonatomic, strong) HYMallCategoryInfo *curCategroy;
@property (nonatomic, strong) HYBrandSummary *brandInfo;
@property (nonatomic, strong) HYMallBrandStory *brandBo;


@end
