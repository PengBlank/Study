//
//  HYGoodCategoryResponse.h
//  Teshehui
//
//  Created by RayXiang on 14-9-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallCategoryInfo.h"

/**
 *  商品分类返回
 */
@interface HYGoodCategoryResponse : CQBaseResponse

@property (nonatomic, strong) HYMallCategoryInfo *category;

@end
