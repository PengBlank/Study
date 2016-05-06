//
//  HYCommentModel.m
//  Teshehui
//
//  Created by RayXiang on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCommentModel.h"
#import "HYMallGoodCommentInfo.h"
#import "HYMallChildOrder.h"

@implementation HYCommentModel

- (id)init
{
    if (self = [super init])
    {
        _desctiptionLevel = 5;
        _serviceLevel = 5;
        _deliverLevel = 5;
        _photos = [NSMutableArray array];
    }
    return self;
}

+ (NSArray *)modelsWithOrderInfo:(HYMallOrderSummary *)orderInfo
{
    NSMutableArray *commentModels = [NSMutableArray array];
    if (orderInfo.orderItem.count > 0)
    {
        HYMallChildOrder *childOrderInfo = orderInfo.orderItem[0];
        for (NSInteger i = 0; i < childOrderInfo.orderItemPOList.count; i++)
        {
            HYMallOrderItem *goods = [childOrderInfo.orderItemPOList objectAtIndex:i];
            if (goods.isEvaluable == HYCanEvaluation ||
                goods.isEvaluable == HYCanAddEvaluation)
            {
                HYCommentModel *model = [[HYCommentModel alloc] init];
                model.goods = goods;
                if (goods.isEvaluable == HYCanAddEvaluation)
                {
                    HYMallGoodCommentInfo *commentInfo = goods.commentInfo;
                    model.preComment = commentInfo.comment;
                    model.creatTime = commentInfo.created;
                    model.photos = [NSMutableArray arrayWithArray:commentInfo.pics];
                }
                model.evaluable = goods.isEvaluable;
                [commentModels addObject:model];
            }
        }
    }
    
    return [NSArray arrayWithArray:commentModels];
}

- (BOOL)canApply
{
    if (self.evaluable == HYCanEvaluation)
    {
        return (self.desctiptionLevel > 0 &&
                self.serviceLevel > 0 &&
                self.deliverLevel > 0);
    }
    else if (self.evaluable == HYCanAddEvaluation)
    {
        return self.comment.length > 0;
    }
    return NO;
}


@end
