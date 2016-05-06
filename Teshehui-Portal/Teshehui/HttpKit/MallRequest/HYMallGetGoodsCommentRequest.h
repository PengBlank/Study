//
//  HYMallGetGoodsCommentRequest.h
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *  获取评价
 */
#import "CQBaseRequest.h"
#import "HYMallGetGoodsCommentResponse.h"

@interface HYMallGetGoodsCommentRequest : CQBaseRequest

@property (nonatomic, copy) NSString* goods_id;
@property (nonatomic, assign) NSInteger num_per_page;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *userid;

@end
