//
//  HYGoodCategoryRequest.h
//  Teshehui
//
//  Created by RayXiang on 14-9-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYGoodCategoryResponse.h"

/**
 *  商品分类请求
 */
@interface HYGoodCategoryRequest : CQBaseRequest

@property (nonatomic, assign) NSInteger num_per_page;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString* category_id;
@property (nonatomic, assign) NSInteger level;

@end
