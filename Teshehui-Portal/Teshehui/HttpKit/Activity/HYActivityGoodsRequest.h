//
//  HYActivityGoodsRequest.h
//  Teshehui
//
//  Created by RayXiang on 14-8-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYActivityGoodsResponse.h"
#import "HYActivityGoods.h"

/**
 *  活动商品列表（根据一级分类取得所有该分类下的商品）
 */
@interface HYActivityGoodsRequest : CQBaseRequest

@property (nonatomic, strong) NSString *activityCode;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

- (id)initReqWithParamStr:(NSString *)paramStr;

@end
