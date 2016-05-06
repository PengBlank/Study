//
//  HYMallGuessFavoriteRequest.h
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *  获取猜你喜欢
 */
#import "CQBaseRequest.h"
#import "HYMallGuessFavoriteResponse.h"

@interface HYMallGuessFavoriteRequest : CQBaseRequest

@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *brandCode;
@property (nonatomic, copy) NSString *categoryCode;
@property (nonatomic, assign) NSInteger maxRows;
@property (nonatomic, copy) NSString *recType;

@end


/*
 业务类型（businessType）
 用户标识（userId）
 品牌编码（productCode）
 品牌编码（brandCode）
 分类编码（categoryCode）
 最大返回记录数（maxRows）
 推荐类型 1:搜索推荐;2:店长推荐;3:猜你喜欢;4:推荐商品(recType)
*/