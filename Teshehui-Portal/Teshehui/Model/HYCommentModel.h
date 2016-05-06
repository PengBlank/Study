//
//  HYCommentModel.h
//  Teshehui
//
//  Created by RayXiang on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYMallOrderSummary.h"

@interface HYCommentModel : NSObject

@property (nonatomic, assign) NSInteger desctiptionLevel;
@property (nonatomic, assign) NSInteger serviceLevel;
@property (nonatomic, assign) NSInteger deliverLevel;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) HYMallOrderItem *goods;
@property (nonatomic, assign) HYOrderGoodsEvaluationStatus evaluable;
@property (nonatomic, strong) NSString *creatTime;
@property (nonatomic, strong) NSString *preComment;

- (BOOL)canApply;

+ (NSArray *)modelsWithOrderInfo:(HYMallOrderSummary *)orderInfo;

@end
