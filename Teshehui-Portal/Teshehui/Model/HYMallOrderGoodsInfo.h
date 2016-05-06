//
//  HYMallOrderGoodsInfo.h
//  Teshehui
//
//  Created by RayXiang on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGoodsInfo.h"
#import "HYMallGoodCommentInfo.h"
#import "HYMallOrderItem.h"

@protocol HYMallOrderGoodsInfo <NSObject>

@end

@interface HYMallOrderGoodsInfo : HYMallGoodsInfo

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *cost_price;
@property (nonatomic, copy) NSString *marketing_price;
//@property (nonatomic, copy) NSString *evaluation;
//@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *credit_value;
@property (nonatomic, assign) NSInteger serviceStatus;  //售后服务的状态
@property (nonatomic, assign) HYOrderGoodsEvaluationStatus evaluable;  //评价状态 0:不可评价,1:可评价,2:可追评

@property (nonatomic, copy) NSString *indemnityId;  //赔付的id
@property (nonatomic, assign) HYIndemnityStatus indemnityStatus;  //赔付的状态 

/**
 *  评价
 */
@property (nonatomic, strong) HYMallGoodCommentInfo *commentInfo;

@property (nonatomic, assign) BOOL is_valid;

@end
