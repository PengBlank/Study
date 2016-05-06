//
//  HYFlowerTypeListResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 鲜花主分类列表请求返回的response
 */

#import "CQBaseResponse.h"
#import "HYFlowerTypeInfo.h"
/*
 category_id	INT	该分类的ID
 parent_category_id	INT	父分类的ID（1为最上级分类）
 product_type_name	STRING	该分类的名称
 */

@interface HYFlowerTypeListResponse : CQBaseResponse

@property (nonatomic, strong) HYFlowerTypeInfo *flowerInfo;

@end
