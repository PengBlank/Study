//
//  HYActivityCategoryRequest.h
//  Teshehui
//
//  Created by RayXiang on 14-8-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYGetActivityListResponse.h"

/**
 *  活动分类列表
 *  返回所有分类，及分类下的商品
 */
@interface HYGetActivityListRequest : CQBaseRequest

@property (nonatomic, strong) NSString *activityCode;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

- (id)initReqWithParamStr:(NSString *)paramStr;

@end
