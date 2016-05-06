//
//  HYFlowerTypeListRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 鲜花主分类列表请求
 */

#import "CQBaseRequest.h"
#import "HYFlowerTypeListResponse.h"

@interface HYFlowerTypeListRequest : CQBaseRequest

@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *level;

@end
